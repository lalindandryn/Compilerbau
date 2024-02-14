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
	sub	$29,$29,20		; allocate frame
	stw	$25,$29,8		; save old frame pointer
	add	$25,$29,20		; setup new frame pointer
	stw	$31,$25,-16		; save return register
	add	$8,$25,-4
	add	$9,$0,3
	stw	$9,$8,0
	add	$8,$25,-8
	add	$9,$0,5
	stw	$9,$8,0
	add	$8,$25,-4
	ldw	$8,$8,0
	add	$9,$25,-8
	ldw	$9,$9,0
	add	$8,$8,$9
	stw	$8,$29,0		; store argument #0
	jal	printi
	add	$8,$0,10
	stw	$8,$29,0		; store argument #0
	jal	printc
	ldw	$31,$25,-16		; restore return register
	ldw	$25,$29,8		; restore old frame pointer
	add	$29,$29,20		; release frame
	jr	$31			; return
