;
; read.s -- input functions
;

	.set	trmBase,0xF0300000	; terminal base address

	.export	readc
	.export	readi

	.import	printc

	.code
	.align	4

	; readc(ref i: int)
readc:
	add	$8,$0,trmBase		; set terminal base address
readc1:
	ldw	$9,$8,0			; get status
	and	$9,$9,1			; rcvr ready?
	beq	$9,$0,readc1		; no - wait
	ldw	$10,$8,4		; get char
	ldw	$11,$29,0		; get address
	stw	$10,$11,0		; store char
	jr	$31			; return

readLine:
	sub	$29,$29,20
	stw	$25,$29,8
	add	$25,$29,20
	stw	$31,$25,-16
	add	$8,$25,-4
	add	$9,$0,0
	stw	$9,$8,0
readLine0:
	add	$8,$25,-4
	ldw	$8,$8,0
	add	$9,$0,79
	bge	$8,$9,readLine1
	add	$8,$25,-8
	stw	$8,$29,0
	jal	readc
	add	$8,$25,-8
	ldw	$8,$8,0
	add	$9,$0,32
	blt	$8,$9,readLine2
	add	$8,$25,-8
	ldw	$8,$8,0
	stw	$8,$29,0
	jal	printc
	add	$8,$25,0
	ldw	$8,$8,0
	add	$9,$25,-4
	ldw	$9,$9,0
	mul	$9,$9,4
	add	$8,$8,$9
	add	$9,$25,-8
	ldw	$9,$9,0
	stw	$9,$8,0
	add	$8,$25,-4
	add	$9,$25,-4
	ldw	$9,$9,0
	add	$10,$0,1
	add	$9,$9,$10
	stw	$9,$8,0
	j	readLine3
readLine2:
	add	$8,$25,-8
	ldw	$8,$8,0
	add	$9,$0,13
	bne	$8,$9,readLine4
	add	$8,$25,-8
	ldw	$8,$8,0
	stw	$8,$29,0
	jal	printc
	add	$8,$0,10
	stw	$8,$29,0
	jal	printc
	add	$8,$25,0
	ldw	$8,$8,0
	add	$9,$25,-4
	ldw	$9,$9,0
	mul	$9,$9,4
	add	$8,$8,$9
	add	$9,$0,0
	stw	$9,$8,0
	add	$8,$25,-4
	add	$9,$0,79
	stw	$9,$8,0
	j	readLine5
readLine4:
	add	$8,$25,-8
	ldw	$8,$8,0
	add	$9,$0,8
	bne	$8,$9,readLine6
	add	$8,$25,-4
	ldw	$8,$8,0
	add	$9,$0,0
	ble	$8,$9,readLine7
	add	$8,$0,8
	stw	$8,$29,0
	jal	printc
	add	$8,$0,32
	stw	$8,$29,0
	jal	printc
	add	$8,$0,8
	stw	$8,$29,0
	jal	printc
	add	$8,$25,-4
	add	$9,$25,-4
	ldw	$9,$9,0
	add	$10,$0,1
	sub	$9,$9,$10
	stw	$9,$8,0
readLine7:
readLine6:
readLine5:
readLine3:
	j	readLine0
readLine1:
	add	$8,$25,0
	ldw	$8,$8,0
	add	$9,$0,79
	mul	$9,$9,4
	add	$8,$8,$9
	add	$9,$0,0
	stw	$9,$8,0
	ldw	$31,$25,-16
	ldw	$25,$29,8
	add	$29,$29,20
	jr	$31

readInt:
	sub	$29,$29,20
	stw	$25,$29,8
	add	$25,$29,20
	stw	$31,$25,-16
	add	$8,$25,-4
	add	$9,$0,1
	stw	$9,$8,0
readInt8:
	add	$8,$25,-4
	ldw	$8,$8,0
	add	$9,$0,1
	bne	$8,$9,readInt9
readInt10:
	add	$8,$25,0
	ldw	$8,$8,0
	add	$9,$25,4
	ldw	$9,$9,0
	ldw	$9,$9,0
	mul	$9,$9,4
	add	$8,$8,$9
	ldw	$8,$8,0
	add	$9,$0,32
	bne	$8,$9,readInt11
	add	$8,$25,4
	ldw	$8,$8,0
	add	$9,$25,4
	ldw	$9,$9,0
	ldw	$9,$9,0
	add	$10,$0,1
	add	$9,$9,$10
	stw	$9,$8,0
	j	readInt10
