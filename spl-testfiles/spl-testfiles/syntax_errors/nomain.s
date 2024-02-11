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
	stw	$25,$29,4		; save old frame pointer
	add	$25,$29,20		; setup new frame pointer
	stw	$31,$25,-20		; save return register
	add	$8,$25,-4
	add	$9,$0,1
	stw	$9,$8,0
L0:
	add	$8,$25,-4
	ldw	$8,$8,0
	add	$9,$0,4
	beq	$8,$9,L1
	add	$8,$25,-12
	add	$9,$0,3
	stw	$9,$8,0
	add	$8,$25,-4
	add	$9,$25,-4
	ldw	$9,$9,0
	add	$10,$0,1
	add	$9,$9,$10
	stw	$9,$8,0
	j	L0
L1:
	ldw	$31,$25,-20		; restore return register
	ldw	$25,$29,4		; restore old frame pointer
	add	$29,$29,20		; release frame
	jr	$31			; return
