#!/bin/bash
# Jake McLellan 
# HW1 - Firewalls
# Linux firewall test script

# Default placeholder value for IP 
ip="192.168.1.1";
# Scan IP for TCP ports 22, 88, 443 (inbound)
sudo nmap -v -sS -p 22,80,443 $ip