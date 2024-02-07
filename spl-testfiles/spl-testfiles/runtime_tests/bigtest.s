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

	.export	callbyval
callbyval:
	sub	$29,$29,8		; allocate frame
	stw	$25,$29,4		; save old frame pointer
	add	$25,$29,8		; setup new frame pointer
	stw	$31,$25,-8		; save return register
	add	$8,$25,0
	add	$9,$25,0
	ldw	$9,$9,0
	add	$10,$0,1
	add	$9,$9,$10
	stw	$9,$8,0
	add	$8,$25,4
	add	$9,$25,4
	ldw	$9,$9,0
	add	$10,$0,1
	add	$9,$9,$10
	stw	$9,$8,0
	ldw	$31,$25,-8		; restore return register
	ldw	$25,$29,4		; restore old frame pointer
	add	$29,$29,8		; release frame
	jr	$31			; return

	.export	callbyref
callbyref:
	sub	$29,$29,8		; allocate frame
	stw	$25,$29,4		; save old frame pointer
	add	$25,$29,8		; setup new frame pointer
	stw	$31,$25,-8		; save return register
	add	$8,$25,0
	ldw	$8,$8,0
	add	$9,$25,0
	ldw	$9,$9,0
	ldw	$9,$9,0
	add	$10,$0,1
	add	$9,$9,$10
	stw	$9,$8,0
	add	$8,$25,4
	ldw	$8,$8,0
	add	$9,$25,4
	ldw	$9,$9,0
	ldw	$9,$9,0
	add	$10,$0,1
	add	$9,$9,$10
	stw	$9,$8,0
	ldw	$31,$25,-8		; restore return register
	ldw	$25,$29,4		; restore old frame pointer
	add	$29,$29,8		; release frame
	jr	$31			; return

	.export	callArray
callArray:
	sub	$29,$29,8		; allocate frame
	stw	$25,$29,4		; save old frame pointer
	add	$25,$29,8		; setup new frame pointer
	stw	$31,$25,-8		; save return register
	add	$8,$25,0
	ldw	$8,$8,0
	add	$9,$0,0
	add	$10,$0,10
	bgeu	$9,$10,_indexError
	mul	$9,$9,4
	add	$8,$8,$9
	add	$9,$0,99
	stw	$9,$8,0
	add	$8,$25,0
	ldw	$8,$8,0
	add	$9,$0,4
	add	$10,$0,10
	bgeu	$9,$10,_indexError
	mul	$9,$9,4
	add	$8,$8,$9
	add	$9,$0,66
	stw	$9,$8,0
	ldw	$31,$25,-8		; restore return register
	ldw	$25,$29,4		; restore old frame pointer
	add	$29,$29,8		; release frame
	jr	$31			; return

	.export	callRecursive
callRecursive:
	sub	$29,$29,16		; allocate frame
	stw	$25,$29,12		; save old frame pointer
	add	$25,$29,16		; setup new frame pointer
	stw	$31,$25,-8		; save return register
	add	$8,$25,0
	ldw	$8,$8,0
	add	$9,$0,10
	bgt	$8,$9,L0
	add	$8,$25,0
	ldw	$8,$8,0
	add	$9,$0,1
	add	$8,$8,$9
	stw	$8,$29,0		; store argument #0
	add	$8,$25,4
	ldw	$8,$8,0
	stw	$8,$29,4		; store argument #1
	jal	callRecursive
L0:
	add	$8,$25,4
	ldw	$8,$8,0
	add	$9,$25,4
	ldw	$9,$9,0
	ldw	$9,$9,0
	add	$10,$25,0
	ldw	$10,$10,0
	add	$9,$9,$10
	stw	$9,$8,0
	add	$8,$25,0
	add	$9,$25,0
	ldw	$9,$9,0
	add	$10,$0,1
	add	$9,$9,$10
	stw	$9,$8,0
	ldw	$31,$25,-8		; restore return register
	ldw	$25,$29,12		; restore old frame pointer
	add	$29,$29,16		; release frame
	jr	$31			; return

	.export	manyargs
