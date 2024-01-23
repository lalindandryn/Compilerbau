;
; print.s -- output functions
;

	.set	trmBase,0xF0300000	; terminal base address

	.export	_prints
	.export	printc
	.export	printi
	.export	_xmtempty

	.code
	.align	4

	; printi(i: int)
printi:
	sub	$29,$29,16
	stw	$25,$29,8
	add	$25,$29,16
	stw	$31,$25,-12
	add	$8,$25,0
	ldw	$8,$8,0
	add	$9,$0,0
	bge	$8,$9,printi1
	add	$8,$0,45
	stw	$8,$29,0
	jal	printc
	add	$8,$25,0
	add	$9,$0,0
	add	$10,$25,0
	ldw	$10,$10,0
	sub	$9,$9,$10
	stw	$9,$8,0
printi1:
	add	$8,$25,-4
	add	$9,$25,0
	ldw	$9,$9,0
	add	$10,$0,10
	div	$9,$9,$10
	stw	$9,$8,0
	add	$8,$25,-4
	ldw	$8,$8,0
	add	$9,$0,0
	beq	$8,$9,printi2
	add	$8,$25,-4
	ldw	$8,$8,0
	stw	$8,$29,0
	jal	printi
printi2:
	add	$8,$25,0
	ldw	$8,$8,0
	add	$9,$25,-4
	ldw	$9,$9,0
	add	$10,$0,10
	mul	$9,$9,$10
	sub	$8,$8,$9
	add	$9,$0,48
	add	$8,$8,$9
	stw	$8,$29,0
	jal	printc
	ldw	$31,$25,-12
	ldw	$25,$29,8
	add	$29,$29,16
	jr	$31

	; printc(i: int)
printc:
	add	$8,$0,trmBase		; set terminal base address
	ldw	$10,$29,0		; get char
	add	$9,$0,0x0A		; line feed?
	bne	$10,$9,printc1		; no - output as is
printc0:				; else output cr first
	ldw	$9,$8,8			; get status
	and	$9,$9,1			; xmtr ready?
	beq	$9,$0,printc0		; no - wait
	add	$10,$0,0x0D
	stw	$10,$8,12		; send char
printc1:
	ldw	$9,$8,8			; get status
	and	$9,$9,1			; xmtr ready?
	beq	$9,$0,printc1		; no - wait
	ldw	$10,$29,0		; get char
	stw	$10,$8,12		; send char
	jr	$31			; return

_prints:
	sub	$29,$29,16
	stw	$25,$29,8
	add	$25,$29,16
	stw	$31,$25,-12
	ldw	$8,$25,0
	stw	$8,$25,-4
prints1:
	ldw	$8,$25,-4
	ldbu	$9,$8,0
	beq	$9,$0,prints2
	add	$8,$8,1
	stw	$8,$25,-4
	stw	$9,$29,0
	jal	printc
	j	prints1
prints2:
	ldw	$31,$25,-12
	ldw	$25,$29,8
	add	$29,$29,16
	jr	$31

_xmtempty:
	add	$2,$0,trmBase
	ldw	$2,$2,8
	and	$2,$2,1
	jr	$31
