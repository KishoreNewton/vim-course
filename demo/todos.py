# The team scratchpad

def sync_records():
    # TODO: batch these writes into one transaction
    # FIXME: retries clobber the audit log timestamps
    # HACK: sleeping 50ms hides the race with the cache
    pass
