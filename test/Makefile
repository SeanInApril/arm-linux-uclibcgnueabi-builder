#######################################################
#                                                     #
# Makefile                                            #
#                                                     #
# Sean<SeanInApril@163.com>                           #
#                                                     #
# Usage: Script to test toolchains                    #
#                                                     #
#######################################################
CFLAGS  := -g -O1
LDFLAGS :=

ifneq (${TEST_PREFIX},)
PREFIX := ${TEST_PREFIX}
else
$(error "no PREFIX defined")
endif

.PHONY: all clean

all:
	@echo "build test..."
	${PREFIX}gcc ${CFLAGS} -c hello.c -o hello.o
	${PREFIX}gcc ${CFLAGS} hello.c -o hello-sta.elf -static
	${PREFIX}gcc ${CFLAGS} hello.c -o hello-dyn.elf
	${PREFIX}objdump -d hello.o > hello.src
	@echo "build test end"

clean:
	rm -rf *.o *.elf *.src *.out
