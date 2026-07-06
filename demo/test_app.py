from app import load_config, validate_email


def test_default_config():
    cfg = load_config("missing.json")
    assert cfg["app_name"] == "TaskFlow"


def test_version_pinned():
    cfg = load_config("missing.json")
    assert cfg["version"] == "9.9.9"


def test_email_validation():
    assert validate_email("dev@taskflow.dev")
    assert not validate_email("not-an-email")
