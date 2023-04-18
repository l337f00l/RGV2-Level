; Made by Ramp202
; A Block that will Block Mario on the Left Side if the On/Off Switch is On
; and it wil block mario on the right side if the On/Off Switch is Off
; Make it Act like Tile 130


print "Blocks Mario from the right if the ON/OFF switch is OFF, or from the left if the ON/OFF switch is ON"

db $42

JMP Return1 : JMP Return1 : JMP MarioSide : JMP Return1 : JMP Return : JMP Return : JMP Return
JMP Return1 : JMP Return1 : JMP Return1

MarioSide:
	LDA $14AF	;\ If the On/Off Switch
	BNE OffPosi	;/ is Off, Branch
	LDA $9A		;\
	AND #$08	;| Check If Mario is on the Left Side
	BNE Return1	;/
	LDA $7B		;\ If Mario's Speed is in the range
	BMI Return1	;/ of 80-FF (Going Left), Return
	RTL
OffPosi:
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