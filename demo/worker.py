"""Background worker: retries failed jobs with exponential backoff."""

import time

from sample import MAX_RETRIES


def run_job(job, attempts=MAX_RETRIES):
    """Run a job, retrying up to MAX_RETRIES times."""
    for attempt in range(attempts):
        try:
            return job()
        except Exception:
            if attempt == attempts - 1:
                raise
            time.sleep(2 ** attempt)
