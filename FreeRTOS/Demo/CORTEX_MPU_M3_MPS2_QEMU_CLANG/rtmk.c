#include "monitor.h"
#define PROTO
//#include "autogen_data.c"
void init_mpu();
RTMK_DATA
int selectedFunction = 0;
RTMK_DATA
int arg = 0;
RTMK_DATA
int sret = 0;
RTMK_CODE
void SVC_Handler_Main( unsigned int *svc_args );
//extern unsigned char * _shared_region;
RTMK_CODE void* rtmkcpy(void * dest, void * src, int size);

RTMK_DATA
int shadow_stack[64];

RTMK_DATA 
int sp;

RTMK_DATA
volatile unsigned long long bridge_time;

RTMK_DATA
int goff;//Global offset across xcalls for shared memory


RTMK_CODE
int switch_view(int to, int push);

RTMK_DATA
char _shared_region[512];
#if 0
RTMK_CODE 
void SVC_Handler(void ) {
		__asm(
						"TST lr, #4\n"
						"ITE EQ\n"
						"MRSEQ r0, MSP\n"
						"MRSNE r0, PSP\n"
						"B SVC_Handler_Main\n"
			 );
}

RTMK_CODE
void SVC_Handler_Main( unsigned int *svc_args ) {
		switch(selectedFunction) {
				case 10:
						init_mpu();
						break;
				case 29012:
						SVC_Handler();
						break;
				case 123123123:
						sret = switch_view(123123);
						break;
				case 123123124:
						sret = switch_view(1231233);
						break;
				case 123123126:
						sret = switch_view(1231232);
						break;
				case 1:
						sret = switch_view(123123);
						break;
				case 2:
						sret = switch_view(123123);
						break;
				case 3:
						sret = switch_view(123123);
						break;
				case 4:
						sret = switch_view(123123);
						break;
				case 5:
						sret = switch_view(123123);
						break;
				case 6:
						sret = switch_view(123123);
						break;
				case 7:
						sret = switch_view(123123);
						break;
				case 8:
						sret = switch_view(123123);
						break;
				case 19:
						sret = switch_view(123123);
						break;
				case 123123:
						sret = switch_view(arg);
						break;
				default:
						break;
		}
		return;

}
#endif 

#define STACK_LEN
RTMK_DATA
int current;

RTMK_DATA
int last;

RTMK_CODE
int lastCompart() {
		return last;
}
typedef void (*xfunction0)(void);
typedef int  (*ifunction0)(void);
typedef int  (*ifunction1i)(int);
typedef int  (*ifunction1p)(void *);
typedef void  (*xfunction1i)(int);
typedef void  (*xfunction1p)(void *);
typedef void  (*xfunction2pi)(void *, int);
typedef void  (*xfunction3pii)(void *, int, int);
typedef void* (*pfunction1i)(int);
typedef void* (*pfunction3iii)(int, int, int);
typedef void* (*pfunction0)();
typedef void  (*xfunction2ii)(int, int);
typedef void  (*xfunction2pp)(void *, void *);
typedef void  (*xfunction2ip)(int, void *);
typedef int  (*ifunction2pi)(void *, int);
typedef int  (*ifunction2pp)(void *, void *);
typedef int  (*ifunction2ppi)(void *, void *, int);
typedef int  (*ifunction3pii)(void *, int, int);
typedef int  (*ifunction2ppii)(void *, void *, int, int);
typedef int  (*ifunction2pppi)(void *, void *, void *, int);
typedef int  (*ifunction5iiipi)(int, int, int, void*, int);
typedef int  (*ifunction6ppipip)(void *, void *,int, void*,int, void*);
typedef int  (*ifunction6piiipp)(void *, int, int, int, void*, void *);
#define MK_METHOD
RTMK_CODE void xcall_arg0(int to, void * funcp) {
		unsigned long long handle;
		BNCHSTART(bridge_time, handle);
		int ret= switch_view(to, 1);
		xfunction0 func = (xfunction0)funcp;
		BNCHEND(bridge_time, handle);
		func();
		BNCHSTART(bridge_time, handle);
		switch_view(ret, 0);
		BNCHEND(bridge_time, handle);
}

