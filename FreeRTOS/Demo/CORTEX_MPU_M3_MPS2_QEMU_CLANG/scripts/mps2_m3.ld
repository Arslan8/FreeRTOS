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
__FLASH_segment_end__                 = __FLASH_segment_start__ + LENGTH( FLASH );

__SRAM_segment_start__      = ORIGIN( RAM );
__SRAM_segment_end__        = __SRAM_segment_start__ + LENGTH( RAM );

__privileged_data_start__   = __SRAM_segment_start__;
__privileged_data_end__     = __SRAM_segment_start__ + __privileged_data_region_size__;

__privileged_functions_start__        = __FLASH_segment_start__;
__privileged_functions_end__          = __FLASH_segment_start__ + __privileged_functions_region_size__;

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
    } >FLASH

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

compartLMA = LOADADDR(.data) + SIZEOF(.data);
  .osection0data :  AT (compartLMA) 
  { . = ALIGN(4); 
		_sosection0data = .; 
  *(.osection0data)		   /* .data sections. */
  . = ALIGN(4); 
  _eosection0data = .;
} > RAM 
test_sym = LOADADDR(.osection0data);
. = _eosection0data + ALIGN(4);
_sosection0datal = LOADADDR(.osection0data);

compartLMA = compartLMA + SIZEOF(.osection0data);
  .osection0 : 
  {
	  . = ALIGN(4);
	  _sosection0 = .;
	  *(.osection0)
	  . = ALIGN(4);
	  _eosection0 = .;
_szosection0 = _eosection0 - _sosection0data;  }  > RAM 
compartLMA = compartLMA + SIZEOF(.osection0); 
  .osection1data :  AT (compartLMA)
  { . = ALIGN(4); 
		_sosection1data = .; 
  *(.osection1data)		   /* .data sections. */
  . = ALIGN(4); 
  _eosection1data = .;
} > RAM
_sosection1datal = LOADADDR(.osection1data);

compartLMA = compartLMA + SIZEOF(.osection1data);
  .osection1 : 
  {
	  . = ALIGN(4);
	  _sosection1 = .;
	  *(.osection1)
	  . = ALIGN(4);
	  _eosection1 = .;
_szosection1 = _eosection1 - _sosection1data;  }  > RAM 
  .osection2data :  AT ( compartLMA ) 
  { . = ALIGN(4); 
		_sosection2data = .; 
  *(.osection2data)		   /* .data sections. */
  . = ALIGN(4); 
  _eosection2data = .;
} > RAM 
_sosection2datal = LOADADDR(.osection2data);
. = _eosection2data + ALIGN(4);

compartLMA = compartLMA + SIZEOF(.osection2data);
  .osection2 : 
  {
	  . = ALIGN(4);
	  _sosection2 = .;
	  *(.osection2)
	  . = ALIGN(4);
	  _eosection2 = .;
_szosection2 = _eosection2 - _sosection2data;  }  > RAM 
laddr = LOADADDR(.osection2data);
lsize = (_eosection2data - _sosection2data);

lsize = SIZEOF(.osection2data); 
cLMA = LOADADDR(.osection0data) + SIZEOF(.osection0data) + 0x00;
cLMA = ALIGN(cLMA, 4);
  .csection0 cLMA : AT(cLMA)  
  {
_scsection0 = .;
	  . = ALIGN(4);
	  *(.csection0)
	  . = ALIGN(4);
_ecsection0 = .;
_szcsection0 = _ecsection0 - _scsection0;  }  > FLASH 
  .csection1 : 
  {
_scsection1 = .;
	  . = ALIGN(4);
	  *(.csection1)
	  . = ALIGN(4);
_ecsection1 = .;
_szcsection1 = _ecsection1 - _scsection1;  } > FLASH 
  .csection2 : 
  {
_scsection2 = .;
	  . = ALIGN(4);
	  *(.csection2)
	  . = ALIGN(4);
_ecsection2 = .;
_szcsection2 = _ecsection2 - _scsection2;  } > FLASH 
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
   __FlashEnd = ORIGIN(FLASH) + LENGTH(FLASH);
   __End_RAM = ORIGIN(RAM) + LENGTH(RAM);
   PROVIDE(__stack = __StackTop);

  /* Check if data + heap + stack exceeds RAM limit */
  ASSERT(__StackLimit >= _heap_top, "region RAM overflowed with stack")
}

