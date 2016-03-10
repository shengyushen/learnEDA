#include<stdio.h>
#include<stdlib.h>
#include<string.h>
#include<unistd.h>

#define LINE_SIZE 128
int main(int argc, char*argv[]) {
	int seconds;
	char line[LINE_SIZE];
	char message[64];

	while(1) {
		printf("alarming..\n");
		fgets(line,LINE_SIZE,stdin);
		//notice: the return char is in line
		//printf("szie of line is %lu\n",strlen(line));
		if(strlen(line)<=1) continue;
		if(sscanf(line ,"%d %64[^\n]",&seconds,message)<2)  {
			fprintf(stderr,"bad command\n");
		} else {
			pid_t pid=fork();
			if(pid==(pid_t)-1) {
				fprintf(stderr,"Error : forking fail\n");
			} else if(pid==(pid_t)0) {
				//in child
				sleep(seconds);
				printf("%d %s\n",seconds,message);
				exit(0);
			} else {
				do {
					//drain all changed state process, and test for o in end of while
					pid=waitpid((pid_t)-1,NULL,WNOHANG);
					if(pid==(pid_t)-1) {
						fprintf(stderr,"Error : waitpid fail\n");
					}
				} while(pid!=(pid_t)0);
			}
		}
	}
}
