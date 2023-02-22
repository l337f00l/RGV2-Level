init:
	REP   #$20 ; 16-bit A

	; Set transfer modes.
	LDA   #$3202
	STA   $4330 ; Channel 3
	LDA   #$3200
	STA   $4340 ; Channel 4

	; Point to HDMA tables.
	LDA   #Gradient1_RedGreenTable
	STA   $4332
	LDA   #Gradient1_BlueTable
	STA   $4342

	SEP   #$20 ; 8-bit A

	; Store program bank to $43x4.
	PHK
	PLA
	STA   $4334 ; Channel 3
	STA   $4344 ; Channel 4

	; Enable channels 3 and 4.
	LDA.b #%00011000
	TSB   $0D9F

	RTL 

; --- HDMA Tables below this line ---
Gradient1_RedGreenTable:
db $1D,$20,$40
db $02,$20,$41
db $02,$20,$42
db $02,$20,$43
db $02,$20,$44
db $02,$20,$45
db $02,$20,$46
db $02,$20,$47
db $02,$20,$48
db $02,$20,$49
db $82,$20,$4A,$20,$4B
db $02,$20,$4A
db $02,$20,$49
db $02,$20,$48
db $02,$20,$47
db $02,$20,$46
db $02,$20,$45
db $02,$20,$44
db $02,$20,$43
db $02,$20,$42
db $02,$20,$41
db $01,$20,$40
db $02,$20,$41
db $02,$20,$42
db $02,$20,$43
db $02,$20,$44
db $01,$20,$45
db $02,$20,$46
db $02,$20,$47
db $02,$20,$48
db $02,$20,$49
db $83,$20,$4A,$20,$4B,$20,$4A
db $02,$20,$49
db $02,$20,$48
db $02,$20,$47
db $02,$20,$46
db $01,$20,$45
db $02,$20,$44
db $02,$20,$43
db $02,$20,$42
db $02,$20,$41
db $02,$20,$40
db $02,$20,$41
db $02,$20,$42
db $02,$20,$43
db $02,$20,$44
db $03,$20,$45
db $02,$20,$46
db $02,$20,$47
db $02,$20,$48
db $02,$20,$49
db $02,$20,$4A
db $82,$20,$4B,$20,$4A
db $02,$20,$49
db $02,$20,$48
db $02,$20,$47
db $02,$20,$46
db $02,$20,$45
db $02,$20,$44
db $02,$20,$43
db $02,$20,$42
db $02,$20,$41
db $01,$20,$40
db $02,$20,$41
db $02,$20,$42
db $01,$20,$43
db $02,$20,$44
db $02,$20,$45
db $02,$20,$46
db $01,$20,$47
db $02,$20,$48
db $02,$20,$49
db $83,$20,$4A,$20,$4B,$20,$4A
db $02,$20,$49
db $02,$20,$48
db $02,$20,$47
db $02,$20,$46
db $02,$20,$45
db $02,$20,$44
db $02,$20,$43
db $02,$20,$42
db $02,$20,$41
db $24,$20,$40
db $00

Gradient1_BlueTable:
db $1D,$80
db $84,$81,$82,$83,$84
db $02,$85
db $8A,$86,$87,$88,$89,$8A,$8B,$8C,$8D,$8E,$8F
db $02,$90
db $82,$91,$92
db $02,$91
db $86,$90,$8F,$8E,$8D,$8C,$8B
db $02,$8A
db $86,$89,$88,$87,$86,$85,$84
db $02,$83
db $8F,$82,$81,$80,$81,$82,$83,$84,$85,$86,$87,$88,$89,$8A,$8B,$8C
db $02,$8D
db $89,$8E,$8F,$90,$91,$92,$91,$90,$8F,$8E
db $02,$8D
db $8E,$8C,$8B,$8A,$89,$88,$87,$86,$85,$84,$83,$82,$81,$80,$81
db $02,$82
db $83,$83,$84,$85
db $02,$86
db $83,$87,$88,$89
db $02,$8A
db $83,$8B,$8C,$8D
db $02,$8E
db $82,$8F,$90
db $02,$91
db $82,$92,$91
db $02,$90
db $8A,$8F,$8E,$8D,$8C,$8B,$8A,$89,$88,$87,$86
db $02,$85
db $98,$84,$83,$82,$81,$80,$81,$82,$83,$84,$85,$86,$87,$88,$89,$8A,$8B,$8C,$8D,$8E,$8F,$90,$91,$92,$91
db $02,$90
db $8A,$8F,$8E,$8D,$8C,$8B,$8A,$89,$88,$87,$86
db $02,$85
db $84,$84,$83,$82,$81
db $24,$80
db $00

main:  ; invisible Mario
LDA #$7F
STA $78
RTL