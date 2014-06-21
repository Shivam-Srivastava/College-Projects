# Simple Makefile

# Your compiler
CC = g++
# Compilation flags
# '-g' turns debugging flags on.
CFLAGS = -g -I /usr/local/include/opencv -I /usr/local/include -L /usr/local/lib

# Linker flags
# When you need to add a library
# '-lm' adds the math library
LDFLAGS = -lm -lopencv_core -lopencv_imgproc -lopencv_highgui -lopencv_video -lopencv_ml -lopencv_ts -lopencv_legacy -lopencv_objdetect -lopencv_calib3d -lopencv_contrib

# all is a target. main is a 'dependency' or requirement for all to be complete
all: main

# The main program depends on the complex number library, and the main file
main: main.o 2d_hair_reconstruct.o
	$(CC) -o $@ $^ $(LDFLAGS) 			# $@ stores the target, 'main' $^ stores all the dependencies 'main.o complex.o'

main.o: main.cpp 2d_hair_reconstruct.hpp
	$(CC) -c $(CFLAGS) -o $@ $(LDFLAGS) $<			# $< stores the first target, just the '.c' file (we won't compile the .h files)

2d_hair_reconstruct.o: 2d_hair_reconstruct.cpp 2d_hair_reconstruct.hpp
	$(CC) -c $(CFLAGS) -o $@ $(LDFLAGS) $<			# $< stores the first target, just the '.c' file (we won't compile the .h files)

# .PHONY tells make that 'all' or 'clean' aren't _actually_ files, and always
# execute the compilation action when 'make all' or 'make clean' are used
.PHONY: all clean							

# Delete all the temporary files we've created so far
clean:
	rm -rf main.o 2d_hair_reconstruct.o
	rm -rf main

