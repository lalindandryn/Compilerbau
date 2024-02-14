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

	.export	main
main:
	sub	$29,$29,148		; allocate frame
	stw	$25,$29,8		; save old frame pointer
	add	$25,$29,148		; setup new frame pointer
	stw	$31,$25,-144		; save return register
	add	$8,$25,-132
	add	$9,$0,123456789
	stw	$9,$8,0
	add	$8,$25,-136
	add	$9,$0,0
	stw	$9,$8,0
L0:
	add	$8,$25,-136
	ldw	$8,$8,0
	add	$9,$0,32
	bge	$8,$9,L1
	add	$8,$25,-128
	add	$9,$25,-136
	ldw	$9,$9,0
	add	$10,$0,32
	bgeu	$9,$10,_indexError
	mul	$9,$9,4
	add	$8,$8,$9
	add	$9,$25,-132
	ldw	$9,$9,0
	add	$10,$25,-132
	ldw	$10,$10,0
	add	$11,$0,2
	div	$10,$10,$11
	add	$11,$0,2
	mul	$10,$10,$11
	sub	$9,$9,$10
	stw	$9,$8,0
	add	$8,$25,-132
	add	$9,$25,-132
	ldw	$9,$9,0
	add	$10,$0,2
	div	$9,$9,$10
	stw	$9,$8,0
	add	$8,$25,-136
	add	$9,$25,-136
	ldw	$9,$9,0
	add	$10,$0,1
	add	$9,$9,$10
	stw	$9,$8,0
	j	L0
L1:
	add	$8,$25,-136
	add	$9,$0,31
	stw	$9,$8,0
L2:
	add	$8,$25,-136
	ldw	$8,$8,0
	add	$9,$0,0
	blt	$8,$9,L3
	add	$8,$25,-128
	add	$9,$25,-136
	ldw	$9,$9,0
	add	$10,$0,32
	bgeu	$9,$10,_indexError
	mul	$9,$9,4
	add	$8,$8,$9
	ldw	$8,$8,0
	stw	$8,$29,0		; store argument #0
	jal	printi
	add	$8,$25,-136
	add	$9,$25,-136
	ldw	$9,$9,0
	add	$10,$0,1
	sub	$9,$9,$10
	stw	$9,$8,0
	add	$8,$25,-136
	ldw	$8,$8,0
	add	$9,$25,-136
	ldw	$9,$9,0
	add	$10,$0,4
	div	$9,$9,$10
	add	$10,$0,4
	mul	$9,$9,$10
	sub	$8,$8,$9
	add	$9,$0,3
	bne	$8,$9,L4
	add	$8,$0,32
	stw	$8,$29,0		; store argument #0
	jal	printc
L4:
	j	L2
L3:
	add	$8,$0,10
	stw	$8,$29,0		; store argument #0
	jal	printc
	ldw	$31,$25,-144		; restore return register
	ldw	$25,$29,8		; restore old frame pointer
	add	$29,$29,148		; release frame
	jr	$31			; return
