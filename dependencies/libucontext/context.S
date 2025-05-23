/*
 * Copyright (c) 2018 Ariadne Conill <nenolod@dereferenced.org>
 *
 * Permission to use, copy, modify, and/or distribute this software for any
 * purpose with or without fee is hereby granted, provided that the above
 * copyright notice and this permission notice appear in all copies.
 *
 * This software is provided 'as is' and without any warranty, express or
 * implied.  In no event shall the authors be liable for any damages arising
 * from the use of this software.
 */

#include "defs.h"

.align 4

.globl ___getcontext1;
___getcontext1:
	str	xzr, [x0, #R0_OFFSET + (0 * REGSZ)]

	/* save GPRs */
	stp	x0, x1,   [x0, #R0_OFFSET + (0 * REGSZ)]
	stp	x2, x3,   [x0, #R0_OFFSET + (2 * REGSZ)]
	stp	x4, x5,   [x0, #R0_OFFSET + (4 * REGSZ)]
	stp	x6, x7,   [x0, #R0_OFFSET + (6 * REGSZ)]
	stp	x8, x9,   [x0, #R0_OFFSET + (8 * REGSZ)]
	stp	x10, x11, [x0, #R0_OFFSET + (10 * REGSZ)]
	stp	x12, x13, [x0, #R0_OFFSET + (12 * REGSZ)]
	stp	x14, x15, [x0, #R0_OFFSET + (14 * REGSZ)]
	stp	x16, x17, [x0, #R0_OFFSET + (16 * REGSZ)]
	stp	x18, x19, [x0, #R0_OFFSET + (18 * REGSZ)]
	stp	x20, x21, [x0, #R0_OFFSET + (20 * REGSZ)]
	stp	x22, x23, [x0, #R0_OFFSET + (22 * REGSZ)]
	stp	x24, x25, [x0, #R0_OFFSET + (24 * REGSZ)]
	stp	x26, x27, [x0, #R0_OFFSET + (26 * REGSZ)]
	stp	x28, x29, [x0, #R0_OFFSET + (28 * REGSZ)]
	str	x30,      [x0, #R0_OFFSET + (30 * REGSZ)]

	/* save current program counter in link register */
	str	x30, [x0, #PC_OFFSET]

	/* save current stack pointer */
	mov	x2, sp
	str	x2, [x0, #SP_OFFSET]

	/* save pstate */
	str	xzr, [x0, #PSTATE_OFFSET]

	/* TODO: SIMD / FPRs */

	mov	x0, #0
	ret

#ifndef WEAK
.globl _getcontext1;
#else
.weak_definition _getcontext1;
#endif
_getcontext1 = ___getcontext1;


.globl ___setcontext1;
___setcontext1:
	/* restore GPRs */
	ldp	x18, x19, [x0, #R0_OFFSET + (18 * REGSZ)]
	ldp	x20, x21, [x0, #R0_OFFSET + (20 * REGSZ)]
	ldp	x22, x23, [x0, #R0_OFFSET + (22 * REGSZ)]
	ldp	x24, x25, [x0, #R0_OFFSET + (24 * REGSZ)]
	ldp	x26, x27, [x0, #R0_OFFSET + (26 * REGSZ)]
	ldp	x28, x29, [x0, #R0_OFFSET + (28 * REGSZ)]
	ldr	x30,      [x0, #R0_OFFSET + (30 * REGSZ)]

	/* save current stack pointer */
	ldr	x2, [x0, #SP_OFFSET]
	mov	sp, x2

	/* TODO: SIMD / FPRs */

	/* save current program counter in link register */
	ldr	x16, [x0, #PC_OFFSET]

	/* restore args */
	ldp	x2, x3, [x0, #R0_OFFSET + (2 * REGSZ)]
	ldp	x4, x5, [x0, #R0_OFFSET + (4 * REGSZ)]
	ldp	x6, x7, [x0, #R0_OFFSET + (6 * REGSZ)]
	ldp	x0, x1, [x0, #R0_OFFSET + (0 * REGSZ)]

	/* jump to new PC */
	br	x16


#ifndef WEAK 
.globl _setcontext1;
#else
.weak_definition _setcontext1;
#endif
_setcontext1 = ___setcontext1;


.globl ___start_context1;
___start_context1:
	/* get the proper context1 into position and test for NULL */
	mov	x0, x19
	cbnz	x0, _setcontext1

	/* something went wrong, exit */
	b	_exit


.globl ___swapcontext1;
___swapcontext1:
	str	xzr, [x0, #R0_OFFSET + (0 * REGSZ)]

	/* save GPRs */
	stp	x2, x3,   [x0, #R0_OFFSET + (2 * REGSZ)]
	stp	x4, x5,   [x0, #R0_OFFSET + (4 * REGSZ)]
	stp	x6, x7,   [x0, #R0_OFFSET + (6 * REGSZ)]
	stp	x8, x9,   [x0, #R0_OFFSET + (8 * REGSZ)]
	stp	x10, x11, [x0, #R0_OFFSET + (10 * REGSZ)]
	stp	x12, x13, [x0, #R0_OFFSET + (12 * REGSZ)]
	stp	x14, x15, [x0, #R0_OFFSET + (14 * REGSZ)]
	stp	x16, x17, [x0, #R0_OFFSET + (16 * REGSZ)]
	stp	x18, x19, [x0, #R0_OFFSET + (18 * REGSZ)]
	stp	x20, x21, [x0, #R0_OFFSET + (20 * REGSZ)]
	stp	x22, x23, [x0, #R0_OFFSET + (22 * REGSZ)]
	stp	x24, x25, [x0, #R0_OFFSET + (24 * REGSZ)]
	stp	x26, x27, [x0, #R0_OFFSET + (26 * REGSZ)]
	stp	x28, x29, [x0, #R0_OFFSET + (28 * REGSZ)]
	str	x30,      [x0, #R0_OFFSET + (30 * REGSZ)]

	/* save current program counter in link register */
	str	x30, [x0, #PC_OFFSET]

	/* save current stack pointer */
	mov	x2, sp
	str	x2, [x0, #SP_OFFSET]

	/* save pstate */
	str	xzr, [x0, #PSTATE_OFFSET]

	/* context1 to swap to is in x1 so... we move to x0 and call setcontext1 */
	/* store our link register in x28 */
	mov	x28, x30

	/* move x1 to x0 and call setcontext1 */
	mov	x0, x1
	bl	_setcontext1

	/* hmm, we came back here try to return */
	mov	x30, x28
	ret

#ifndef WEAK
.globl _swapcontext1;
#else
.weak_definition swapcontext1;
#endif
_swapcontext1 = ___swapcontext1;
