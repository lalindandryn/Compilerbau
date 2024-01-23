;
; exit.s -- halt program execution
;

	.set	SHUTDOWN,0xFF100000	; shutdown device address

	.export	exit

	.import	_xmtempty

	.code
	.align	4

	; exit()
exit:
	jal	_xmtempty		; get transmitter status
	beq	$2,$0,exit		; wait until empty
	stw	$0,$0,SHUTDOWN		; then shut down
stop:					; this is never reached
	j	stop			; but better safe then sorry
