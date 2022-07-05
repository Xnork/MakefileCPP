TARGET_VERSION = 0.0.1
TARGET = App

BIN_DIR = bin
SRC_DIR = src
SRC_FILES = $(shell find $(SRC_DIR) -type f -iname *.cpp)
OBJECTS = $(SRC_FILES:%.cpp=%.o)
INCLUDES = -Iinclude -I$(shell find lib -type d -iname include)
LIBS = -L$(sort $(dir $(wildcard lib/*/)))
BUILD_TYPE = debug
CPP_FLAGS = -std=c++17 $(INCLUDES)
RM = @rm
Q = @
ECHO = @echo
TEST_DIR = tests

ifeq ($(BUILD_TYPE),debug)
	CPP_FLAGS += -O0 -g
else ifeq ($(BUILD_TYPE),release)
	CPP_FLAGS += -O3 -s -DNDEBUG
else
	$(error Build type $(BUILD_TYPE) error.)
	@exit 1
endif

all: deps $(OBJECTS) $(TARGET)	
.PHONY: all

%.o: %.cpp
	$(ECHO) "\033[32mCompiling\033[0m[\033[33m$(notdir $@)\033[0m] \033[36m$(dir $<)\033[33m$(notdir $<)\033[0m..."
	$(Q)$(CXX) -c -o $@ $< $(CPP_FLAGS)
$(TARGET): $(OBJECTS)
	$(ECHO) "\033[32;1mLinking\033[0m executable \033[33m$(TARGET)\033[0m..."
	$(Q)$(CXX) -o $@ $^ $(LIBS)

clean:
	$(RM) $(OBJECTS) $(TARGET)
clean_all:
	$(RM) $(OBJECTS) $(TARGET)
	$(MAKE) -C lib clean
deps:
	$(MAKE) -C lib
clean_deps:
	$(MAKE) -C lib clean
test:
	$(MAKE) -C $(TEST_DIR)
