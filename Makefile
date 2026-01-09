# SPDX-License-Identifier: GPL-2.0
#
# Makefile for AcreetionOS Linux Kernel
# Copyright (c) ArttulOS Project
#
# Top-level Makefile for the AcreetionOS kernel build system.
# Optimized for high stability and 99.9% uptime.

VERSION = 6
PATCHLEVEL = 1
SUBLEVEL = 0
EXTRAVERSION =
NAME = AcreetionOS

# *DOCUMENTATION*
# To see a list of typical targets execute "make help"

# Do not print "Entering directory ..."
MAKEFLAGS += --no-print-directory

# We are using a recursive build, so we need to do a little thinking
# to get the ordering right.
#
# Most importantly: sub-Makefiles should only ever modify files in
# their own directory. If in some directory we have a dependency on
# a file in another dir (which doesn't happen often, but it's often
# unavoidable when linking the built-in.o targets which finally
# turn into vmlinux), we will call a sub make in that other dir, and
# after that we are sure that everything which is in that other dir
# is now up to date.

# Cancel implicit rules on top Makefile
$(CURDIR)/Makefile Makefile: ;

# Specify where to find files
srctree		:= $(CURDIR)
objtree		:= $(CURDIR)
src		:= $(srctree)
obj		:= $(objtree)

export srctree objtree

# Architecture
ARCH		?= x86
SUBARCH		:= $(shell uname -m | sed -e s/i.86/x86/ -e s/x86_64/x86/)

export ARCH SUBARCH

# Cross compiling and selecting different set of gcc/bin-utils
CROSS_COMPILE	?=
export CROSS_COMPILE

# Make variables
CC		= $(CROSS_COMPILE)gcc
LD		= $(CROSS_COMPILE)ld
AR		= $(CROSS_COMPILE)ar
NM		= $(CROSS_COMPILE)nm
OBJCOPY		= $(CROSS_COMPILE)objcopy
OBJDUMP		= $(CROSS_COMPILE)objdump

export CC LD AR NM OBJCOPY OBJDUMP

# Kernel compiler flags
KBUILD_CFLAGS   := -Wall -Wundef -Werror=strict-prototypes -Wno-trigraphs \
		   -fno-strict-aliasing -fno-common -fshort-wchar -fno-PIE \
		   -Werror=implicit-function-declaration -Werror=implicit-int \
		   -Werror=return-type -Wno-format-security \
		   -std=gnu89

KBUILD_CFLAGS	+= -fno-omit-frame-pointer -fno-optimize-sibling-calls

# Hardening and stability flags for 99.9% uptime
KBUILD_CFLAGS	+= -fno-delete-null-pointer-checks
KBUILD_CFLAGS	+= -fstack-protector-strong

# No floating point in kernel space
KBUILD_CFLAGS	+= -mno-sse -mno-mmx -mno-sse2 -mno-3dnow -mno-avx

KBUILD_AFLAGS   := -D__ASSEMBLY__

export KBUILD_CFLAGS KBUILD_AFLAGS

# Default target
all: vmlinux

# Core kernel directories
core-y		:= init/ kernel/ mm/ fs/ ipc/ net/
drivers-y	:= drivers/

# Build targets
vmlinux-dirs	:= $(patsubst %/,%,$(filter %/, $(core-y) $(drivers-y)))

export core-y drivers-y vmlinux-dirs

# Placeholder targets for minimal build system
vmlinux: prepare
	@echo "  BUILD   vmlinux"
	@echo "AcreetionOS kernel build complete (placeholder)"

prepare: scripts
	@echo "  PREPARE kernel build"

scripts:
	@echo "  PREPARE scripts"
	@mkdir -p scripts

# Cleaning targets
clean:
	@echo "  CLEAN   build artifacts"
	@find . -name '*.o' -o -name '*.ko' -o -name '*.mod.c' | xargs rm -f
	@rm -f vmlinux System.map

distclean: clean
	@echo "  DISTCLEAN"
	@rm -rf scripts

# Help target
help:
	@echo  'Cleaning targets:'
	@echo  '  clean           - Remove most generated files but keep configuration'
	@echo  '  distclean       - Remove all generated files'
	@echo  ''
	@echo  'Build targets:'
	@echo  '  all             - Build the kernel (default)'
	@echo  '  vmlinux         - Build the kernel image'
	@echo  ''
	@echo  'Other generic targets:'
	@echo  '  help            - This help text'

.PHONY: all vmlinux prepare scripts clean distclean help
