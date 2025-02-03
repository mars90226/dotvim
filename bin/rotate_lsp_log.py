#!/usr/bin/env python3

import logging
import os
import shutil
from pathlib import Path

logging.basicConfig(
    level=logging.INFO, format="%(asctime)s - %(levelname)s - %(message)s"
)


def get_state_dir() -> Path:
    """Return the XDG state directory as a Path, defaulting to ~/.local/state."""
    state_home = os.getenv("XDG_STATE_HOME")
    return Path(state_home) if state_home else Path.home() / ".local" / "state"


def get_nvim_state_dir() -> Path:
    """Return the path to the nvim state directory."""
    return get_state_dir() / "nvim"


def rotate_nvim_lsp_log(nvim_state_dir: Path):
    """Rotate the nvim LSP log files."""
    current_log = nvim_state_dir / "lsp.log"

    if not current_log.exists():
        logging.info("No current log file found at %s", current_log)
        return

    # List rotated logs that match lsp.log.<number>
    rotated_logs = []
    for log_file in nvim_state_dir.glob("lsp.log.*"):
        parts = log_file.name.rsplit(".", 1)
        if len(parts) == 2 and parts[1].isdigit():
            rotated_logs.append(log_file)

    # Sort logs in reverse order based on their numeric suffix
    rotated_logs.sort(key=lambda f: int(f.name.rsplit(".", 1)[-1]), reverse=True)

    for log_file in rotated_logs:
        try:
            num = int(log_file.name.rsplit(".", 1)[-1])
            new_log = nvim_state_dir / f"lsp.log.{num + 1}"
            logging.info("Rotating %s to %s", log_file, new_log)
            shutil.move(str(log_file), str(new_log))
        except Exception as e:
            logging.error("Error rotating file %s: %s", log_file, e)

    # Rotate the current log
    new_current_log = nvim_state_dir / "lsp.log.1"
    try:
        logging.info("Rotating %s to %s", current_log, new_current_log)
        shutil.move(str(current_log), str(new_current_log))
    except Exception as e:
        logging.error("Error rotating current log %s: %s", current_log, e)


if __name__ == "__main__":
    rotate_nvim_lsp_log(get_nvim_state_dir())
