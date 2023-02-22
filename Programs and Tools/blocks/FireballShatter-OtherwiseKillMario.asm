; by SJandCharlieTheCat

!HurtOrKill = $00F5B7 ; change to $00F606 to instakill

db $37

JMP MarioBelow : JMP MarioAbove : JMP MarioSide
JMP SpriteV : JMP SpriteH
JMP Cape : JMP Fireball
JMP MarioCorner : JMP MarioBody : JMP MarioHead
JMP WallFeet : JMP WallBody

Cape:
RTL
MarioCorner:
MarioBody:
MarioHead:
WallFeet:
WallBody:
MarioBelow:
MarioAbove:
MarioSide:
    JSL !HurtOrKill
    RTL
SpriteV:
SpriteH:
    LDY #$10	;act like tile 130
	LDA #$30
	STA $1693
	RTL
Fireball:
    LDA $170B|!addr,x
    BEQ +
    STZ $170B|!addr,x
	LDA #$17 ; Bowser fireball sound
    STA $1DFC
    %create_smoke()
    %erase_block()
    +
    Return:
    RTL

print "Death block, but will be destroyed by a Mario fireball."