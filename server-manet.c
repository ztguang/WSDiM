/*
  The source code file is released under GNU GPL V2,V3
  Author: Tongguang Zhang
  Date: 2018-01-12
*/

// gcc -lpthread server-manet.c -o server-manet
// gcc -I/usr/include/mysql/ -L/usr/lib64/mysql/ -lmysqlclient -lpthread server-manet.c -o server-manet
// indent -npro -kr -i8 -ts8 -sob -l280 -ss -ncs -cp1 *

/*
make testing in the same computer:

[client-manet.c] send to
[(MASTER) handle_client(void *arg) IN server-manet.c] send to
[(MASTER) send2slave(void *arg) IN server-manet.c] send to
[(SLAVE) slave(void *arg) IN server-manet-slave.c]

startup sequence:

[root@localhost server-client-pthread-c]# ./server-manet
[root@localhost server-client-pthread-c]# ./server-manet-slave
[root@localhost server-client-pthread-c]# ./client-manet

++++++++++++++++++++++++++++++++++++++++++++++
make testing in CORE:

1. 	在每个节点的主目录创建文件： ctrl.txt, masterip.txt, hosts, 
	根据batman-adv协议，选择 主节点，其它为从节点；要修改 上面3个文件的值

[client-manet.c] send to
[(MASTER) handle_client(void *arg) IN server-manet.c] send to
[(MASTER) send2slave(void *arg) IN server-manet.c] send to
[(SLAVE) slave(void *arg) IN server-manet.c]
*/
//Description: when master start, this algorithm will run as a deamon

// 一共有三段，分别对应于三种数据同步
// There are three segments, which correspond to three kinds of data synchronization 
//used to syn multi-engine
//----------------------------------------------------------------------used to syn multi-engine  - begin
//used to pub WSLT
//----------------------------------------------------------------------used to pub WSLT  - begin
//used to syn WSLT
//----------------------------------------------------------------------used to syn WSLT  - begin
//-------------------------------------------------WSLT_syn_server  - begin
//-------------------------------------------------WSLT_syn_client  - begin

#include <stdio.h>
#include <stdlib.h>
#include <unistd.h>
#include <errno.h>
#include <string.h>
#include <sys/time.h>
#include <sys/types.h>
#include <sys/socket.h>
#include <sys/ioctl.h>
#include <netinet/tcp.h>
#include <netinet/in.h>
#include <net/if.h>
#include <arpa/inet.h>
#include <sys/epoll.h>
#include <pthread.h>

//#endif
#define BUF_SIZE 1024
#define NAME_SIZE 40
#define PROCESSID_SIZE 52

#define MASTER_PORT 11111
#define CLIENT_PORT 22222
#define CLIENTMSG_SIZE 62

#define WSLT_pub_server_PORT 33333
#define WSLT_syn_server_PORT 44444

#define EPOLL_RUN_TIMEOUT -1		//epoll: timeout
#define EPOLL_SIZE 10000		//epoll: Maximum number of listening clients
#define LISTEN_SIZE 10			//Monitor queue length

#define IF_NAME "eth0"			//network interface name
//#define IF_NAME "enp13s0"		//network interface name

#define CHK(eval) if(eval < 0){perror("eval"); exit(-1);}
#define CHK2(res, eval) if((res = eval) < 0){perror("eval"); exit(-1);}

//ctrl: Master or Slave, this value is set by batman-adv;
//  ctrl=0, SMD is Slave role;
//  ctrl=1, SMD is elected as a Master role;
int ctrl;

//changed: Master or Slave, this value is set by batman-adv;
//  changed=0, Master SMD is not changed, so, do not need to create thread in MAIN again for data synchronization;
//  changed=1, Master SMD is changed, so, need to create thread in MAIN again for data synchronization;
int changed=0;

//int changed_db=0;
int is_me=-1;
int prev_ctrl=-1;  //0:Slave; 1:Master;

char *masterip;
char *self_ip;

int pipe_fd[2];

//select	//used to syn multi-engine
//select (global variables), due to master() & send2slave() use them, 用于 select 的全局变量，放在文件开头
int maxi, listenfd, sockfd;
int client[FD_SETSIZE];					//save clients with data request

//select	//used to pub WSLT
//select (global variables), due to WSLT_pub_server() & receive4pubclient() use them, 用于 select 的全局变量，放在文件开头
int maxi2, listenfd2, sockfd2; 
int client2[FD_SETSIZE];					//save clients with data request

//select	//used to syn WSLT
//select (global variables), due to WSLT_syn_client() & send2synserver() use them, 用于 select 的全局变量，放在文件开头
int maxi3, listenfd3, sockfd3; 
int client3[FD_SETSIZE];					//save clients with data request

int start=1;				//set initial state

//used to syn multi-engine
pthread_t tid_master;			//used in pthread_join, pthread_cancel		//pthread_create(&tid_send2slave);
pthread_t tid_slave;			//used in pthread_join, pthread_cancel		//receive
pthread_t tid_send2slave;		//used in pthread_join, pthread_cancel		//send

//used to pub WSLT
pthread_t tid_WSLT_pub_server;		//used in pthread_join, pthread_cancel		//pthread_create(&tid_receive4pubclient);
pthread_t tid_WSLT_pub_client;		//used in pthread_join, pthread_cancel		//send
pthread_t tid_receive4pubclient;	//used in pthread_join, pthread_cancel		//receive

//used to syn WSLT
pthread_t tid_WSLT_syn_server;		//used in pthread_join, pthread_cancel		//pthread_create(&tid_receive4synclient);
pthread_t tid_WSLT_syn_client;		//used in pthread_join, pthread_cancel		//pthread_create(&tid_send2synserver_?);
pthread_t tid_send2synserver_0;		//used in pthread_join, pthread_cancel		//send
pthread_t tid_send2synserver_1;		//used in pthread_join, pthread_cancel		//send
pthread_t tid_send2synserver_2;		//used in pthread_join, pthread_cancel		//send
pthread_t tid_send2synserver_3;		//used in pthread_join, pthread_cancel		//send
pthread_t tid_send2synserver_4;		//used in pthread_join, pthread_cancel		//send
pthread_t tid_send2synserver_5;		//used in pthread_join, pthread_cancel		//send
pthread_t tid_send2synserver_6;		//used in pthread_join, pthread_cancel		//send
pthread_t tid_send2synserver_7;		//used in pthread_join, pthread_cancel		//send
pthread_t tid_send2synserver_8;		//used in pthread_join, pthread_cancel		//send
pthread_t tid_send2synserver_9;		//used in pthread_join, pthread_cancel		//send
pthread_t tid_receive4synclient;	//used in pthread_join, pthread_cancel		//receive


//the list of IP addresses
char *ipaddr[]={"10.0.0.1", "10.0.0.2", "10.0.0.3", "10.0.0.4", "10.0.0.5", "10.0.0.6", "10.0.0.7", "10.0.0.8", "10.0.0.9", "10.0.0.10"};
int ipaddr_num=10;