manyargs:
	sub	$29,$29,24		; allocate frame
	stw	$25,$29,20		; save old frame pointer
	add	$25,$29,24		; setup new frame pointer
	stw	$31,$25,-8		; save return register
	add	$8,$25,0
	ldw	$8,$8,0
	stw	$8,$29,0		; store argument #0
	add	$8,$25,4
	stw	$8,$29,4		; store argument #1
	jal	callRecursive
	add	$8,$25,0
	ldw	$8,$8,0
	add	$9,$0,0
	ble	$8,$9,L1
	add	$8,$25,0
	ldw	$8,$8,0
	add	$9,$0,1
	sub	$8,$8,$9
	stw	$8,$29,0		; store argument #0
	add	$8,$25,12
	ldw	$8,$8,0
	ldw	$8,$8,0
	stw	$8,$29,4		; store argument #1
	add	$8,$25,8
	ldw	$8,$8,0
	stw	$8,$29,8		; store argument #2
	add	$8,$25,4
	stw	$8,$29,12		; store argument #3
	jal	manyargs
L1:
	add	$8,$25,0
	ldw	$8,$8,0
	add	$9,$0,0
	bne	$8,$9,L2
	add	$8,$25,0
	ldw	$8,$8,0
	stw	$8,$29,0		; store argument #0
	add	$8,$25,4
	ldw	$8,$8,0
	stw	$8,$29,4		; store argument #1
	add	$8,$0,0
	stw	$8,$29,8		; store argument #2
	add	$8,$0,67
	stw	$8,$29,12		; store argument #3
	jal	check
L2:
	add	$8,$25,0
	ldw	$8,$8,0
	add	$9,$0,1
	bne	$8,$9,L3
	add	$8,$25,0
	ldw	$8,$8,0
	stw	$8,$29,0		; store argument #0
	add	$8,$25,4
	ldw	$8,$8,0
	stw	$8,$29,4		; store argument #1
	add	$8,$0,1
	stw	$8,$29,8		; store argument #2
	add	$8,$0,69
	stw	$8,$29,12		; store argument #3
	jal	check
L3:
	add	$8,$25,0
	ldw	$8,$8,0
	stw	$8,$29,0		; store argument #0
	jal	printi
	add	$8,$0,32
	stw	$8,$29,0		; store argument #0
	jal	printc
	add	$8,$25,4
	ldw	$8,$8,0
	stw	$8,$29,0		; store argument #0
	jal	printi
	add	$8,$0,10
	stw	$8,$29,0		; store argument #0
	jal	printc
	ldw	$31,$25,-8		; restore return register
	ldw	$25,$29,20		; restore old frame pointer
	add	$29,$29,24		; release frame
	jr	$31			; return

	.export	hide
hide:
	sub	$29,$29,16		; allocate frame
	stw	$25,$29,4		; save old frame pointer
	add	$25,$29,16		; setup new frame pointer
	stw	$31,$25,-16		; save return register
	ldw	$31,$25,-16		; restore return register
	ldw	$25,$29,4		; restore old frame pointer
	add	$29,$29,16		; release frame
	jr	$31			; return

	.export	main
