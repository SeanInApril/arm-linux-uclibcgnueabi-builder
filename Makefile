#######################################################
#                                                     #
# Makefile                                            #
#                                                     #
# Sean<SeanInApril@163.com>                           #
#                                                     #
# Usage:Script to build arm-linux-uclibcgnueabi(arm32)#
#                                                     #
#######################################################

# Platform: ubuntu16.04/Niaoyun VPS                   #

#######################################################
# setup-env - envirments setup                        #
#######################################################
#setup-env:

#customize here
#------------------------8<----------------------------
ALIAS     := arm-linux

_BIN_VER_ := 2.31
_GCC_VER_ := 8.2.0
_LIB_VER_ := 1.0.30
_GDB_VER_ := 8.1
_KNL_VER_ := 4.17.9

#_PATH_   := ${HOME}/gnutools
_PATH_    := 
_OPTIONS_ := --disable-nls
#------------------------8<----------------------------

ARCH   := arm
TARGET := arm-linux-uclibcgnueabi

BINUTILS_VERSION := binutils-${_BIN_VER_}
GCC_VERSION      := gcc-${_GCC_VER_}
UCLIBC_VERSION   := uClibc-ng-${_LIB_VER_}
GDB_VERSION      := gdb-${_GDB_VER_}
KERNEL_VERSION   := linux-${_KNL_VER_}

_TOP_DIR_ := $$(pwd)

ifeq (${_PATH_}, )
PREFIX_PARENT := ${_TOP_DIR_}/gnutools
else
PREFIX_PARENT := ${_PATH_}
endif

PRJROOT := ${_TOP_DIR_}/build/${TARGET}-${_GCC_VER_}
PREFIX  := ${PREFIX_PARENT}/${TARGET}-${_GCC_VER_}

TARGET_PREFIX := ${PREFIX}/${TARGET}

#SW_DL_URL := ftp://sources.redhat.com/pub
#SW_DL_URL := https://mirrors.ustc.edu.cn
SW_DL_URL := https://mirrors.tuna.tsinghua.edu.cn
DLFLAGS   := -c --tries=0 --timeout=10

