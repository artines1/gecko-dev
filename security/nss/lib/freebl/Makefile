#! gmake
#
# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.

#######################################################################
# (1) Include initial platform-independent assignments (MANDATORY).   #
#######################################################################

include manifest.mn

#######################################################################
# (2) Include "global" configuration information. (OPTIONAL)          #
#######################################################################

include $(CORE_DEPTH)/coreconf/config.mk

#######################################################################
# (3) Include "component" configuration information. (OPTIONAL)       #
#######################################################################



#######################################################################
# (4) Include "local" platform-dependent assignments (OPTIONAL).      #
#######################################################################

include config.mk

# default for all platforms
# unset this on those that have multiple freebl libraries
FREEBL_BUILD_SINGLE_SHLIB = 1

ifdef USE_64
	DEFINES += -DNSS_USE_64
endif

ifdef USE_ABI32_FPU
	DEFINES += -DNSS_USE_ABI32_FPU
endif

ifeq ($(FREEBL_NO_DEPEND),1)
	DEFINES += -DFREEBL_NO_DEPEND
	STUBS_SRCS = stubs.c
endif

ifeq ($(FREEBL_LOWHASH),1)
	DEFINES += -DFREEBL_LOWHASH
	LOWHASH_SRCS = nsslowhash.c
	LOWHASH_EXPORTS = nsslowhash.h
	MAPFILE_SOURCE = freebl_hash_vector.def
	NEED_STUB_BUILD = 1
else
	MAPFILE_SOURCE = freebl.def
endif

ifdef USE_STUB_BUILD
	CSRCS           = lowhash_vector.c
	SIMPLE_OBJS     = $(CSRCS:.c=$(OBJ_SUFFIX))
	OBJS            = $(addprefix $(OBJDIR)/$(PROG_PREFIX), $(SIMPLE_OBJS))
	ALL_TRASH :=    $(TARGETS) $(OBJS) $(OBJDIR) LOGS TAGS $(GARBAGE) \
                $(NOSUCHFILE) so_locations
	MAPFILE_SOURCE = freebl_hash.def
endif

# FREEBL_USE_PRELINK
#
# Most modern version of Linux support a speed optimization scheme where an
# application called prelink modifies programs and shared libraries to quickly
# load if they fit into an already designed address space. In short, prelink
# scans the list of programs and libraries on your system, assigns them a
# predefined space in the the address space, then provides the fixups to the
# library.
#
# The modification of the shared library is correctly detected by the freebl
# FIPS checksum scheme where we check a signed hash of the library against the
# library itself.
#
# The prelink command itself can reverse the process of modification and output
# the prestine shared library as it was before prelink made it's changes.
# This option tells Freebl could use prelink to output the original copy of
# the shared library before prelink modified it.
#
# FREEBL_PRELINK_COMMAND
#
# This is an optional environment variable which can override the default
# prelink command. It could be used on systems that did something similiar to 
# prelink but used a different command and syntax. The only requirement is the 
# program must take the library as the last argument, the program must output 
# the original library to standard out, and the program does not need to take 
# any quoted or imbedded spaces in its arguments (except the path to the 
# library itself, which can have imbedded spaces or special characters).
#
ifdef FREEBL_USE_PRELINK
	DEFINES += -DFREEBL_USE_PRELINK
ifdef LINUX
	DEFINES += -D__GNU_SOURCE=1
endif
endif
ifdef NSS_NO_INIT_SUPPORT
    DEFINES += -DNSS_NO_INIT_SUPPORT
endif

ifdef FREEBL_PRELINK_COMMAND
	DEFINES +=-DFREEBL_PRELINK_COMMAND=\"$(FREEBL_PRELINK_COMMAND)\"
endif
# NSS_X86 means the target is a 32-bits x86 CPU architecture
# NSS_X64 means the target is a 64-bits 64 CPU architecture
# NSS_X86_OR_X64 means the target is either x86 or x64
ifeq (,$(filter-out i386 x386 x86 x86_64,$(CPU_ARCH)))
        DEFINES += -DNSS_X86_OR_X64
        EXTRA_SRCS += gcm-x86.c aes-x86.c
$(OBJDIR)/gcm-x86.o: CFLAGS += -mpclmul -maes
$(OBJDIR)/aes-x86.o: CFLAGS += -mpclmul -maes
ifneq (,$(USE_64)$(USE_X32))
        DEFINES += -DNSS_X64
else
        DEFINES += -DNSS_X86