main:
	sub	$29,$29,4664		; allocate frame
	stw	$25,$29,20		; save old frame pointer
	add	$25,$29,4664		; setup new frame pointer
	stw	$31,$25,-4648		; save return register
	add	$8,$0,1
	stw	$8,$29,0		; store argument #0
	jal	ausgabe
	add	$8,$25,-4
	add	$9,$0,1
	add	$10,$0,2
	sub	$9,$9,$10
	add	$10,$0,3
	sub	$9,$9,$10
	stw	$9,$8,0
	add	$8,$25,-8
	add	$9,$0,1
	add	$10,$0,2
	add	$11,$25,-4
	ldw	$11,$11,0
	sub	$11,$0,$11
	mul	$10,$10,$11
	add	$9,$9,$10
	add	$10,$0,7
	add	$11,$0,77
	sub	$10,$10,$11
	add	$11,$0,7
	div	$10,$10,$11
	add	$11,$0,5
	div	$10,$10,$11
	add	$11,$0,2
	add	$12,$0,1
	add	$13,$0,2
	add	$14,$0,4
	add	$15,$0,5
	add	$16,$0,4
	add	$17,$0,3
	add	$18,$0,2
	add	$19,$0,1
	add	$20,$0,1
	add	$21,$0,3
	add	$22,$0,4
	add	$23,$0,5
	sub	$22,$22,$23
	sub	$21,$21,$22
	add	$20,$20,$21
	mul	$19,$19,$20
	sub	$18,$18,$19
	add	$17,$17,$18
	sub	$16,$16,$17
	add	$15,$15,$16
	sub	$14,$14,$15
	add	$13,$13,$14
	sub	$12,$12,$13
	mul	$11,$11,$12
	mul	$10,$10,$11
	sub	$9,$9,$10
	stw	$9,$8,0
	add	$8,$25,-4
	ldw	$8,$8,0
	stw	$8,$29,0		; store argument #0
	add	$8,$25,-8
	ldw	$8,$8,0
	stw	$8,$29,4		; store argument #1
	add	$8,$0,4
	sub	$8,$0,$8
	stw	$8,$29,8		; store argument #2
	add	$8,$0,25
	stw	$8,$29,12		; store argument #3
	jal	check
	add	$8,$25,-4
	ldw	$8,$8,0
	stw	$8,$29,0		; store argument #0
	jal	printi
	add	$8,$0,32
	stw	$8,$29,0		; store argument #0
	jal	printc
	add	$8,$25,-8
	ldw	$8,$8,0
	stw	$8,$29,0		; store argument #0
	jal	printi
	add	$8,$0,10
	stw	$8,$29,0		; store argument #0
	jal	printc
	add	$8,$25,-4
	add	$9,$0,43690
	stw	$9,$8,0
	add	$8,$25,-8
	add	$9,$0,48059
	add	$10,$0,65
	add	$11,$0,2
	mul	$10,$10,$11
	sub	$9,$9,$10
	stw	$9,$8,0
	add	$8,$25,-4
	ldw	$8,$8,0
	stw	$8,$29,0		; store argument #0
	add	$8,$25,-8
	ldw	$8,$8,0
	stw	$8,$29,4		; store argument #1
	add	$8,$0,43690
	stw	$8,$29,8		; store argument #2
	add	$8,$0,47929
	stw	$8,$29,12		; store argument #3
	jal	check
	add	$8,$25,-4
	ldw	$8,$8,0
	stw	$8,$29,0		; store argument #0
	jal	printi
	add	$8,$0,32
	stw	$8,$29,0		; store argument #0
	jal	printc
	add	$8,$25,-8
	ldw	$8,$8,0
	stw	$8,$29,0		; store argument #0
	jal	printi
	add	$8,$0,10
	stw	$8,$29,0		; store argument #0
	jal	printc
	add	$8,$25,-4
	add	$9,$0,1
	sub	$9,$0,$9
	stw	$9,$8,0
	add	$8,$25,-8
	add	$9,$0,32
	stw	$9,$8,0
	add	$8,$25,-504
	add	$9,$0,0
	sub	$9,$0,$9
	add	$10,$0,5
	bgeu	$9,$10,_indexError
	mul	$9,$9,40
	add	$8,$8,$9
	add	$9,$0,7
	add	$10,$0,10
	bgeu	$9,$10,_indexError
	mul	$9,$9,4
	add	$8,$8,$9
	add	$9,$25,-4
	ldw	$9,$9,0
	add	$10,$25,-4
	ldw	$10,$10,0
	sub	$10,$0,$10
	sub	$9,$9,$10
	stw	$9,$8,0
	add	$8,$25,-504
	add	$9,$25,-4
	ldw	$9,$9,0
	sub	$9,$0,$9
	add	$10,$0,5
	bgeu	$9,$10,_indexError
	mul	$9,$9,40
	add	$8,$8,$9
	add	$9,$0,8
	add	$10,$0,10
	bgeu	$9,$10,_indexError
	mul	$9,$9,4
	add	$8,$8,$9
	add	$9,$0,135
	stw	$9,$8,0
	add	$8,$25,-504
	add	$9,$0,1
	add	$10,$0,1
	add	$9,$9,$10
	add	$10,$0,5
	bgeu	$9,$10,_indexError
	mul	$9,$9,40
	add	$8,$8,$9
	add	$9,$0,9
	add	$10,$0,10
	bgeu	$9,$10,_indexError
	mul	$9,$9,4
	add	$8,$8,$9
	add	$9,$0,10
	stw	$9,$8,0
	add	$8,$25,-504
	add	$9,$0,0
	add	$10,$0,5
	bgeu	$9,$10,_indexError
	mul	$9,$9,40
	add	$8,$8,$9
	add	$9,$0,7
	add	$10,$0,10
	bgeu	$9,$10,_indexError
	mul	$9,$9,4
	add	$8,$8,$9
	ldw	$8,$8,0
	stw	$8,$29,0		; store argument #0
	add	$8,$25,-504
	add	$9,$0,1
	add	$10,$0,5
	bgeu	$9,$10,_indexError
	mul	$9,$9,40
	add	$8,$8,$9
	add	$9,$0,8
	add	$10,$0,10
	bgeu	$9,$10,_indexError
	mul	$9,$9,4
	add	$8,$8,$9
	ldw	$8,$8,0
	stw	$8,$29,4		; store argument #1
	add	$8,$0,2
	sub	$8,$0,$8
	stw	$8,$29,8		; store argument #2
	add	$8,$0,135
	stw	$8,$29,12		; store argument #3
	jal	check
	add	$8,$25,-504
	add	$9,$0,0
	add	$10,$0,5
	bgeu	$9,$10,_indexError
	mul	$9,$9,40
	add	$8,$8,$9
	add	$9,$0,7
	add	$10,$0,10
	bgeu	$9,$10,_indexError
	mul	$9,$9,4
	add	$8,$8,$9
	ldw	$8,$8,0
	stw	$8,$29,0		; store argument #0
	jal	printi
	add	$8,$0,32
	stw	$8,$29,0		; store argument #0
	jal	printc
	add	$8,$25,-504
	add	$9,$0,1
	add	$10,$0,5
	bgeu	$9,$10,_indexError
	mul	$9,$9,40
	add	$8,$8,$9
	add	$9,$0,8
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
	add	$8,$0,2
	stw	$8,$29,0		; store argument #0
	jal	ausgabe
	add	$8,$25,-4
	ldw	$8,$8,0
	stw	$8,$29,0		; store argument #0
	add	$8,$25,-8
	ldw	$8,$8,0
	stw	$8,$29,4		; store argument #1
	jal	callbyval
	add	$8,$25,-4
	ldw	$8,$8,0
	stw	$8,$29,0		; store argument #0
	add	$8,$25,-8
	ldw	$8,$8,0
	stw	$8,$29,4		; store argument #1
	add	$8,$0,1
	sub	$8,$0,$8
	stw	$8,$29,8		; store argument #2
	add	$8,$0,32
	stw	$8,$29,12		; store argument #3
	jal	check
	add	$8,$25,-4
	ldw	$8,$8,0
	stw	$8,$29,0		; store argument #0
	jal	printi
	add	$8,$0,32
	stw	$8,$29,0		; store argument #0
	jal	printc
	add	$8,$25,-8
	ldw	$8,$8,0
	stw	$8,$29,0		; store argument #0
	jal	printi
	add	$8,$0,10
	stw	$8,$29,0		; store argument #0
	jal	printc
	add	$8,$25,-4
	stw	$8,$29,0		; store argument #0
	add	$8,$25,-8
	stw	$8,$29,4		; store argument #1
	jal	callbyref
	add	$8,$25,-4
	ldw	$8,$8,0
	stw	$8,$29,0		; store argument #0
	add	$8,$25,-8
	ldw	$8,$8,0
	stw	$8,$29,4		; store argument #1
	add	$8,$0,0
	stw	$8,$29,8		; store argument #2
	add	$8,$0,33
	stw	$8,$29,12		; store argument #3
	jal	check
	add	$8,$25,-4
	ldw	$8,$8,0
	stw	$8,$29,0		; store argument #0
	jal	printi
	add	$8,$0,32
	stw	$8,$29,0		; store argument #0
	jal	printc
	add	$8,$25,-8
	ldw	$8,$8,0
	stw	$8,$29,0		; store argument #0
	jal	printi
	add	$8,$0,10
	stw	$8,$29,0		; store argument #0
	jal	printc
	add	$8,$25,-544
	add	$9,$0,0
	add	$10,$0,10
	bgeu	$9,$10,_indexError
	mul	$9,$9,4
	add	$8,$8,$9
	add	$9,$0,5
	stw	$9,$8,0
	add	$8,$25,-544
	add	$9,$0,1
	add	$10,$0,10
	bgeu	$9,$10,_indexError
	mul	$9,$9,4
	add	$8,$8,$9
	add	$9,$0,4
	stw	$9,$8,0
	add	$8,$25,-544
	add	$9,$0,2
	add	$10,$0,10
	bgeu	$9,$10,_indexError
	mul	$9,$9,4
	add	$8,$8,$9
	add	$9,$0,3
	stw	$9,$8,0
	add	$8,$25,-544
	add	$9,$0,3
	add	$10,$0,10
	bgeu	$9,$10,_indexError
	mul	$9,$9,4
	add	$8,$8,$9
	add	$9,$0,2
	stw	$9,$8,0
	add	$8,$25,-544
	add	$9,$0,4
	add	$10,$0,10
	bgeu	$9,$10,_indexError
	mul	$9,$9,4
	add	$8,$8,$9
	add	$9,$0,1
	stw	$9,$8,0
	add	$8,$25,-544
	stw	$8,$29,0		; store argument #0
	jal	callArray
	add	$8,$25,-544
	add	$9,$0,0
	add	$10,$0,10
	bgeu	$9,$10,_indexError
	mul	$9,$9,4
	add	$8,$8,$9
	ldw	$8,$8,0
	stw	$8,$29,0		; store argument #0
	add	$8,$25,-544
	add	$9,$0,4
	add	$10,$0,10
	bgeu	$9,$10,_indexError
	mul	$9,$9,4
	add	$8,$8,$9
	ldw	$8,$8,0
	stw	$8,$29,4		; store argument #1
	add	$8,$0,99
	stw	$8,$29,8		; store argument #2
	add	$8,$0,66
	stw	$8,$29,12		; store argument #3
	jal	check
	add	$8,$25,-544
	add	$9,$0,0
	add	$10,$0,10
	bgeu	$9,$10,_indexError
	mul	$9,$9,4
	add	$8,$8,$9
	ldw	$8,$8,0
	stw	$8,$29,0		; store argument #0
	jal	printi
	add	$8,$0,32
	stw	$8,$29,0		; store argument #0
	jal	printc
	add	$8,$25,-544
	add	$9,$0,4
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
	add	$8,$25,-4
	add	$9,$0,1
	stw	$9,$8,0
	add	$8,$25,-8
	add	$9,$0,1
	stw	$9,$8,0
	add	$8,$25,-4
	ldw	$8,$8,0
	stw	$8,$29,0		; store argument #0
	add	$8,$25,-8
	stw	$8,$29,4		; store argument #1
	jal	callRecursive
	add	$8,$25,-4
	ldw	$8,$8,0
	stw	$8,$29,0		; store argument #0
	add	$8,$25,-8
	ldw	$8,$8,0
	stw	$8,$29,4		; store argument #1
	add	$8,$0,1
	stw	$8,$29,8		; store argument #2
	add	$8,$0,67
	stw	$8,$29,12		; store argument #3
	jal	check
	add	$8,$25,-4
	ldw	$8,$8,0
	stw	$8,$29,0		; store argument #0
	jal	printi
	add	$8,$0,32
	stw	$8,$29,0		; store argument #0
	jal	printc
	add	$8,$25,-8
	ldw	$8,$8,0
	stw	$8,$29,0		; store argument #0
	jal	printi
	add	$8,$0,10
	stw	$8,$29,0		; store argument #0
	jal	printc
	add	$8,$0,3
	stw	$8,$29,0		; store argument #0
	jal	ausgabe
	add	$8,$25,-4
	add	$9,$0,0
	stw	$9,$8,0
