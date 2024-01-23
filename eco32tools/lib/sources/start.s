;
; start.s -- startup routine and interrupt support
;

	.export	_start
	.export	_getisr
	.export	_setisr

	.import	_tmrinit
	.import	_gfxinit
	.import	_prints
	.import	main
	.import	exit

	.code
	.align	4

	; reset arrives here
_start:
	j	start

	; interrupts arrive here
intrpt:
	sub	$29,$29,20*4		; 20 registers to save
	stw	$1,$29,0		; save registers
	stw	$2,$29,4
	stw	$8,$29,8
	stw	$9,$29,12
	stw	$10,$29,16
	stw	$11,$29,20
	stw	$12,$29,24
	stw	$13,$29,28
	stw	$14,$29,32
	stw	$15,$29,36
	stw	$16,$29,40
	stw	$17,$29,44
	stw	$18,$29,48
	stw	$19,$29,52
	stw	$20,$29,56
	stw	$21,$29,60
	stw	$22,$29,64
	stw	$23,$29,68
	stw	$25,$29,72
	stw	$31,$29,76
	add	$25,$29,0		; fp = sp
	mvfs	$26,0			; get PSW
	slr	$26,$26,14		; $26 = 4 * IRQ number
	and	$26,$26,0x1F << 2
	ldw	$27,$26,irqsrv		; get addr of service routine
	jalr	$27			; call service routine
	ldw	$1,$29,0		; restore registers
	ldw	$2,$29,4
	ldw	$8,$29,8
	ldw	$9,$29,12
	ldw	$10,$29,16
	ldw	$11,$29,20
	ldw	$12,$29,24
	ldw	$13,$29,28
	ldw	$14,$29,32
	ldw	$15,$29,36
	ldw	$16,$29,40
	ldw	$17,$29,44
	ldw	$18,$29,48
	ldw	$19,$29,52
	ldw	$20,$29,56
	ldw	$21,$29,60
	ldw	$22,$29,64
	ldw	$23,$29,68
	ldw	$25,$29,72
	ldw	$31,$29,76
	add	$29,$29,20*4		; release save area
	rfx				; return from interrupt

	; initialize runtime support and call main, then halt
start:
	add	$8,$0,1 << 27		; set V-bit in PSW
	mvts	$8,0
	add	$25,$0,0xC0100000	; stack is located 1M above code
	sub	$29,$25,4		; sp = fp - 4
	jal	_tmrinit		; initialize timer
	jal	_gfxinit		; initialize graphics
	add	$8,$0,startmsg
	stw	$8,$29,0
	jal	_prints			; say that main is going to execute
	jal	main
	add	$8,$0,stopmsg
	stw	$8,$29,0
	jal	_prints			; say that main is over
	j	exit

	; get interrupt service routine
_getisr:
	sll	$4,$4,2
	ldw	$2,$4,irqsrv
	jr	$31

	; set interrupt service routine
_setisr:
	sll	$4,$4,2
	stw	$5,$4,irqsrv
	cctl	7			; sync caches
	jr	$31

	; show message corresponding to interrupt
handleinterrupt:
	sub	$29,$29,12
	stw	$25,$29,8
	add	$25,$29,12
	stw	$31,$25,-8
	ldw	$8,$26,msgtbl
	stw	$8,$29,0
	jal	_prints			; show message
	ldw	$31,$25,-8
	ldw	$25,$29,8
	add	$29,$29,12
	j exit			

	.data
	.align	4

	; interrupt service routine table
irqsrv:
	.word	handleinterrupt		; 00: terminal 0 transmitter interrupt
	.word	handleinterrupt		; 01: terminal 0 receiver interrupt
	.word	handleinterrupt		; 02: terminal 1 transmitter interrupt
	.word	handleinterrupt		; 03: terminal 1 receiver interrupt
	.word	handleinterrupt		; 04: keyboard interrupt
	.word	handleinterrupt		; 05: unused
	.word	handleinterrupt		; 06: unused
	.word	handleinterrupt		; 07: unused
	.word	handleinterrupt		; 08: disk interrupt
	.word	handleinterrupt		; 09: unused
	.word	handleinterrupt		; 10: unused
	.word	handleinterrupt		; 11: unused
	.word	handleinterrupt		; 12: unused
	.word	handleinterrupt		; 13: unused
	.word	handleinterrupt		; 14: timer interrupt
	.word	handleinterrupt		; 15: unused
	.word	handleinterrupt		; 16: bus timeout exception
	.word	handleinterrupt		; 17: illegal instruction exception
	.word	handleinterrupt		; 18: privileged instruction exception
	.word	handleinterrupt		; 19: divide instruction exception
	.word	handleinterrupt		; 20: trap instruction exception
	.word	handleinterrupt		; 21: TLB miss exception
	.word	handleinterrupt		; 22: TLB write exception
	.word	handleinterrupt		; 23: TLB invalid exception
	.word	handleinterrupt		; 24: illegal address exception
	.word	handleinterrupt		; 25: privileged address exception
	.word	handleinterrupt		; 26: unused
	.word	handleinterrupt		; 27: unused
	.word	handleinterrupt		; 28: unused
	.word	handleinterrupt		; 29: unused
	.word	handleinterrupt		; 30: unused
	.word	handleinterrupt		; 31: unused

	; message table