endif
endif
ifeq ($(CPU_ARCH),aarch64)
    EXTRA_SRCS += gcm-aarch64.c
endif

ifeq ($(OS_TARGET),OSF1)
    DEFINES += -DMP_ASSEMBLY_MULTIPLY -DMP_NO_MP_WORD
    MPI_SRCS += mpvalpha.c
endif

ifeq (OS2,$(OS_TARGET))
    ASFILES  = mpi_x86_os2.s
    DEFINES += -DMP_ASSEMBLY_MULTIPLY -DMP_ASSEMBLY_SQUARE 
    DEFINES += -DMP_ASSEMBLY_DIV_2DX1D
    DEFINES += -DMP_USE_UINT_DIGIT -DMP_NO_MP_WORD
    DEFINES += -DMP_IS_LITTLE_ENDIAN
endif

ifeq (,$(filter-out WINNT WIN95,$(OS_TARGET)))
ifndef USE_64
# 32-bit Windows
ifdef NS_USE_GCC
# Ideally, we want to use assembler
#     ASFILES  = mpi_x86.s
#     DEFINES += -DMP_ASSEMBLY_MULTIPLY -DMP_ASSEMBLY_SQUARE \
#                -DMP_ASSEMBLY_DIV_2DX1D
# but we haven't figured out how to make it work, so we are not
# using assembler right now.
    ASFILES  =
    DEFINES += -DMP_NO_MP_WORD -DMP_USE_UINT_DIGIT
else
# MSVC
    MPI_SRCS += mpi_x86_asm.c
    DEFINES += -DMP_ASSEMBLY_MULTIPLY -DMP_ASSEMBLY_SQUARE 
    DEFINES += -DMP_ASSEMBLY_DIV_2DX1D -DMP_USE_UINT_DIGIT -DMP_NO_MP_WORD
    ifdef BUILD_OPT
	OPTIMIZER += -Ox  # maximum optimization for freebl
    endif
    # The Intel AES assembly code requires Visual C++ 2010.
    # if $(_MSC_VER) >= 1600 (Visual C++ 2010)
    ifeq ($(firstword $(sort $(_MSC_VER) 1600)),1600)
	DEFINES += -DUSE_HW_AES -DINTEL_GCM
	ASFILES += intel-aes-x86-masm.asm intel-gcm-x86-masm.asm
	EXTRA_SRCS += intel-gcm-wrap.c
	ifeq ($(CLANG_CL),1)
	    INTEL_GCM_CLANG_CL = 1
	endif
    endif
endif
else
    # -DMP_NO_MP_WORD
    DEFINES += -DMP_IS_LITTLE_ENDIAN
ifdef NS_USE_GCC
# Ideally, we should use amd64 assembly code, but it's not yet mingw-w64
# compatible.
else
# MSVC
    ifdef BUILD_OPT
	OPTIMIZER += -Ox  # maximum optimization for freebl
    endif
    ASFILES  = arcfour-amd64-masm.asm mpi_amd64_masm.asm mp_comba_amd64_masm.asm
    DEFINES += -DNSS_BEVAND_ARCFOUR -DMPI_AMD64 -DMP_ASSEMBLY_MULTIPLY
    DEFINES += -DNSS_USE_COMBA
    # The Intel AES assembly code requires Visual C++ 2010 (10.0). The _xgetbv
    # compiler intrinsic function requires Visual C++ 2010 (10.0) SP1.
    ifeq ($(_MSC_VER_GE_10SP1),1)
	DEFINES += -DUSE_HW_AES -DINTEL_GCM
	ASFILES += intel-aes-x64-masm.asm intel-gcm-x64-masm.asm
	EXTRA_SRCS += intel-gcm-wrap.c
	ifeq ($(CLANG_CL),1)
	    INTEL_GCM_CLANG_CL = 1
	endif
    endif
    MPI_SRCS += mpi_amd64.c
endif
endif
endif

ifeq ($(OS_TARGET),IRIX)
ifeq ($(USE_N32),1)
    ASFILES  = mpi_mips.s
    ifeq ($(NS_USE_GCC),1)
	ASFLAGS = -Wp,-P -Wp,-traditional -O -mips3
    else
	ASFLAGS = -O -OPT:Olimit=4000 -dollar -fullwarn -xansi -n32 -mips3 
    endif
    DEFINES += -DMP_ASSEMBLY_MULTIPLY -DMP_ASSEMBLY_SQUARE
    DEFINES += -DMP_USE_UINT_DIGIT
