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
	sub	$29,$29,16		; allocate frame
	stw	$25,$29,4		; save old frame pointer
	add	$25,$29,16		; setup new frame pointer
	stw	$31,$25,-16		; save return register
	add	$8,$25,-8
	add	$9,$0,1
	add	$10,$0,2
	bgeu	$9,$10,_indexError
	mul	$9,$9,4
	add	$8,$8,$9
	add	$9,$0,1
	stw	$9,$8,0
	ldw	$31,$25,-16		; restore return register
	ldw	$25,$29,4		; restore old frame pointer
	add	$29,$29,16		; release frame
	jr	$31			; return
