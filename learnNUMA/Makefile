OBJS =  main.o 
CC = gcc
CFLAGS = -lnuma

main.exe : $(OBJS)
	$(CC)  $^ -o $@  $(CFLAGS)

%.o : %.c
	$(CC)  -c $< $(CFLAGS)

depend :
	$(CC) -E -MM *.c > .depend

sinclude .depend

clean : 
	rm -f *.exe *.o

