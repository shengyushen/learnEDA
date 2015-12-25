OBJS = ssyvector.o ssycontainer.o main.o 
GPP = g++
GPPOPT = -std=gnu++11

main.exe : $(OBJS)
	$(GPP) $(GPPOPT) $^ -o $@ 

%.o : %.cpp
	$(GPP) $(GPPOPT) -c $<

depend :
	$(GPP) -E -MM *.cpp > .depend

sinclude .depend

clean : 
	rm -f *.exe *.o

