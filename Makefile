prefix=/usr/local

CFLAGS += -Wall
CXXFLAGS += -D_GLIBCXX_DEBUG -std=c++11 -Wall -Werror -Wno-psabi
LDLIBS += -lm -latomic

ifeq ($(findstring armv6,$(shell uname -m)),armv6)
# Broadcom BCM2835 SoC with 700 MHz 32-bit ARM 1176JZF-S (ARMv6 arch)
PI_VERSION = -DRPI1
else
# Broadcom BCM2836 SoC with 900 MHz 32-bit quad-core ARM Cortex-A7  (ARMv7 arch)
# Broadcom BCM2837 SoC with 1.2 GHz 64-bit quad-core ARM Cortex-A53 (ARMv8 arch)
PI_VERSION = -DRPI23
endif

all: PiCW

mailbox.o: mailbox.c mailbox.h
	$(CC) $(CFLAGS) -c mailbox.c

PiCW: PiCW.cpp mailbox.o mailbox.h
	$(CXX) $(CXXFLAGS) $(LDLIBS) $(PI_VERSION) -pthread mailbox.o PiCW.cpp -o PiCW

clean:
	-rm -f PiCW *.o

.PHONY: install
install: PiCW
	install -m 0755 PiCW $(prefix)/bin

.PHONY: uninstall
uninstall:
	-rm -f $(prefix)/bin/PiCW