RTMK_CODE void xcall_arg1_noidp(int to, void * funcp, char * arg0, int size) {
}

RTMK_CODE void xcall_arg3ppp(int to, void * funcp, void * arg0, int size, void * arg1, int size1, void * arg2, int size2) {

}

RTMK_CODE void pcall_arg1p(int to, void * funcp, char * arg0, int size) {
}

RTMK_CODE void xcall_arg2_noidpi(int to, void * funcp, void* arg0, int size, int arg1, int size1)
{}
RTMK_CODE void xcall_arg1i(int to, void * funcp, int arg0, int size) {
		unsigned long long handle;
		BNCHSTART(bridge_time, handle);
		int ret= switch_view(to, 1);
		xfunction1i func = (xfunction1i)funcp;
		BNCHEND(bridge_time, handle);
		func(arg0);
		BNCHSTART(bridge_time, handle);
		switch_view(ret, 0);
		BNCHEND(bridge_time, handle);
}
RTMK_CODE void * pcall_arg0(int to, void * funcp) {
		unsigned long long handle;
		BNCHSTART(bridge_time, handle);
		int ret= switch_view(to,1);
		pfunction0 func = (pfunction0)funcp;
		BNCHEND(bridge_time, handle);
		void * bret = func();
		BNCHSTART(bridge_time, handle);
		switch_view(ret,0);
		BNCHEND(bridge_time, handle);
		return bret;
}
RTMK_CODE void *  pcall_arg3iii(int to, void * funcp, int arg0, int size, int arg1, int size1, int arg2, int size2) {
		unsigned long long handle;
		BNCHSTART(bridge_time, handle);
		int ret= switch_view(to,1);
		pfunction3iii func = (pfunction3iii)funcp;
		BNCHEND(bridge_time, handle);
		void * bret = func(arg0,arg1,arg2);
		BNCHSTART(bridge_time, handle);
		switch_view(ret,0);
		BNCHEND(bridge_time, handle);
		return bret;
}
#ifdef STACK_SWITCH
RTMK_DATA
char stack[19][512];
RTMK_DATA
void * ret_temp_stack;
#endif 

//RTMK_CODE void* rtmkcpy(void * dest, void * src, int size);
RTMK_CODE void * pcall_arg1i(int to, void * funcp, int arg0, int size) {
		unsigned long long handle;
		BNCHSTART(bridge_time, handle);
#ifdef STACK_SWITCH
		int sp = 0;
		int comp = getCompartmentFromAddr(&sp);
#endif 
		int ret;
		pfunction1i func; 
		void * bret;
#ifdef STACK_SWITCH
		if (comp && comp!= to) {
				sp = ((unsigned)&bret -sizeof(bret));
				rtmkcpy(&stack[to][(sizeof(stack)/19) - (36)],((unsigned)&bret -sizeof(bret)), 40);
				/* Move to shared stack */
				//switch_stack();
				asm ("mov sp, %0\n\t"
								:
								: "r" (&stack[to][(sizeof(stack)/19) - 36]));
		}

#endif
		ret= switch_view(to,1);
		func = (pfunction1i)funcp;
		BNCHEND(bridge_time, handle);
		bret = func(arg0);
		BNCHSTART(bridge_time, handle);
#ifdef STACK_SWITCH
		ret_temp_stack = bret;
#endif
		switch_view(ret,0);
#ifdef STACK_SWITCH
		if (comp && comp != to) {
				asm ("mov sp, %0\n\t"
								:
								: "r" (sp));
		}
		bret = ret_temp_stack;
#endif 
		BNCHEND(bridge_time, handle);
		return bret;
}
RTMK_CODE void xcall_arg2ii(int to, void * funcp, int arg0, int size, int arg1, int size1) {
		unsigned long long handle;
		BNCHSTART(bridge_time, handle);
		int ret= switch_view(to,1);
		xfunction2ii func = (xfunction2ii)funcp;
		BNCHEND(bridge_time, handle);
		func(arg0, arg1);
		BNCHSTART(bridge_time, handle);
		switch_view(ret,0);
		BNCHEND(bridge_time, handle);
}