void *send2slave(void *arg);
void *receive4pubclient(void *arg);
void *receive4synclient(void *arg);
void *send2synserver(void *synserverip);

void perr_exit(const char *s)
{
	perror(s);
	exit(1);
}

//******************************* Replace a specified Line in a Text File

//filename: "/etc/hosts"
//str: "mpe.localhost"
//return the matched line number
int findline(char *filename, char *str)
{
	// open the file for reading
	FILE *file = fopen(filename, "r");

	// make sure the file opened properly
	if(NULL == file)
	{
		fprintf(stderr, "Cannot open file: %s\n", filename);
		return 1;
	}

	// set up the buffer to read the line into. Don't worry too much
	// if some of the lines are longer than 80 characters - the buffer
	// will be made bigger if need be.
	size_t buffer_size = 80;
	char *buffer = malloc(buffer_size * sizeof(char));

	// read each line and print it to the screen
	int line_number = 0, find = 0;
	while(-1 != getline(&buffer, &buffer_size, file))
	{
		line_number++;
		if(NULL != strstr(buffer, str))
		{
			find = 1;
			break;
		}
		//printf("%d: %s", line_number, buffer);
	}

	if(find == 0) line_number = 0;

	fclose(file);
	free(buffer);

	return line_number;
} //end findline()

void replaceline(char *filename, int delete_line, char *newcontent)
{
	FILE *fileptr1, *fileptr2;
	//char filename[40];
	char c;
	int temp = 1;

	fileptr1 = fopen(filename, "r");

/*
	//print the contents of file .
	while ((c = getc(fileptr1)) != EOF)
	{
		printf("%c", c);
	}
//*/

	//take fileptr1 to start point.
	rewind(fileptr1);
	//open tempinterm.txt in write mode
	fileptr2 = fopen("tempinterm.txt", "w");

	while ((c = getc(fileptr1)) != EOF)
	{
		//till the line to be deleted comes,copy the content to other
		if (temp != delete_line) {
			putc(c, fileptr2);
			while ((c = getc(fileptr1)) != '\n') putc(c, fileptr2);
			putc('\n', fileptr2);
			temp++;
		} else {
			while ((c = getc(fileptr1)) != '\n');	//read and skip the line
			//while ((c = getchar()) != '\n') putc(c, fileptr2);
			while(*newcontent != '\0') putc(*newcontent++, fileptr2);
			putc('\n', fileptr2);
			temp++;
		}
	}

	//append a new line at the end of file
	if(delete_line == 0)
	{
		while(*newcontent != '\0') putc(*newcontent++, fileptr2);
		putc('\n', fileptr2);
	}

	fclose(fileptr1);
	fclose(fileptr2);
	remove(filename);
	rename("tempinterm.txt", filename);
} //end replaceline()
//******************************* Replace a specified Line in a Text File


//******************************* set ctrl & master_ip in /etc/hosts
//convert ip address string into uint
uint32_t ip2uint(const char *ip) {
    int a, b, c, d;
    uint32_t addr = 0;

    if (sscanf(ip, "%d.%d.%d.%d", &a, &b, &c, &d) != 4)
       return 0;

    addr = a << 24;
    addr |= b << 16;
    addr |= c << 8;
    addr |= d;
    return addr;
} //end ip2uint()

//read ip address
char * getipaddress(char * interface)
{
	int fd;
	struct ifreq ifr;

	fd = socket(AF_INET, SOCK_DGRAM, 0);
	ifr.ifr_addr.sa_family = AF_INET;	//I want to get an IPv4 IP address
	strncpy(ifr.ifr_name, interface, IFNAMSIZ - 1);	//I want IP address attached to "eth0"
	ioctl(fd, SIOCGIFADDR, &ifr);
	close(fd);
	return inet_ntoa(((struct sockaddr_in *)&ifr.ifr_addr)->sin_addr);
} //end getipaddress()

//read_ctrl, set URL of application system. Access master_ip in browser.
void *read_ctrl(void *arg)
{
	char filename[6] = "hosts";	//set master_ip in /etc/hosts
	int line = -1;				//the matched line number
	char newline[32];			//255.108.162.227   mpe.localhost, added into /etc/hosts

	uint32_t prev_ip = ip2uint("0.0.0.0");
	uint32_t me_ip = ip2uint(getipaddress(IF_NAME));
	uint32_t master_ip;

	size_t buffer_size = 16;
	masterip = malloc(buffer_size * sizeof(char));

	FILE *fp1;
	char c;

	while (1) {		//running for ever
		// gcc -lpthread server-manet.c -o server-manet
		//read the value of ctrl set by batman-adv;
		fp1 = fopen ("ctrl.txt", "r");	//echo 1 >ctrl.txt

		//gcc -lpthread server-manet.c -o server-manet-slave
		//fp1 = fopen ("ctrl_slave.txt", "r");	//echo 0 >ctrl_slave.txt

		c = fgetc(fp1);
		ctrl = c - '0';
		//printf("%d\n", ctrl);
		fclose(fp1);

		//read master_ip of Master SMD;
		fp1 = fopen ("masterip.txt", "r");	//echo 1.1.1.1 >masterip.txt
		//memset(masterip, 0, buffer_size);
		bzero(masterip, buffer_size);

		getline(&masterip, &buffer_size, fp1);
		/* strip trailing newline */
		for (int i = 0; i < strlen(masterip); i++)
		{
			if ( masterip[i] == '\n' || masterip[i] == '\r' )
				masterip[i] = '\0';
		}

		//printf("%s\n", masterip);
		//printf("(%d)-<%s> masterip: %s\n", __LINE__, __FUNCTION__, masterip);
		fclose(fp1);

		master_ip = ip2uint(masterip);

		if (master_ip == me_ip && is_me != -1) {
			prev_ctrl = is_me;
			is_me = 1;
		} else if (master_ip != me_ip && is_me != -1) {
			prev_ctrl = is_me;
			is_me = 0;
		}

		//printf("(%d)-<%s> prev_ip: %u --- master_ip: %u\n", __LINE__, __FUNCTION__, prev_ip, master_ip);

		if (master_ip!=prev_ip) {
			changed=1;
			prev_ip=master_ip;

			//add (or update) "master_ip mpe.localhost" in /etc/hosts;
			line = findline(filename, "mpe.localhost");
			//memset(newline, 0, 32);
			bzero(newline, 32);
		 	sprintf(newline,"%s%s",masterip,"   mpe.localhost");	//produce "10.108.162.227   mpe.localhost"
			replaceline(filename, line, newline);
			//replaceline(filename, line, "10.108.162.227   mpe.localhost");
		} else {
			changed=0;
		}

		//printf("(%d)-<%s> changed: %d --- prev_ctrl: %d\n", __LINE__, __FUNCTION__, changed, prev_ctrl);

		if (changed) {
			if (prev_ctrl == 0) {
				pthread_cancel(tid_slave);		//kill slave thread
				pthread_cancel(tid_WSLT_pub_client);	//kill WSLT_pub_client thread
				pthread_cancel(tid_receive4synclient);	//kill receive4synclient thread
				pthread_cancel(tid_WSLT_syn_server);	//kill WSLT_syn_server thread
			}
			if (prev_ctrl == 1) {
				pthread_cancel(tid_send2slave);		//kill send2slave thread
				pthread_cancel(tid_master);		//kill master thread
				pthread_cancel(tid_receive4pubclient);	//kill receive4pubclient thread
				pthread_cancel(tid_WSLT_pub_server);	//kill WSLT_pub_server thread
				pthread_cancel(tid_WSLT_syn_client);	//kill WSLT_syn_client thread

				//kill send2synserver thread for synserverip in IP_list		//the list of IP addresses
				for (int i = 0; i < ipaddr_num; i++) {				//the list of IP addresses

					if (strcmp(ipaddr[i], self_ip)==0) continue;

					if (i==0) pthread_cancel(tid_send2synserver_0);
					else if (i==1) pthread_cancel(tid_send2synserver_1);
					else if (i==2) pthread_cancel(tid_send2synserver_2);
					else if (i==3) pthread_cancel(tid_send2synserver_3);
					else if (i==4) pthread_cancel(tid_send2synserver_4);
					else if (i==5) pthread_cancel(tid_send2synserver_5);
					else if (i==6) pthread_cancel(tid_send2synserver_6);
					else if (i==7) pthread_cancel(tid_send2synserver_7);
					else if (i==8) pthread_cancel(tid_send2synserver_8);
					else if (i==9) pthread_cancel(tid_send2synserver_9);
				} //end for
			}
		}

		sleep(1);
	}	//end while

	//free(masterip);
} //end read_ctrl()
//******************************* set ctrl & master_ip in /etc/hosts