L4:
	add	$8,$25,-4
	ldw	$8,$8,0
	add	$9,$0,3
	bgt	$8,$9,L5
	add	$8,$25,-8
	add	$9,$0,2
	add	$10,$25,-4
	ldw	$10,$10,0
	mul	$9,$9,$10
	add	$10,$0,1
	add	$9,$9,$10
	stw	$9,$8,0
	add	$8,$25,-48
	add	$9,$25,-4
	ldw	$9,$9,0
	add	$10,$0,10
	bgeu	$9,$10,_indexError
	mul	$9,$9,4
	add	$8,$8,$9
	add	$9,$25,-8
	ldw	$9,$9,0
	add	$10,$25,-8
	ldw	$10,$10,0
	add	$11,$25,-8
	ldw	$11,$11,0
	add	$10,$10,$11
	add	$11,$25,-8
	ldw	$11,$11,0
	mul	$10,$10,$11
	add	$11,$25,-8
	ldw	$11,$11,0
	add	$12,$25,-8
	ldw	$12,$12,0
	add	$13,$25,-8
	ldw	$13,$13,0
	add	$14,$25,-8
	ldw	$14,$14,0
	add	$15,$25,-8
	ldw	$15,$15,0
	add	$14,$14,$15
	mul	$13,$13,$14
	add	$12,$12,$13
	mul	$11,$11,$12
	add	$10,$10,$11
	add	$11,$25,-8
	ldw	$11,$11,0
	div	$10,$10,$11
	add	$11,$25,-8
	ldw	$11,$11,0
	div	$10,$10,$11
	mul	$9,$9,$10
	stw	$9,$8,0
	add	$8,$25,-48
	add	$9,$0,0
	add	$10,$0,10
	bgeu	$9,$10,_indexError
	mul	$9,$9,4
	add	$8,$8,$9
	add	$9,$25,-48
	add	$10,$0,0
	add	$11,$0,10
	bgeu	$10,$11,_indexError
	mul	$10,$10,4
	add	$9,$9,$10
	ldw	$9,$9,0
	add	$10,$25,-48
	add	$11,$25,-4
	ldw	$11,$11,0
	add	$12,$0,10
	bgeu	$11,$12,_indexError
	mul	$11,$11,4
	add	$10,$10,$11
	ldw	$10,$10,0
	add	$9,$9,$10
	stw	$9,$8,0
	add	$8,$25,-4
	ldw	$8,$8,0
	stw	$8,$29,0		; store argument #0
	jal	printi
	add	$8,$0,32
	stw	$8,$29,0		; store argument #0
	jal	printc
	add	$8,$25,-48
	add	$9,$25,-4
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
	add	$8,$25,-4
	add	$9,$25,-4
	ldw	$9,$9,0
	add	$10,$0,1
	add	$9,$9,$10
	stw	$9,$8,0
	j	L4
