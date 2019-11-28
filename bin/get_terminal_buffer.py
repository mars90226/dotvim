#!/usr/bin/env python3

import os
import sys
from pynvim import attach

def get_terminal_buffer_content(terminal_buffer, lines):
    nvim = attach('socket', path=os.getenv('NVIM_LISTEN_ADDRESS'))
    content_lines = int(nvim.command_output('echo len(getbufline("' + terminal_buffer + '", 1, "$"))'))
    raw_content = nvim.call('getbufline', terminal_buffer, content_lines-lines+1, '$')
    return "\n".join(raw_content)

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