endif
endif

ifeq ($(OS_TARGET),Darwin)
ifeq ($(CPU_ARCH),x86)
    ASFILES  = mpi_sse2.s
    DEFINES += -DMP_USE_UINT_DIGIT
    DEFINES += -DMP_ASSEMBLY_MULTIPLY -DMP_ASSEMBLY_SQUARE
    DEFINES += -DMP_ASSEMBLY_DIV_2DX1D
endif
endif # Darwin

ifeq ($(OS_TARGET),Linux)
ifeq ($(CPU_ARCH),x86_64)
    ASFILES  = arcfour-amd64-gas.s mpi_amd64_gas.s
    ASFLAGS += -fPIC -Wa,--noexecstack
    DEFINES += -DNSS_BEVAND_ARCFOUR -DMPI_AMD64 -DMP_ASSEMBLY_MULTIPLY
    DEFINES += -DNSS_USE_COMBA
    DEFINES += -DMP_IS_LITTLE_ENDIAN
#   DEFINES += -DMPI_AMD64_ADD
    # comment the next four lines to turn off Intel HW acceleration.
    DEFINES += -DUSE_HW_AES -DINTEL_GCM
    ASFILES += intel-aes.s intel-gcm.s
    EXTRA_SRCS += intel-gcm-wrap.c
    INTEL_GCM = 1
    MPI_SRCS += mpi_amd64.c mp_comba.c
endif
ifeq ($(CPU_ARCH),x86)
    ASFILES  = mpi_x86.s
    DEFINES += -DMP_ASSEMBLY_MULTIPLY -DMP_ASSEMBLY_SQUARE 
    DEFINES += -DMP_ASSEMBLY_DIV_2DX1D -DMP_USE_UINT_DIGIT
    DEFINES += -DMP_IS_LITTLE_ENDIAN
endif
ifeq ($(CPU_ARCH),arm)
    DEFINES += -DMP_ASSEMBLY_MULTIPLY -DMP_ASSEMBLY_SQUARE 
    DEFINES += -DMP_USE_UINT_DIGIT
    DEFINES += -DSHA_NO_LONG_LONG # avoid 64-bit arithmetic in SHA512
    MPI_SRCS += mpi_arm.c
endif
ifeq ($(CPU_ARCH),ppc)
ifdef USE_64
    DEFINES += -DNSS_NO_INIT_SUPPORT
endif # USE_64
endif # ppc
endif # Linux

ifeq ($(OS_TARGET),AIX)
    DEFINES += -DMP_USE_UINT_DIGIT
    ifndef USE_64
	DEFINES += -DMP_NO_DIV_WORD -DMP_NO_ADD_WORD -DMP_NO_SUB_WORD
    endif
endif # AIX

ifeq ($(OS_TARGET), HP-UX)
ifneq ($(OS_TEST), ia64)
# PA-RISC
ASFILES += ret_cr16.s
ifndef USE_64
    FREEBL_BUILD_SINGLE_SHLIB = 
    HAVE_ABI32_INT32 = 1
    HAVE_ABI32_FPU = 1
endif
ifdef FREEBL_CHILD_BUILD
ifdef USE_ABI32_INT32
# build for DA1.1 (HP PA 1.1) 32-bit ABI build with 32-bit arithmetic
    DEFINES  += -DMP_USE_UINT_DIGIT -DMP_NO_MP_WORD
    DEFINES += -DSHA_NO_LONG_LONG # avoid 64-bit arithmetic in SHA512
else
ifdef USE_64
# this builds for DA2.0W (HP PA 2.0 Wide), the LP64 ABI, using 64-bit digits 
    MPI_SRCS += mpi_hp.c 
    ASFILES  += hpma512.s hppa20.s 
    DEFINES  += -DMP_ASSEMBLY_MULTIPLY -DMP_ASSEMBLY_SQUARE
else
# this builds for DA2.0 (HP PA 2.0 Narrow) ABI32_FPU model 
# (the 32-bit ABI with 64-bit registers) using 64-bit digits
    MPI_SRCS += mpi_hp.c 
    ASFILES  += hpma512.s hppa20.s 
    DEFINES  += -DMP_ASSEMBLY_MULTIPLY -DMP_ASSEMBLY_SQUARE
ifndef NS_USE_GCC
    ARCHFLAG = -Aa +e +DA2.0 +DS2.0
endif
endif
endif
endif
endif
endif