RTMK_CODE void xcall_arg2ip(int to, void * funcp, int arg0, int size, void * arg1, int size1) {
		unsigned long long handle;
		BNCHSTART(bridge_time, handle);
		unsigned long mem_used = (unsigned long) (&_shared_region) + goff;
		void * pt = rtmkcpy((&_shared_region) + goff, arg1, size1);
		int ret= switch_view(to,1);
		xfunction2ip func = (xfunction2ip)funcp;
		if (size1 > 0)
				mem_used = ((unsigned long )pt + size1 - mem_used);
		else 
				mem_used = 0;
		goff += mem_used;
		BNCHEND(bridge_time, handle);
		func(arg0, pt);
		BNCHSTART(bridge_time, handle);
		rtmkcpy(arg1,  (&_shared_region) + goff, size1);
		goff -= mem_used;
		switch_view(ret,0);
		BNCHEND(bridge_time, handle);
}
//__attribute__((always_inline))
RTMK_CODE void* rtmkcpy(void * dest, void * src, int size) {
		if (size<=0) {
				return src;
		}
		// Typecast src and dest addresses to (char *)
		char *csrc = (char *)src;
		char *cdest = (char *)dest;

		// Copy contents of src[] to dest[]
		for (int i=0; i<size; i++)
				cdest[i] = csrc[i];

		return dest;
}
RTMK_CODE void xcall_arg1p(int to, void * funcp, char * arg0, int size) {
		unsigned long long handle;
		BNCHSTART(bridge_time, handle);
		unsigned long mem_used = (unsigned long) (&_shared_region) + goff;
		void * pt = rtmkcpy((&_shared_region) + goff, arg0, size);
		int ret= switch_view(to,1);
		xfunction1p func = (xfunction1p)funcp;
		if (size > 0)
				mem_used = ((unsigned long )pt + size - mem_used);
		else
				mem_used = 0;
		goff += mem_used;
		BNCHEND(bridge_time, handle);
		func(pt);
		BNCHSTART(bridge_time, handle);
		rtmkcpy(arg0, (&_shared_region) + goff, size);
		goff -= mem_used;
		switch_view(ret,0);
		BNCHEND(bridge_time, handle);
}

RTMK_CODE void xcall_arg2pi(int to, void * funcp, char * arg0, int size, int arg1, int size1) {
		unsigned long long handle;
		BNCHSTART(bridge_time, handle);
		unsigned long mem_used = (unsigned long) (&_shared_region) + goff;
		void * pt = rtmkcpy((&_shared_region) + goff, arg0, size);
		int ret= switch_view(to,1);
		xfunction2pi func = (xfunction2pi)funcp;
		if (size > 0)
				mem_used = ((unsigned long )pt + size - mem_used);
		else
				mem_used = 0;
		goff += mem_used;
		BNCHEND(bridge_time, handle);
		func(pt, arg1);
		BNCHSTART(bridge_time, handle);
		rtmkcpy((&_shared_region) + goff, arg0, size);
		goff -= mem_used;
		switch_view(ret,0);
		BNCHEND(bridge_time, handle);
}

