.global start
.extern kernel_main

.set CPUID_MASK, 1 << 21
.set MULTIBOOT_MAGIC, 0x36d76289

.section .text
start:
	movl $stack_top, %esp
	call check_a20
	call check_pe
	call kernel_main
	hlt

check_a20:
    movl $0x112345, %edi
    movl $0x012345, %esi
    movl %esi, (%esi)
    movl %edi, (%edi)
    cmpsd
    je .no_a20
    ret
.no_a20:
    movl 'A', %eax
	jmp error

check_pe:
	movl %cr0, %eax
	test $1, %eax
	jz .no_pe
	ret
.no_pe:
	movl 'P', %eax
	jmp error

error:
	movl $0x4f524f45, 0xb8000
	movl $0x4f3a4f52, 0xb8004
	movl $0x4f204f20, 0xb8008
	mov %al, 0xb800a
	hlt

.section .bss
.align 16
stack_bottom:
	.skip 16384
stack_top:
