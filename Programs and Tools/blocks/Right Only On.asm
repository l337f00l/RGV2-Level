; Made by Ramp202
; A Block that will block mario on the Right Side if the On/Off Switch is On
; If the On/Off Switch is Off, it will do nothing
; Make it Act like Tile 130

print "Blocks Mario from the right if the ON/OFF switch is ON"

db $42

JMP Return1 : JMP Return1 : JMP MarioSide : JMP Return1 : JMP Return : JMP Return1 : JMP Return1
JMP Return1 : JMP Return1 : JMP Return1

MarioSide:
	LDA $14AF
	BNE Return1
	LDA $9A		;\
	AND #$08	;| If Mario is on the Right Side, Branch
	BNE Right	;/
	BRA Return1
Right:
	LDA $7B		;\ If Mario's speed is in the range
	BPL Return1	;/ of 00-7F (Going Right), Return
	RTL
Return1:
	LDA #$25
	STA $1693
	LDY #$00
Return:
	RTL