#function to check wheather file exsits in path
#return empty, if doesn't exist
#$(1) - name
#$(2) - path
#$(call FILE_DIR_EXIST,name,path)
FILE_DIR_EXIST=$(filter %$(1), $(shell echo $(2)/*))


.PHONY: all
	@echo "build end!"

all: show-info setup-dir setup-dl setup-uzp build-bin build-cc1 build-hdr build-lib build-cc2 build-gdb build-lnk build-pac
#	@echo "start all!"
#	make show-info

#	make setup-dir
#	make setup-dl
#	make setup-uzp

#	make build-bin
#	make build-cc1
#	make build-hdr
#	make build-lib
#	make build-cc2
#	make build-gdb

#	make build-lnk
#	make build-pac
	@echo "end all!"

#######################################################
# show-info - show the directory infos                #
#######################################################
show-info:
	@echo "show info..."
	@echo "-----------------8<---------------------"
	@echo "ALIAS := "${ALIAS}
	@echo "BINUTILS_VERSION := "${BINUTILS_VERSION}
	@echo "GCC_VERSION      := "${GCC_VERSION}
	@echo "GDB_VERSION      := "${GDB_VERSION}
	@echo "KERNEL_VERSION   := "${KERNEL_VERSION}
	@echo "UCLIBC_VERSION   := "${UCLIBC_VERSION}
	@echo "PRJROOT          := "${PRJROOT}
	@echo "PREFIX           := "${PREFIX}
	@echo "_OPTIONS_        := "${_OPTIONS_}
	@echo "-----------------8<---------------------"
	@echo "show info end"

#######################################################
# setup-pkg - prerequisite                            #
#######################################################
#setup-pkg:
#	sudo apt-get install libncurses5-dev gperf bison flex texinfo help2man gawk libtool libtool-bin automake

#######################################################
# setup-dir - directory structure construct           #
#######################################################
setup-dir:
	@echo "setup dir..."
	mkdir -pv ${PRJROOT} ${PREFIX}

	mkdir -pv ${_TOP_DIR_}/package
	mkdir -pv ${_TOP_DIR_}/target

	mkdir -pv ${PRJROOT}/src
	mkdir -pv ${PRJROOT}/bld
	cp -rf ${_TOP_DIR_}/test ${PRJROOT}

	mkdir -pv ${PRJROOT}/bld/${BINUTILS_VERSION}
	mkdir -pv ${PRJROOT}/bld/${GCC_VERSION}-pass1
	mkdir -pv ${PRJROOT}/bld/${GCC_VERSION}-pass2
	mkdir -pv ${PRJROOT}/bld/${GDB_VERSION}
	mkdir -pv ${PRJROOT}/bld/${UCLIBC_VERSION}

	tree -L 3
	@echo "setup dir end"

#######################################################
# setup-dl - donload tarballs                         #
#######################################################
#an urgerly implimentation, should be optimized
ifneq ($(_KNL_VER_:2.%=Z.%), $(_KNL_VER_))
_MID_DIR_ := v2.6
endif

ifneq ($(_KNL_VER_:3.%=Z.%), $(_KNL_VER_))
_MID_DIR_ := v3.x
endif

ifneq ($(_KNL_VER_:4.%=Z.%), $(_KNL_VER_))
_MID_DIR_ := v4.x
endif

ifneq ($(_KNL_VER_:5.%=Z.%), $(_KNL_VER_))
_MID_DIR_ := v5.x
endif

ifndef _MID_DIR_
$(error "unsupport kernel version")
endif

setup-dl:
#download tarballs here
	@echo "download src..."
	wget ${DLFLAGS} -O ${_TOP_DIR_}/package/binutils-${_BIN_VER_}.tar.xz ${SW_DL_URL}/gnu/binutils/binutils-${_BIN_VER_}.tar.xz
	wget ${DLFLAGS} -O ${_TOP_DIR_}/package/gcc-${_GCC_VER_}.tar.xz      ${SW_DL_URL}/gnu/gcc/gcc-${_GCC_VER_}/gcc-${_GCC_VER_}.tar.xz
	wget ${DLFLAGS} -O ${_TOP_DIR_}/package/gdb-${_GDB_VER_}.tar.xz      ${SW_DL_URL}/gnu/gdb/gdb-${_GDB_VER_}.tar.xz

	wget ${DLFLAGS} -O ${_TOP_DIR_}/package/uClibc-ng-${_LIB_VER_}.tar.xz    https://downloads.uclibc-ng.org/releases/${_LIB_VER_}/uClibc-ng-${_LIB_VER_}.tar.xz

	wget ${DLFLAGS} -O ${_TOP_DIR_}/package/linux-${_KNL_VER_}.tar.xz    ${SW_DL_URL}/kernel/$(_MID_DIR_)/linux-${_KNL_VER_}.tar.xz
	@echo "download src end"

#######################################################
# setup-uzp - unzip tarballs                          #
#######################################################
setup-uzp:
	@echo "unzip src..."
ifeq ($(call FILE_DIR_EXIST,binutils-${_BIN_VER_},${PRJROOT}/src),)
	tar -Jxvf ${_TOP_DIR_}/package/binutils-${_BIN_VER_}.tar.xz -C ${PRJROOT}/src
endif
ifeq ($(call FILE_DIR_EXIST,gcc-${_GCC_VER_},${PRJROOT}/src),)
	tar -Jxvf ${_TOP_DIR_}/package/gcc-${_GCC_VER_}.tar.xz      -C ${PRJROOT}/src
endif
ifeq ($(call FILE_DIR_EXIST,gdb-${_GDB_VER_},${PRJROOT}/src),)
	tar -Jxvf ${_TOP_DIR_}/package/gdb-${_GDB_VER_}.tar.xz      -C ${PRJROOT}/src
endif
ifeq ($(call FILE_DIR_EXIST,linux-${_KNL_VER_},${PRJROOT}/src),)
	tar -Jxvf ${_TOP_DIR_}/package/linux-${_KNL_VER_}.tar.xz    -C ${PRJROOT}/src
endif
ifeq ($(call FILE_DIR_EXIST,uClibc-ng-${_LIB_VER_},${PRJROOT}/src),)
	tar -Jxvf ${_TOP_DIR_}/package/uClibc-ng-${_LIB_VER_}.tar.xz    -C ${PRJROOT}/src
endif
	@echo "unzip src end"

#######################################################
# build-hdr - build linux headers                     #
#######################################################
build-hdr:
	@echo "build hdr..."
ifeq ($(call FILE_DIR_EXIST,version.h,${PREFIX}/${TARGET}/include/linux),)
	make -C ${PRJROOT}/src/${KERNEL_VERSION} ARCH=${ARCH} CROSS_COMPILE=${PREFIX}/bin/${TARGET}- INSTALL_HDR_PATH=${PREFIX}/${TARGET} headers_install
endif
	@echo "build hdr end"

#######################################################
# build-bin - binutils                                #
#######################################################
build-bin:
	@echo "build bin..."
	cp -f ${_TOP_DIR_}/Makefile ${PRJROOT}/bld/${BINUTILS_VERSION}/Makefile.inn
	make -C ${PRJROOT}/bld/${BINUTILS_VERSION} -f Makefile.inn build-bin-inner _PRJROOT_INN_=${PRJROOT} _PREFIX_INN_=${PREFIX}
	@echo "build bin end"

build-bin-inner:
ifeq ($(call FILE_DIR_EXIST,Makefile,${_PRJROOT_INN_}/bld/${BINUTILS_VERSION}),)
	${_PRJROOT_INN_}/src/${BINUTILS_VERSION}/configure --target=${TARGET} --prefix=${_PREFIX_INN_} --enable-shared ${_OPTIONS_} 2>&1 |tee configure.out
endif
	make -w all install 2>&1 |tee make.out

#######################################################
# build-cc1 - gcc-pass1                               #
#######################################################
build-cc1:
	@echo "build cc1..."
	cp -f ${_TOP_DIR_}/Makefile ${PRJROOT}/bld/${GCC_VERSION}-pass1/Makefile.inn
	make -C ${PRJROOT}/bld/${GCC_VERSION}-pass1 -f Makefile.inn build-cc1-inner _PRJROOT_INN_=${PRJROOT} _PREFIX_INN_=${PREFIX}
	@echo "build cc1 end"

build-cc1-inner:
ifeq ($(call FILE_DIR_EXIST,Makefile,${_PRJROOT_INN_}/bld/${GCC_VERSION}-pass1),)
	${_PRJROOT_INN_}/src/${GCC_VERSION}/configure --target=${TARGET} --prefix=${_PREFIX_INN_} --enable-languages=c --disable-shared --disable-threads --without-headers --disable-libmudflap --disable-nls  2>&1 |tee configure.out
endif
	make -w all-gcc install-gcc 2>&1 |tee make-gcc.out
	make -w all-target-libgcc install-target-libgcc 2>&1 |tee make-target-libgcc.out

#######################################################
# build-lib build uClibc-ng                           #
#######################################################
build-lib:
	@echo "build lib..."
#	make -C ${PRJROOT}/src/${UCLIBC_VERSION} menuconfig
	cp -f ${_TOP_DIR_}/config/.config ${PRJROOT}/src/${UCLIBC_VERSION}/
	make -C ${PRJROOT}/src/${UCLIBC_VERSION} CROSS_COMPILER_PREFIX=${PREFIX}/bin/${TARGET}- KERNEL_HEADERS=${TARGET_PREFIX}/include RUNTIME_PREFIX=${PREFIX}/ DEVEL_PREFIX=${TARGET_PREFIX}/ install 2>&1 |tee ${PRJROOT}/bld/${UCLIBC_VERSION}/make-install.out
	@echo "build lib end"

#######################################################
# build-cc2 - gcc-pass2                               #
#######################################################
build-cc2:
	@echo "build cc2..."
	cp -f ${_TOP_DIR_}/Makefile ${PRJROOT}/bld/${GCC_VERSION}-pass2/Makefile.inn
	make -C ${PRJROOT}/bld/${GCC_VERSION}-pass2 -f Makefile.inn build-cc2-inner _PRJROOT_INN_=${PRJROOT} _PREFIX_INN_=${PREFIX}
	@echo "build cc2 end"

build-cc2-inner:
ifeq ($(call FILE_DIR_EXIST,Makefile,${_PRJROOT_INN_}/bld/${GCC_VERSION}-pass2),)
	${_PRJROOT_INN_}/src/${GCC_VERSION}/configure --target=${TARGET} --prefix=${_PREFIX_INN_} --enable-languages=c,c++ --enable-shared --enable-threads=posix --disable-libsanitizer ${_OPTIONS_} --with-headers=${_PREFIX_INN_}/${TARGET}/include --with-libs=${_PREFIX_INN_}/${TARGET}/lib 2>&1 |tee configure.out
endif
	make -w all install 2>&1 |tee make.out

#######################################################
# build-gdb - build gdb                               #
#######################################################
build-gdb:
	@echo "build gdb..."
	cp -f ${_TOP_DIR_}/Makefile ${PRJROOT}/bld/${GDB_VERSION}/Makefile.inn
	make -C ${PRJROOT}/bld/${GDB_VERSION} -f Makefile.inn build-gdb-inner _PRJROOT_INN_=${PRJROOT} _PREFIX_INN_=${PREFIX}
	@echo "build gdb end"

build-gdb-inner:
ifeq ($(call FILE_DIR_EXIST,Makefile,${_PRJROOT_INN_}/bld/${GDB_VERSION}),)
	${_PRJROOT_INN_}/src/${GDB_VERSION}/configure --target=${TARGET} --prefix=${_PREFIX_INN_} --enable-shared ${_OPTIONS_} 2>&1 |tee configure.out
endif
	make -w all install 2>&1 |tee make.out

#######################################################
# build-lnk - build alias                             #
#######################################################
build-lnk:
	@echo "build lnk..."
#ifeq ($(call FILE_DIR_EXIST,${ALIAS}-gcc,${PREFIX}/bin),)
	ln -s -f ${PREFIX}/bin/${TARGET}-addr2line ${PREFIX}/bin/${ALIAS}-addr2line
	ln -s -f ${PREFIX}/bin/${TARGET}-ar        ${PREFIX}/bin/${ALIAS}-ar
	ln -s -f ${PREFIX}/bin/${TARGET}-as        ${PREFIX}/bin/${ALIAS}-as
	ln -s -f ${PREFIX}/bin/${TARGET}-c++       ${PREFIX}/bin/${ALIAS}-c++
	ln -s -f ${PREFIX}/bin/${TARGET}-c++filt   ${PREFIX}/bin/${ALIAS}-c++filt
	ln -s -f ${PREFIX}/bin/${TARGET}-cpp       ${PREFIX}/bin/${ALIAS}-cpp
	ln -s -f ${PREFIX}/bin/${TARGET}-elfedit   ${PREFIX}/bin/${ALIAS}-elfedit
	ln -s -f ${PREFIX}/bin/${TARGET}-g++       ${PREFIX}/bin/${ALIAS}-g++
	ln -s -f ${PREFIX}/bin/${TARGET}-gcc       ${PREFIX}/bin/${ALIAS}-gcc
	ln -s -f ${PREFIX}/bin/${TARGET}-gcov      ${PREFIX}/bin/${ALIAS}-gcov
	ln -s -f ${PREFIX}/bin/${TARGET}-gdb       ${PREFIX}/bin/${ALIAS}-gdb
	ln -s -f ${PREFIX}/bin/${TARGET}-gprof     ${PREFIX}/bin/${ALIAS}-gprof
	ln -s -f ${PREFIX}/bin/${TARGET}-ld        ${PREFIX}/bin/${ALIAS}-ld
	ln -s -f ${PREFIX}/bin/${TARGET}-nm        ${PREFIX}/bin/${ALIAS}-nm
	ln -s -f ${PREFIX}/bin/${TARGET}-objcopy   ${PREFIX}/bin/${ALIAS}-objcopy
	ln -s -f ${PREFIX}/bin/${TARGET}-objdump   ${PREFIX}/bin/${ALIAS}-objdump
	ln -s -f ${PREFIX}/bin/${TARGET}-ranlib    ${PREFIX}/bin/${ALIAS}-ranlib
	ln -s -f ${PREFIX}/bin/${TARGET}-readelf   ${PREFIX}/bin/${ALIAS}-readelf
	ln -s -f ${PREFIX}/bin/${TARGET}-run       ${PREFIX}/bin/${ALIAS}-run
	ln -s -f ${PREFIX}/bin/${TARGET}-size      ${PREFIX}/bin/${ALIAS}-size
	ln -s -f ${PREFIX}/bin/${TARGET}-strings   ${PREFIX}/bin/${ALIAS}-strings
	ln -s -f ${PREFIX}/bin/${TARGET}-strip     ${PREFIX}/bin/${ALIAS}-strip
#endif
	@echo "build lnk end"

#######################################################
# build-pac - build tarball                           #
#######################################################
build-pac:
	@echo "build tarball here"
#FIXME: build versions of bin/gcc/gdb/lib/kernel into the tarball here
	tar -zcvf ${_TOP_DIR_}/target/${TARGET}-toolchain-${_GCC_VER_}-$$(date +%Y%m%d%H%M%S).tar.gz -C ${PREFIX_PARENT} ${TARGET}-${_GCC_VER_}
	@echo "build tarball end"

test-tool:
	@echo "test here"
	make -C ${PRJROOT}/test TEST_PREFIX=${PREFIX}/bin/${TARGET}-
	@echo "test end"

clean:
	@echo "clean here"
	rm -rf *.out
	rm -rf ${PRJROOT} ${PREFIX}
	@echo "clean end"
