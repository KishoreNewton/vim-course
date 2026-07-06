#!/usr/bin/env python3
"""A web application framework demo for Vim editing practice."""

import os
import sys
from datetime import datetime

# Configuration
DEBUG = True
VERSION = "2.1.0"
MAX_RETRIES = 3

def greet(name):
    """Return a greeting message."""
    return f"Hello, {name}!"

def calculate(a, b, operation="add"):
    """Perform basic arithmetic operations."""
    if operation == "add":
        return a + b
    elif operation == "subtract":
        return a - b
    elif operation == "multiply":
        return a * b
    elif operation == "divide":
        if b == 0:
            raise ValueError("Cannot divide by zero")
        return a / b
    return None

def parse_config(filepath):
    """Parse a configuration file and return settings."""
    config = {}
    with open(filepath, 'r') as f:
        for line in f:
            line = line.strip()
            if line and not line.startswith('#'):
                key, value = line.split('=', 1)
                config[key.strip()] = value.strip()
    return config

class DataProcessor:
    """Process and transform data records."""

    def __init__(self, data):
        self.data = data
        self.results = []
        self.errors = []
        self.processed_count = 0

    def validate(self, item):
        """Check if a data item is valid."""
        if not item or not isinstance(item, str):
            return False
        return len(item.strip()) > 0

    def process(self):
        """Process all data items."""
        for item in self.data:
            if self.validate(item):
                self.results.append(item.strip().lower())
                self.processed_count += 1
            else:
                self.errors.append(f"Invalid item: {item}")
        return self.results

    def summary(self):
        """Return processing summary."""
        return {
            "total": len(self.data),
            "processed": self.processed_count,
            "errors": len(self.errors),
            "timestamp": datetime.now().isoformat(),
        }

class Logger:
    """Simple logging utility."""

    def __init__(self, name, level="INFO"):
        self.name = name
        self.level = level

    def info(self, message):
        print(f"[{self.name}] INFO: {message}")

    def error(self, message):
        print(f"[{self.name}] ERROR: {message}")

    def debug(self, message):
        if DEBUG:
            print(f"[{self.name}] DEBUG: {message}")

if __name__ == "__main__":
    logger = Logger("main")
    logger.info(f"Starting application v{VERSION}")
    print(greet("Vim User"))
    print(calculate(10, 5))
    print(calculate(10, 5, "multiply"))

    processor = DataProcessor(["hello", "world", "", "vim", None, "editor"])
    results = processor.process()
    logger.info(f"Results: {results}")
    logger.info(f"Summary: {processor.summary()}")
