SRC=src
BLD=build
LIB=lib

$(BLD)/%.o:$(SRC)/%.c
	mkdir -p $(@D)
	clang -c $< -o $@

$(LIB)/liba.dylib: $(BLD)/a.o
	mkdir -p $(@D)
	libtool -dynamic -o $@ $(BLD)/a.o

# we need libSystem.dylib for lazy binding.
$(LIB)/libb.dylib: $(BLD)/b.o $(LIB)/liba.dylib
	mkdir -p $(@D)
	libtool -dynamic -o $@ $(BLD)/b.o -L$(LIB) -la -lSystem

main: $(BLD)/main.o $(LIB)/libb.dylib
	clang -o $@ $(BLD)/main.o -L$(LIB) -lb

.PHONY: clean
clean:
	rm -fR $(BLD) $(LIB) main
