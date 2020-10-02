p = input("Path to file: ");
min_len = int(input("Minimum character count: "));
f = open(p, "rb").read();
i = 0;
while(i < len(f)):
	sub_i = 0;
	while(i+sub_i < len(f) and f[i+sub_i] in range(32, 127)): 
		sub_i += 1;
	if(len(f[i:i+sub_i]) >= min_len): 
		print(hex(i), f[i:i+sub_i].decode());
	i+= sub_i + 1;