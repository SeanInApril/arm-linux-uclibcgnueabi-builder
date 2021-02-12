#######################################################
# README                                              #
#                                                     #
# Sean<SeanInApril@163.com>                           #
#                                                     #
# README for crosstool build                          #
#######################################################

#######################################################
#                                                     #
# Platform:                                           #
#                                                     #
#   ubuntu-16.04.3 LTS/Niaoyun VPS                    #
#     (GNU/Linux-4.4.0-87-generic x86_64)             #
#   binutils 2.26.1                                   #
#   gcc version 5.4.0 20160609                        #
#                                                     #
#######################################################

#######################################################
#                                                     #
# Prerequisite packages:                              #
#                                                     #
# $sudo apt-get install                          \    #
#   gperf bison flex texinfo help2man gawk aria2 \    #
#   autoconf automake libtool libtool-bin        \    #
#   patch tree curl wget bc                      \    #
#   g++ build-essential                          \    #
#   libncurses5-dev libiberty-dev                \    #
#   libgmp-dev libmpc-dev libmpfr-dev libisl-dev      #
#                                                     #
#######################################################

#######################################################
#                                                     #
# Kernel version supported:                           #
#                                                     #
#   2.x - 5.x(for the coming versions)                #
#                                                     #
#######################################################

#######################################################
#                                                     #
# Customize start/end between --8<-- --8<--           #
#                                                     #
# ALIAS     - alias for the toolchain, e.g. arm-linux #
# _VER_     - version number of packages              #
# _PATH_    - path the toolchain will be built        #
# _OPTIONS_ - common options for bin/cc2/gdb          #
#                                                     #
#######################################################

#######################################################
#                                                     #
# Tested combinations:                                #
#                                                     #
# combination1                                        #
#   binutils-2.31                                     #
#   gcc-8.2.0                                         #
#   uClibc-ng-1.0.30                                  #
#   gdb-8.1                                           #
#   linux-4.17.9                                      #
#                                                     #
# on Ubuntu 16.04.3 LTS(Niaoyun VPS)                  #
#######################################################

#######################################################
#                                                     #
# Tested combinations:                                #
#                                                     #
# combination1                                        #
#   binutils-2.31                                     #
#   gcc-8.2.0                                         #
#   uClibc-ng-1.0.30                                  #
#   gdb-8.1                                           #
#   linux-4.17.9                                      #
#                                                     #
# on MacOS High Sierra(Darwin 17.3.0 X86_64)          #
#######################################################


#######################################################
#                                                     #
# Mirrors for downloading:                            #
#                                                     #
#   https://mirrors.tuna.tsinghua.edu.cn - by default #
#   https://mirrors.ustc.edu.cn
#     - seems not support wget breakpoint continuing  #
#       well                                          #
#                                                     #
#######################################################