# The blapi functions are defined not only in the freebl shared
# libraries but also in the shared libraries linked with loader.c
# (libsoftokn3.so and libssl3.so).  We need to use GNU ld's
# -Bsymbolic option or the equivalent option for other linkers
# to bind the blapi function references in FREEBLVector vector
# (ldvector.c) to the blapi functions defined in the freebl
# shared libraries.
ifeq (,$(filter-out BSD_OS FreeBSD Linux NetBSD OpenBSD, $(OS_TARGET)))
    MKSHLIB += -Wl,-Bsymbolic
endif

ifeq ($(OS_TARGET),SunOS)

ifdef NS_USE_GCC
    ifdef GCC_USE_GNU_LD
	MKSHLIB += -Wl,-Bsymbolic,-z,now,-z,text
    else
	MKSHLIB += -Wl,-B,symbolic,-z,now,-z,text
    endif # GCC_USE_GNU_LD
else
    MKSHLIB += -B symbolic -z now -z text
endif # NS_USE_GCC

# Sun's WorkShop defines v8, v8plus and v9 architectures.
# gcc on Solaris defines v8 and v9 "cpus".  
# gcc's v9 is equivalent to Workshop's v8plus.
# gcc's -m64 is equivalent to Workshop's v9
# We always use Sun's assembler, which uses Sun's naming convention.
ifeq ($(CPU_ARCH),sparc)
    FREEBL_BUILD_SINGLE_SHLIB=
    ifdef USE_64
        HAVE_ABI64_INT = 1
        HAVE_ABI64_FPU = 1
    else
        HAVE_ABI32_FPU = 1
        HAVE_ABI32_INT64 = 1
    endif
    SYSV_SPARC = 1
    SOLARIS_AS = /usr/ccs/bin/as
    #### set arch, asm, c flags
    ifdef NS_USE_GCC
	ifdef USE_ABI32_INT64
	    ARCHFLAG=-mcpu=v9 -Wa,-xarch=v8plus
	    SOLARIS_AS_FLAGS = -xarch=v8plus -K PIC
	endif
	ifdef USE_ABI32_FPU
	    ARCHFLAG=-mcpu=v9 -Wa,-xarch=v8plusa
	    SOLARIS_AS_FLAGS = -xarch=v8plusa -K PIC
	endif # USE_ABI32_FPU
	ifdef USE_ABI64_INT
	    # this builds for Sparc v9a pure 64-bit architecture
	    ARCHFLAG += -mcpu=v9 -Wa,-xarch=v9
	    SOLARIS_AS_FLAGS = -xarch=v9 -K PIC
	endif
	ifdef USE_ABI64_FPU
	    # this builds for Sparc v9a pure 64-bit architecture
	    # It uses floating point, and 32-bit word size
	    ARCHFLAG += -mcpu=v9 -Wa,-xarch=v9a
	    SOLARIS_AS_FLAGS = -xarch=v9a -K PIC
	endif
    else # NS_USE_GCC
	# FPU_TARGET_OPTIMIZER specifies the target processor and cache
	# properties of the ABI32_FPU and ABI64_FPU architectures for use
	# by the optimizer.
	ifeq (,$(findstring Sun WorkShop 6,$(shell $(CC) -V 2>&1)))
	    # if the compiler is not Forte 6
	    FPU_TARGET_OPTIMIZER = -xcache=64/32/4:1024/64/4 -xchip=ultra3
	else
	    # Forte 6 C compiler generates incorrect code for rijndael.c
	    # if -xchip=ultra3 is used (Bugzilla bug 333925).  So we revert
	    # to what we used in NSS 3.10.
	    FPU_TARGET_OPTIMIZER = -xchip=ultra2
	endif
	ifdef USE_ABI32_INT64
	    # this builds for Sparc v8+a ABI32_FPU architecture, 64-bit registers, 
	    # 32-bit ABI, it uses 64-bit words, integer arithmetic,
	    # no FPU (non-VIS cpus).
	    # These flags were suggested by the compiler group for building
	    # with SunStudio 10.
	    ifdef BUILD_OPT
                SOL_CFLAGS += -xO4
	    endif
 	    SOL_CFLAGS += -xtarget=generic
	    ARCHFLAG = -xarch=v8plus
	    SOLARIS_AS_FLAGS = -xarch=v8plus -K PIC
	endif
	ifdef USE_ABI32_FPU
	    # this builds for Sparc v8+a ABI32_FPU architecture, 64-bit registers, 
	    # 32-bit ABI, it uses FPU code, and 32-bit word size.
	    # these flags were determined by running cc -### -fast and copying
	    # the generated flag settings
	    SOL_CFLAGS += -fsingle -xmemalign=8s
	    ifdef BUILD_OPT
                SOL_CFLAGS += -D__MATHERR_ERRNO_DONTCARE -fsimple=1
                SOL_CFLAGS += -xalias_level=basic -xbuiltin=%all
                SOL_CFLAGS += $(FPU_TARGET_OPTIMIZER) -xdepend
                SOL_CFLAGS += -xlibmil -xO5
	    endif
	    ARCHFLAG = -xarch=v8plusa
	    SOLARIS_AS_FLAGS = -xarch=v8plusa -K PIC
	endif
	ifdef USE_ABI64_INT
	    # this builds for Sparc v9a pure 64-bit architecture,
	    # no FPU (non-VIS cpus). For building with SunStudio 10.
	    ifdef BUILD_OPT
                SOL_CFLAGS += -xO4
	    endif
 	    SOL_CFLAGS += -xtarget=generic
	    ARCHFLAG = -xarch=v9
	    SOLARIS_AS_FLAGS = -xarch=v9 -K PIC
	endif
	ifdef USE_ABI64_FPU
	    # this builds for Sparc v9a pure 64-bit architecture
	    # It uses floating point, and 32-bit word size.
	    # See comment for USE_ABI32_FPU.
	    SOL_CFLAGS += -fsingle -xmemalign=8s
	    ifdef BUILD_OPT
                SOL_CFLAGS += -D__MATHERR_ERRNO_DONTCARE -fsimple=1
                SOL_CFLAGS += -xalias_level=basic -xbuiltin=%all
                SOL_CFLAGS += $(FPU_TARGET_OPTIMIZER) -xdepend
                SOL_CFLAGS += -xlibmil -xO5
	    endif
	    ARCHFLAG = -xarch=v9a
	    SOLARIS_AS_FLAGS = -xarch=v9a -K PIC
	endif
    endif # NS_USE_GCC

    ### set flags for both GCC and Sun cc
    ifdef USE_ABI32_INT64
	# this builds for Sparc v8+a ABI32_FPU architecture, 64-bit registers, 
	# 32-bit ABI, it uses 64-bit words, integer arithmetic, no FPU
	# best times are with no MP_ flags specified
    endif
    ifdef USE_ABI32_FPU
	# this builds for Sparc v8+a ABI32_FPU architecture, 64-bit registers, 
	# 32-bit ABI, it uses FPU code, and 32-bit word size
	MPI_SRCS += mpi_sparc.c
	ASFILES  = mpv_sparcv8.s montmulfv8.s
	DEFINES  += -DMP_NO_MP_WORD -DMP_USE_UINT_DIGIT -DMP_ASSEMBLY_MULTIPLY
	DEFINES  += -DMP_USING_MONT_MULF -DMP_MONT_USE_MP_MUL
    endif
    ifdef USE_ABI64_INT
	# this builds for Sparc v9a pure 64-bit architecture
	# best times are with no MP_ flags specified
    endif
    ifdef USE_ABI64_FPU
	# this builds for Sparc v9a pure 64-bit architecture
	# It uses floating point, and 32-bit word size
	MPI_SRCS += mpi_sparc.c
	ASFILES   = mpv_sparcv9.s montmulfv9.s
	DEFINES  += -DMP_NO_MP_WORD -DMP_USE_UINT_DIGIT -DMP_ASSEMBLY_MULTIPLY
	DEFINES  += -DMP_USING_MONT_MULF -DMP_MONT_USE_MP_MUL
    endif

