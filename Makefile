.SUFFIXES : .c .o 
#override CFLAGS += -O2 -Wall 
CFLAGS += -O2 -Wall 
OBJS = main.o
SRCS = $(OBJS:.o=.c)
 
test : $(OBJS)
	$(CC) -o test $(OBJS)

clean:
	@rm ./*.o
	@rm test

