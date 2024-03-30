# Makefile

# SOURCES (core and app/src prefix omitted)
CORE_SOURCES = test.cpp
APP_SOURCES = main.cpp

# DEPENDENCIES
CORE_OBJS = $(CORE_SOURCES:.cpp=.o)
APP_OBJS = $(APP_SOURCES:.cpp=.o)

# COMPILER
GCC = g++
LINK = g++

CFLAGS = -Wall -Wextra -O3 -std=c++17 -I.

# Special Libraries
CORE_LIBS = 
APP_LIBS = 

BUILD_DIR = build
CORE_DIR = core/src
APP_DIR = app/src
CORE_OUT = $(BUILD_DIR)/libcore.so
APP_OUT = $(BUILD_DIR)/app

all: app

core: $(CORE_OUT)

app: core $(APP_OUT)

clean:
	rm -rf $(BUILD_DIR)
	rm -rf $(addprefix $(APP_DIR)/,$(APP_OBJS))
	rm -rf $(addprefix $(CORE_DIR)/,$(CORE_OBJS))

# special instructions for compiler | core object files
$(CORE_DIR)/%.o: $(CORE_DIR)/%.cpp
	$(GCC) $(CFLAGS) -c -fPIC -o $@ $^

# special instructions for compiler | core linking
$(CORE_OUT): $(addprefix $(CORE_DIR)/,$(CORE_OBJS))
	@mkdir -p $(BUILD_DIR)
	$(LINK) -shared -o $@ $^ $(CORE_LIBS)

# special instructions for compiler | app linking
$(APP_OUT): $(addprefix $(APP_DIR)/,$(APP_OBJS))
	$(LINK) $(CFLAGS) -o $@ $^ -L$(BUILD_DIR) -lcore -Wl,-rpath,'$$ORIGIN/../'$(BUILD_DIR)

.PHONY: clean
