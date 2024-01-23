;
; error.s -- runtime errors
;

	.export	_indexError

	.import	_prints
	.import	exit

	.code
	.align	4

_indexError:
	sub	$29,$29,12
	stw	$25,$29,8
	add	$25,$29,12
	stw	$31,$25,-8
	add	$8,$0,indexErrMsg
	stw	$8,$29,0
	jal	_prints
	ldw	$31,$25,-8
	ldw	$25,$29,8
	add	$29,$29,12
	j	exit

indexErrMsg:
	.byte	"SPL/RTS: index out of bounds"
	.byte	0x0D, 0x0A, 0
