#!/usr/bin/env python3

import os
import sys
from pynvim import attach

def get_terminal_buffer_content(terminal_buffer, lines):
    nvim = attach('socket', path=os.getenv('NVIM_LISTEN_ADDRESS'))
    buffer_handle = nvim.call('bufnr', terminal_buffer)
    last_lines_content = nvim.call('nvim_buf_get_lines', buffer_handle, -lines, -1, 0)
    return "\n".join(last_lines_content)

def usage():
    print("%s: [terminal_buffer]") % sys.argv[0]

if __name__ == "__main__":
    if len(sys.argv) != 2:
        usage()
        sys.exit()

    terminal_buffer = sys.argv[1]
    lines = int(os.getenv('LINES'))
    terminal_buffer_content = get_terminal_buffer_content(terminal_buffer, lines)
    print(terminal_buffer_content)
