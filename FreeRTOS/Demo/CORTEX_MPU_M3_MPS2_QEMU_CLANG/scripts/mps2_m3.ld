/*
 * FreeRTOS V202212.00
 * Copyright (C) 2020 Amazon.com, Inc. or its affiliates.  All Rights Reserved.
 *
 * Permission is hereby granted, free of charge, to any person obtaining a copy of
 * this software and associated documentation files (the "Software"), to deal in
 * the Software without restriction, including without limitation the rights to
 * use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of
 * the Software, and to permit persons to whom the Software is furnished to do so,
 * subject to the following conditions:
 *
 * The above copyright notice and this permission notice shall be included in all
 * copies or substantial portions of the Software.
 *
 * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 * IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS
 * FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR
 * COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER
 * IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN
 * CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
 *
 * https://www.FreeRTOS.org
 * https://github.com/FreeRTOS
 *
 */

#define LFLASH 0x0003FFFF
#define OFLASH 0x00000000
MEMORY
{
  FLASH (rx)         : ORIGIN = 0x00000000, LENGTH = 0x0003FFFF
  RAM (rw)           : ORIGIN = 0x20000000, LENGTH = 0x07fffff
}
/* Entry Point. */
ENTRY(Reset_Handler)

/* Highest address of the user mode stack. */
_estack                     = ORIGIN(RAM) + LENGTH(RAM);

_Min_Heap_Size = 0x200 ;        /* Required amount of heap. */
_Min_Stack_Size = 0x400 ;       /* Required amount of stack. */


M_VECTOR_RAM_SIZE = (16 + 48) * 4;

__privileged_functions_region_size__  = 64K; /* 64000 bytes */
__privileged_data_region_size__       = 32K; /* 32000 bytes */

__FLASH_segment_start__               = ORIGIN( FLASH );
__FLASH_segment_end__                 = ORIGIN( FLASH ) + LENGTH ( FLASH );

__privileged_functions_start__        = __FLASH_segment_start__;
__privileged_functions_end__          = __FLASH_segment_start__ + __privileged_functions_region_size__;

__SRAM_segment_start__      = ORIGIN( RAM );
__SRAM_segment_end__        = __SRAM_segment_start__ + LENGTH( RAM );

__privileged_data_start__   = __SRAM_segment_start__;
__privileged_data_end__     = __SRAM_segment_start__ + __privileged_data_region_size__;


