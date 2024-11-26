.PHONY: all

EXE = fx-trader

CXX = g++


# Directories
SRC_DIR = src
OBJ_DIR = .obj
INC_DIR = include



# Source files
SRCS = $(wildcard $(SRC_DIR)/*.cpp)
OBJS = $(patsubst $(SRC_DIR)/%.cpp,$(OBJ_DIR)/%.o,$(SRCS))

SRC1 = $(wildcard $(INC_DIR)/imgui/*.cpp)
OBJS += $(patsubst $(INC_DIR)/imgui/%.cpp,$(OBJ_DIR)/%.o,$(SRC1))

SRC2 = $(wildcard $(INC_DIR)/glad/src/glad.c)
OBJS += $(patsubst $(INC_DIR)/glad/src/%.c,$(OBJ_DIR)/%.o,$(SRC2))


LIBS =
UNAME_S := $(shell uname -s)
LINUX_GL_LIBS = -lGL


CXXFLAGS = -std=c++17 -pthread

ifeq ($(UNAME_S), Linux) #LINUX
	ECHO_MESSAGE = "Linux"
	LIBS += $(LINUX_GL_LIBS) `pkg-config --static --libs glfw3`

	CXXFLAGS += `pkg-config --cflags glfw3`
	CFLAGS = $(CXXFLAGS)
endif

CXXFLAGS += -g -Iinclude/imgui
#-I/usr/local/include  -L/usr/local/lib -lglfw3 -ldl -lGL -Wall -Wextra


# Executable
TARGET = fx-trader


$(OBJ_DIR)/%.o:%.cpp | $(OBJ_DIR) | $(OBJ_DIR)
	$(CXX) $(CXXFLAGS) -c -o $@ $<

$(OBJ_DIR)/%.o: $(INC_DIR)/imgui/%.cpp | $(OBJ_DIR)
	$(CXX) $(CXXFLAGS) -c -o $@ $<

$(OBJ_DIR)/%.o: $(INC_DIR)/glad/src/%.c | $(OBJ_DIR)
	$(CXX) $(CXXFLAGS) -c -o $@ $<

$(OBJ_DIR)/%.o: $(SRC_DIR)/%.cpp | $(OBJ_DIR)
	$(CXX) $(CXXFLAGS) -c -o $@ $<


all: $(EXE)
	@echo Build complete for $(ECHO_MESSAGE)

$(EXE): $(OBJS)
	$(CXX) -o $@ $^ $(CXXFLAGS) $(LIBS)


.PHONY: clean

clean:
	rm -f $(OBJ_DIR)/*.o $(TARGET)


$(OBJ_DIR):
	@mkdir -p $@