msgtbl:	.word	xmtmsg		; 00: terminal 0 transmitter interrupt
	.word	rcvmsg		; 01: terminal 0 receiver interrupt
	.word	xmtmsg		; 02: terminal 1 transmitter interrupt
	.word	rcvmsg		; 03: terminal 1 receiver interrupt
	.word	kbdmsg		; 04: keyboard interrupt
	.word	uimsg		; 05: unused
	.word	uimsg		; 06: unused
	.word	uimsg		; 07: unused
	.word	dskmsg		; 08: disk interrupt
	.word	uimsg		; 09: unused
	.word	uimsg		; 10: unused
	.word	uimsg		; 11: unused
	.word	uimsg		; 12: unused
	.word	uimsg		; 13: unused
	.word	uimsg		; 14: timer interrupt
	.word	uimsg		; 15: unused
	.word	btmsg		; 16: bus timeout exception
	.word	iimsg		; 17: illegal instruction exception
	.word	pimsg		; 18: privileged instruction exception
	.word	dimsg		; 19: divide instruction exception
	.word	timsg		; 20: trap instruction exception
	.word	msmsg		; 21: TLB miss exception
	.word	wrmsg		; 22: TLB write exception
	.word	ivmsg		; 23: TLB invalid exception
	.word	iamsg		; 24: illegal address exception
	.word	pamsg		; 25: privileged address exception
	.word	uemsg		; 26: unused
	.word	uemsg		; 27: unused
	.word	uemsg		; 28: unused
	.word	uemsg		; 29: unused
	.word	uemsg		; 30: unused
	.word	uemsg		; 31: unused

;
; start/stop messages
;

startmsg:
	.byte	"SPL/RTS: main() started", 0x0d, 0x0a, 0

stopmsg:
	.byte	"SPL/RTS: main() finished", 0x0d, 0x0a, 0

;
; interrupt messages
;

uimsg:	.byte	"SPL/RTS: unknown interrupt"
	.byte	0x0D, 0x0A, 0

xmtmsg:	.byte	"SPL/RTS: terminal transmitter interrupt"
	.byte	0x0D, 0x0A, 0

rcvmsg:	.byte	"SPL/RTS: terminal receiver interrupt"
	.byte	0x0D, 0x0A, 0

kbdmsg:	.byte	"SPL/RTS: keyboard interrupt"
	.byte	0x0D, 0x0A, 0

dskmsg:	.byte	"SPL/RTS: disk interrupt"
	.byte	0x0D, 0x0A, 0

tmrmsg:	.byte	"SPL/RTS: timer interrupt"
	.byte	0x0D, 0x0A, 0

;
; exception messages
;

uemsg:	.byte	"SPL/RTS: unknown exception"
	.byte	0x0D, 0x0A, 0

btmsg:	.byte	"SPL/RTS: bus timeout exception"
	.byte	0x0D, 0x0A, 0

iimsg:	.byte	"SPL/RTS: illegal instruction exception"
	.byte	0x0D, 0x0A, 0

pimsg:	.byte	"SPL/RTS: privileged instruction exception"
	.byte	0x0D, 0x0A, 0

dimsg:	.byte	"SPL/RTS: divide instruction exception"
	.byte	0x0D, 0x0A, 0

timsg:	.byte	"SPL/RTS: trap instruction exception"
	.byte	0x0D, 0x0A, 0

msmsg:	.byte	"SPL/RTS: TLB miss exception"
	.byte	0x0D, 0x0A, 0

wrmsg:	.byte	"SPL/RTS: TLB write exception"
	.byte	0x0D, 0x0A, 0

ivmsg:	.byte	"SPL/RTS: TLB invalid exception"
	.byte	0x0D, 0x0A, 0

iamsg:	.byte	"SPL/RTS: illegal address exception"
	.byte	0x0D, 0x0A, 0

pamsg:	.byte	"SPL/RTS: privileged address exception"
	.byte	0x0D, 0x0A, 0
