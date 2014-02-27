	.section	__TEXT,__text,regular,pure_instructions
	.globl	_ring_size
	.align	4, 0x90
_ring_size:                             ## @ring_size
	.cfi_startproc
## BB#0:
	pushq	%rbp
Ltmp2:
	.cfi_def_cfa_offset 16
Ltmp3:
	.cfi_offset %rbp, -16
	movq	%rsp, %rbp
Ltmp4:
	.cfi_def_cfa_register %rbp
	movl	$262144, %eax           ## imm = 0x40000
	popq	%rbp
	ret
	.cfi_endproc

	.globl	_ring_detach
	.align	4, 0x90
_ring_detach:                           ## @ring_detach
	.cfi_startproc
## BB#0:
	pushq	%rbp
Ltmp7:
	.cfi_def_cfa_offset 16
Ltmp8:
	.cfi_offset %rbp, -16
	movq	%rsp, %rbp
Ltmp9:
	.cfi_def_cfa_register %rbp
	xorl	%eax, %eax
	popq	%rbp
	ret
	.cfi_endproc

	.globl	_ring_write_reserve
	.align	4, 0x90
_ring_write_reserve:                    ## @ring_write_reserve
	.cfi_startproc
## BB#0:
	pushq	%rbp
Ltmp12:
	.cfi_def_cfa_offset 16
Ltmp13:
	.cfi_offset %rbp, -16
	movq	%rsp, %rbp
Ltmp14:
	.cfi_def_cfa_register %rbp
	movq	8(%rdi), %rcx
	movslq	262156(%rcx), %rdi
	movzwl	%di, %r8d
	movl	$65536, %eax            ## imm = 0x10000
	movl	$65536, %edx            ## imm = 0x10000
	subl	%r8d, %edx
	andl	$-4, %esi
	cmpl	%edx, %esi
	cmovgl	%edx, %esi
	subl	%edi, %eax
	leaq	(%rcx,%rdi,4), %rdx
	subl	262144(%rcx), %eax
	cmpl	%eax, %esi
	cmovlel	%esi, %eax
	leal	(%rax,%rdi), %esi
	movl	%esi, 262156(%rcx)
	shll	$2, %eax
	popq	%rbp
	ret
	.cfi_endproc

	.globl	_ring_write_notify
	.align	4, 0x90
_ring_write_notify:                     ## @ring_write_notify
	.cfi_startproc
## BB#0:
	pushq	%rbp
Ltmp17:
	.cfi_def_cfa_offset 16
Ltmp18:
	.cfi_offset %rbp, -16
	movq	%rsp, %rbp
Ltmp19:
	.cfi_def_cfa_register %rbp
	movq	8(%rdi), %rax
	sarl	$2, %esi
	addl	%esi, 262152(%rax)
	popq	%rbp
	ret
	.cfi_endproc

	.globl	_ring_read_reserve
	.align	4, 0x90
_ring_read_reserve:                     ## @ring_read_reserve
	.cfi_startproc
## BB#0:
	pushq	%rbp
Ltmp22:
	.cfi_def_cfa_offset 16
Ltmp23:
	.cfi_offset %rbp, -16
	movq	%rsp, %rbp
Ltmp24:
	.cfi_def_cfa_register %rbp
	movq	8(%rdi), %rcx
	movslq	262148(%rcx), %rdi
	movzwl	%di, %edx
	movl	$65536, %eax            ## imm = 0x10000
	subl	%edx, %eax
	andl	$-4, %esi
	cmpl	%eax, %esi
	cmovgl	%eax, %esi
	movl	262152(%rcx), %eax
	leaq	(%rcx,%rdi,4), %rdx
	subl	%edi, %eax
	cmpl	%eax, %esi
	cmovlel	%esi, %eax
	leal	(%rax,%rdi), %esi
	movl	%esi, 262148(%rcx)
	shll	$2, %eax
	popq	%rbp
	ret
	.cfi_endproc

	.globl	_ring_read_notify
	.align	4, 0x90
_ring_read_notify:                      ## @ring_read_notify
	.cfi_startproc
## BB#0:
	pushq	%rbp
Ltmp27:
	.cfi_def_cfa_offset 16
Ltmp28:
	.cfi_offset %rbp, -16
	movq	%rsp, %rbp
Ltmp29:
	.cfi_def_cfa_register %rbp
	movq	8(%rdi), %rax
	sarl	$2, %esi
	addl	%esi, 262144(%rax)
	popq	%rbp
	ret
	.cfi_endproc

	.globl	_ring_write
	.align	4, 0x90
_ring_write:                            ## @ring_write
	.cfi_startproc
## BB#0:
	pushq	%rbp
Ltmp32:
	.cfi_def_cfa_offset 16
Ltmp33:
	.cfi_offset %rbp, -16
	movq	%rsp, %rbp
Ltmp34:
	.cfi_def_cfa_register %rbp
	popq	%rbp
	ret
	.cfi_endproc

	.globl	_ring_read
	.align	4, 0x90
_ring_read:                             ## @ring_read
	.cfi_startproc
## BB#0:
	pushq	%rbp
Ltmp37:
	.cfi_def_cfa_offset 16
Ltmp38:
	.cfi_offset %rbp, -16
	movq	%rsp, %rbp
Ltmp39:
	.cfi_def_cfa_register %rbp
	popq	%rbp
	ret
	.cfi_endproc


.subsections_via_symbols
