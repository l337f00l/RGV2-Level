; Made by Ramp202
; A Block that will block mario on the Left Side if the On/Off Switch is Off
; If the On/Off Switch is On, it will do nothing
; Make it Act like Tile 130

print "Blocks Mario from the left if the ON/OFF switch is OFF"

db $42

JMP Return1 : JMP Return1 : JMP MarioSide : JMP Return1 : JMP Return : JMP Return : JMP Return
JMP Return1 : JMP Return1 : JMP Return1

MarioSide:
	LDA $14AF
	BEQ Return1
	LDA $9A		;\
	AND #$08	;| Check If Mario is on the Left Side
	BNE Return1	;/
	LDA $7B		;\ If Mario's Speed is in the range
	BMI Return1	;/ of 80-FF (Going Left), Return
	RTL
Return1:
	LDA #$25
	STA $1693
	LDY #$00
Return:
	RTL