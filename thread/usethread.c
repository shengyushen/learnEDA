#include<stdio.h>
#include<stdlib.h>
#include<string.h>
#include<unistd.h>
#include<pthread.h>
#include<assert.h>

#define LINE_SIZE 128

typedef struct  {
	int seconds;
	char message[64];
} alarm_t;

void * alarm_thread (void * pv) {
	alarm_t * palarm=(alarm_t*) pv;
	//detach to avoid the main thread from reading sub thread's status
	int status=pthread_detach(pthread_self());
	assert(status==0) ;
	sleep(palarm->seconds);
	printf("%d %s\n",palarm->seconds,palarm->message);
	free(palarm);
	return NULL;
}

int main(int argc, char*argv[]) {
	char line[LINE_SIZE];

	while(1) {
		printf("alarming..\n");
		fgets(line,LINE_SIZE,stdin);
		if(strlen(line)<=1) continue;

		alarm_t * palarm = malloc(sizeof(alarm_t));
		int status_scanf= sscanf(line ,"%d %64[^\n]",&(palarm->seconds),(palarm->message));
		if(status_scanf!=2) continue;

		pthread_t thread;
		int status = pthread_create(&thread,NULL,alarm_thread,palarm);
		//or we can wait for the thread with pthread_join and without pthread_detach
		assert(status==0);
	}
	//returning cause all sub threads terminate
	// can you keep them alive but exit main with pthread_exit
	return 0;
}
