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

	.export	p
p:
	sub	$29,$29,16		; allocate frame
	stw	$25,$29,4		; save old frame pointer
	add	$25,$29,16		; setup new frame pointer
	stw	$31,$25,-16		; save return register
	add	$8,$25,-4
	add	$9,$0,0
	stw	$9,$8,0
L0:
	add	$8,$25,-4
	ldw	$8,$8,0
	add	$9,$0,5
	bge	$8,$9,L1
	add	$8,$25,-8
	add	$9,$0,0
	stw	$9,$8,0
L2:
	add	$8,$25,-8
	ldw	$8,$8,0
	add	$9,$0,7
	bge	$8,$9,L3
	add	$8,$25,-4
	ldw	$8,$8,0
	add	$9,$25,-8
	ldw	$9,$9,0
	bne	$8,$9,L4
	add	$8,$25,0
	ldw	$8,$8,0
	add	$9,$25,-4
	ldw	$9,$9,0
	add	$10,$0,5
	bgeu	$9,$10,_indexError
	mul	$9,$9,28
	add	$8,$8,$9
	add	$9,$25,-8
	ldw	$9,$9,0
	add	$10,$0,7
	bgeu	$9,$10,_indexError
	mul	$9,$9,4
	add	$8,$8,$9
	add	$9,$25,-4
	ldw	$9,$9,0
	add	$10,$25,-8
	ldw	$10,$10,0
	add	$9,$9,$10
	stw	$9,$8,0
L4:
	add	$8,$25,-8
	add	$9,$25,-8
	ldw	$9,$9,0
	add	$10,$0,1
	add	$9,$9,$10
	stw	$9,$8,0
	j	L2
L3:
	add	$8,$25,-4
	add	$9,$25,-4
	ldw	$9,$9,0
	add	$10,$0,1
	add	$9,$9,$10
	stw	$9,$8,0
	j	L0
L1:
	ldw	$31,$25,-16		; restore return register
	ldw	$25,$29,4		; restore old frame pointer
	add	$29,$29,16		; release frame
	jr	$31			; return

	.export	main
main:
	sub	$29,$29,444		; allocate frame
	stw	$25,$29,8		; save old frame pointer
	add	$25,$29,444		; setup new frame pointer
	stw	$31,$25,-440		; save return register
	add	$8,$25,-424
	add	$9,$0,0
	stw	$9,$8,0
L5:
	add	$8,$25,-424
	ldw	$8,$8,0
	add	$9,$0,3
	bge	$8,$9,L6
	add	$8,$25,-428
	add	$9,$0,0
	stw	$9,$8,0
L7:
	add	$8,$25,-428
	ldw	$8,$8,0
	add	$9,$0,5
	bge	$8,$9,L8
	add	$8,$25,-432
	add	$9,$0,0
	stw	$9,$8,0
L9:
	add	$8,$25,-432
	ldw	$8,$8,0
	add	$9,$0,7
	bge	$8,$9,L10
	add	$8,$25,-420
	add	$9,$25,-424
	ldw	$9,$9,0
	add	$10,$0,3
	bgeu	$9,$10,_indexError
	mul	$9,$9,140
	add	$8,$8,$9
	add	$9,$25,-428
	ldw	$9,$9,0
	add	$10,$0,5
	bgeu	$9,$10,_indexError
	mul	$9,$9,28
	add	$8,$8,$9
	add	$9,$25,-432
	ldw	$9,$9,0
	add	$10,$0,7
	bgeu	$9,$10,_indexError
	mul	$9,$9,4
	add	$8,$8,$9
	add	$9,$0,0
	stw	$9,$8,0
	add	$8,$25,-432
	add	$9,$25,-432
	ldw	$9,$9,0
	add	$10,$0,1
	add	$9,$9,$10
	stw	$9,$8,0
	j	L9
L10:
	add	$8,$25,-428
	add	$9,$25,-428
	ldw	$9,$9,0
	add	$10,$0,1
	add	$9,$9,$10
	stw	$9,$8,0
	j	L7
L8:
	add	$8,$25,-424
	add	$9,$25,-424
	ldw	$9,$9,0
	add	$10,$0,1
	add	$9,$9,$10
	stw	$9,$8,0
	j	L5
L6:
	add	$8,$25,-420
	add	$9,$0,1
	add	$10,$0,3
	bgeu	$9,$10,_indexError
	mul	$9,$9,140
	add	$8,$8,$9
	stw	$8,$29,0		; store argument #0
	jal	p
	add	$8,$25,-424
	add	$9,$0,0
	stw	$9,$8,0
L11:
	add	$8,$25,-424
	ldw	$8,$8,0
	add	$9,$0,3
	bge	$8,$9,L12
	add	$8,$25,-428
	add	$9,$0,0
	stw	$9,$8,0
L13:
	add	$8,$25,-428
	ldw	$8,$8,0
	add	$9,$0,5
	bge	$8,$9,L14
	add	$8,$25,-432
	add	$9,$0,0
	stw	$9,$8,0
L15:
	add	$8,$25,-432
	ldw	$8,$8,0
	add	$9,$0,7
	bge	$8,$9,L16
	add	$8,$25,-420
	add	$9,$25,-424
	ldw	$9,$9,0
	add	$10,$0,3
	bgeu	$9,$10,_indexError
	mul	$9,$9,140
	add	$8,$8,$9
	add	$9,$25,-428
	ldw	$9,$9,0
	add	$10,$0,5
	bgeu	$9,$10,_indexError
	mul	$9,$9,28
	add	$8,$8,$9
	add	$9,$25,-432
	ldw	$9,$9,0
	add	$10,$0,7
	bgeu	$9,$10,_indexError
	mul	$9,$9,4
	add	$8,$8,$9
	ldw	$8,$8,0
	stw	$8,$29,0		; store argument #0
	jal	printi
	add	$8,$0,32
	stw	$8,$29,0		; store argument #0
	jal	printc
	add	$8,$25,-432
	add	$9,$25,-432
	ldw	$9,$9,0
	add	$10,$0,1
	add	$9,$9,$10
	stw	$9,$8,0
	j	L15
L16:
	add	$8,$0,10
	stw	$8,$29,0		; store argument #0
	jal	printc
	add	$8,$25,-428
	add	$9,$25,-428
	ldw	$9,$9,0
	add	$10,$0,1
	add	$9,$9,$10
	stw	$9,$8,0
	j	L13
L14:
	add	$8,$0,10
	stw	$8,$29,0		; store argument #0
	jal	printc
	add	$8,$25,-424
	add	$9,$25,-424
	ldw	$9,$9,0
	add	$10,$0,1
	add	$9,$9,$10
	stw	$9,$8,0
	j	L11
L12:
	ldw	$31,$25,-440		; restore return register
	ldw	$25,$29,8		; restore old frame pointer
	add	$29,$29,444		; release frame
	jr	$31			; return