else
    # Solaris for non-sparc family CPUs
    ifdef NS_USE_GCC
	LD = gcc
	AS = gcc
	ASFLAGS = -x assembler-with-cpp
    endif
    ifeq ($(USE_64),1)
	# Solaris for AMD64
	ifdef NS_USE_GCC
	    ASFILES  = arcfour-amd64-gas.s mpi_amd64_gas.s
	    ASFLAGS += -march=opteron -m64 -fPIC
	    MPI_SRCS += mp_comba.c
	    # comment the next four lines to turn off Intel HW acceleration
	    ASFILES += intel-gcm.s
	    EXTRA_SRCS += intel-gcm-wrap.c
	    INTEL_GCM = 1
	    DEFINES += -DINTEL_GCM
	else
	    ASFILES  = arcfour-amd64-sun.s mpi_amd64_sun.s sha-fast-amd64-sun.s
 	    ASFILES += mp_comba_amd64_sun.s mpcpucache_amd64.s
	    ASFLAGS += -xarch=generic64 -K PIC
            SOL_CFLAGS += -xprefetch=no
	    SHA_SRCS =
 	    MPCPU_SRCS =
	    # Intel acceleration for GCM does not build currently with Studio
	endif
	DEFINES += -DNSS_BEVAND_ARCFOUR -DMPI_AMD64 -DMP_ASSEMBLY_MULTIPLY
	DEFINES += -DNSS_USE_COMBA -DMP_IS_LITTLE_ENDIAN
	# comment the next two lines to turn off Intel HW acceleration
	DEFINES += -DUSE_HW_AES
	ASFILES += intel-aes.s
	MPI_SRCS += mpi_amd64.c
    else
	# Solaris x86
	DEFINES += -DMP_USE_UINT_DIGIT
	DEFINES += -DMP_ASSEMBLY_MULTIPLY -DMP_ASSEMBLY_SQUARE 
	DEFINES += -DMP_ASSEMBLY_DIV_2DX1D
	ASFILES  = mpi_i86pc.s
 	ifndef NS_USE_GCC
 	   MPCPU_SRCS =
 	   ASFILES += mpcpucache_x86.s
 	endif
    endif