//----------------------------------------------------------------------used to syn multi-engine  - begin
//communication between master & slave
//arg is sock, arg is NULL
void *slave(void *arg)
{
	int sock;

	// timestamp
	struct timeval tv;

	struct tcp_info info;
	int leng = sizeof(info);

	struct sockaddr_in seraddr;
	seraddr.sin_family = PF_INET;
	seraddr.sin_port = htons(MASTER_PORT);
	seraddr.sin_addr.s_addr = inet_addr(masterip);	//Master ip address, added in /etc/hosts
	//seraddr.sin_addr.s_addr = inet_addr(SERVER_HOST);

	CHK2(sock, socket(PF_INET, SOCK_STREAM, 0));
	CHK(connect(sock, (struct sockaddr *)&seraddr, sizeof(seraddr)) < 0);

	int len;
	char buf[BUF_SIZE];

	while (1)		//communication between master & slave
	{
		//printf("(%d)-<%s> slave changed: %d\n", __LINE__, __FUNCTION__, changed);

/*
		if (changed) {
			CHK(close(sock));
 			break;
		}
//*/
		//before reading and writing, first to judge whether the "socket connection" is normal
		getsockopt(sock, IPPROTO_TCP, TCP_INFO, &info, (socklen_t *) &leng);
		if ((info.tcpi_state == TCP_ESTABLISHED)) {		//socket connected 
			bzero(buf, BUF_SIZE);

			//printf("(%d)-<%s> will Recv data\n", __LINE__, __FUNCTION__);
			CHK2(len, recv(sock, buf, BUF_SIZE, MSG_NOSIGNAL));	//read * from master
			//printf("(%d)-<%s> Recv data from %s: [ %s ]\n", __LINE__, __FUNCTION__, masterip, buf);

			// timestamp
			gettimeofday(&tv,NULL);
			printf("Slave (%s) recv data from Master (%s): [ %s ] at millisecond:%ld\n", self_ip, masterip, buf, tv.tv_sec*1000 + tv.tv_usec/1000);

		} else {		// socket disconnected 
			CHK(close(sock));
			//return NULL;
			seraddr.sin_addr.s_addr = inet_addr(masterip);	//Master ip address
			CHK2(sock, socket(PF_INET, SOCK_STREAM, 0));
			CHK(connect(sock, (struct sockaddr *)&seraddr, sizeof(seraddr)) < 0);
			//printf("(%d)-<%s> reconnect Master: [ %s ]\n", __LINE__, __FUNCTION__, masterip);

			// timestamp
			gettimeofday(&tv,NULL);
			printf("Slave (%s) reconnect Master (%s) at millisecond:%ld\n", self_ip, masterip, tv.tv_sec*1000 + tv.tv_usec/1000);
			sleep(1);
			continue;
		}

		//update correlative tables in database;
		//todo
	} //end while
} //end slave()

//communication between master & slave
//arg is sock, arg is NULL
void *master(void *arg)
{
	//select (local variables), the other variables (global variables) at the begin of the file
	int i, maxfd, connfd, nready;
	fd_set rset, allset;

	//int listenfd;		//监听socket
	struct sockaddr_in addr, peer;
	addr.sin_family = PF_INET;
	addr.sin_port = htons(MASTER_PORT);
	addr.sin_addr.s_addr = inet_addr(self_ip);		// Master IP ADDRESS
	//addr.sin_addr.s_addr = inet_addr(SERVER_HOST);
	socklen_t socklen;
	socklen = sizeof(struct sockaddr_in);

	socklen_t cliaddr_len;
	struct sockaddr_in cliaddr;
	char str[INET_ADDRSTRLEN];

	struct tcp_info info;
	int leng = sizeof(info);

	//send MSG to Slave
	//pthread_t tid_send2slave;
	//int rt = pthread_create(&tid_send2slave, NULL, send2slave, (void *)&client);
	int rt = pthread_create(&tid_send2slave, NULL, send2slave, NULL);
	if (-1 == rt) {
		printf("master: create thread (send2slave) error\n");
		return NULL;
	}

	if (listenfd) close(listenfd);		//to avoid: Error: Address already in use

	CHK2(listenfd, socket(PF_INET, SOCK_STREAM, 0));

	//to avoid: Error: Address already in use
	int on = 1;
	if ((setsockopt(listenfd, SOL_SOCKET, SO_REUSEADDR, &on, sizeof(on))) < 0) {
		perror("server: setsockopt failed");
		exit(EXIT_FAILURE);
	}

	CHK(bind(listenfd, (struct sockaddr *)&addr, sizeof(addr)));

	//printf("listen\n");
	CHK(listen(listenfd, LISTEN_SIZE));
	//printf("(%d)-<%s> Master: waiting Slave to connect\n", __LINE__, __FUNCTION__);

	maxfd = listenfd;
	maxi = -1;
	for (i = 0; i < FD_SETSIZE; i++)
		client[i] = -1;
	FD_ZERO(&allset);
	FD_SET(listenfd, &allset);	//add listenfd to allset

	//select, add all connect fd to allset
	while (1) {
		//sleep(1);

		//clear invalid fd
		for (int i = 0; i <= maxi; i++) {
			if ((sockfd = client[i]) < 0 || listenfd == client[i] )
				continue;

			//send data to other smartphones (other slaves), [ void *slave(void *arg) ]
			//before reading and writing, first to judge whether the "socket connection" is normal
			getsockopt(sockfd, IPPROTO_TCP, TCP_INFO, &info, (socklen_t *) &leng);
			if ((info.tcpi_state == TCP_ESTABLISHED)) {		// socket connected 
				;
			} else {		// socket disconnected 
				//printf("(%d)-<%s> Slave closed\n", __LINE__, __FUNCTION__);
				CHK(close(sockfd));
				FD_CLR(sockfd, &allset);
				client[i] = -1;
			}
		}

		rset = allset;
		nready = select(maxfd + 1, &rset, NULL, NULL, NULL);
		if (nready < 0)
			perr_exit("select error");

		if (FD_ISSET(listenfd, &rset)) {
			cliaddr_len = sizeof(cliaddr);
			CHK2(connfd, accept(listenfd, (struct sockaddr *)&cliaddr, &cliaddr_len));

			printf("Master (%s) connected by [ %s:%d ]\n", self_ip, inet_ntop(AF_INET, &cliaddr.sin_addr, str, sizeof(str)), ntohs(cliaddr.sin_port));

			for (i = 0; i < FD_SETSIZE; i++)
				if (client[i] < 0) {
					client[i] = connfd;
					break;
				}
			if (i == FD_SETSIZE) {
				fputs("too many clients\n", stderr);
				exit(1);
			}

			FD_SET(connfd, &allset);	//add connfd to allset
			if (connfd > maxfd)
				maxfd = connfd;
			if (i > maxi)
				maxi = i;

			if (--nready == 0)
				continue;
		} //end if
	} //end while
} //end master()

