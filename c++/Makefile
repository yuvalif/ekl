# making all .cpp files in the directory
# each one into its own object

CXX ?= g++ 

CXXFLAGS ?= -Wall --std=c++11

LIB = libekl.a

SRCS = $(wildcard *.cpp)

OBJS = $(patsubst %.cpp,%.o,$(SRCS))

TESTS = $(wildcard *_test.cpp)

TEST_BIN = test_runner

all: $(LIB)

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

.PHONY: all clean test

