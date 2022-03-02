import sys
import time
import requests
from threading import Thread


def checkproxy(ip, port, protocol="socks4", timeout=10):
	start = time.time()
	try:
		resp = requests.get('http://ifconfig.me/ip',timeout=timeout, proxies=dict(http='{protocol}://{ip}:{port}'.format(protocol=protocol, ip=ip, port=str(port))));
		print(resp.text, (ip, port), time.time() - start)
		return True
	except:
		return False
	return False

def parsefile(path):
	proxies = set()
	protocol = ""
	content = []
	with open(path) as file:
		content = file.read().split("\n")
		protocol = content[0].strip()
		content = content[1:]
	for line in content:
		pair = line.split()
		ip = pair[0]
		port = int(pair[1])
		proxies.add((ip, port))
	return protocol, proxies
	
def main():
	path = "socks5.txt"
	protocol, proxies = parsefile(path)
	print("[*] " + protocol.upper())
	threads = []
	for proxy in proxies:
		thread = Thread(target=checkproxy, args=(proxy[0], proxy[1], protocol,))
		threads.append(thread)
	for thread in threads:
		thread.start()
	for thread in threads:
		thread.join()
	
main()