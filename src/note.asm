;
; File generated by cc65 v 2.18 - N/A
;
	.fopt		compiler,"cc65 v 2.18 - N/A"
	.setcpu		"6502"
	.smart		on
	.autoimport	on
	.case		on
	.debuginfo	off
	.importzp	sp, sreg, regsave, regbank
	.importzp	tmp1, tmp2, tmp3, tmp4, ptr1, ptr2, ptr3, ptr4
	.macpack	longbranch
	.forceimport	__STARTUP__
	.export		_note
	.export		_rest

.segment	"RODATA"

; ---------------------------------------------------------------
; int __near__ main (void)
; ---------------------------------------------------------------

.segment	"CODE"
; receive integer argument note 0-61
; wall of nop
_note:
  .REPEAT 3902
  nop
  .ENDREP
  bit $C030
  dec $02
  beq Exit
  jmp ($00)
Exit:
  rts

_rest:
  .REPEAT 1000
  nop
  .ENDREP
  rts
