	.import	printi
	.import	printc
	.import	readi
	.import	readc
	.import	exit
	.import	time
	.import	clearAll
	.import	setPixel
	.import	drawLine
	.import	drawCircle
	.import	_indexError

	.code
	.align	4

	.export	ackermann
ackermann:
	sub	$29,$29,24		; allocate frame
	stw	$25,$29,16		; save old frame pointer
	add	$25,$29,24		; setup new frame pointer
	stw	$31,$25,-12		; save return register
	add	$8,$25,0
	ldw	$8,$8,0
	add	$9,$0,0
	bne	$8,$9,L0
	add	$8,$25,8
	ldw	$8,$8,0
	add	$9,$25,4
	ldw	$9,$9,0
	add	$10,$0,1
	add	$9,$9,$10
	stw	$9,$8,0
	j	L1
L0:
	add	$8,$25,4
	ldw	$8,$8,0
	add	$9,$0,0
	bne	$8,$9,L2
	add	$8,$25,0
	ldw	$8,$8,0
	add	$9,$0,1
	sub	$8,$8,$9
	stw	$8,$29,0		; store argument #0
	add	$8,$0,1
	stw	$8,$29,4		; store argument #1
	add	$8,$25,8
	ldw	$8,$8,0
	stw	$8,$29,8		; store argument #2
	jal	ackermann
	j	L3
L2:
	add	$8,$25,0
	ldw	$8,$8,0
	stw	$8,$29,0		; store argument #0
	add	$8,$25,4
	ldw	$8,$8,0
	add	$9,$0,1
	sub	$8,$8,$9
	stw	$8,$29,4		; store argument #1
	add	$8,$25,-4
	stw	$8,$29,8		; store argument #2
	jal	ackermann
	add	$8,$25,0
	ldw	$8,$8,0
	add	$9,$0,1
	sub	$8,$8,$9
	stw	$8,$29,0		; store argument #0
	add	$8,$25,-4
	ldw	$8,$8,0
	stw	$8,$29,4		; store argument #1
	add	$8,$25,8
	ldw	$8,$8,0
	stw	$8,$29,8		; store argument #2
	jal	ackermann
L3:
L1:
	ldw	$31,$25,-12		; restore return register
	ldw	$25,$29,16		; restore old frame pointer
	add	$29,$29,24		; release frame
	jr	$31			; return

	.export	main
main:
	sub	$29,$29,32		; allocate frame
	stw	$25,$29,16		; save old frame pointer
	add	$25,$29,32		; setup new frame pointer
	stw	$31,$25,-20		; save return register
	add	$8,$25,-4
	add	$9,$0,0
	stw	$9,$8,0
L4:
	add	$8,$25,-4
	ldw	$8,$8,0
	add	$9,$0,3
	bgt	$8,$9,L5
	add	$8,$25,-8
	add	$9,$0,0
	stw	$9,$8,0
L6:
	add	$8,$25,-8
	ldw	$8,$8,0
	add	$9,$0,6
	bgt	$8,$9,L7
	add	$8,$25,-4
	ldw	$8,$8,0
	stw	$8,$29,0		; store argument #0
	add	$8,$25,-8
	ldw	$8,$8,0
	stw	$8,$29,4		; store argument #1
	add	$8,$25,-12
	stw	$8,$29,8		; store argument #2
	jal	ackermann
	add	$8,$25,-4
	ldw	$8,$8,0
	stw	$8,$29,0		; store argument #0
	jal	printi
	add	$8,$0,32
	stw	$8,$29,0		; store argument #0
	jal	printc
	add	$8,$25,-8
	ldw	$8,$8,0
	stw	$8,$29,0		; store argument #0
	jal	printi
	add	$8,$0,32
	stw	$8,$29,0		; store argument #0
	jal	printc
	add	$8,$25,-12
	ldw	$8,$8,0
	stw	$8,$29,0		; store argument #0
	jal	printi
	add	$8,$0,10
	stw	$8,$29,0		; store argument #0
	jal	printc
	add	$8,$25,-8
	add	$9,$25,-8
	ldw	$9,$9,0
	add	$10,$0,1
	add	$9,$9,$10
	stw	$9,$8,0
	j	L6
L7:
	add	$8,$25,-4
	add	$9,$25,-4
	ldw	$9,$9,0
	add	$10,$0,1
	add	$9,$9,$10
	stw	$9,$8,0
	j	L4
L5:
	ldw	$31,$25,-20		; restore return register
	ldw	$25,$29,16		; restore old frame pointer
	add	$29,$29,32		; release frame
	jr	$31			; return
