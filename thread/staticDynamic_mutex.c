#include <pthread.h>
#include <stdlib.h>
#include <stdio.h>

#include "errors.h"

typedef struct my_struct {
	pthread_mutex_t mutex;
	int value;
} my_struct_t;


my_struct_t data={PTHREAD_MUTEX_INITIALIZER,0};


int main(int argc, char** argv) {

	my_struct_t * p_my_struct;

	p_my_struct = (my_struct_t *)malloc(sizeof(my_struct_t));
	if(((void *)p_my_struct)==NULL) error_abort("allocing my_struct_t");

	
	int status=pthread_mutex_init(&(p_my_struct->mutex),NULL);
	if(status!=0) error_abort("init mutex");

	status = pthread_mutex_destroy(&(p_my_struct->mutex));
	if(status!=0) error_abort("destroy mutex");

	(void) free(p_my_struct);
	return 0;
}