L5:
	add	$8,$25,-4
	ldw	$8,$8,0
	stw	$8,$29,0		; store argument #0
	add	$8,$25,-48
	add	$9,$0,0
	add	$10,$0,10
	bgeu	$9,$10,_indexError
	mul	$9,$9,4
	add	$8,$8,$9
	ldw	$8,$8,0
	stw	$8,$29,4		; store argument #1
	add	$8,$0,4
	stw	$8,$29,8		; store argument #2
	add	$8,$0,221
	stw	$8,$29,12		; store argument #3
	jal	check
	add	$8,$25,-4
	add	$9,$0,0
	stw	$9,$8,0
	add	$8,$25,-8
	add	$9,$0,1
	stw	$9,$8,0
	add	$8,$25,-4
	ldw	$8,$8,0
	add	$9,$25,-8
	ldw	$9,$9,0
	bne	$8,$9,L6
	add	$8,$25,-4
	ldw	$8,$8,0
	add	$9,$25,-8
	ldw	$9,$9,0
	add	$10,$0,1
	sub	$9,$9,$10
	beq	$8,$9,L7
	add	$8,$0,101
	stw	$8,$29,0		; store argument #0
	jal	printc
	add	$8,$0,114
	stw	$8,$29,0		; store argument #0
	jal	printc
	add	$8,$0,114
	stw	$8,$29,0		; store argument #0
	jal	printc
	add	$8,$0,111
	stw	$8,$29,0		; store argument #0
	jal	printc
	add	$8,$0,114
	stw	$8,$29,0		; store argument #0
	jal	printc
	j	L8
