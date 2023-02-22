; Increments a counter whenever you bounce on an enemy (and/or get a 1-up)

!AddressToSet = $13CC ; $13CC, coin count

Print "INIT ",pc
Print "MAIN ",pc


LDA $1DF9|!addr
CMP #$13 
BCC .Ret
LDA $1DF9|!addr
CMP #$1A ; $19+1
BCS .Ret
INC !AddressToSet ; or DEC, or LDA, etc. 
BRA End
.Ret
LDA $1DFC|!addr
CMP #$05 ; one-up sound
BNE End
INC !AddressToSet ; or DEC, or LDA, etc. 
End:
RTL