//send MSG to Slave
//the goal is to synchronize process data between master & slave, send data to other smartphones
void *send2slave(void *arg)
{
	//int client = *((int *)arg);
	//sleep(5);
	char buf[BUF_SIZE];
	int res, len;
	char clientmsg[CLIENTMSG_SIZE];

	struct tcp_info info;
	int leng = sizeof(info);

	//int pipe_fd[2], epfd;
	int epfd;

	int epoll_events_count;
	static struct epoll_event ev, events[1];
	ev.events = EPOLLIN | EPOLLET;
	//CHK(pipe(pipe_fd));
	CHK2(epfd, epoll_create(EPOLL_SIZE));
	ev.data.fd = pipe_fd[0];	// reader
	CHK(epoll_ctl(epfd, EPOLL_CTL_ADD, pipe_fd[0], &ev));

	//Using epoll to simulate process execution，Database update event，Event driven database synchronization
	while (1) {		//communication between master & slave

		//printf("(%d)-<%s> changed: %d\n", __LINE__, __FUNCTION__, changed);

		//if (changed) break;

		//event_driven, read pipe_fd[0] from handle_client(void *arg) which read * from client-manet.c 
		//epoll_wait(int epfd, struct epoll_event * events, int maxevents, int timeout)
		//参数events用来从内核得到事件的集合，maxevents告之内核这个events有多大，
		//这个 maxevents的值不能大于创建epoll_create()时的size，
		//参数timeout是超时时间 , 毫秒，0会立即返回，-1将不确定，也有说法说是永久阻塞
		if((epoll_events_count = epoll_wait(epfd, events, 1, EPOLL_RUN_TIMEOUT)) < 0){
			//perror("evall");
			//printf("EINTR [%d] [%d]\n", EINTR, epoll_events_count);
			//exit(-1);
			sleep(1);
			continue;
		}

		//epoll
		for (int i = 0; i < epoll_events_count; i++) {
			if (events[i].data.fd == pipe_fd[0])	//reading end of pipe, accept MSG from client-manet.c
			{
				bzero(&clientmsg, CLIENTMSG_SIZE);
				CHK2(res, read(pipe_fd[0], clientmsg, CLIENTMSG_SIZE));
				//printf("(%d)-<%s> clientmsg: %s\n", __LINE__, __FUNCTION__, clientmsg);

				for (int i = 0; i <= maxi; i++) {
					if ((sockfd = client[i]) < 0 || listenfd == client[i] )
						continue;
					//send data to other smartphones (other slaves), [ void *slave(void *arg) ]
					//before reading and writing, first to judge whether the "socket connection" is normal
					getsockopt(sockfd, IPPROTO_TCP, TCP_INFO, &info, (socklen_t *) &leng);
					if ((info.tcpi_state == TCP_ESTABLISHED)) {		// socket connected 
						//for (int i = 0; i <= maxi; i++)
						CHK(send(client[i], "synchronous data", strlen("synchronous data"), MSG_NOSIGNAL));
						printf("Master (%s) send MSG to Slave\n", self_ip);
					}
				} // end for
			} // end if
		} // end for

		sleep(1);
	} // end while
} //end send2slave()
//----------------------------------------------------------------------used to syn multi-engine  - end




//----------------------------------------------------------------------used to pub WSLT  - begin
//communication between WSLT_pub_server & WSLT_pub_client
//arg is sock, arg is NULL
void *WSLT_pub_client(void *arg)
{
	int sock;

	// timestamp
	struct timeval tv;

	struct tcp_info info;
	int leng = sizeof(info);

	struct sockaddr_in seraddr;
	seraddr.sin_family = PF_INET;
	seraddr.sin_port = htons(WSLT_pub_server_PORT);
	seraddr.sin_addr.s_addr = inet_addr(masterip);	//Master ip address, added in /etc/hosts
	//seraddr.sin_addr.s_addr = inet_addr(SERVER_HOST);

	CHK2(sock, socket(PF_INET, SOCK_STREAM, 0));
	CHK(connect(sock, (struct sockaddr *)&seraddr, sizeof(seraddr)) < 0);

	int len;
	char *sql="INSERT INTO webservice (name, suuid, url) VALUES ('webservice1', 'xxxx', 'www.ws.com/ws1');";

	while (1)		//communication between master & slave
	{
		//printf("(%d)-<%s> slave changed: %d\n", __LINE__, __FUNCTION__, changed);

/*
		if (changed) {
			CHK(close(sock));
 			break;
		}
//*/
		//before reading and writing, first to judge whether the "socket connection" is normal
		getsockopt(sock, IPPROTO_TCP, TCP_INFO, &info, (socklen_t *) &leng);
		if ((info.tcpi_state == TCP_ESTABLISHED)) {		//socket connected 
			CHK(send(sock, sql, strlen(sql), MSG_NOSIGNAL));
			// timestamp
			gettimeofday(&tv,NULL);
			printf("WSLT_pub_client (%s) Send SQL to WSLT_pub_server (%s): [ %s ] at millisecond:%ld\n", self_ip, masterip, sql, tv.tv_sec*1000 + tv.tv_usec/1000);

			sleep(1);

		} else {		// socket disconnected 
			CHK(close(sock));
			//return NULL;
			seraddr.sin_addr.s_addr = inet_addr(masterip);	//Master ip address
			CHK2(sock, socket(PF_INET, SOCK_STREAM, 0));
			CHK(connect(sock, (struct sockaddr *)&seraddr, sizeof(seraddr)) < 0);
			//printf("(%d)-<%s> reconnect Master: [ %s ]\n", __LINE__, __FUNCTION__, masterip);

			// timestamp
			gettimeofday(&tv,NULL);
			printf("WSLT_pub_client (%s) reconnect WSLT_pub_server (%s) at millisecond:%ld\n", self_ip, masterip, tv.tv_sec*1000 + tv.tv_usec/1000);

			sleep(1);
			continue;
		}

		//update correlative tables in database;
		//todo
	} //end while
} //end WSLT_pub_client()