endif # Solaris for non-sparc family CPUs
endif # target == SunO

ifdef USE_64
# no __int128 at least up to lcc 1.23 (pretending to be gcc5)
# NB: CC_NAME is not defined here
ifneq ($(shell $(CC) -? 2>&1 >/dev/null </dev/null | sed -e 's/:.*//;1q'),lcc)
    ifdef CC_IS_CLANG
            HAVE_INT128_SUPPORT = 1
            DEFINES += -DHAVE_INT128_SUPPORT
    else ifeq (1,$(CC_IS_GCC))
        ifneq (,$(filter 4.6 4.7 4.8 4.9,$(word 1,$(GCC_VERSION)).$(word 2,$(GCC_VERSION))))
            HAVE_INT128_SUPPORT = 1
            DEFINES += -DHAVE_INT128_SUPPORT
        endif
        ifeq (,$(filter 0 1 2 3 4,$(word 1,$(GCC_VERSION))))
            HAVE_INT128_SUPPORT = 1
            DEFINES += -DHAVE_INT128_SUPPORT
        endif
    endif
endif # lcc
endif # USE_64

ifndef HAVE_INT128_SUPPORT
    DEFINES += -DKRML_NOUINT128
endif

ifndef NSS_DISABLE_CHACHAPOLY
    ifeq ($(CPU_ARCH),x86_64)
        ifdef HAVE_INT128_SUPPORT
            EXTRA_SRCS += Hacl_Poly1305_64.c
        else
            EXTRA_SRCS += Hacl_Poly1305_32.c
        endif
    else
        ifeq ($(CPU_ARCH),aarch64)
            EXTRA_SRCS += Hacl_Poly1305_64.c
        else
            EXTRA_SRCS += Hacl_Poly1305_32.c
        endif
    endif # x86_64

    VERIFIED_SRCS += Hacl_Chacha20.c
    VERIFIED_SRCS += Hacl_Chacha20_Vec128.c
endif # NSS_DISABLE_CHACHAPOLY

ifeq (,$(filter-out i386 x386 x86 x86_64 aarch64,$(CPU_ARCH)))
    # All intel architectures get the 64 bit version
    # With custom uint128 if necessary (faster than generic 32 bit version).
    ECL_SRCS += curve25519_64.c
    VERIFIED_SRCS += Hacl_Curve25519.c
else
    # All non intel architectures get the generic 32 bit implementation (slow!)
    ECL_SRCS += curve25519_32.c
endif

ifndef HAVE_INT128_SUPPORT
    VERIFIED_SRCS += FStar.c
endif

#######################################################################
# (5) Execute "global" rules. (OPTIONAL)                              #
#######################################################################

include $(CORE_DEPTH)/coreconf/rules.mk

#######################################################################
# (6) Execute "component" rules. (OPTIONAL)                           #
#######################################################################



#######################################################################
# (7) Execute "local" rules. (OPTIONAL).                              #
#######################################################################

export:: private_export

rijndael_tables:
	$(CC) -o $(OBJDIR)/make_rijndael_tab rijndael_tables.c \
	         $(DEFINES) $(INCLUDES) $(OBJDIR)/libfreebl.a
	$(OBJDIR)/make_rijndael_tab