L7:
	add	$8,$0,101
	stw	$8,$29,0		; store argument #0
	jal	printc
	add	$8,$0,114
	stw	$8,$29,0		; store argument #0
	jal	printc
	add	$8,$0,114
	stw	$8,$29,0		; store argument #0
	jal	printc
	add	$8,$0,111
	stw	$8,$29,0		; store argument #0
	jal	printc
	add	$8,$0,114
	stw	$8,$29,0		; store argument #0
	jal	printc
L8:
	j	L9
L6:
	add	$8,$0,111
	stw	$8,$29,0		; store argument #0
	jal	printc
	add	$8,$0,107
	stw	$8,$29,0		; store argument #0
	jal	printc
L9:
	add	$8,$0,10
	stw	$8,$29,0		; store argument #0
	jal	printc
	add	$8,$0,4
	stw	$8,$29,0		; store argument #0
	jal	ausgabe
	add	$8,$0,1
	stw	$8,$29,0		; store argument #0
	add	$8,$0,3
	stw	$8,$29,4		; store argument #1
	add	$8,$25,-4640
	stw	$8,$29,8		; store argument #2
	add	$8,$25,-8
	stw	$8,$29,12		; store argument #3
	jal	manyargs
	add	$8,$0,10
	stw	$8,$29,0		; store argument #0
	jal	printc
	ldw	$31,$25,-4648		; restore return register
	ldw	$25,$29,20		; restore old frame pointer
	add	$29,$29,4664		; release frame
	jr	$31			; return

	.export	ausgabe
