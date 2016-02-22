OBJS = isok.o ssy.o 
GPP = g++
GPPOPT = -fprofile-arcs -ftest-coverage

test : main.exe
	- ./main.exe 
	./main.exe 1
	./main.exe 2
	gcov ssy.cpp

main.exe : $(OBJS)
	$(GPP) $(GPPOPT) $^ -o $@ 

%.o : %.cpp
	$(GPP) $(GPPOPT) -c $<

depend :
	$(GPP) -E -MM *.cpp > .depend

sinclude .depend

clean : 
	rm -f *.exe *.o *.gcov *.gcno *.gcda *.out