vpath %.h mpi ecl verified
vpath %.c mpi ecl verified
vpath %.S mpi ecl
vpath %.s mpi ecl
vpath %.asm mpi ecl
INCLUDES += -Impi -Iecl -Iverified


DEFINES += -DMP_API_COMPATIBLE

MPI_USERS = dh.c pqg.c dsa.c rsa.c ec.c

MPI_OBJS = $(addprefix $(OBJDIR)/$(PROG_PREFIX), $(MPI_SRCS:.c=$(OBJ_SUFFIX)))
MPI_OBJS += $(addprefix $(OBJDIR)/$(PROG_PREFIX), $(MPI_USERS:.c=$(OBJ_SUFFIX)))

$(MPI_OBJS): $(MPI_HDRS)

ECL_USERS = ec.c

ECL_OBJS = $(addprefix $(OBJDIR)/$(PROG_PREFIX), $(ECL_SRCS:.c=$(OBJ_SUFFIX)) $(ECL_ASM_SRCS:$(ASM_SUFFIX)=$(OBJ_SUFFIX)))
ECL_OBJS += $(addprefix $(OBJDIR)/$(PROG_PREFIX), $(ECL_USERS:.c=$(OBJ_SUFFIX)))

$(ECL_OBJS): $(ECL_HDRS)

$(OBJDIR)/sysrand$(OBJ_SUFFIX): sysrand.c unix_rand.c win_rand.c

$(OBJDIR)/$(PROG_PREFIX)mpprime$(OBJ_SUFFIX): primes.c

$(OBJDIR)/ldvector$(OBJ_SUFFIX) $(OBJDIR)/loader$(OBJ_SUFFIX) : loader.h

ifeq ($(SYSV_SPARC),1)

$(OBJDIR)/mpv_sparcv8.o $(OBJDIR)/mpv_sparcv8x.o $(OBJDIR)/montmulfv8.o : $(OBJDIR)/%.o : %.s
	@$(MAKE_OBJDIR)
	$(SOLARIS_AS) -o $@ $(SOLARIS_AS_FLAGS) $<

$(OBJDIR)/mpv_sparcv9.o $(OBJDIR)/montmulfv9.o : $(OBJDIR)/%.o : %.s
	@$(MAKE_OBJDIR)
	$(SOLARIS_AS) -o $@ $(SOLARIS_AS_FLAGS) $<

$(OBJDIR)/mpmontg.o: mpmontg.c montmulf.h

endif

ifndef FREEBL_CHILD_BUILD

# Parent build. This is where we decide which shared libraries to build

ifdef FREEBL_BUILD_SINGLE_SHLIB

################### Single shared lib stuff #########################
SINGLE_SHLIB_DIR = $(OBJDIR)/$(OS_TARGET)_SINGLE_SHLIB
ALL_TRASH += $(SINGLE_SHLIB_DIR) 

$(SINGLE_SHLIB_DIR):
	-mkdir -p $(SINGLE_SHLIB_DIR)

release_md libs:: $(SINGLE_SHLIB_DIR)
	$(MAKE) FREEBL_CHILD_BUILD=1 \
 OBJDIR=$(SINGLE_SHLIB_DIR) $@
######################## common stuff #########################

endif

ifdef NEED_STUB_BUILD
SINGLE_SHLIB_DIR = $(OBJDIR)/$(OS_TARGET)_SINGLE_SHLIB
ALL_TRASH += $(SINGLE_SHLIB_DIR) 
$(SINGLE_SHLIB_DIR):
	-mkdir $(SINGLE_SHLIB_DIR)

release_md libs:: $(SINGLE_SHLIB_DIR)
	$(MAKE) FREEBL_CHILD_BUILD=1 USE_STUB_BUILD=1 \
 OBJDIR=$(SINGLE_SHLIB_DIR) $@
endif

# multiple shared libraries

######################## ABI32_FPU stuff #########################
ifdef HAVE_ABI32_FPU
ABI32_FPU_DIR = $(OBJDIR)/$(OS_TARGET)_ABI32_FPU
ALL_TRASH += $(ABI32_FPU_DIR) 

$(ABI32_FPU_DIR):
	-mkdir $(ABI32_FPU_DIR)

release_md libs:: $(ABI32_FPU_DIR)
	$(MAKE) FREEBL_CHILD_BUILD=1 USE_ABI32_FPU=1 \
 OBJDIR=$(ABI32_FPU_DIR) $@