//communication between WSLT_pub_server & WSLT_pub_client
//arg is sock, arg is NULL
void *WSLT_pub_server(void *arg)
{
	//select (local variables), the other variables (global variables) at the begin of the file
	int i, maxfd, connfd, nready;
	fd_set rset, allset;

	//int listenfd2;		//监听socket
	struct sockaddr_in addr, peer;
	addr.sin_family = PF_INET;
	addr.sin_port = htons(WSLT_pub_server_PORT);
	addr.sin_addr.s_addr = inet_addr(self_ip);		// Master IP ADDRESS
	//addr.sin_addr.s_addr = inet_addr(SERVER_HOST);
	socklen_t socklen;
	socklen = sizeof(struct sockaddr_in);

	socklen_t cliaddr_len;
	struct sockaddr_in cliaddr;
	char str[INET_ADDRSTRLEN];

	struct tcp_info info;
	int leng = sizeof(info);

	//send MSG to Slave
	//pthread_t tid_receive4pubclient;
	//int rt = pthread_create(&tid_receive4pubclient, NULL, receive4pubclient, (void *)&client);
	int rt = pthread_create(&tid_receive4pubclient, NULL, receive4pubclient, NULL);
	if (-1 == rt) {
		printf("WSLT_pub_server: create thread (tid_receive4pubclient) error\n");
		return NULL;
	}

	if (listenfd2) close(listenfd2);		//to avoid: Error: Address already in use

	CHK2(listenfd2, socket(PF_INET, SOCK_STREAM, 0));

	//to avoid: Error: Address already in use
	int on = 1;
	if ((setsockopt(listenfd2, SOL_SOCKET, SO_REUSEADDR, &on, sizeof(on))) < 0) {
		perror("WSLT_pub_server: setsockopt failed");
		exit(EXIT_FAILURE);
	}

	CHK(bind(listenfd2, (struct sockaddr *)&addr, sizeof(addr)));

	//printf("listen\n");
	CHK(listen(listenfd2, LISTEN_SIZE));
	//printf("(%d)-<%s> Master: waiting Slave to connect\n", __LINE__, __FUNCTION__);

	maxfd = listenfd2;
	maxi2 = -1;
	for (i = 0; i < FD_SETSIZE; i++)
		client2[i] = -1;
	FD_ZERO(&allset);
	FD_SET(listenfd2, &allset);	//add listenfd2 to allset

	//select, add all connect fd to allset
	while (1) {
		//sleep(1);

		//clear invalid fd
		for (int i = 0; i <= maxi2; i++) {
			if ((sockfd2 = client2[i]) < 0 || listenfd2 == client2[i] )
				continue;

			//send data to other smartphones (other slaves), [ void *slave(void *arg) ]
			//before reading and writing, first to judge whether the "socket connection" is normal
			getsockopt(sockfd2, IPPROTO_TCP, TCP_INFO, &info, (socklen_t *) &leng);
			if ((info.tcpi_state == TCP_ESTABLISHED)) {		// socket connected 
				;
			} else {		// socket disconnected 
				//printf("(%d)-<%s> Slave closed\n", __LINE__, __FUNCTION__);
				CHK(close(sockfd2));
				FD_CLR(sockfd2, &allset);
				client2[i] = -1;
			}
		}

		rset = allset;
		nready = select(maxfd + 1, &rset, NULL, NULL, NULL);
		if (nready < 0)
			perr_exit("select error");

		if (FD_ISSET(listenfd2, &rset)) {
			cliaddr_len = sizeof(cliaddr);
			CHK2(connfd, accept(listenfd2, (struct sockaddr *)&cliaddr, &cliaddr_len));

			printf("WSLT_pub_server (%s) connected by [ %s:%d ]\n", self_ip, inet_ntop(AF_INET, &cliaddr.sin_addr, str, sizeof(str)), ntohs(cliaddr.sin_port));

			for (i = 0; i < FD_SETSIZE; i++)
				if (client2[i] < 0) {
					client2[i] = connfd;
					break;
				}
			if (i == FD_SETSIZE) {
				fputs("too many clients\n", stderr);
				exit(1);
			}

			FD_SET(connfd, &allset);	//add connfd to allset
			if (connfd > maxfd)
				maxfd = connfd;
			if (i > maxi2)
				maxi2 = i;

			if (--nready == 0)
				continue;
		} //end if
	} //end while
} //end WSLT_pub_server()


//receive SQL from WSLT_pub_client, the goal is to update WSLT
void *receive4pubclient(void *arg)
{
	//int client = *((int *)arg);
	//sleep(5);
	char buf[BUF_SIZE];
	int res, len;
	char clientmsg[CLIENTMSG_SIZE];

	struct tcp_info info;
	int leng = sizeof(info);

	//int pipe_fd[2], epfd;
	int epfd;

	int epoll_events_count;
	static struct epoll_event ev, events[1];
	ev.events = EPOLLIN | EPOLLET;
	//CHK(pipe(pipe_fd));
	CHK2(epfd, epoll_create(EPOLL_SIZE));
	ev.data.fd = pipe_fd[0];	// reader
	CHK(epoll_ctl(epfd, EPOLL_CTL_ADD, pipe_fd[0], &ev));

	//Using epoll to simulate process execution，Database update event，Event driven database synchronization
	while (1) {		//communication between master & slave

		//printf("(%d)-<%s> changed: %d\n", __LINE__, __FUNCTION__, changed);

		//if (changed) break;

		//event_driven, read pipe_fd[0] from handle_client(void *arg) which read * from client-manet.c 
		//epoll_wait(int epfd, struct epoll_event * events, int maxevents, int timeout)
		//参数events用来从内核得到事件的集合，maxevents告之内核这个events有多大，
		//这个 maxevents的值不能大于创建epoll_create()时的size，
		//参数timeout是超时时间 , 毫秒，0会立即返回，-1将不确定，也有说法说是永久阻塞
		if((epoll_events_count = epoll_wait(epfd, events, 1, EPOLL_RUN_TIMEOUT)) < 0){
			//perror("evall");
			//printf("EINTR [%d] [%d]\n", EINTR, epoll_events_count);
			//exit(-1);
			sleep(1);
			continue;
		}

		//epoll
		for (int i = 0; i < epoll_events_count; i++) {
			if (events[i].data.fd == pipe_fd[0])	//reading end of pipe, accept MSG from client-manet.c
			{
				bzero(&clientmsg, CLIENTMSG_SIZE);
				CHK2(res, read(pipe_fd[0], clientmsg, CLIENTMSG_SIZE));
				//printf("(%d)-<%s> clientmsg: %s\n", __LINE__, __FUNCTION__, clientmsg);

				for (int i = 0; i <= maxi2; i++) {
					if ((sockfd2 = client2[i]) < 0 || listenfd2 == client2[i] )
						continue;
					//send data to other smartphones (other slaves), [ void *slave(void *arg) ]
					//before reading and writing, first to judge whether the "socket connection" is normal
					getsockopt(sockfd2, IPPROTO_TCP, TCP_INFO, &info, (socklen_t *) &leng);
					if ((info.tcpi_state == TCP_ESTABLISHED)) {		// socket connected

						bzero(buf, BUF_SIZE);

						//printf("(%d)-<%s> will Recv data\n", __LINE__, __FUNCTION__);
						CHK2(len, recv(sockfd2, buf, BUF_SIZE, MSG_NOSIGNAL));	//read * from master
						printf("WSLT_pub_server (%s) recv SQL from %s: [ %s ]\n", self_ip, masterip, buf);
					}
				} // end for
			} // end if
		} // end for
	} // end while
} //end receive4pubclient()
//----------------------------------------------------------------------used to pub WSLT  - end