RTMK_CODE void xcall_arg3pii(int to, void * funcp, char * arg0, int size, int arg1, int size1, int arg2, int size2) {
		unsigned long long handle;
		BNCHSTART(bridge_time, handle);
		unsigned long mem_used = (unsigned long) (&_shared_region) + goff;
		void * pt = rtmkcpy((&_shared_region) + goff, arg0, size);
		int ret= switch_view(to,1);
		xfunction3pii func = (xfunction3pii)funcp;
		if (size > 0)
				mem_used = ((unsigned long )pt + size - mem_used);
		else
				mem_used = 0;
		goff += mem_used;
		BNCHEND(bridge_time, handle);
		func(pt, arg1, arg2);
		BNCHSTART(bridge_time, handle);
		rtmkcpy(arg0, (&_shared_region) + goff, size);
		goff -= mem_used;
		switch_view(ret,0);
		BNCHEND(bridge_time, handle);
}
RTMK_CODE int icall_arg3pii(int to, void * funcp, char * arg0, int size, int arg1, int size1, int arg2, int size2) {
		unsigned long long handle;
		BNCHSTART(bridge_time, handle);
		unsigned long mem_used = (unsigned long) (&_shared_region) + goff;
		void * pt = rtmkcpy((&_shared_region) + goff, arg0, size);
		int ret= switch_view(to,1);
		ifunction3pii func = (ifunction3pii)funcp;
		if (size > 0)
				mem_used = ((unsigned long )pt + size - mem_used);
		else
				mem_used = 0;
		goff += mem_used;
		BNCHEND(bridge_time, handle);
		int realRet = func(pt, arg1, arg2);
		BNCHSTART(bridge_time, handle);
		goff -= mem_used;
		rtmkcpy(arg0, (&_shared_region) + goff, size);
		switch_view(ret,0);
		BNCHEND(bridge_time, handle);
		return realRet;
}
RTMK_CODE void xcall_arg2pp(int to, void * funcp, char * arg0, int size, char * arg1, int size1) {
		unsigned long long handle;
		BNCHSTART(bridge_time, handle);
		unsigned long mem_used = (unsigned long) (&_shared_region) + goff;
		void *pt  = rtmkcpy((&_shared_region) + goff, arg0, size);
		int offset = 0;
		if (size>0) 
				offset += size;
		void *pt1 = rtmkcpy((void *)((unsigned int)&_shared_region + offset), arg1, size1);
		if (size1 > 0)
				mem_used = ((unsigned long )pt1 + size1 - mem_used);
		else {
				if (size > 0)
						mem_used = ((unsigned long )pt + size - mem_used);
				else 
						mem_used =0; // Both pointers are opaque 
		}

		goff += mem_used;
		int ret= switch_view(to,1);
		xfunction2pp func = (xfunction2pp)funcp;
		BNCHEND(bridge_time, handle);
		func(pt, pt1);
		BNCHSTART(bridge_time, handle);
		rtmkcpy(arg1, (void *)((unsigned int)&_shared_region + offset), size1);
		rtmkcpy(arg0, (&_shared_region) + goff, size);
		goff -= mem_used;
		switch_view(ret,0);
		BNCHEND(bridge_time, handle);
}

RTMK_CODE int switch_view_svc(int param) {
		selectedFunction = 123123;
		arg = param;
		// prvPortStartFirstTask
		__asm volatile (
						" cpsie i               \n"/* Globally enable interrupts. */
						" cpsie f               \n"
						" dsb                   \n"
						" isb                   \n"
						" svc 0                 \n"
						" nop                   \n"
					   );
		int ret = sret;
		return ret;
}
RTMK_CODE int icall_arg0(int to, void * funcp) {
		unsigned long long handle;
#ifdef MK_METHOD
		BNCHSTART(bridge_time, handle);
		int ret= switch_view(to,1);
		ifunction0 func = funcp;
		BNCHEND(bridge_time, handle);
		int retReal = func();
		BNCHSTART(bridge_time, handle);
		switch_view(ret,0);
		BNCHEND(bridge_time, handle);
		return retReal;
#elif defined(AC_METHOD)
		BNCHSTART(bridge_time, handle);
		int ret = switch_view_svc(to);
		BNCHEND(bridge_time, handle);
		int retReal = func();
		BNCHSTART(bridge_time, handle);
		switch_view_svc(ret);
		BNCHEND(bridge_time, handle);
		return retReal;
#endif
}

