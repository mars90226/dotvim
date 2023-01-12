#!/usr/bin/env python3

import os
import sys
from pynvim import attach


def get_buffer_content(tab, win, lines):
    nvim = attach("socket", path=os.getenv("NVIM"))
    win_id = nvim.call("win_getid", win, tab)
    win_height = nvim.call("winheight", win_id)
    buffer_handle = nvim.call("winbufnr", win_id)
    last_lines_content = nvim.call(
        "nvim_buf_get_lines", buffer_handle, -win_height - 1, -win_height + lines - 1, 0
    )
    return "\n".join(last_lines_content)


def usage():
    print("%s: [tab] [win] [lines]") % sys.argv[0]


if __name__ == "__main__":
    if len(sys.argv) != 4:
        usage()
        sys.exit()

    tab = sys.argv[1]
    win = sys.argv[2]
    lines = int(sys.argv[3])
    buffer_content = get_buffer_content(tab, win, lines)
    print(buffer_content)
