.include "constants.asm"
.include "header.asm"

.segment "ZEROPAGE"
.segment "BSS"

.segment "CODE"
.proc irq_handler
  RTI
.endproc

.proc reset_handler
  SEI           ; turn on interrupts
  CLD           ; turn off non-existent decimal mode
  LDX #$00
  STX PPUCTRL   ; disable NMI
  STX PPUMASK   ; turn off display

vblankwait:     ; wait for PPU to fully boot up
  BIT PPUSTATUS
  BPL vblankwait

  JMP main
.endproc

.proc nmi_handler
	; TODO: read controllers
	; TODO: update sprites
	; TODO: redraw screen
  RTI
.endproc

.proc main
  LDX PPUSTATUS   ; reset PPUADDR latch
  LDX #$3f
  STX PPUADDR
  LDX #$00
  STX PPUADDR     ; set PPU to write to $3f00 (palette ram)

copy_palettes:
  LDA palettes,x  ; use indexed addressing into palette storage
  STA PPUDATA
  INX
  CPX #$20          ; have we copied 32 values?
  BNE copy_palettes ; if no, repeat

vblankwait:       ; wait for another vblank before continuing
  BIT PPUSTATUS
  BPL vblankwait

  LDA #%00011110  ; turn on screen
  STA PPUMASK

forever:
  JMP forever     ; do nothing, forever
.endproc

.segment "RODATA"
palettes:
.byte $21, $11, $24, $20 ;light blue, medium blue, pink, white
.byte $21, $01, $0f, $31 ;light blue, 
.byte $21, $06, $16, $26 ;light blue, 
.byte $21, $09, $19, $29 ;light blue, 

.byte $21, $00, $10, $30 ;light blue, 
.byte $21, $01, $0f, $31 ;light blue, 
.byte $21, $06, $16, $26 ;light blue, 
.byte $21, $09, $19, $29 ;light blue, 

.segment "VECTORS"
.addr nmi_handler, reset_handler, irq_handler

.segment "CHR"
.incbin "blank.chr"
