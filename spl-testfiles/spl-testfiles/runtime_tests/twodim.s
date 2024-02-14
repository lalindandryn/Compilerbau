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
	sub	$29,$29,120		; allocate frame
	stw	$25,$29,8		; save old frame pointer
	add	$25,$29,120		; setup new frame pointer
	stw	$31,$25,-116		; save return register
	add	$8,$25,-104
	add	$9,$0,0
	stw	$9,$8,0
L0:
	add	$8,$25,-104
	ldw	$8,$8,0
	add	$9,$0,5
	bge	$8,$9,L1
	add	$8,$25,-108
	add	$9,$0,0
	stw	$9,$8,0
L2:
	add	$8,$25,-108
	ldw	$8,$8,0
	add	$9,$0,5
	bge	$8,$9,L3
	add	$8,$25,-104
	ldw	$8,$8,0
	add	$9,$25,-108
	ldw	$9,$9,0
	bne	$8,$9,L4
	add	$8,$25,-100
	add	$9,$25,-104
	ldw	$9,$9,0
	add	$10,$0,5
	bgeu	$9,$10,_indexError
	mul	$9,$9,20
	add	$8,$8,$9
	add	$9,$25,-108
	ldw	$9,$9,0
	add	$10,$0,5
	bgeu	$9,$10,_indexError
	mul	$9,$9,4
	add	$8,$8,$9
	add	$9,$0,1
	stw	$9,$8,0
	j	L5
L4:
	add	$8,$25,-100
	add	$9,$25,-104
	ldw	$9,$9,0
	add	$10,$0,5
	bgeu	$9,$10,_indexError
	mul	$9,$9,20
	add	$8,$8,$9
	add	$9,$25,-108
	ldw	$9,$9,0
	add	$10,$0,5
	bgeu	$9,$10,_indexError
	mul	$9,$9,4
	add	$8,$8,$9
	add	$9,$0,0
	stw	$9,$8,0
L5:
	add	$8,$25,-108
	add	$9,$25,-108
	ldw	$9,$9,0
	add	$10,$0,1
	add	$9,$9,$10
	stw	$9,$8,0
	j	L2
L3:
	add	$8,$25,-104
	add	$9,$25,-104
	ldw	$9,$9,0
	add	$10,$0,1
	add	$9,$9,$10
	stw	$9,$8,0
	j	L0
L1:
	add	$8,$25,-104
	add	$9,$0,0
	stw	$9,$8,0
L6:
	add	$8,$25,-104
	ldw	$8,$8,0
	add	$9,$0,5
	bge	$8,$9,L7
	add	$8,$25,-108
	add	$9,$0,0
	stw	$9,$8,0
L8:
	add	$8,$25,-108
	ldw	$8,$8,0
	add	$9,$0,5
	bge	$8,$9,L9
	add	$8,$25,-100
	add	$9,$25,-104
	ldw	$9,$9,0
	add	$10,$0,5
	bgeu	$9,$10,_indexError
	mul	$9,$9,20
	add	$8,$8,$9
	add	$9,$25,-108
	ldw	$9,$9,0
	add	$10,$0,5
	bgeu	$9,$10,_indexError
	mul	$9,$9,4
	add	$8,$8,$9
	ldw	$8,$8,0
	stw	$8,$29,0		; store argument #0
	jal	printi
	add	$8,$25,-108
	add	$9,$25,-108
	ldw	$9,$9,0
	add	$10,$0,1
	add	$9,$9,$10
	stw	$9,$8,0
	j	L8
L9:
	add	$8,$0,10
	stw	$8,$29,0		; store argument #0
	jal	printc
	add	$8,$25,-104
	add	$9,$25,-104
	ldw	$9,$9,0
	add	$10,$0,1
	add	$9,$9,$10
	stw	$9,$8,0
	j	L6
L7:
	ldw	$31,$25,-116		; restore return register
	ldw	$25,$29,8		; restore old frame pointer
	add	$29,$29,120		; release frame
	jr	$31			; return