RTMK_CODE int icall_arg1i(int to, void * funcp, int arg0, int size) {
		unsigned long long handle;
		BNCHSTART(bridge_time, handle);
		int ret= switch_view(to,1);
		ifunction1i func = funcp;
		BNCHEND(bridge_time, handle);
		int retReal = func(arg0);
		BNCHSTART(bridge_time, handle);
		switch_view(ret,0);
		BNCHEND(bridge_time, handle);
		return retReal;
}

RTMK_CODE int icall_arg1i_noid(void * func, int arg0, int size) {
		return icall_arg1i(getCompartmentFromAddr((unsigned int)func), func, arg0, size);
}

RTMK_CODE int icall_arg1p(int to, void * funcp, void * arg0, int size) {
		unsigned long long handle;
		BNCHSTART(bridge_time, handle);
		unsigned long mem_used = 0;
		void * pt = rtmkcpy((&_shared_region ) + goff, arg0, size);
		if (size > 0)
				mem_used = size;
		int ret= switch_view(to,1);
		/* TODO: How to copy? */
		ifunction1p func = funcp;	
		goff += mem_used;
		BNCHEND(bridge_time, handle);
		int retReal = func(pt);
		BNCHSTART(bridge_time, handle);
		rtmkcpy(arg0, (&_shared_region ) + goff, size);
		goff -= mem_used;
		switch_view(ret,0);
		BNCHEND(bridge_time, handle);
		return retReal;
}
RTMK_CODE int icall_arg1p_noid(void * func, void * arg0, int size) {
		return icall_arg1p(getCompartmentFromAddr((unsigned int)func), func, arg0, size);
}
RTMK_CODE int getCompartmentFromAddr(unsigned int addr) {
		unsigned long long handle;
		BNCHSTART(bridge_time, handle);
		//int ret;
		int compartment = 0;
		/* TODO: Binary search would be far superior here */
#if 0
		for (int i =0; i< (sizeof(comp_info)/sizeof(comp_info[0])); i++) {
				if (addr > comp_info[i].start && addr < comp_info[i].end) {
						compartment = i;
						break;
				}
				if (addr > comp_info[i].dstart && addr < comp_info[i].dend) {
						compartment = i;
						break;
				}
		}
#endif 
		BNCHEND(bridge_time, handle);
		return compartment;
}

RTMK_CODE int icall_arg0_noid(ifunction0 func) {
		return icall_arg0(getCompartmentFromAddr((unsigned int)func), func);
}

RTMK_CODE void xcall_arg0_noid(xfunction0 func) {
		xcall_arg0(getCompartmentFromAddr((unsigned int)func), func);
}

RTMK_CODE void xcall_arg1p_noid(char * function, void * arg0, int size) {
		xcall_arg1p(getCompartmentFromAddr((unsigned int)function), function, arg0, size);
}


RTMK_CODE int icall_arg2pi(int to, void * funcp, void * arg0, int size, int arg1, int size1) {
		unsigned long long handle;
		BNCHSTART(bridge_time, handle);
		unsigned long mem_used = (unsigned long) (&_shared_region) + goff;
		void * pt = rtmkcpy((&_shared_region) + goff, arg0, size);
		int ret= switch_view(to,1);
		ifunction2pi fun = funcp;
		if (size > 0)
				mem_used = ((unsigned long )pt + size - mem_used);
		else
				mem_used = 0;
		goff += mem_used;
		BNCHEND(bridge_time, handle);
		int retReal = fun(pt, arg1);
		BNCHSTART(bridge_time, handle);
		rtmkcpy(arg0, (&_shared_region) + goff, size);
		goff -= mem_used;
		switch_view(ret,0);
		BNCHEND(bridge_time, handle);
		return retReal;
}

