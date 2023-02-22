; Code which teleports the player to a specified level when all sprites are killed.
; Can rework this to add exception, like $B9

!Level = $0103 ; The level to teleport to.
!FirstException = $B9 ; message box

;;; exit flags; 0 = no, 1 = yes
!Secondary  = 0 ; Secondary exit flag.
!Water  = 0 ; If secondary = 1, water level flag.
; If secondary = 0, midway exit flag (note: destination must use separate midway settings).

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

main:
LDX.b #!sprite_slots-1
- LDA !14C8,x
BNE .ret
DEX
BPL -
REP #$20
LDA #!Level|(((!Water<<3)|(1<<2)|(!Secondary<<1))<<8)
PHX ; begin
PHY
PHA
STZ $88
SEP #$30
JSL $03BCDC|!bank ; EXLEVEL
PLA
STA $19B8|!addr,x
PLA
ORA #$04
STA $19D8|!addr,x
LDA #$06
STA $71
PLY
PLX
.ret
RTL