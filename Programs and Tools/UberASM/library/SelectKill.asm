main:
	LDA $16 ; load controller buttons
	AND #$20 ; $20 is select
	CMP #$20 ; check to see if player hit select
	BEQ HitSelect ;If the player hit select then run HitSelect
	RTL ; end
HitSelect:
	JSL $00F606 ; kill Mario :D
	RTL ; return