RTMK_CODE int icall_arg2pp(int to, void * funcp, void * arg0, int size, void * arg1, int size1) {
		unsigned long long handle;
		BNCHSTART(bridge_time, handle);
		unsigned long mem_used = (unsigned long) (&_shared_region) + goff;
		void *pt  = rtmkcpy((&_shared_region) + goff, arg0, size);
		int offset = goff;
		if (size>0)
				offset += size;
		void *pt1 = rtmkcpy((void *)((unsigned int)&_shared_region + offset), arg1, size1);
		if (size1 > 0)
				mem_used = ((unsigned long )pt1 + size1 - mem_used);
		else {
				if (size>0) {
						mem_used = ((unsigned long )pt + size - mem_used);
				}
				else {
						mem_used =0;
				}
		}
		goff += mem_used;
		int ret= switch_view(to,1);
		ifunction2pp fun = funcp;
		BNCHEND(bridge_time, handle);
		int retReal = fun(pt,pt1);
		BNCHSTART(bridge_time, handle);
		rtmkcpy(arg1, (void *)((unsigned int)&_shared_region + offset), size1);
        rtmkcpy(arg0, (&_shared_region) + goff, size);
		goff -= mem_used;
		switch_view(ret,0);
		BNCHEND(bridge_time, handle);
		return retReal;
}

RTMK_CODE int icall_arg3ppi(int to, void * funcp, void * arg0, int size, void * arg1, int size1, int arg2, int size2) {
		unsigned long long handle;
		BNCHSTART(bridge_time, handle);
		int offset = goff;
		unsigned long mem_used = (unsigned long) (&_shared_region) + goff;
		void * p0 =rtmkcpy((&_shared_region) +goff, arg0, size);
		if (size>0)
				offset += size;
		void * p1 =rtmkcpy((void *)((unsigned int)&_shared_region + offset), arg1, size1);
		if (size1 > 0)
				mem_used = ((unsigned long )p1 + size1 - mem_used);
		else {
				if (size > 0) {
						mem_used = ((unsigned long )p0 +size - mem_used);
				} else {
						mem_used = 0;
				}
		}
		goff += mem_used;
		int ret= switch_view(to,1);
		ifunction2ppi fun = funcp;
		BNCHEND(bridge_time, handle);
		int retReal = fun(p0,p1, arg2);
		BNCHSTART(bridge_time, handle);
		goff -= mem_used;
		rtmkcpy(arg1, (void *)((unsigned int)&_shared_region + offset), size1);
        rtmkcpy(arg0, (&_shared_region) + goff, size);
		switch_view(ret,0);
		BNCHEND(bridge_time, handle);
		return retReal;
}

RTMK_CODE int icall_arg4ppii(int to, void * funcp, void * arg0, int size, void * arg1, int size1, int arg2, int size2, int arg3, int size3) {
		unsigned long long handle;
		BNCHSTART(bridge_time, handle);
		unsigned long mem_used = (unsigned long) (&_shared_region) + goff;
		void *pt  = rtmkcpy((&_shared_region) + goff, arg0, size);
		int offset = goff;
		if (size>0)
				offset += size;
		void *pt1 = rtmkcpy((void *)((unsigned int)&_shared_region + offset), arg1, size1);

		if (size1 > 0)
				mem_used = ((unsigned long )pt1 + size1 - mem_used);
		else {
				if (size > 0) {
						mem_used = ((unsigned long )pt + size - mem_used);
				} else {
						mem_used = 0;
				}
		}
		goff += mem_used;
		int ret= switch_view(to,1);
		ifunction2ppii fun = funcp;
		BNCHEND(bridge_time, handle);
		int retReal = fun(pt, pt1, arg2, arg3);
		BNCHSTART(bridge_time, handle);
		rtmkcpy(arg1, (void *)((unsigned int)&_shared_region + offset), size1);
        rtmkcpy(arg0, (&_shared_region) + goff, size);
		goff -= mem_used;
		switch_view(ret,0);
		BNCHEND(bridge_time, handle);
		return retReal;
}

