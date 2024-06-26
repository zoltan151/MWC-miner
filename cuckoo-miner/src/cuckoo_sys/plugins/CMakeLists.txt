cmake_minimum_required(VERSION 3.2)
project (CuckooMinerPlugins)

include_directories(${CMAKE_CUDA_TOOLKIT_INCLUDE_DIRECTORIES})

set(CMAKE_LIBRARY_OUTPUT_DIRECTORY ${CMAKE_BINARY_DIR}/plugins)
set (CMAKE_CXX_FLAGS "--std=c++11")

set (OPT "-O3")
set (DOPT "-DPREFETCH")

set (FLAGS "-Wno-format -Wno-deprecated-declarations -D_POSIX_C_SOURCE=200112L ${OPT} ${DOPT} -I. ${CPPFLAGS} -pthread")
set (GPP_FLAGS "-march=native -m64 ${FLAGS}")
set (CFLAGS "-Wno-format -fomit-frame-pointer ${OPT}")
set (GCC_FLAGS "-m64 -std=gnu11 ${CFLAGS}")

set (CUDA_HOST_COMPILER_OVERRIDE $ENV{CUDA_HOST_COMPILER})
set (SKIP_CUCKATOO_GPU $ENV{SKIP_CUCKATOO_GPU})
set (SKIP_CUCKAROO_GPU $ENV{SKIP_CUCKAROO_GPU})
set (SKIP_CUCKAROOD_GPU $ENV{SKIP_CUCKAROOD_GPU})
set (SKIP_CUCKAROOM_CPU "1")
set (SKIP_CUCKAROOM_GPU $ENV{SKIP_CUCKAROOM_GPU})
set (SKIP_CUCKAROOZ_CPU "1")
set (SKIP_CUCKAROOZ_GPU $ENV{SKIP_CUCKAROOZ_GPU})

#blake2b prerequisite
set (BLAKE_2B "cuckoo/src/crypto/blake2b-ref.c")

#common to all plugins
set (PLUGIN_BUILD_FLAGS "-DC_CALL_CONVENTION=1 -DSQUASH_OUTPUT=1")

#build CPU target
function (build_cpu_target sources target props)
	add_library(${target} SHARED ${sources})
	set_target_properties(${target} PROPERTIES COMPILE_FLAGS "${GPP_FLAGS} ${props} ${PLUGIN_BUILD_FLAGS}" PREFIX "" SUFFIX ".cuckooplugin")
endfunction()

function (build_cuda_target sources target props)
##	if (BUILD_CUDA_PLUGINS)
		include("cmake/find_cuda.cmake")
                include_directories(${CMAKE_CUDA_TOOLKIT_INCLUDE_DIRECTORIES})
#		if (CUDA_FOUND)
			set (CUDA_PROPAGATE_HOST_FLAGS ON)
			cuda_add_library (${target} SHARED ${sources} OPTIONS "${props} ${PLUGIN_BUILD_FLAGS}")
			set_target_properties(${target} PROPERTIES PREFIX "" SUFFIX ".cuckooplugin")
#		endif (CUDA_FOUND)
##	endif (BUILD_CUDA_PLUGINS)
endfunction()

##################################################################################
### CUCKATOO (Asic Tuned) ########################################################
##################################################################################

### AT LEAN CPU TARGETS  #########################################

set (AT_LEAN_CPU_SRC
			cuckoo/src/cuckatoo/cuckatoo.h
			cuckoo/src/cuckatoo/bitmap.hpp
			cuckoo/src/cuckatoo/graph.hpp
			cuckoo/src/cuckatoo/compress.hpp
			cuckoo/src/threads/barrier.hpp
			cuckoo/src/crypto/siphash.hpp
			cuckoo/src/cuckatoo/lean.hpp
			cuckoo/src/cuckatoo/lean.cpp
			${BLAKE_2B})

#build_cpu_target("${AT_LEAN_CPU_SRC}" cuckatoo_lean_cpu_compat_31 "-mno-avx2 -DNSIPHASH=4 -DATOMIC -DEDGEBITS=31")
#build_cpu_target("${AT_LEAN_CPU_SRC}" cuckatoo_lean_cpu_avx2_31 "-mavx2 -DNSIPHASH=8 -DATOMIC -DEDGEBITS=31")

### AT MEAN CPU TARGETS  #########################################

