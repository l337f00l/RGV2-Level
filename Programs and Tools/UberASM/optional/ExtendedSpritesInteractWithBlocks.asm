; Uberasm to make certain extended sprite interact with blocks.

; In case of custom blocks, it'll execute their "MarioFireball" code.
!InteractWithCustomBlocks = 1

; Flag used to signal that the MarioFireball code is being executed by this UberASM
; It should be a RAM address in the "Should be 00" category in the RAM map
; In the custom block you need to check for it: if 0, then it's a Mario fireball (not triggered by this uberasm),
; otherwise it's another extended sprite (triggered by this uberasm) and the value is the ext sprite slot + 1.
; For example:
; MarioFireball:
;     LDX $0DD4|!addr
;     BEQ ActualMarioFireball
;     DEX                   ; Get ext sprite slot by doing -1
;     STZ $170B|!addr,x     ; Kill the extended sprite
;     RTL
; ActualMarioFireball:
; ... other stuff           ; Do something else if it's a Mario fireball
;     RTL
; You always need to handle killing the ext sprite yourself if needed (STZ $170B,x).
!CustomInteractionFlag = $0DD4|!addr

; Set to 1 if using pages 40+ for GPS blocks
!Pages40Plus = 0

; Extended sprite numbers that will interact with blocks
ExtSpriteNumbers:
    db $0D
.end    ; Don't change this

; Act as number (low byte) ignored by the sprite (high byte is always 1 for these).
; For example, $30 will make the sprite not destroy when touching blocks that act as cement.
; Only used for vanilla blocks.
IgnoredActAs:
    db $2F,$30
.end    ; Don't change this

; :aaaa:
if !Pages40Plus == 0
    !BankPointer = read3(read3($06F690+$08)+$09)
else
    !BankPointer = read3(read3($06F690+$08)+$05)
endif

main:
    lda $9D
    ora $13D4|!addr
    bne .Return
    phb
    phk
    plb
    ldx.b #10-1
-   lda $170B|!addr,x
    beq +  
    ldy.b #(ExtSpriteNumbers_end-ExtSpriteNumbers-1)
--  cmp ExtSpriteNumbers,y
    beq ++
    dey
    bpl --
    bra +
++  jsr BlockInteract
    bcc +
    stz $170B|!addr,x
    plb
    rtl
+   dex
    bpl -
    plb
.Return
    rtl

BlockInteract:
    lda $1729|!addr,x
    xba
    lda $1715|!addr,x
    rep #$20
    clc
    adc #$0004
    and #$FFF0
    sta $98
    sep #$20
    lda $1733|!addr,x
    xba
    lda $171F|!addr,x
    rep #$20
    clc
    adc #$0004
    and #$FFF0
    sta $9A
    sep #$20
    stz $1933|!addr
    jsl GetMap16_Main
    cpy #$00
    beq .return
    cpy #$01
    beq .vanilla
if !InteractWithCustomBlocks
.custom
    phx
    inx
    stx $0DD4|!addr
    rep #$30
    sta $03
    tax                     ;\
    lda.l !BankPointer,x    ;| Check if the block was inserted with GPS
    sep #$30                ;|
    beq +                   ;/
    jsl $06F7C0|!bank
    stz $0DD4|!addr
+   plx
endif
    clc     ; Sprite erasing must be handled in the custom block.
    rts
.vanilla
    phx
    ldx.b #(IgnoredActAs_end-IgnoredActAs-1)
-   cmp IgnoredActAs,x
    bne +
    plx
    clc
    rts
+   dex
    bpl -
    dey     ; Y is always 1 here, and must be 0 for the routine.
    lda $1693|!addr
    jsl $00F160|!bank
    plx
    sec
    rts
.return
    clc
    rts
