; Only toggled on press

main:
	LDA $18
	AND #$30
	BEQ +
		LDA $14AF|!addr
		EOR #$01
		STA $14AF|!addr
	+
	RTL