set (AT_MEAN_CPU_SRC
			cuckoo/src/cuckatoo/cuckatoo.h
			cuckoo/src/cuckatoo/bitmap.hpp
			cuckoo/src/cuckatoo/graph.hpp
			cuckoo/src/cuckatoo/compress.hpp
			cuckoo/src/threads/barrier.hpp
			cuckoo/src/crypto/siphash.hpp
			cuckoo/src/cuckatoo/mean.hpp
			cuckoo/src/cuckatoo/mean.cpp
			${BLAKE_2B})

#build_cpu_target("${AT_MEAN_CPU_SRC}" cuckatoo_mean_cpu_compat_31 "-mno-avx2 -DXBITS=8 -DNSIPHASH=4 -DEXPANDROUND=8 -DCOMPRESSROUND=22 -DSAVEEDGES -DEDGEBITS=31")
#build_cpu_target("${AT_MEAN_CPU_SRC}" cuckatoo_mean_cpu_avx2_31 "-mavx2 -DXBITS=8 -DNSIPHASH=8 -DEXPANDROUND=8 -DCOMPRESSROUND=22 -DSAVEEDGES -DEDGEBITS=31")

### AT LEAN CUDA TARGETS  #########################################

set (AT_LEAN_CUDA_SRC
			cuckoo/src/crypto/siphash.cuh
			cuckoo/src/cuckatoo/lean.cu
			${BLAKE_2B} )

#if (NOT SKIP_CUCKATOO_GPU)
  build_cuda_target("${AT_LEAN_CUDA_SRC}" cuckatoo_lean_cuda_31 "-DEDGEBITS=31")
#endif()

### AT MEAN CUDA TARGETS  #########################################

set (AT_MEAN_CUDA_SRC
			cuckoo/src/crypto/siphash.cuh
			cuckoo/src/cuckatoo/mean.cu
			${BLAKE_2B} )

#if (NOT SKIP_CUCKATOO_GPU)
  build_cuda_target("${AT_MEAN_CUDA_SRC}" cuckatoo_mean_cuda_gtx_31 "-DNEPS_A=133 -DNEPS_B=85 -DPART_BITS=1 -DFLUSHA=2 -DEDGEBITS=31")
  build_cuda_target("${AT_MEAN_CUDA_SRC}" cuckatoo_mean_cuda_rtx_31 "-DNEPS_A=133 -DNEPS_B=85 -DPART_BITS=0 -DEDGEBITS=31 -arch sm_75")
  #build_cuda_target("${AT_MEAN_CUDA_SRC}" cuckatoo_extra_mean_cuda_rtx_31 "-DFLUSHA=2 -DNEPS_A=135 -DNEPS_B=88 -DPART_BITS=1 -DEDGEBITS=31")
#endif()

##################################################################################
### CUCKAROO (Asic Resistant)  ###################################################
##################################################################################

### AR CPU BUILDING  #########################################

set (AR_CPU_SRC
			cuckoo/src/cuckaroo/cuckaroo.hpp
			cuckoo/src/cuckaroo/bitmap.hpp
			cuckoo/src/cuckaroo/graph.hpp
			cuckoo/src/threads/barrier.hpp
			cuckoo/src/crypto/siphash.hpp
			cuckoo/src/cuckaroo/mean.hpp
			cuckoo/src/cuckaroo/mean.cpp
			${BLAKE_2B})

### AR CPU TARGETS #########################################

#build_cpu_target("${AR_CPU_SRC}" cuckaroo_cpu_compat_31 "-mno-avx2 -DNSIPHASH=4 -DEDGEBITS=31 -DSAVEEDGES")
#build_cpu_target("${AR_CPU_SRC}" cuckaroo_cpu_avx2_31 "-mavx2 -DNSIPHASH=8 -DEDGEBITS=31 -DSAVEEDGES")

### AR CUDA TARGETS #########################################

set (AR_CUDA_SRC cuckoo/src/cuckaroo/mean.cu ${BLAKE_2B} )

if (NOT SKIP_CUCKAROO_GPU)
  #build_cuda_target("${AR_CUDA_SRC}" cuckaroo_cuda_31 "-DEDGEBITS=31")
  
endif()

##################################################################################
### CUCKAROOD (Asic Resistant)  ##################################################
##################################################################################

### AR CPU BUILDING  #########################################

