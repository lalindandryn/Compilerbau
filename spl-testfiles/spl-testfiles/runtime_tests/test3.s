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

	.export	sort
sort:
	sub	$29,$29,20		; allocate frame
	stw	$25,$29,4		; save old frame pointer
	add	$25,$29,20		; setup new frame pointer
	stw	$31,$25,-20		; save return register
	add	$8,$25,-4
	add	$9,$0,9
	stw	$9,$8,0
L0:
	add	$8,$25,-4
	ldw	$8,$8,0
	add	$9,$0,0
	blt	$8,$9,L1
	add	$8,$25,-8
	add	$9,$0,1
	stw	$9,$8,0
L2:
	add	$8,$25,-8
	ldw	$8,$8,0
	add	$9,$25,-4
	ldw	$9,$9,0
	bgt	$8,$9,L3
	add	$8,$25,0
	ldw	$8,$8,0
	add	$9,$25,-8
	ldw	$9,$9,0
	add	$10,$0,1
	sub	$9,$9,$10
	add	$10,$0,10
	bgeu	$9,$10,_indexError
	mul	$9,$9,4
	add	$8,$8,$9
	ldw	$8,$8,0
	add	$9,$25,0
	ldw	$9,$9,0
	add	$10,$25,-8
	ldw	$10,$10,0
	add	$11,$0,10
	bgeu	$10,$11,_indexError
	mul	$10,$10,4
	add	$9,$9,$10
	ldw	$9,$9,0
	ble	$8,$9,L4
	add	$8,$25,-12
	add	$9,$25,0
	ldw	$9,$9,0
	add	$10,$25,-8
	ldw	$10,$10,0
	add	$11,$0,1
	sub	$10,$10,$11
	add	$11,$0,10
	bgeu	$10,$11,_indexError
	mul	$10,$10,4
	add	$9,$9,$10
	ldw	$9,$9,0
	stw	$9,$8,0
	add	$8,$25,0
	ldw	$8,$8,0
	add	$9,$25,-8
	ldw	$9,$9,0
	add	$10,$0,1
	sub	$9,$9,$10
	add	$10,$0,10
	bgeu	$9,$10,_indexError
	mul	$9,$9,4
	add	$8,$8,$9
	add	$9,$25,0
	ldw	$9,$9,0
	add	$10,$25,-8
	ldw	$10,$10,0
	add	$11,$0,10
	bgeu	$10,$11,_indexError
	mul	$10,$10,4
	add	$9,$9,$10
	ldw	$9,$9,0
	stw	$9,$8,0
	add	$8,$25,0
	ldw	$8,$8,0
	add	$9,$25,-8
	ldw	$9,$9,0
	add	$10,$0,10
	bgeu	$9,$10,_indexError
	mul	$9,$9,4
	add	$8,$8,$9
	add	$9,$25,-12
	ldw	$9,$9,0
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
	sub	$9,$9,$10
	stw	$9,$8,0
	j	L0
L1:
	ldw	$31,$25,-20		; restore return register
	ldw	$25,$29,4		; restore old frame pointer
	add	$29,$29,20		; release frame
	jr	$31			; return

	.export	main
