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
	sub	$29,$29,28		; allocate frame
	stw	$25,$29,24		; save old frame pointer
	add	$25,$29,28		; setup new frame pointer
	stw	$31,$25,-8		; save return register
	add	$8,$0,0
	stw	$8,$29,0		; store argument #0
	jal	clearAll
	add	$8,$0,0
	stw	$8,$29,0		; store argument #0
	add	$8,$0,0
	stw	$8,$29,4		; store argument #1
	add	$8,$0,639
	stw	$8,$29,8		; store argument #2
	add	$8,$0,479
	stw	$8,$29,12		; store argument #3
	add	$8,$0,16711935
	stw	$8,$29,16		; store argument #4
	jal	drawLine
	add	$8,$0,0
	stw	$8,$29,0		; store argument #0
	add	$8,$0,479
	stw	$8,$29,4		; store argument #1
	add	$8,$0,639
	stw	$8,$29,8		; store argument #2
	add	$8,$0,0
	stw	$8,$29,12		; store argument #3
	add	$8,$0,16776960
	stw	$8,$29,16		; store argument #4
	jal	drawLine
	add	$8,$0,320
	stw	$8,$29,0		; store argument #0
	add	$8,$0,240
	stw	$8,$29,4		; store argument #1
	add	$8,$0,40
	stw	$8,$29,8		; store argument #2
	add	$8,$0,65535
	stw	$8,$29,12		; store argument #3
	jal	drawCircle
	add	$8,$0,320
	stw	$8,$29,0		; store argument #0
	add	$8,$0,240
	stw	$8,$29,4		; store argument #1
	add	$8,$0,80
	stw	$8,$29,8		; store argument #2
	add	$8,$0,16711680
	stw	$8,$29,12		; store argument #3
	jal	drawCircle
	add	$8,$0,320
	stw	$8,$29,0		; store argument #0
	add	$8,$0,240
	stw	$8,$29,4		; store argument #1
	add	$8,$0,120
	stw	$8,$29,8		; store argument #2
	add	$8,$0,65280
	stw	$8,$29,12		; store argument #3
	jal	drawCircle
	add	$8,$0,320
	stw	$8,$29,0		; store argument #0
	add	$8,$0,240
	stw	$8,$29,4		; store argument #1
	add	$8,$0,160
	stw	$8,$29,8		; store argument #2
	add	$8,$0,16777215
	stw	$8,$29,12		; store argument #3
	jal	drawCircle
	add	$8,$0,320
	stw	$8,$29,0		; store argument #0
	add	$8,$0,240
	stw	$8,$29,4		; store argument #1
	add	$8,$0,200
	stw	$8,$29,8		; store argument #2
	add	$8,$0,255
	stw	$8,$29,12		; store argument #3
	jal	drawCircle
	ldw	$31,$25,-8		; restore return register
	ldw	$25,$29,24		; restore old frame pointer
	add	$29,$29,28		; release frame
	jr	$31			; return