ausgabe:
	sub	$29,$29,12		; allocate frame
	stw	$25,$29,8		; save old frame pointer
	add	$25,$29,12		; setup new frame pointer
	stw	$31,$25,-8		; save return register
	add	$8,$0,10
	stw	$8,$29,0		; store argument #0
	jal	printc
	add	$8,$0,84
	stw	$8,$29,0		; store argument #0
	jal	printc
	add	$8,$0,101
	stw	$8,$29,0		; store argument #0
	jal	printc
	add	$8,$0,115
	stw	$8,$29,0		; store argument #0
	jal	printc
	add	$8,$0,116
	stw	$8,$29,0		; store argument #0
	jal	printc
	add	$8,$0,32
	stw	$8,$29,0		; store argument #0
	jal	printc
	add	$8,$25,0
	ldw	$8,$8,0
	stw	$8,$29,0		; store argument #0
	jal	printi
	add	$8,$0,10
	stw	$8,$29,0		; store argument #0
	jal	printc
	add	$8,$0,61
	stw	$8,$29,0		; store argument #0
	jal	printc
	add	$8,$0,61
	stw	$8,$29,0		; store argument #0
	jal	printc
	add	$8,$0,61
	stw	$8,$29,0		; store argument #0
	jal	printc
	add	$8,$0,61
	stw	$8,$29,0		; store argument #0
	jal	printc
	add	$8,$0,61
	stw	$8,$29,0		; store argument #0
	jal	printc
	add	$8,$0,61
	stw	$8,$29,0		; store argument #0
	jal	printc
	add	$8,$0,61
	stw	$8,$29,0		; store argument #0
	jal	printc
	add	$8,$0,61
	stw	$8,$29,0		; store argument #0
	jal	printc
	add	$8,$0,10
	stw	$8,$29,0		; store argument #0
	jal	printc
	ldw	$31,$25,-8		; restore return register
	ldw	$25,$29,8		; restore old frame pointer
	add	$29,$29,12		; release frame
	jr	$31			; return

	.export	check