readInt11:
	add	$8,$25,0
	ldw	$8,$8,0
	add	$9,$25,4
	ldw	$9,$9,0
	ldw	$9,$9,0
	mul	$9,$9,4
	add	$8,$8,$9
	ldw	$8,$8,0
	add	$9,$0,0
	bne	$8,$9,readInt12
	add	$8,$25,0
	ldw	$8,$8,0
	stw	$8,$29,0
	jal	readLine
	add	$8,$25,4
	ldw	$8,$8,0
	add	$9,$0,0
	stw	$9,$8,0
	j	readInt13
readInt12:
	add	$8,$25,-4
	add	$9,$0,0
	stw	$9,$8,0
readInt13:
	j	readInt8
readInt9:
	add	$8,$25,0
	ldw	$8,$8,0
	add	$9,$25,4
	ldw	$9,$9,0
	ldw	$9,$9,0
	mul	$9,$9,4
	add	$8,$8,$9
	ldw	$8,$8,0
	add	$9,$0,45
	bne	$8,$9,readInt14
	add	$8,$25,-8
	add	$9,$0,0
	add	$10,$0,1
	sub	$9,$9,$10
	stw	$9,$8,0
	add	$8,$25,4
	ldw	$8,$8,0
	add	$9,$25,4
	ldw	$9,$9,0
	ldw	$9,$9,0
	add	$10,$0,1
	add	$9,$9,$10
	stw	$9,$8,0
	j	readInt15
readInt14:
	add	$8,$25,-8
	add	$9,$0,1
	stw	$9,$8,0
readInt15:
	add	$8,$25,8
	ldw	$8,$8,0
	add	$9,$0,0
	stw	$9,$8,0
	add	$8,$25,-4
	add	$9,$0,1
	stw	$9,$8,0
readInt16:
	add	$8,$25,-4
	ldw	$8,$8,0
	add	$9,$0,1
	bne	$8,$9,readInt17
	add	$8,$25,0
	ldw	$8,$8,0
	add	$9,$25,4
	ldw	$9,$9,0
	ldw	$9,$9,0
	mul	$9,$9,4
	add	$8,$8,$9
	ldw	$8,$8,0
	add	$9,$0,48
	blt	$8,$9,readInt18
	add	$8,$25,0
	ldw	$8,$8,0
	add	$9,$25,4
	ldw	$9,$9,0
	ldw	$9,$9,0
	mul	$9,$9,4
	add	$8,$8,$9
	ldw	$8,$8,0
	add	$9,$0,57
	bgt	$8,$9,readInt20
	add	$8,$25,8
	ldw	$8,$8,0
	add	$9,$25,8
	ldw	$9,$9,0
	ldw	$9,$9,0
	add	$10,$0,10
	mul	$9,$9,$10
	add	$10,$25,0
	ldw	$10,$10,0
	add	$11,$25,4
	ldw	$11,$11,0
	ldw	$11,$11,0
	mul	$11,$11,4
	add	$10,$10,$11
	ldw	$10,$10,0
	add	$9,$9,$10
	add	$10,$0,48
	sub	$9,$9,$10
	stw	$9,$8,0
	add	$8,$25,4
	ldw	$8,$8,0
	add	$9,$25,4
	ldw	$9,$9,0
	ldw	$9,$9,0
	add	$10,$0,1
	add	$9,$9,$10
	stw	$9,$8,0
	j	readInt21
readInt20:
	add	$8,$25,-4
	add	$9,$0,0
	stw	$9,$8,0
readInt21:
	j	readInt19
readInt18:
	add	$8,$25,-4
	add	$9,$0,0
	stw	$9,$8,0
readInt19:
	j	readInt16
readInt17:
	add	$8,$25,8
	ldw	$8,$8,0
	add	$9,$25,8
	ldw	$9,$9,0
	ldw	$9,$9,0
	add	$10,$25,-8
	ldw	$10,$10,0
	mul	$9,$9,$10
	stw	$9,$8,0
	ldw	$31,$25,-16
	ldw	$25,$29,8
	add	$29,$29,20
	jr	$31

	; readi(ref i: int)
readi:
	sub	$29,$29,20
	stw	$25,$29,16
	add	$25,$29,20
	stw	$31,$25,-8
	add	$8,$0,line
	stw	$8,$29,0
	add	$8,$0,ptr
	stw	$8,$29,4
	ldw	$8,$25,0
	stw	$8,$29,8
	jal	readInt
	ldw	$31,$25,-8
	ldw	$25,$29,16
	add	$29,$29,20
	jr	$31

	.data
	.align	4

line:
	.space	80*4

ptr:
	.word	0
