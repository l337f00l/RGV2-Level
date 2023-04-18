; Made by Ramp202
; A Block that will block mario on the Right Side
; Make it Act like Tile 130

print "Blocks Mario from the right"

db $42

JMP Return1 : JMP Return1 : JMP MarioSide : JMP Return1 : JMP Return : JMP Return1 : JMP Return1
JMP Return1 : JMP Return1 : JMP Return1

MarioSide:
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