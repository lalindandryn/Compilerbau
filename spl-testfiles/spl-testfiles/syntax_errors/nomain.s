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

	.export	test
test:
	sub	$29,$29,8		; allocate frame
	stw	$25,$29,4		; save old frame pointer
	add	$25,$29,8		; setup new frame pointer
	stw	$31,$25,-8		; save return register
	add	$8,$25,8
	ldw	$8,$8,0
	add	$9,$25,0
	ldw	$9,$9,0
	add	$10,$25,4
	ldw	$10,$10,0
	add	$9,$9,$10
	stw	$9,$8,0
	ldw	$31,$25,-8		; restore return register
	ldw	$25,$29,4		; restore old frame pointer
	add	$29,$29,8		; release frame
	jr	$31			; return

	.export	main
main:
	sub	$29,$29,36		; allocate frame
	stw	$25,$29,4		; save old frame pointer
	add	$25,$29,36		; setup new frame pointer
	stw	$31,$25,-36		; save return register
	add	$8,$25,-4
	add	$9,$0,1
	stw	$9,$8,0
	add	$8,$25,-28
	add	$9,$25,-4
	ldw	$9,$9,0
	add	$10,$0,3
	bgeu	$9,$10,_indexError
	mul	$9,$9,8
	add	$8,$8,$9
	add	$9,$25,-4
	ldw	$9,$9,0
	add	$10,$0,2
	bgeu	$9,$10,_indexError
	mul	$9,$9,4
	add	$8,$8,$9
	add	$9,$0,2
	stw	$9,$8,0
	ldw	$31,$25,-36		; restore return register
	ldw	$25,$29,4		; restore old frame pointer
	add	$29,$29,36		; release frame
	jr	$31			; return