main:
	sub	$29,$29,56		; allocate frame
	stw	$25,$29,8		; save old frame pointer
	add	$25,$29,56		; setup new frame pointer
	stw	$31,$25,-52		; save return register
	add	$8,$25,-44
	add	$9,$0,0
	stw	$9,$8,0
	add	$8,$25,-40
	add	$9,$25,-44
	ldw	$9,$9,0
	add	$10,$0,10
	bgeu	$9,$10,_indexError
	mul	$9,$9,4
	add	$8,$8,$9
	add	$9,$0,0
	stw	$9,$8,0
	add	$8,$25,-44
	add	$9,$25,-44
	ldw	$9,$9,0
	add	$10,$0,1
	add	$9,$9,$10
	stw	$9,$8,0
	add	$8,$25,-40
	add	$9,$25,-44
	ldw	$9,$9,0
	add	$10,$0,10
	bgeu	$9,$10,_indexError
	mul	$9,$9,4
	add	$8,$8,$9
	add	$9,$0,2
	stw	$9,$8,0
	add	$8,$25,-44
	add	$9,$25,-44
	ldw	$9,$9,0
	add	$10,$0,1
	add	$9,$9,$10
	stw	$9,$8,0
	add	$8,$25,-40
	add	$9,$25,-44
	ldw	$9,$9,0
	add	$10,$0,10
	bgeu	$9,$10,_indexError
	mul	$9,$9,4
	add	$8,$8,$9
	add	$9,$0,4
	stw	$9,$8,0
	add	$8,$25,-44
	add	$9,$25,-44
	ldw	$9,$9,0
	add	$10,$0,1
	add	$9,$9,$10
	stw	$9,$8,0
	add	$8,$25,-40
	add	$9,$25,-44
	ldw	$9,$9,0
	add	$10,$0,10
	bgeu	$9,$10,_indexError
	mul	$9,$9,4
	add	$8,$8,$9
	add	$9,$0,6
	stw	$9,$8,0
	add	$8,$25,-44
	add	$9,$25,-44
	ldw	$9,$9,0
	add	$10,$0,1
	add	$9,$9,$10
	stw	$9,$8,0
	add	$8,$25,-40
	add	$9,$25,-44
	ldw	$9,$9,0
	add	$10,$0,10
	bgeu	$9,$10,_indexError
	mul	$9,$9,4
	add	$8,$8,$9
	add	$9,$0,8
	stw	$9,$8,0
	add	$8,$25,-44
	add	$9,$25,-44
	ldw	$9,$9,0
	add	$10,$0,1
	add	$9,$9,$10
	stw	$9,$8,0
	add	$8,$25,-40
	add	$9,$25,-44
	ldw	$9,$9,0
	add	$10,$0,10
	bgeu	$9,$10,_indexError
	mul	$9,$9,4
	add	$8,$8,$9
	add	$9,$0,9
	stw	$9,$8,0
	add	$8,$25,-44
	add	$9,$25,-44
	ldw	$9,$9,0
	add	$10,$0,1
	add	$9,$9,$10
	stw	$9,$8,0
	add	$8,$25,-40
	add	$9,$25,-44
	ldw	$9,$9,0
	add	$10,$0,10
	bgeu	$9,$10,_indexError
	mul	$9,$9,4
	add	$8,$8,$9
	add	$9,$0,7
	stw	$9,$8,0
	add	$8,$25,-44
	add	$9,$25,-44
	ldw	$9,$9,0
	add	$10,$0,1
	add	$9,$9,$10
	stw	$9,$8,0
	add	$8,$25,-40
	add	$9,$25,-44
	ldw	$9,$9,0
	add	$10,$0,10
	bgeu	$9,$10,_indexError
	mul	$9,$9,4
	add	$8,$8,$9
	add	$9,$0,5
	stw	$9,$8,0
	add	$8,$25,-44
	add	$9,$25,-44
	ldw	$9,$9,0
	add	$10,$0,1
	add	$9,$9,$10
	stw	$9,$8,0
	add	$8,$25,-40
	add	$9,$25,-44
	ldw	$9,$9,0
	add	$10,$0,10
	bgeu	$9,$10,_indexError
	mul	$9,$9,4
	add	$8,$8,$9
	add	$9,$0,3
	stw	$9,$8,0
	add	$8,$25,-44
	add	$9,$25,-44
	ldw	$9,$9,0
	add	$10,$0,1
	add	$9,$9,$10
	stw	$9,$8,0
	add	$8,$25,-40
	add	$9,$25,-44
	ldw	$9,$9,0
	add	$10,$0,10
	bgeu	$9,$10,_indexError
	mul	$9,$9,4
	add	$8,$8,$9
	add	$9,$0,1
	stw	$9,$8,0
	add	$8,$25,-44
	add	$9,$25,-44
	ldw	$9,$9,0
	add	$10,$0,1
	add	$9,$9,$10
	stw	$9,$8,0
	add	$8,$25,-40
	stw	$8,$29,0		; store argument #0
	jal	sort
	add	$8,$25,-44
	add	$9,$0,0
	stw	$9,$8,0
L5:
	add	$8,$25,-44
	ldw	$8,$8,0
	add	$9,$0,10
	bge	$8,$9,L6
	add	$8,$25,-40
	add	$9,$25,-44
	ldw	$9,$9,0
	add	$10,$0,10
	bgeu	$9,$10,_indexError
	mul	$9,$9,4
	add	$8,$8,$9
	ldw	$8,$8,0
	stw	$8,$29,0		; store argument #0
	jal	printi
	add	$8,$0,10
	stw	$8,$29,0		; store argument #0
	jal	printc
	add	$8,$25,-44
	add	$9,$25,-44
	ldw	$9,$9,0
	add	$10,$0,1
	add	$9,$9,$10
	stw	$9,$8,0
	j	L5
L6:
	ldw	$31,$25,-52		; restore return register
	ldw	$25,$29,8		; restore old frame pointer
	add	$29,$29,56		; release frame
	jr	$31			; return
