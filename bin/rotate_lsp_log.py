#!/usr/bin/env python3

import glob
import os
import shutil


def get_state_dir():
    """Return the XDG state directory, or ~/.local/state if not set."""
    return os.getenv("XDG_STATE_HOME", os.path.expanduser("~/.local/state"))


def get_nvim_state_dir():
    """Return the path to the nvim state directory."""
    return os.path.join(get_state_dir(), "nvim")


def rotate_nvim_lsp_log(nvim_state_dir):
    """Rotate the nvim lsp log files."""
    lsp_log_glob = os.path.join(nvim_state_dir, "lsp.log.*")
    current_lsp_log = os.path.join(nvim_state_dir, "lsp.log")
    rotate_lsp_log_prefix = f"{current_lsp_log}."
    new_current_lsp_log = f"{rotate_lsp_log_prefix}1"

    if not os.path.exists(current_lsp_log):
        return

    for lsp_log in sorted(glob.glob(lsp_log_glob), reverse=True):
        lsp_log_ext = lsp_log.split(".")[-1]
        new_lsp_log = f"{rotate_lsp_log_prefix}{int(lsp_log_ext) + 1}"
        print(f"rotate {lsp_log} to {new_lsp_log}")
        shutil.move(lsp_log, new_lsp_log)

    print(f"rotate {current_lsp_log} to {new_current_lsp_log}")
    shutil.move(current_lsp_log, new_current_lsp_log)


if __name__ == "__main__":
    rotate_nvim_lsp_log(get_nvim_state_dir())