//----------------------------------------------------------------------used to syn WSLT  - begin
//communication between WSLT_syn_server & WSLT_syn_client

//-------------------------------------------------WSLT_syn_server  - begin
//arg is sock, arg is NULL
void *WSLT_syn_server(void *arg)
{
	//select (local variables), the other variables (global variables) at the begin of the file
	int i, maxfd, connfd, nready;
	fd_set rset, allset;

	//int listenfd3;		//监听socket
	struct sockaddr_in addr, peer;
	addr.sin_family = PF_INET;
	addr.sin_port = htons(WSLT_syn_server_PORT);
	addr.sin_addr.s_addr = inet_addr(self_ip);		// Master IP ADDRESS
	//addr.sin_addr.s_addr = inet_addr(SERVER_HOST);
	socklen_t socklen;
	socklen = sizeof(struct sockaddr_in);

	socklen_t cliaddr_len;
	struct sockaddr_in cliaddr;
	char str[INET_ADDRSTRLEN];

	struct tcp_info info;
	int leng = sizeof(info);

	//send MSG to Slave
	//pthread_t tid_receive4synclient;
	//int rt = pthread_create(&tid_receive4synclient, NULL, receive4synclient, (void *)&client);
	int rt = pthread_create(&tid_receive4synclient, NULL, receive4synclient, NULL);
	if (-1 == rt) {
		printf("WSLT_syn_server: create thread (receive4synclient) error\n");
		return NULL;
	}

	if (listenfd3) close(listenfd3);		//to avoid: Error: Address already in use

	CHK2(listenfd3, socket(PF_INET, SOCK_STREAM, 0));

	//to avoid: Error: Address already in use
	int on = 1;
	if ((setsockopt(listenfd3, SOL_SOCKET, SO_REUSEADDR, &on, sizeof(on))) < 0) {
		perror("WSLT_syn_server: setsockopt failed");
		exit(EXIT_FAILURE);
	}

	CHK(bind(listenfd3, (struct sockaddr *)&addr, sizeof(addr)));

	//printf("listen\n");
	CHK(listen(listenfd3, LISTEN_SIZE));
	//printf("(%d)-<%s> Master: waiting Slave to connect\n", __LINE__, __FUNCTION__);

	maxfd = listenfd3;
	maxi3 = -1;
	for (i = 0; i < FD_SETSIZE; i++)
		client3[i] = -1;
	FD_ZERO(&allset);
	FD_SET(listenfd3, &allset);	//add listenfd3 to allset

	//select, add all connect fd to allset
	while (1) {
		//sleep(1);

		//clear invalid fd
		for (int i = 0; i <= maxi3; i++) {
			if ((sockfd3 = client3[i]) < 0 || listenfd3 == client3[i] )
				continue;

			//send data to other smartphones (other slaves), [ void *slave(void *arg) ]
			//before reading and writing, first to judge whether the "socket connection" is normal
			getsockopt(sockfd3, IPPROTO_TCP, TCP_INFO, &info, (socklen_t *) &leng);
			if ((info.tcpi_state == TCP_ESTABLISHED)) {		// socket connected 
				;
			} else {		// socket disconnected 
				//printf("(%d)-<%s> Slave closed\n", __LINE__, __FUNCTION__);
				CHK(close(sockfd3));
				FD_CLR(sockfd3, &allset);
				client3[i] = -1;
			}
		}

		rset = allset;
		nready = select(maxfd + 1, &rset, NULL, NULL, NULL);
		if (nready < 0)
			perr_exit("select error");

		if (FD_ISSET(listenfd3, &rset)) {
			cliaddr_len = sizeof(cliaddr);
			CHK2(connfd, accept(listenfd3, (struct sockaddr *)&cliaddr, &cliaddr_len));

			printf("WSLT_syn_server (%s) connected by [ %s:%d ]\n", self_ip, inet_ntop(AF_INET, &cliaddr.sin_addr, str, sizeof(str)), ntohs(cliaddr.sin_port));

			for (i = 0; i < FD_SETSIZE; i++)
				if (client3[i] < 0) {
					client3[i] = connfd;
					break;
				}
			if (i == FD_SETSIZE) {
				fputs("too many clients\n", stderr);
				exit(1);
			}

			FD_SET(connfd, &allset);	//add connfd to allset
			if (connfd > maxfd)
				maxfd = connfd;
			if (i > maxi3)
				maxi3 = i;

			if (--nready == 0)
				continue;
		} //end if
	} //end while
} //end WSLT_syn_server()


//receive SQL from WSLT_syn_client, the goal is to update WSLT
void *receive4synclient(void *arg)
{
	//int client = *((int *)arg);
	//sleep(5);
	char buf[BUF_SIZE];
	int len;

	struct tcp_info info;
	int leng = sizeof(info);

	while (1) {		//communication between WSLT_syn_server & WSLT_syn_client

		//printf("(%d)-<%s> changed: %d\n", __LINE__, __FUNCTION__, changed);
		//if (changed) break;

		for (int i = 0; i <= maxi3; i++) {
			if ((sockfd3 = client3[i]) < 0 || listenfd3 == client3[i] )
				continue;
			//send data to other smartphones (other slaves), [ void *slave(void *arg) ]
			//before reading and writing, first to judge whether the "socket connection" is normal
			getsockopt(sockfd3, IPPROTO_TCP, TCP_INFO, &info, (socklen_t *) &leng);
			if ((info.tcpi_state == TCP_ESTABLISHED)) {		// socket connected

				bzero(buf, BUF_SIZE);

				//printf("(%d)-<%s> will Recv data\n", __LINE__, __FUNCTION__);
				CHK2(len, recv(sockfd3, buf, BUF_SIZE, MSG_NOSIGNAL));	//read * from master
				printf("WSLT_syn_server (%s) recv SQL from %s: [ %s ]\n", self_ip, masterip, buf);
			}
		} // end for
	} // end while
} //end receive4synclient()
//-------------------------------------------------WSLT_syn_server  - end


