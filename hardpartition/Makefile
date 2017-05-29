OBJS =  main.o 
CC = g++
CFLAGS = -std=c++11 

main.exe : $(OBJS)
	$(CC)  $^ -o $@  $(CFLAGS)

%.o : %.cpp
	$(CC)  -c $< $(CFLAGS)

depend :
	$(CC) -E -MM *.cpp > .depend

sinclude .depend

clean : 
	rm -f *.exe *.o

