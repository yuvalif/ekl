# making all .cpp files in the directory
# each one into its own object

CXX ?= g++ 

CXXFLAGS ?= -Wall --std=c++11 -O2 -Wno-unused-but-set-variable -Wno-unused-variable

LIB = libekl.a

PROG = min_estimation

SRCS = $(wildcard *.cpp)

OBJS = $(patsubst %.cpp,%.o,$(SRCS))

TESTS = $(wildcard *_test.cpp)

TEST_BIN = test_runner

all: $(PROG)

lib: $(LIB)

$(PROG): $(LIB)
	$(CXX) $(CXXFLAGS) -o $(PROG) $(addsuffix .cpp,$(PROG)) $(LIB)

$(LIB): $(OBJS)
	ar r $(LIB) $(OBJS)

%: %.cpp
	$(CXX) -c $(CXXFLAGS) -o $@ $<

test: $(TESTS)
	$(CXX) $(CXXFLAGS) -o $(TEST_BIN) $< $(LIB)
	./$(TEST_BIN)
	rm -f $(TEST_BIN)

clean: 
	rm -f $(OBJS)
	rm -f $(LIB)
	rm -f $(PROG)

.PHONY: all clean test lib

