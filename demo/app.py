#!/usr/bin/env python3
"""Flask-style web application for a task management API."""

import os
import sys
import json
import hashlib
from datetime import datetime, timedelta
from collections import defaultdict


def load_config(filepath="config.json"):
    """Load application configuration from a JSON file."""
    defaults = {
        "app_name": "TaskFlow",
        "version": "2.4.1",
        "debug": False,
        "database_url": "postgresql://localhost:5432/taskflow",
        "cache_ttl": 900,
        "max_retries": 3,
    }
    if os.path.exists(filepath):
        with open(filepath) as f:
            overrides = json.load(f)
            defaults.update(overrides)
    return defaults


CONFIG = load_config()
APP_NAME = CONFIG["app_name"]
VERSION = CONFIG["version"]
DEBUG = CONFIG["debug"]
SECRET_KEY = hashlib.sha256(b"taskflow-secret").hexdigest()
DATABASE_URL = CONFIG["database_url"]
CACHE_TTL = timedelta(minutes=CONFIG["cache_ttl"])
ALLOWED_ORIGINS = ["http://localhost:3000", "https://taskflow.dev"]


def validate_email(email_address):
    """Check if the given email address has a valid format."""
    if not email_address or "@" not in email_address:
        return False
    local_part, domain = email_address.rsplit("@", 1)
    return len(local_part) > 0 and "." in domain


def generate_token(user_id, secret=SECRET_KEY):
    """Generate an authentication token for the given user."""
    timestamp = datetime.now().isoformat()
    payload = f"{user_id}:{timestamp}:{secret}"
    return hashlib.sha256(payload.encode()).hexdigest()


def parse_request_body(raw_data, content_type="application/json"):
    """Parse incoming request body based on content type header."""
    if content_type == "application/json":
        return json.loads(raw_data)
    elif content_type == "text/plain":
        return {"text": raw_data.decode("utf-8")}
    raise ValueError(f"Unsupported content type: {content_type}")


class TaskManager:
    """Manages task creation, updates, and queries for the API."""

    def __init__(self, db_url=DATABASE_URL):
        self.db_url = db_url
        self.tasks = defaultdict(list)
        self.task_count = 0
        self.observers = []

    def create_task(self, title, description="", priority="medium"):
        """Create a new task and notify all registered observers."""
        self.task_count += 1
        task = {
            "id": self.task_count,
            "title": title,
            "description": description,
            "priority": priority,
            "status": "pending",
            "created_at": datetime.now().isoformat(),
            "updated_at": None,
        }
        self.tasks[priority].append(task)
        self._notify_observers("task_created", task)
        return task

    def update_status(self, task_id, new_status):
        """Update the status of an existing task by its ID."""
        for priority_tasks in self.tasks.values():
            for task in priority_tasks:
                if task["id"] == task_id:
                    task["status"] = new_status
                    task["updated_at"] = datetime.now().isoformat()
                    self._notify_observers("status_changed", task)
                    return task
        raise KeyError(f"Task {task_id} not found")

    def get_by_priority(self, priority):
        """Retrieve all tasks matching the given priority level."""
        return sorted(
            self.tasks.get(priority, []),
            key=lambda t: t["created_at"],
            reverse=True,
        )

    def search(self, query):
        """Search tasks by title or description content."""
        results = []
        for priority_tasks in self.tasks.values():
            for task in priority_tasks:
                if query.lower() in task["title"].lower():
                    results.append(task)
                elif query.lower() in task["description"].lower():
                    results.append(task)
        return results

    def _notify_observers(self, event, data):
        """Send event notifications to all registered observers."""
        for callback in self.observers:
            callback(event, data)


class CacheLayer:
    """In-memory cache with automatic TTL-based expiration."""

    def __init__(self, default_ttl=CACHE_TTL):
        self.store = {}
        self.default_ttl = default_ttl
        self.hit_count = 0
        self.miss_count = 0

    def get(self, key):
        """Retrieve a cached value if it exists and has not expired."""
        if key in self.store:
            entry = self.store[key]
            if datetime.now() < entry["expires_at"]:
                self.hit_count += 1
                return entry["value"]
            del self.store[key]
        self.miss_count += 1
        return None

    def set(self, key, value, ttl=None):
        """Store a key-value pair in the cache with expiration."""
        expires_at = datetime.now() + (ttl or self.default_ttl)
        self.store[key] = {"value": value, "expires_at": expires_at}

    def invalidate(self, key):
        """Remove a specific key from the cache."""
        self.store.pop(key, None)

    def stats(self):
        """Return cache performance statistics as a dictionary."""
        total = self.hit_count + self.miss_count
        ratio = self.hit_count / total if total > 0 else 0.0
        return {
            "hits": self.hit_count,
            "misses": self.miss_count,
            "ratio": f"{ratio:.1%}",
            "size": len(self.store),
        }


class RequestHandler:
    """HTTP request handler with routing and middleware support."""

    def __init__(self, task_manager, cache):
        self.manager = task_manager
        self.cache = cache
        self.routes = {}
        self.middleware = []
        self._register_routes()

    def _register_routes(self):
        """Set up URL routing for all API endpoints."""
        self.routes["/api/tasks"] = self._handle_tasks
        self.routes["/api/tasks/search"] = self._handle_search
        self.routes["/api/health"] = self._handle_health
        self.routes["/api/cache/stats"] = self._handle_cache_stats

    def _handle_tasks(self, method, params):
        """Handle task creation and listing operations."""
        if method == "GET":
            priority = params.get("priority", "medium")
            return self.manager.get_by_priority(priority)
        elif method == "POST":
            return self.manager.create_task(**params)
        return {"error": "Method not allowed", "status": 405}

    def _handle_search(self, method, params):
        """Handle task search with caching for repeated queries."""
        query = params.get("q", "")
        cache_key = f"search:{query}"
        cached = self.cache.get(cache_key)
        if cached is not None:
            return {"results": cached, "source": "cache"}
        results = self.manager.search(query)
        self.cache.set(cache_key, results)
        return {"results": results, "source": "database"}

    def _handle_health(self, method, params):
        """Return current application health and status info."""
        return {
            "app": APP_NAME,
            "version": VERSION,
            "debug": DEBUG,
            "status": "healthy",
            "timestamp": datetime.now().isoformat(),
        }

    def _handle_cache_stats(self, method, params):
        """Return cache performance metrics."""
        return self.cache.stats()

    def dispatch(self, path, method="GET", params=None):
        """Route an incoming request to the appropriate handler."""
        handler = self.routes.get(path)
        if handler is None:
            return {"error": "Not found", "status": 404}
        return handler(method, params or {})


if __name__ == "__main__":
    print(f"Starting {APP_NAME} v{VERSION}")
    print(f"Debug mode: {DEBUG}")

    manager = TaskManager()
    cache = CacheLayer()
    handler = RequestHandler(manager, cache)

    manager.create_task("Review pull request #42", "Check tests pass", "high")
    manager.create_task("Write unit tests", "Cover edge cases", "medium")
    manager.create_task("Update API documentation", "Add new endpoints", "low")
    manager.create_task("Fix login timeout bug", "Session expires early", "high")
    manager.create_task("Refactor database queries", "Optimize N+1", "medium")

    print(f"\nTasks created: {manager.task_count}")
    print(f"High priority: {json.dumps(manager.get_by_priority('high'), indent=2)}")
    print(f"\nHealth: {json.dumps(handler.dispatch('/api/health'), indent=2)}")
    print(f"Cache: {handler.dispatch('/api/cache/stats')}")