SECTIONS
{
    .privileged_functions :
    {
        . = ALIGN(4);
        KEEP(*(.isr_vector)) /* Startup code */
        . = ALIGN(4);
        *(privileged_functions)
        . = ALIGN(4);
        FILL(0xDEAD);
        /* Ensure that un-privileged code is placed after the region reserved                                                                                                                                         4          * for privileged kernel code. */
        /* Note that dot (.) actually refers to the byte offset from the start
            * of the current section (.privileged_functions in this case). As a
            * result, setting dot (.) to a value sets the size of the section. */
        . = __privileged_functions_region_size__;
    } >FLASH :thummb

    .text :
    {
        . = ALIGN(4);
        __syscalls_flash_start__ = .;
        *(freertos_system_calls)
        __syscalls_flash_end__ = .;
        . = ALIGN(4);
        *(.text)
        *(.text*)
        *(.glue_7)         /* glue arm to thumb code. */
        *(.glue_7t)        /* glue thumb to arm code. */
        *(.eh_frame)

        KEEP (*(.init))
        KEEP (*(.fini))
        KEEP(*(.eh_frame))
        . = ALIGN(4);
        _etext = .;
    } > FLASH


    .rodata :
    {
        . = ALIGN(4);
        *(.rodata)         /* .rodata sections  (constants, strings, etc.). */
        *(.rodata*)        /* .rodata* sections (constants, strings, etc.). */
        . = ALIGN(4);

    } > FLASH

    .ARM.extab :
    {
        . = ALIGN(4);
        *(.ARM.extab* .gnu.linkonce.armextab.*)
        . = ALIGN(4);
    } >FLASH

    .ARM :
    {
        . = ALIGN(4);
        __exidx_start = .;
        *(.ARM.exidx*)
        /* *(.ARM.exidx* .gnu.linkonce.armexidx.*) */
        __exidx_end = .;
        . = ALIGN(4);
    } >FLASH

    .preinit_array :
    {
        . = ALIGN(4);
        PROVIDE_HIDDEN (__preinit_array_start = .);
        KEEP (*(.preinit_array*))
        PROVIDE_HIDDEN (__preinit_array_end = .);
        . = ALIGN(4);
    } >FLASH

    .init_array :
    {
        . = ALIGN(4);
        PROVIDE_HIDDEN (__init_array_start = .);
        KEEP (*(SORT(.init_array.*)))
        KEEP (*(.init_array*))
        PROVIDE_HIDDEN (__init_array_end = .);
        . = ALIGN(4);
    } >FLASH

    .fini_array :
    {
        . = ALIGN(4);
        PROVIDE_HIDDEN (__fini_array_start = .);
        KEEP (*(SORT(.fini_array.*)))
        KEEP (*(.fini_array*))
        PROVIDE_HIDDEN (__fini_array_end = .);
        . = ALIGN(4);
    } >FLASH

    _sidata = LOADADDR(.privileged_data);

    .privileged_data :
    {
        . = ALIGN(4);
        _sdata = .;        /* Create a global symbol at data start. */
        *(privileged_data)
        . = ALIGN(4);
        FILL(0xDEAD);
        /* Ensure that un-privileged data is placed after the region reserved
            * for privileged kernel data. */
        /* Note that dot (.) actually refers to the byte offset from the start
            * * of the current section (.privileged_data in this case). As a result,
            * * setting dot (.) to a value sets the size of the section. */
        /*. = __privileged_data_region_size__; */
		ASSERT((. - _sdata) < __privileged_data_region_size__, "More data than allowed");
    } >RAM AT> FLASH

    .data : /* AT ( _sidata ) */
    {
		. = __SRAM_segment_start__ + __privileged_data_region_size__;
        . = ALIGN(4);
        *(.data)           /* .data sections. */
        *(.data*)
        . = ALIGN(4);
        _edata = .;
    } > RAM AT > FLASH

  .csection0 : 
  {
_scsection0 = .;
	  . = ALIGN(4);
	  *(.csection0)
	  . = ALIGN(4);
_ecsection0 = .;
  } > FLASH 
  .csection1 : 
  {
_scsection1 = .;
	  . = ALIGN(4);
	  *(.csection1)
	  . = ALIGN(4);
_ecsection1 = .;
  } > FLASH 
  .csection2 : 
  {
_scsection2 = .;
	  . = ALIGN(4);
	  *(.csection2)
	  . = ALIGN(4);
_ecsection2 = .;
  } > FLASH 
  .csection3 : 
  {
_scsection3 = .;
	  . = ALIGN(4);
	  *(.csection3)
	  . = ALIGN(4);
_ecsection3 = .;
  } > FLASH 
  .csection4 : 
  {
_scsection4 = .;
	  . = ALIGN(4);
	  *(.csection4)
	  . = ALIGN(4);
_ecsection4 = .;
  } > FLASH 
  .csection5 : 
  {
_scsection5 = .;
	  . = ALIGN(4);
	  *(.csection5)
	  . = ALIGN(4);
_ecsection5 = .;
  } > FLASH 
  .csection6 : 
  {
_scsection6 = .;
	  . = ALIGN(4);
	  *(.csection6)
	  . = ALIGN(4);
_ecsection6 = .;
  } > FLASH 
  .csection7 : 
  {
_scsection7 = .;
	  . = ALIGN(4);
	  *(.csection7)
	  . = ALIGN(4);
_ecsection7 = .;
  } > FLASH 
  .csection8 : 
  {
_scsection8 = .;
	  . = ALIGN(4);
	  *(.csection8)
	  . = ALIGN(4);
_ecsection8 = .;
  } > FLASH 
  .csection9 : 
  {
_scsection9 = .;
	  . = ALIGN(4);
	  *(.csection9)
	  . = ALIGN(4);
_ecsection9 = .;
  } > FLASH 
  .csection10 : 
  {
_scsection10 = .;
	  . = ALIGN(4);
	  *(.csection10)
	  . = ALIGN(4);
_ecsection10 = .;
  } > FLASH 
  .csection11 : 
  {
_scsection11 = .;
	  . = ALIGN(4);
	  *(.csection11)
	  . = ALIGN(4);
_ecsection11 = .;
  } > FLASH 
  .csection12 : 
  {
_scsection12 = .;
	  . = ALIGN(4);
	  *(.csection12)
	  . = ALIGN(4);
_ecsection12 = .;
  } > FLASH 
  .csection13 : 
  {
_scsection13 = .;
	  . = ALIGN(4);
	  *(.csection13)
	  . = ALIGN(4);
_ecsection13 = .;
  } > FLASH 
  .csection14 : 
  {
_scsection14 = .;
	  . = ALIGN(4);
	  *(.csection14)
	  . = ALIGN(4);
_ecsection14 = .;
  } > FLASH 
  .csection15 : 
  {
_scsection15 = .;
	  . = ALIGN(4);
	  *(.csection15)
	  . = ALIGN(4);
_ecsection15 = .;
  } > FLASH 
  .csection16 : 
  {
_scsection16 = .;
	  . = ALIGN(4);
	  *(.csection16)
	  . = ALIGN(4);
_ecsection16 = .;
  } > FLASH 
  .csection17 : 
  {
_scsection17 = .;
	  . = ALIGN(4);
	  *(.csection17)
	  . = ALIGN(4);
_ecsection17 = .;
  } > FLASH 
  .csection18 : 
  {
_scsection18 = .;
	  . = ALIGN(4);
	  *(.csection18)
	  . = ALIGN(4);
_ecsection18 = .;
  } > FLASH 
  .csection19 : 
  {
_scsection19 = .;
	  . = ALIGN(4);
	  *(.csection19)
	  . = ALIGN(4);
_ecsection19 = .;
  } > FLASH 


    . = ALIGN(4);
    .bss :
    {
        _sbss = .;
        __bss_start__ = _sbss;
        *(.bss)
        *(.bss*)
        *(COMMON)
        . = ALIGN(4);
        _ebss = .;
        __bss_end__ = _ebss;
    } >RAM

    ._user_heap_stack :
    {
        . = ALIGN(8);
        PROVIDE ( end = . );
        PROVIDE ( _end = . );
        _heap_bottom = .;
        . = . + _Min_Heap_Size;
        _heap_top = .;
        . = . + _Min_Stack_Size;
        . = ALIGN(8);
       } >RAM

  .osection0 : AT ( _sidata  + compartLMA)
  {
	  . = ALIGN(4);
	  _sosection0 = .;
	  *(.osection0)
	  . = ALIGN(4);
	  _eosection0 = .;
  }  > RAM 
compartLMA = compartLMA + SIZEOF(.osection0); 
  .osection1 : AT ( _sidata  + compartLMA)
  {
	  . = ALIGN(4);
	  _sosection1 = .;
	  *(.osection1)
	  . = ALIGN(4);
	  _eosection1 = .;
  }  > RAM 
compartLMA = compartLMA + SIZEOF(.osection1); 
  .osection2 : AT ( _sidata  + compartLMA)
  {
	  . = ALIGN(4);
	  _sosection2 = .;
	  *(.osection2)
	  . = ALIGN(4);
	  _eosection2 = .;
  }  > RAM 
compartLMA = compartLMA + SIZEOF(.osection2); 
  .osection3 : AT ( _sidata  + compartLMA)
  {
	  . = ALIGN(4);
	  _sosection3 = .;
	  *(.osection3)
	  . = ALIGN(4);
	  _eosection3 = .;
  }  > RAM 
compartLMA = compartLMA + SIZEOF(.osection3); 
  .osection4 : AT ( _sidata  + compartLMA)
  {
	  . = ALIGN(4);
	  _sosection4 = .;
	  *(.osection4)
	  . = ALIGN(4);
	  _eosection4 = .;
  }  > RAM 
compartLMA = compartLMA + SIZEOF(.osection4); 
  .osection5 : AT ( _sidata  + compartLMA)
  {
	  . = ALIGN(4);
	  _sosection5 = .;
	  *(.osection5)
	  . = ALIGN(4);
	  _eosection5 = .;
  }  > RAM 
compartLMA = compartLMA + SIZEOF(.osection5); 
  .osection6 : AT ( _sidata  + compartLMA)
  {
	  . = ALIGN(4);
	  _sosection6 = .;
	  *(.osection6)
	  . = ALIGN(4);
	  _eosection6 = .;
  }  > RAM 
compartLMA = compartLMA + SIZEOF(.osection6); 
  .osection7 : AT ( _sidata  + compartLMA)
  {
	  . = ALIGN(4);
	  _sosection7 = .;
	  *(.osection7)
	  . = ALIGN(4);
	  _eosection7 = .;
  }  > RAM 
compartLMA = compartLMA + SIZEOF(.osection7); 
  .osection8 : AT ( _sidata  + compartLMA)
  {
	  . = ALIGN(4);
	  _sosection8 = .;
	  *(.osection8)
	  . = ALIGN(4);
	  _eosection8 = .;
  }  > RAM 
compartLMA = compartLMA + SIZEOF(.osection8); 
  .osection9 : AT ( _sidata  + compartLMA)
  {
	  . = ALIGN(4);
	  _sosection9 = .;
	  *(.osection9)
	  . = ALIGN(4);
	  _eosection9 = .;
  }  > RAM 
compartLMA = compartLMA + SIZEOF(.osection9); 
  .osection10 : AT ( _sidata  + compartLMA)
  {
	  . = ALIGN(4);
	  _sosection10 = .;
	  *(.osection10)
	  . = ALIGN(4);
	  _eosection10 = .;
  }  > RAM 
compartLMA = compartLMA + SIZEOF(.osection10); 
  .osection11 : AT ( _sidata  + compartLMA)
  {
	  . = ALIGN(4);
	  _sosection11 = .;
	  *(.osection11)
	  . = ALIGN(4);
	  _eosection11 = .;
  }  > RAM 
compartLMA = compartLMA + SIZEOF(.osection11); 
  .osection12 : AT ( _sidata  + compartLMA)
  {
	  . = ALIGN(4);
	  _sosection12 = .;
	  *(.osection12)
	  . = ALIGN(4);
	  _eosection12 = .;
  }  > RAM 
compartLMA = compartLMA + SIZEOF(.osection12); 
  .osection13 : AT ( _sidata  + compartLMA)
  {
	  . = ALIGN(4);
	  _sosection13 = .;
	  *(.osection13)
	  . = ALIGN(4);
	  _eosection13 = .;
  }  > RAM 
compartLMA = compartLMA + SIZEOF(.osection13); 
  .osection14 : AT ( _sidata  + compartLMA)
  {
	  . = ALIGN(4);
	  _sosection14 = .;
	  *(.osection14)
	  . = ALIGN(4);
	  _eosection14 = .;
  }  > RAM 
compartLMA = compartLMA + SIZEOF(.osection14); 
  .osection15 : AT ( _sidata  + compartLMA)
  {
	  . = ALIGN(4);
	  _sosection15 = .;
	  *(.osection15)
	  . = ALIGN(4);
	  _eosection15 = .;
  }  > RAM 
compartLMA = compartLMA + SIZEOF(.osection15); 
  .osection16 : AT ( _sidata  + compartLMA)
  {
	  . = ALIGN(4);
	  _sosection16 = .;
	  *(.osection16)
	  . = ALIGN(4);
	  _eosection16 = .;
  }  > RAM 
compartLMA = compartLMA + SIZEOF(.osection16); 
  .osection17 : AT ( _sidata  + compartLMA)
  {
	  . = ALIGN(4);
	  _sosection17 = .;
	  *(.osection17)
	  . = ALIGN(4);
	  _eosection17 = .;
  }  > RAM 
compartLMA = compartLMA + SIZEOF(.osection17); 
  .osection18 : AT ( _sidata  + compartLMA)
  {
	  . = ALIGN(4);
	  _sosection18 = .;
	  *(.osection18)
	  . = ALIGN(4);
	  _eosection18 = .;
  }  > RAM 
compartLMA = compartLMA + SIZEOF(.osection18); 
  .osection19 : AT ( _sidata  + compartLMA)
  {
	  . = ALIGN(4);
	  _sosection19 = .;
	  *(.osection19)
	  . = ALIGN(4);
	  _eosection19 = .;
  }  > RAM 
compartLMA = compartLMA + SIZEOF(.osection19); 

    /DISCARD/ :
    {
        libc.a ( * )
        libm.a ( * )
        libgcc.a ( * )
    }

    .ARM.attributes 0 : { *(.ARM.attributes) }

   /* Set stack top to end of RAM, and stack limit move down by
    * size of stack_dummy section */
   __StackTop = ORIGIN(RAM) + LENGTH(RAM);
   __StackLimit = __StackTop - _Min_Stack_Size;
   PROVIDE(__stack = __StackTop);

  /* Check if data + heap + stack exceeds RAM limit */
  ASSERT(__StackLimit >= _heap_top, "region RAM overflowed with stack")
}