//-------------------------------------------------WSLT_syn_client  - begin
//arg is sock, arg is NULL
void *WSLT_syn_client(void *arg)
{
	int rt;
	for (int i = 0; i < ipaddr_num; i++) {			//the list of IP addresses

		if (strcmp(ipaddr[i], self_ip)==0) continue;

		if (i==0) {
			rt = pthread_create(&tid_send2synserver_0, NULL, send2synserver, ipaddr[i]);
			if (-1 == rt) { printf("WSLT_syn_client: create thread (send2synserver) error\n"); return NULL; }
		} else if (i==1) {
			rt = pthread_create(&tid_send2synserver_1, NULL, send2synserver, ipaddr[i]);
			if (-1 == rt) { printf("WSLT_syn_client: create thread (send2synserver) error\n"); return NULL; }
		} else if (i==2) {
			rt = pthread_create(&tid_send2synserver_2, NULL, send2synserver, ipaddr[i]);
			if (-1 == rt) { printf("WSLT_syn_client: create thread (send2synserver) error\n"); return NULL; }
		} else if (i==3) {
			rt = pthread_create(&tid_send2synserver_3, NULL, send2synserver, ipaddr[i]);
			if (-1 == rt) { printf("WSLT_syn_client: create thread (send2synserver) error\n"); return NULL; }
		} else if (i==4) {
			rt = pthread_create(&tid_send2synserver_4, NULL, send2synserver, ipaddr[i]);
			if (-1 == rt) { printf("WSLT_syn_client: create thread (send2synserver) error\n"); return NULL; }
		} else if (i==5) {
			rt = pthread_create(&tid_send2synserver_5, NULL, send2synserver, ipaddr[i]);
			if (-1 == rt) { printf("WSLT_syn_client: create thread (send2synserver) error\n"); return NULL; }
		} else if (i==6) {
			rt = pthread_create(&tid_send2synserver_6, NULL, send2synserver, ipaddr[i]);
			if (-1 == rt) { printf("WSLT_syn_client: create thread (send2synserver) error\n"); return NULL; }
		} else if (i==7) {
			rt = pthread_create(&tid_send2synserver_7, NULL, send2synserver, ipaddr[i]);
			if (-1 == rt) { printf("WSLT_syn_client: create thread (send2synserver) error\n"); return NULL; }
		} else if (i==8) {
			rt = pthread_create(&tid_send2synserver_8, NULL, send2synserver, ipaddr[i]);
			if (-1 == rt) { printf("WSLT_syn_client: create thread (send2synserver) error\n"); return NULL; }
		} else if (i==9) {
			rt = pthread_create(&tid_send2synserver_9, NULL, send2synserver, ipaddr[i]);
			if (-1 == rt) { printf("WSLT_syn_client: create thread (send2synserver) error\n"); return NULL; }
		}
	} //end for
} //end WSLT_syn_client()


//send SQL to WSLT_syn_server, the goal is to syn WSLT
//synserverip is one item of IP_list			//the list of IP addresses
void *send2synserver(void *synserverip)
{
	int sock;

	// timestamp
	struct timeval tv;

	struct tcp_info info;
	int leng = sizeof(info);

	struct sockaddr_in seraddr;
	seraddr.sin_family = PF_INET;
	seraddr.sin_port = htons(MASTER_PORT);
	seraddr.sin_addr.s_addr = inet_addr(synserverip);	//Master ip address, added in /etc/hosts
	//seraddr.sin_addr.s_addr = inet_addr(SERVER_HOST);

	CHK2(sock, socket(PF_INET, SOCK_STREAM, 0));
	CHK(connect(sock, (struct sockaddr *)&seraddr, sizeof(seraddr)) < 0);

	int len;
	char *sql="INSERT INTO webservice (name, suuid, url) VALUES ('webservice1', 'xxxx', 'www.ws.com/ws1');";

	while (1)		//communication between WSLT_syn_server & WSLT_syn_client
	{
		//printf("(%d)-<%s> slave changed: %d\n", __LINE__, __FUNCTION__, changed);

/*
		if (changed) {
			CHK(close(sock));
 			break;
		}
//*/
		//before reading and writing, first to judge whether the "socket connection" is normal
		getsockopt(sock, IPPROTO_TCP, TCP_INFO, &info, (socklen_t *) &leng);
		if ((info.tcpi_state == TCP_ESTABLISHED)) {		//socket connected 
			CHK(send(sock, sql, strlen(sql), MSG_NOSIGNAL));
			// timestamp
			gettimeofday(&tv,NULL);
			printf("WSLT_syn_client (%s) send SQL to %s: [ %s ] at millisecond:%ld\n", self_ip, synserverip, sql, tv.tv_sec*1000 + tv.tv_usec/1000);

		} else {		// socket disconnected 
			CHK(close(sock));
			//return NULL;
			seraddr.sin_addr.s_addr = inet_addr(synserverip);	//Master ip address
			CHK2(sock, socket(PF_INET, SOCK_STREAM, 0));
			CHK(connect(sock, (struct sockaddr *)&seraddr, sizeof(seraddr)) < 0);
			//printf("(%d)-<%s> reconnect Master: [ %s ]\n", __LINE__, __FUNCTION__, synserverip);

			// timestamp
			gettimeofday(&tv,NULL);
			printf("WSLT_syn_client (%s) reconnect WSLT_syn_server (%s) at millisecond:%ld\n", self_ip, synserverip, tv.tv_sec*1000 + tv.tv_usec/1000);

			sleep(1);
			continue;
		}

		//update correlative tables in database;
		//todo
	} //end while
} //end send2synserver()
//-------------------------------------------------WSLT_syn_client  - end

//----------------------------------------------------------------------used to syn WSLT  - end