set (AR2_CPU_SRC
			cuckoo/src/cuckarood/cuckarood.hpp
			cuckoo/src/cuckarood/bitmap.hpp
			cuckoo/src/cuckarood/graph.hpp
			cuckoo/src/threads/barrier.hpp
			cuckoo/src/crypto/siphash.hpp
			cuckoo/src/crypto/siphashxN.h
			cuckoo/src/cuckarood/mean.hpp
			cuckoo/src/cuckarood/mean.cpp
			${BLAKE_2B})

### AR CPU TARGETS #########################################

#build_cpu_target("${AR2_CPU_SRC}" cuckarood_cpu_compat_31 "-mno-avx2 -DNSIPHASH=4 -DEDGEBITS=31 -DSAVEEDGES")
#build_cpu_target("${AR2_CPU_SRC}" cuckarood_cpu_avx2_31 "-mavx2 -DNSIPHASH=8 -DEDGEBITS=31 -DSAVEEDGES")

### AR CUDA TARGETS #########################################

set (AR2_CUDA_SRC cuckoo/src/cuckarood/kernel.cuh cuckoo/src/cuckarood/photon.cu ${BLAKE_2B} )

if (NOT SKIP_CUCKAROOD_GPU)
  #build_cuda_target("${AR2_CUDA_SRC}" cuckarood_cuda_31 "-DEDGEBITS=31")
endif()

##################################################################################
### CUCKAROOM (Asic Resistant)  ##################################################
##################################################################################

### AR CPU BUILDING  #########################################

set (AR2_CPU_SRC
			cuckoo/src/cuckaroom/cuckaroom.hpp
			cuckoo/src/cuckaroom/bitmap.hpp
			cuckoo/src/cuckaroom/graph.hpp
			cuckoo/src/threads/barrier.hpp
			cuckoo/src/crypto/siphash.hpp
			cuckoo/src/crypto/siphashxN.h
			cuckoo/src/cuckaroom/mean.hpp
			cuckoo/src/cuckaroom/mean.cpp
			${BLAKE_2B})

### AR CPU TARGETS #########################################

if (NOT SKIP_CUCKAROOM_CPU)
  #build_cpu_target("${AR2_CPU_SRC}" cuckaroom_cpu_compat_31 "-mno-avx2 -DNSIPHASH=4 -DEDGEBITS=31 -DSAVEEDGES")
  #build_cpu_target("${AR2_CPU_SRC}" cuckaroom_cpu_avx2_31 "-mavx2 -DNSIPHASH=8 -DEDGEBITS=31 -DSAVEEDGES")
endif()

### AR CUDA TARGETS #########################################

set (AR2_CUDA_SRC cuckoo/src/cuckaroom/meaner.cu ${BLAKE_2B} )
set (AR2_CUDA_SRC2 cuckoo/src/cuckaroom/kernel.cuh cuckoo/src/cuckaroom/mean.cu ${BLAKE_2B} )

if (NOT SKIP_CUCKAROOM_GPU)
  #build_cuda_target("${AR2_CUDA_SRC}" cuckaroom_cuda_31 "-DEDGEBITS=31")
endif()

##################################################################################
### CUCKAROOZ (Asic Resistant)  ##################################################
##################################################################################

### AR CPU BUILDING  #########################################

set (AR2_CPU_SRC
			cuckoo/src/cuckarooz/cuckarooz.hpp
			cuckoo/src/cuckarooz/bitmap.hpp
			cuckoo/src/cuckarooz/graph.hpp
			cuckoo/src/threads/barrier.hpp
			cuckoo/src/crypto/siphash.hpp
			cuckoo/src/crypto/siphashxN.h
			cuckoo/src/cuckarooz/mean.hpp
			cuckoo/src/cuckarooz/mean.cpp
			${BLAKE_2B})

### AR CPU TARGETS #########################################

if (NOT SKIP_CUCKAROOZ_CPU)
 # build_cpu_target("${AR2_CPU_SRC}" cuckarooz_cpu_compat_31 "-mno-avx2 -DNSIPHASH=4 -DEDGEBITS=31 -DSAVEEDGES")
 # build_cpu_target("${AR2_CPU_SRC}" cuckarooz_cpu_avx2_31 "-mavx2 -DNSIPHASH=8 -DEDGEBITS=31 -DSAVEEDGES")
endif()

### AR CUDA TARGETS #########################################

set (AR2_CUDA_SRC cuckoo/src/cuckarooz/mean.cu ${BLAKE_2B} )

if (NOT SKIP_CUCKAROOZ_GPU)
  #build_cuda_target("${AR2_CUDA_SRC}" cuckarooz_cuda_31 "-DEDGEBITS=31")
endif()
