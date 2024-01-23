;
; graphics.s -- graphics routines
;

	.set	gfxBase,0xFFC00000	; graphics base address

	.export	_gfxinit
	.export	_gfxinstalled
	.export	_nogfx
	.export	_setPixelNoCheck
	.export	clearAll
	.export	setPixel

	.import	_getisr
	.import	_setisr
	.import	_prints
	.import	exit

	.code
	.align	4

gfxintrpt:
	stw	$0,$0,_gfxinstalled	; interrupt - no graphics
	add	$30,$30,4		; skip offending instruction
	jr	$31

_gfxinit:
	sub	$29,$29,8
	stw	$25,$29,4
	add	$25,$29,8
	stw	$31,$25,-8
	add	$4,$0,16		; get old ISR for bus timeout
	jal	_getisr
	add	$10,$2,0
	add	$4,$0,16		; set new ISR
	add	$5,$0,gfxintrpt
	jal	_setisr
	stw	$0,$0,gfxBase		; try to access frame buffer
	add	$4,$0,16		; restore old ISR
	add	$5,$10,0
	jal	_setisr
	ldw	$31,$25,-8
	ldw	$25,$29,4
	add	$29,$29,8
	jr	$31

_nogfx:
	sub	$29,$29,12
	stw	$25,$29,8
	add	$25,$29,12
	stw	$31,$25,-8
	add	$8,$0,noGfxMsg
	stw	$8,$29,0
	jal	_prints
	ldw	$31,$25,-8
	ldw	$25,$29,8
	add	$29,$29,12
	j	exit

	; clearAll(color: int)
clearAll:
	ldw	$8,$0,_gfxinstalled
	beq	$8,$0,_nogfx
clearAllNoCheck:
	add	$8,$0,gfxBase
	add	$9,$0,640*480
	ldw	$10,$29,0
clearAll1:
	stw	$10,$8,0
	add	$8,$8,4
	sub	$9,$9,1
	bne	$9,$0,clearAll1
	jr	$31

	; setPixel(x: int, y: int, color: int)
setPixel:
	ldw	$8,$0,_gfxinstalled
	beq	$8,$0,_nogfx
_setPixelNoCheck:
	sub	$29,$29,4
	stw	$25,$29,0
	add	$25,$29,4
	add	$8,$0,gfxBase
	add	$9,$0,640
	add	$10,$25,4
	ldw	$10,$10,0
	mul	$9,$9,$10
	add	$10,$25,0
	ldw	$10,$10,0
	add	$9,$9,$10
	mul	$9,$9,4
	add	$8,$8,$9
	add	$9,$25,8
	ldw	$9,$9,0
	stw	$9,$8,0
	ldw	$25,$29,0
	add	$29,$29,4
	jr	$31

	.data
	.align	4

_gfxinstalled:
	.word	1

noGfxMsg:
	.byte	"SPL/RTS: graphics controller not installed"
	.byte	0x0D, 0x0A, 0