check:
	sub	$29,$29,16		; allocate frame
	stw	$25,$29,12		; save old frame pointer
	add	$25,$29,16		; setup new frame pointer
	stw	$31,$25,-8		; save return register
	add	$8,$25,0
	ldw	$8,$8,0
	add	$9,$25,8
	ldw	$9,$9,0
	beq	$8,$9,L10
	add	$8,$25,0
	ldw	$8,$8,0
	stw	$8,$29,0		; store argument #0
	add	$8,$25,8
	ldw	$8,$8,0
	stw	$8,$29,4		; store argument #1
	jal	error
L10:
	add	$8,$25,4
	ldw	$8,$8,0
	add	$9,$25,12
	ldw	$9,$9,0
	beq	$8,$9,L11
	add	$8,$25,4
	ldw	$8,$8,0
	stw	$8,$29,0		; store argument #0
	add	$8,$25,12
	ldw	$8,$8,0
	stw	$8,$29,4		; store argument #1
	jal	error
L11:
	ldw	$31,$25,-8		; restore return register
	ldw	$25,$29,12		; restore old frame pointer
	add	$29,$29,16		; release frame
	jr	$31			; return

	.export	error
error:
	sub	$29,$29,12		; allocate frame
	stw	$25,$29,8		; save old frame pointer
	add	$25,$29,12		; setup new frame pointer
	stw	$31,$25,-8		; save return register
	add	$8,$0,69
	stw	$8,$29,0		; store argument #0
	jal	printc
	add	$8,$0,114
	stw	$8,$29,0		; store argument #0
	jal	printc
	add	$8,$0,114
	stw	$8,$29,0		; store argument #0
	jal	printc
	add	$8,$0,111
	stw	$8,$29,0		; store argument #0
	jal	printc
	add	$8,$0,114
	stw	$8,$29,0		; store argument #0
	jal	printc
	add	$8,$0,58
	stw	$8,$29,0		; store argument #0
	jal	printc
	add	$8,$0,105
	stw	$8,$29,0		; store argument #0
	jal	printc
	add	$8,$0,61
	stw	$8,$29,0		; store argument #0
	jal	printc
	add	$8,$25,0
	ldw	$8,$8,0
	stw	$8,$29,0		; store argument #0
	jal	printi
	add	$8,$0,44
	stw	$8,$29,0		; store argument #0
	jal	printc
	add	$8,$0,69
	stw	$8,$29,0		; store argument #0
	jal	printc
	add	$8,$0,120
	stw	$8,$29,0		; store argument #0
	jal	printc
	add	$8,$0,112
	stw	$8,$29,0		; store argument #0
	jal	printc
	add	$8,$0,101
	stw	$8,$29,0		; store argument #0
	jal	printc
	add	$8,$0,99
	stw	$8,$29,0		; store argument #0
	jal	printc
	add	$8,$0,116
	stw	$8,$29,0		; store argument #0
	jal	printc
	add	$8,$0,101
	stw	$8,$29,0		; store argument #0
	jal	printc
	add	$8,$0,100
	stw	$8,$29,0		; store argument #0
	jal	printc
	add	$8,$0,58
	stw	$8,$29,0		; store argument #0
	jal	printc
	add	$8,$25,4
	ldw	$8,$8,0
	stw	$8,$29,0		; store argument #0
	jal	printi
	add	$8,$0,10
	stw	$8,$29,0		; store argument #0
	jal	printc
	ldw	$31,$25,-8		; restore return register
	ldw	$25,$29,8		; restore old frame pointer
	add	$29,$29,12		; release frame
	jr	$31			; return
