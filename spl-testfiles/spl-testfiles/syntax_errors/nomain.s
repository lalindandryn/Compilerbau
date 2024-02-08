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
	sub	$29,$29,32		; allocate frame
	stw	$25,$29,16		; save old frame pointer
	add	$25,$29,32		; setup new frame pointer
	stw	$31,$25,-20		; save return register
	add	$8,$25,-4
	add	$9,$0,1
	stw	$9,$8,0
	add	$8,$25,-8
	add	$9,$0,2
	stw	$9,$8,0
	add	$8,$25,-4
	ldw	$8,$8,0
	stw	$8,$29,0		; store argument #0
	add	$8,$25,-8
	ldw	$8,$8,0
	stw	$8,$29,4		; store argument #1
	add	$8,$25,-12
	stw	$8,$29,8		; store argument #2
	jal	test
	ldw	$31,$25,-20		; restore return register
	ldw	$25,$29,16		; restore old frame pointer
	add	$29,$29,32		; release frame
	jr	$31			; return