RTMK_CODE int icall_arg4pppi(int to, void * funcp, void * arg0, int size, void * arg1, int size1, void * arg2, int size2, int arg3, int size3) {
		unsigned long long handle;
		BNCHSTART(bridge_time, handle);
		int offset = goff;
		unsigned long mem_used = (unsigned long) (&_shared_region) + goff;
		void * p0 =rtmkcpy((&_shared_region) + goff, arg0, size);
		if (size>0)
				offset += size;
		void * p1 =rtmkcpy((void *)((unsigned int)&_shared_region + offset), arg1, size1);
		if (size1>0)
				offset += size1;
		void * p2 =rtmkcpy((void *)((unsigned int)&_shared_region + offset), arg2, size2);

		if (size2 > 0)
				mem_used = ((unsigned long )p2 + size2 - mem_used);
		else {
				if (size1>0) {
						mem_used = ((unsigned long )p1 + size1 - mem_used);
				} else if (size > 0) {
						mem_used = ((unsigned long )p0 + size - mem_used);
				}
				else {
						mem_used = 0;
				}
		}
		goff += mem_used;
		int ret= switch_view(to,1);
		ifunction2pppi fun = funcp;
		BNCHEND(bridge_time, handle);
		int retReal = fun(p0, p1, p2, arg3);
		BNCHSTART(bridge_time, handle);
		goff -= mem_used;
		switch_view(ret,0);
		while(1); // Fix
		BNCHEND(bridge_time, handle);
		return retReal;
}

