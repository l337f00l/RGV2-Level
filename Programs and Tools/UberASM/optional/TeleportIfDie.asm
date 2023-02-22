 ; Note that this won't even bring up retry prompt
 ; and if you die to sprite, weird physics after transition

!LevelToTeleportTo = $103 

main:
LDA $71
CMP #$09
BNE End
REP #$20                ; \
LDA #!LevelToTeleportTo
PHX
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
End:
RTL