;
; timer.s -- timer functions
;

	.set	tmrBase,0xF0000000	; timer base address

	.export	_tmrinit
	.export	time

	.import	_setisr

	.code
	.align	4

	; time(ref i: int)
time:
	ldw	$8,$29,0		; get address
	ldw	$9,$0,seconds		; get time
	stw	$9,$8,0			; store time
	jr	$31

_tmrinit:
	sub	$29,$29,8
	stw	$25,$29,4
	add	$25,$29,8
	stw	$31,$25,-8
	add	$4,$0,14		; set ISR for timer
	add	$5,$0,update
	jal	_setisr
	add	$8,$0,tmrBase		; program timer
	add	$9,$0,50000000		; divisor = 50000000
	stw	$9,$8,4
	add	$9,$0,2			; enable timer interrupts
	stw	$9,$8,0
	mvfs	$8,0
	or	$8,$8,1 << 14		; open timer IRQ mask bit
	or	$8,$8,1 << 23		; enable processor interrupts
	mvts	$8,0
	ldw	$31,$25,-8
	ldw	$25,$29,4
	add	$29,$29,8
	jr	$31

update:
	ldw	$8,$0,tmrBase		; reset timer IRQ
	ldw	$8,$0,seconds		; increment seconds
	add	$8,$8,1
	stw	$8,$0,seconds
	jr	$31

	.data
	.align	4

seconds:
	.word	0