RTMK_CODE int icall_arg6ppipip(int to, void * funcp, void * arg0, int size, void * arg1, int size1, int arg2, int size2, void * arg3, int size3, 
				int arg4, int size4, void * arg5, int size5) {
		unsigned long long handle;
		BNCHSTART(bridge_time, handle);
		unsigned long mem_used = (unsigned long) (&_shared_region) + goff;
		int offset = goff;
		void * p0 =rtmkcpy((&_shared_region) + goff, arg0, size);
		unsigned long offset_ptr = (unsigned long) (&_shared_region) + goff;
		unsigned long offset_size = 0;
		if (size>0) {
				offset += size;
				offset_ptr = (unsigned long)p0;
				offset_size = size;
		}
		void * p1 =rtmkcpy((void *)((unsigned int)&_shared_region + offset), arg1, size1);
		if (size1>0) {
				offset += size1;
				offset_ptr = (unsigned long)p1;
				offset_size = size1;
		}
		void * p2 =rtmkcpy((void *)((unsigned int)&_shared_region + offset), arg3, size3);
		if (size3>0) {
				offset += size3;
				offset_ptr = (unsigned long)p2;
				offset_size = size3;
		}
		void * p3 =rtmkcpy((void *)((unsigned int)&_shared_region + offset), arg5, size5);

		if (size5 > 0)
				mem_used = ((unsigned long )p3 + size5 - mem_used);
		else 
				mem_used = ((unsigned long )offset_ptr +offset_size - mem_used);
		goff += mem_used;
		int ret= switch_view(to,1);
		ifunction6ppipip fun = funcp;
		BNCHEND(bridge_time, handle);
		int retReal = fun(p0, p1, arg2, p2, arg4, p3);
		BNCHSTART(bridge_time, handle);
		while(1); //fix
		goff -= mem_used;
		switch_view(ret,0);
		BNCHEND(bridge_time, handle);
		return retReal;
}
RTMK_CODE int icall_arg6piiipp(int to, void * funcp, void * arg0, int size, int arg1, int size1, int arg2, int size2, int arg3, int size3,
				void* arg4, int size4, void * arg5, int size5) {
		unsigned long long handle;
		BNCHSTART(bridge_time, handle);
		unsigned long mem_used = (unsigned long) (&_shared_region) + goff;
		int offset = goff;
		unsigned long offset_ptr = (unsigned long) (&_shared_region) + goff;
		unsigned long offset_size = 0;
		void * p0 =rtmkcpy((&_shared_region) + goff, arg0, size);
		if (size>0) {
				offset += size;
				offset_ptr = (unsigned long)p0;
				offset_size = size;
		}
		void * p4 =rtmkcpy((void *)((unsigned int)&_shared_region + offset), arg4, size4);
		if (size4>0) {
				offset += size4;
				offset_ptr = (unsigned long)p4;
				offset_size = size4;
		}
		void * p5 =rtmkcpy((void *)((unsigned int)&_shared_region + offset), arg5, size5);
		if (size5 > 0)
				mem_used = ((unsigned long )p5 + size5 - mem_used);
		else
				mem_used = ((unsigned long )offset_ptr + offset_size - mem_used);
		goff += mem_used;
		int ret= switch_view(to,1);
		ifunction6piiipp fun = funcp;
		BNCHEND(bridge_time, handle);
		int retReal = fun(p0, arg1, arg2, arg3, p4, p5);
		BNCHSTART(bridge_time, handle);
		while(1); //Fix
		goff -= mem_used;
		switch_view(ret,0);
		BNCHEND(bridge_time, handle);
		return retReal;
}
RTMK_CODE int icall_arg5iiipi(int to, void * funcp, int arg0, int size, int arg1, int size1, int arg2, int size2, void * arg3, int size3,
				int arg4, int size4) {
		unsigned long long handle;
		BNCHSTART(bridge_time, handle);
		unsigned long mem_used = (unsigned long) (&_shared_region) + goff;
		void * p2 =rtmkcpy((&_shared_region) + goff, arg3, size3);
		if (size3 > 0)
				mem_used = ((unsigned long )p2 + size3 - mem_used);
		else
				mem_used = ((unsigned long )p2 - mem_used);
		goff += mem_used;
		int ret= switch_view(to,1);
		ifunction5iiipi fun = funcp;
		BNCHEND(bridge_time, handle);
		int retReal = fun(arg0, arg1, arg2, p2, arg4);
		BNCHSTART(bridge_time, handle);
		while(1); //Fix
		goff -= mem_used;
		switch_view(ret,0);
		BNCHEND(bridge_time, handle);
		return retReal;
}

RTMK_CODE 
unsigned int mystrlen(const char *str) {
		int i =0;
		while(*str++!= '\0') {
				i++;
		}
		return i;
}

		RTMK_CODE
int mymemcmp(const void *m1, const void *m2, unsigned int n)
{
		const char *c1 = m1;
		const char *c2 = m2;

		if (!n) {
				return 0;
		}

		while ((--n > 0) && (*c1 == *c2)) {
				c1++;
				c2++;
		}

		return *c1 - *c2;
}

RTMK_DATA unsigned long stmpF;
RTMK_DATA unsigned long i;
RTMK_CODE
void write_number(unsigned long stmp) {
		stmpF += stmp; 
		i++;
		if (i == 4) while(1);
}

#define CURRENT     ((volatile unsigned int *)0xE000E018) 
RTMK_CODE unsigned long long curr_stamp(){
		unsigned long stmp = 0;
#ifdef FREERTOS
		//  __asm volatile ("cpsid i");
		unsigned long add = (0x4e1f - *CURRENT);
		unsigned long tick = xTaskGetTickCount();
		unsigned long stmp = ((tick * 0x4e1f) + add);
		//  __asm volatile ("cpsie i");
#endif 
		return stmp;
}



int switch_view(int to, int push) {
		return 0;
}
/* 
   typedef struct {
   int start;
   int size;
   int dstart;
   int dsize;
   } SEC_INFO; */
