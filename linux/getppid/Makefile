OBJS = main.o 
GPP = g++
GPPOPT =

main.exe : $(OBJS)
	$(GPP) $(GPPOPT) $^ -o $@ 

%.o : %.cpp
	$(GPP) $(GPPOPT) -c $<

depend :
	$(GPP) -E -MM *.cpp > .depend

sinclude .depend

clean : 
	rm -f *.exe *.o