//to simulate process execution，Database update event，Event driven database synchronization
//handle_client on SMD that waiting data sent by client-manet.c
//client-manet send MESSAGE to handle_client
//arg refer to pipefd
void *handle_client(void *arg)
{
	//socket to listen
	int listener;		//监听socket
	struct sockaddr_in addr, peer;
	addr.sin_family = PF_INET;
	addr.sin_port = htons(CLIENT_PORT);
	addr.sin_addr.s_addr = inet_addr(self_ip);
	socklen_t socklen;
	socklen = sizeof(struct sockaddr_in);
	int len;
	int client;

	// timestamp
	struct timeval tv;

	struct tcp_info info;
	int leng = sizeof(info);

	CHK2(listener, socket(PF_INET, SOCK_STREAM, 0));

	// to avoid: Error: Address already in use
	int on = 1;
	if ((setsockopt(listener, SOL_SOCKET, SO_REUSEADDR, &on, sizeof(on))) < 0) {
		perror("client: setsockopt failed\n");
		exit(EXIT_FAILURE);
	}

	CHK(bind(listener, (struct sockaddr *)&addr, sizeof(addr)));

	//printf("listen\n");
	CHK(listen(listener, LISTEN_SIZE));
	//printf("(%d)-<%s> client: listening\n", __LINE__, __FUNCTION__);
	//socket to listen

	int pipe_write = *((int *)arg);
	char clientmsg[CLIENTMSG_SIZE];

	while (1) {
		CHK2(client, accept(listener, (struct sockaddr *)&peer, &socklen));
		//printf("(%d)-<%s> client: accepted\n", __LINE__, __FUNCTION__);

		while (1) {
			//------------------read * from client-manet

			//before reading and writing, first to judge whether the "socket connection" is normal
			getsockopt(client, IPPROTO_TCP, TCP_INFO, &info, (socklen_t *) &leng);
			if ((info.tcpi_state == TCP_ESTABLISHED)) {		//socket connected 
				bzero(clientmsg, CLIENTMSG_SIZE);			//receive MESSAGE from client-manet.c
				CHK2(len, recv(client, clientmsg, CLIENTMSG_SIZE, MSG_NOSIGNAL));
				if (len > 0) {

					// timestamp
					//printf("second:%ld\n",tv.tv_sec);
		gettimeofday(&tv,NULL);
		printf("(%d)-<%s> client-manet connected at millisecond:%ld\n", __LINE__, __FUNCTION__, tv.tv_sec*1000 + tv.tv_usec/1000);
					//printf("microsecond:%ld\n",tv.tv_sec*1000000 + tv.tv_usec);

					//printf("(%d)-<%s> write pipe_write: %s\n", __LINE__, __FUNCTION__, clientmsg);
					CHK(write(pipe_write, clientmsg, strlen(clientmsg)));	//send MSG to send2slave(void)
				}
			} else {		// socket disconnected 
				printf("client-manet disconnected to server-manet\n");
				CHK(close(client));
				break;
			}
		} //end while
	} //end while

	return NULL; // not reach there
} //end handle_client thread

int main(int argc, char *argv[])
{
	//size_t buffer_size = 16;
	//char self_ip[16];
	//memset(self_ip, 0, 16);

	CHK(pipe(pipe_fd));

	self_ip = malloc(16 * sizeof(char));
	bzero(self_ip, 16);
	sprintf(self_ip,"%s",getipaddress(IF_NAME));

	//------- create thread: read_ctrl
	pthread_t readctrl;
	int rc = pthread_create(&readctrl, NULL, read_ctrl, NULL);
	if (-1 == rc) {
		printf("read_ctrl thread creation error\n");
		return -1;
	}
	//------- create thread: read_ctrl

	//------- create thread: handle_client
	pthread_t writer;
	int rt = pthread_create(&writer, NULL, handle_client, (void *)&pipe_fd[1]);
	if (-1 == rt) {
		printf("main: create thread (handle_client) error\n");
		return -1;
	}
	//------- create thread: handle_client

	sleep(3);		//waiting for read_ctrl to read the value of ctrl and master_ip of Master SMD
	//int start=1;		//set initial state

	//pthread_t tid;	//used in pthread_join

	void *tret;		//used in pthread_join

	while (1) {
		//printf("(%d)-<%s> start: %d\t ctrl: %d\t changed: %d\n", __LINE__, __FUNCTION__, start, ctrl, changed);

		if (start==1 && ctrl==1) {
			//printf("(%d)-<%s> start: %d\t ctrl: %d\t changed: %d\n", __LINE__, __FUNCTION__, start, ctrl, changed);
			printf("I am Master (%s)\n", self_ip);
			start=0;
			is_me=1;
			pthread_create(&tid_master, NULL, master, NULL);	//used to syn multi-engine
			pthread_create(&tid_WSLT_pub_server, NULL, WSLT_pub_server, NULL);	//used to pub WSLT
			pthread_create(&tid_WSLT_syn_client, NULL, WSLT_syn_client, NULL);	//used to syn WSLT
			pthread_join(tid_master, &tret);			//used to syn multi-engine
			pthread_join(tid_WSLT_pub_server, &tret);				//used to pub WSLT
			pthread_join(tid_WSLT_syn_client, &tret);				//used to syn WSLT
		} else if (start==1 && ctrl==0) {
			//printf("(%d)-<%s> start: %d\t ctrl: %d\t changed: %d\n", __LINE__, __FUNCTION__, start, ctrl, changed);
			printf("I am Slave (%s)\n", self_ip);
			start=0;
			is_me=0;
			pthread_create(&tid_slave, NULL, slave, NULL);		//used to syn multi-engine
			pthread_create(&tid_WSLT_pub_client, NULL, WSLT_pub_client, NULL);	//used to pub WSLT
			pthread_create(&tid_WSLT_syn_server, NULL, WSLT_syn_server, NULL);	//used to syn WSLT
			pthread_join(tid_slave, &tret);				//used to syn multi-engine
			pthread_join(tid_WSLT_pub_client, &tret);				//used to pub WSLT
			pthread_join(tid_WSLT_syn_server, &tret);				//used to syn WSLT
		} else if (start==0 && changed==1 && ctrl==1) {
			sleep(1);	//waiting to socket address 
			//printf("(%d)-<%s> start: %d\t ctrl: %d\t changed: %d\n", __LINE__, __FUNCTION__, start, ctrl, changed);
			printf("I am Master (%s) again\n", self_ip);
			pthread_create(&tid_master, NULL, master, NULL);	//used to syn multi-engine
			pthread_create(&tid_WSLT_pub_server, NULL, WSLT_pub_server, NULL);	//used to pub WSLT
			pthread_create(&tid_WSLT_syn_client, NULL, WSLT_syn_client, NULL);	//used to syn WSLT
			pthread_join(tid_master, &tret);			//used to syn multi-engine
			pthread_join(tid_WSLT_pub_server, &tret);				//used to pub WSLT
			pthread_join(tid_WSLT_syn_client, &tret);				//used to syn WSLT
		} else if (start==0 && changed==1 && ctrl==0) {
			sleep(6);	//waiting master initialize
			//printf("(%d)-<%s> start: %d\t ctrl: %d\t changed: %d\n", __LINE__, __FUNCTION__, start, ctrl, changed);
			printf("I am Slave (%s) again\n", self_ip);
			pthread_create(&tid_slave, NULL, slave, NULL);		//used to syn multi-engine
			pthread_create(&tid_WSLT_pub_client, NULL, WSLT_pub_client, NULL);	//used to pub WSLT
			pthread_create(&tid_WSLT_syn_server, NULL, WSLT_syn_server, NULL);	//used to syn WSLT
			pthread_join(tid_slave, &tret);				//used to syn multi-engine
			pthread_join(tid_WSLT_pub_client, &tret);				//used to pub WSLT
			pthread_join(tid_WSLT_syn_server, &tret);				//used to syn WSLT
		} else continue;	//start==0 and changed==0

		//sleep(1);
	} //end while

} //end main()