endif

######################## ABI32_INT32 stuff #########################
ifdef HAVE_ABI32_INT32
ABI32_INT32_DIR = $(OBJDIR)/$(OS_TARGET)_ABI32_INT32
ALL_TRASH += $(ABI32_INT32_DIR) 

$(ABI32_INT32_DIR):
	-mkdir $(ABI32_INT32_DIR)

release_md libs:: $(ABI32_INT32_DIR)
	$(MAKE) FREEBL_CHILD_BUILD=1 USE_ABI32_INT32=1 \
 OBJDIR=$(ABI32_INT32_DIR) $@
endif

######################## ABI32_INT64 stuff #########################
ifdef HAVE_ABI32_INT64
ABI32_INT64_DIR = $(OBJDIR)/$(OS_TARGET)_ABI32_INT64
ALL_TRASH += $(ABI32_INT64_DIR) 

$(ABI32_INT64_DIR):
	-mkdir $(ABI32_INT64_DIR)

release_md libs:: $(ABI32_INT64_DIR)
	$(MAKE) FREEBL_CHILD_BUILD=1 USE_ABI32_INT64=1\
 OBJDIR=$(ABI32_INT64_DIR) $@
endif

######################## END of 32-bit stuff #########################

# above is 32-bit builds, below is 64-bit builds

######################## ABI64_FPU stuff #########################
ifdef HAVE_ABI64_FPU
ABI64_FPU_DIR = $(OBJDIR)/$(OS_TARGET)_ABI64_FPU
ALL_TRASH += $(ABI64_FPU_DIR) 

$(ABI64_FPU_DIR):
	-mkdir $(ABI64_FPU_DIR)

release_md libs:: $(ABI64_FPU_DIR)
	$(MAKE) FREEBL_CHILD_BUILD=1 USE_ABI64_FPU=1 \
 OBJDIR=$(ABI64_FPU_DIR) $@
endif

######################## ABI64_INT stuff #########################
ifdef HAVE_ABI64_INT
ABI64_INT_DIR = $(OBJDIR)/$(OS_TARGET)_ABI64_INT
ALL_TRASH += $(ABI64_INT_DIR) 

$(ABI64_INT_DIR):
	-mkdir $(ABI64_INT_DIR)

release_md libs:: $(ABI64_INT_DIR)
	$(MAKE) FREEBL_CHILD_BUILD=1 USE_ABI64_INT=1 \
 OBJDIR=$(ABI64_INT_DIR) $@
endif

endif  # FREEBL_CHILD_BUILD


# Bugzilla Bug 333917: the non-x86 code in desblapi.c seems to violate
# ANSI C's strict aliasing rules.
ifeq ($(OS_TARGET),Linux)
ifneq ($(CPU_ARCH),x86)
$(OBJDIR)/$(PROG_PREFIX)desblapi$(OBJ_SUFFIX): desblapi.c
	@$(MAKE_OBJDIR)
ifdef NEED_ABSOLUTE_PATH
	$(CC) -o $@ -c $(CFLAGS) -fno-strict-aliasing $(call core_abspath,$<)
else
	$(CC) -o $@ -c $(CFLAGS) -fno-strict-aliasing $<
endif
endif
endif

ifdef INTEL_GCM
#
# GCM binary needs -mssse3
#
$(OBJDIR)/$(PROG_PREFIX)intel-gcm-wrap$(OBJ_SUFFIX): CFLAGS += -mssse3

# The integrated assembler in Clang 3.2 does not support % in the
# expression of a .set directive. intel-gcm.s uses .set to give
# symbolic names to registers, for example,
#     .set  Htbl, %rdi
# So we can't use Clang's integrated assembler with intel-gcm.s.
ifdef CC_IS_CLANG
$(OBJDIR)/$(PROG_PREFIX)intel-gcm$(OBJ_SUFFIX): CFLAGS += -no-integrated-as
endif
endif

ifdef INTEL_GCM_CLANG_CL
#
# clang-cl needs -mssse3
#
$(OBJDIR)/$(PROG_PREFIX)intel-gcm-wrap$(OBJ_SUFFIX): CFLAGS += -mssse3
endif

ifeq ($(CPU_ARCH),aarch64)
$(OBJDIR)/$(PROG_PREFIX)gcm-aarch64$(OBJ_SUFFIX): CFLAGS += -march=armv8-a+crypto
endif
