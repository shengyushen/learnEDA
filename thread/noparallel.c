#include<stdio.h>
#include<string.h>
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
			sleep(seconds);
			printf("%d %s\n",seconds,message);
		}
	}
}
