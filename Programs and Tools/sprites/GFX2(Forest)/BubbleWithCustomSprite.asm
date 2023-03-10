; https://bin.smwcentral.net/u/25222/spriteremap.asm

; $02D9C3 

;IF the EXTRA BIT is set to 2, you only need to set the extension byte 1, with the exact same setting as above:
;00 -> goomba
;01 -> bob-omb
;02 -> fish
;03 -> mushroom
;if (extra byte 1 > 03 && extra bit == 3) -> goes back to goomba (00) to prevent from reading from tables that don't exist
;However IF the EXTRA BIT is set to 3,you will need to set all 4 of the extension bytes and they will need to be as following:
;extension byte 1 = sprite number (the one in Lunar Magic) of the sprite to spawn, currently doesn't support custom sprites.
;extension byte 2 = YXPPCCCT properties of the 16x16 tile inside of the bubble
;extension byte 3 = number of 16x16 tile to use inside of the bubble
;extension byte 4 = !!!ONLY THE SECOND BIT!!!, if set the sprite is not edible by yoshi, if not set sprite is edible by yoshi. So basically if you write 00 it will be edible by yoshi, ;if you write 02, it won't. Keep in mind that sprites that are normally not edible will not set this automatically, for example if you put a Chuck and you don't set this byte to 02, ;it will be edible by Yoshi AND if eaten, the game will crash. It is YOUR responsibility to remember to set this bit.
;FOR THE LOVE OF EVERYTHING PLEASE DON'T SET THE FOURTH EXTENSION BYTE TO AN ODD VALUE, like 01, 03, etc.
;Quick note that the tile inside of the bubble will always be 16x16 but the bubble can spawn sprites of any size.

;;disassembled by Atari2.0, all code taken from smw-irq, made by p4plus2 along with the contribution of thomas (kaizoman) so big thanks to them. 
;;all the details for the settings of the extra bit and extension bytes at the bottom of the README: https://github.com/Atari2/smw_asm/tree/master/bubble_customized/bubble
incsrc "BubbleWithCustomSprite_tables.asm" ;;get 'em tables
;;DEFINE FOR THE README
!README = 1
;;sprite defines
!sprite = !extra_byte_1
!props = !extra_byte_2
!tiles = !extra_byte_3
!special = !extra_byte_4
assert !README != 0, "You haven't read the README, have you? Aborting insertion..."
print "INIT", pc
InitBubbleSpr:					;-----------| Bubble INIT
	%BEC(+) ;;if the extra bit is clear, use the extra byte 1 to set the sprite inside the bubble from the vanilla 4
	LDA !special,X ;;load the fourth ext. byte
	AND #$02
	LSR 
	ORA !1686,X ;set the inedible flag if bit 2 of !special is set
	STA !1686,X
	LDA !sprite,X ;if yes, load extra byte 1 to C2 without modifying it 
	TAY
	BRA .continue
	+
	LDA !extra_byte_1,X ;;safety measure, if extra byte is > 3, set it to 00
	CMP #$04
	BCS .zero
	TAY
	BRA .continue
	.zero
	LDY #$00
	.continue
	STY !C2,X					;$018567	|/
	DEC.w !1534,X				;$018569	|
	JSR FaceMario				;$01856C	|

print "MAIN ", pc

BubbleSpriteMain:				;-----------| Bubble MAIN
	PHB							;$02D8AD	|
	PHK							;$02D8AE	|
	PLB							;$02D8AF	|
	JSR CODE_02D8BB				;$02D8B0	|
	PLB							;$02D8B3	|
	RTL							;$02D8B4	|

FaceMario:						;-----------| Subroutine to make a sprite face Mario.
	%SubHorzPos()			    ;$01857C	|
	TYA							;$01857F	|
	STA.w !157C,X				;$018580	|					;			|
	RTS							;$018583	|E
	; Bubble misc RAM:
	; $C2   - Sprite inside the bubble. 0 = Goomba, 1 = Bob-omb, 2 = fish, 3 = mushroom
	; $151C - Vertical direction of acceleration. Even = down, odd = up.
	; $1534 - Timer for the bubble. Pops when it runs out.
	; $157C - Horizontal direction of movement. 0 = right, 1 = left.
CODE_02D8BB:	;-----------| Actual bubble MAIN
	LDA !15D0,X 
	BEQ .notbeingeaten
	JSR CODE_02D978
	.notbeingeaten
	LDA.w !15EA,X				;$02D8BB	|\ 
	CLC							;$02D8BE	||
	ADC.b #$14					;$02D8BF	|| Set up a 16x16 tile for the sprite inside the bubble.
	STA.w !15EA,X				;$02D8C1	||
	PHX
	JSL $0190B2				;$02D8C4	|/  call to JSL wrapper for SubSprGFX2Entry1. This routine draws a single 16x16						;$02D8C8	|
	PLX
	%BES(+)       ;if the extra bit is set, go to +
	PHX 
	LDA !C2,X					;$02D8C9	|\ 
	LDY.w !15EA,X				;$02D8CB	||
	TAX							;$02D8CE	|| Set actual YXPPCCCT for the tile.
	LDA.w BubbleSprGfxProp1,X	;$02D8CF	||
	ORA $64						;$02D8D2	||
	STA.w $0303|!addr,Y				;$02D8D4	|/
	LDA $14						;$02D8D7	|\ 
	ASL							;$02D8D9	||
	ASL							;$02D8DA	||
	ASL							;$02D8DB	||
	LDA.w BubbleSprTiles1,X		;$02D8DC	|| Set actual tile number for the tile, animating it on an 4-frame cycle.
	BCC CODE_02D8E4				;$02D8DF	||
	LDA.w BubbleSprTiles2,X		;$02D8E1	||
	BRA .no
	+
	LDY.w !15EA,X
	LDA !props,X
	ORA $64
	STA $0303|!addr,Y
	LDA $14
	ASL 
	ASL 
	ASL 
	LDA !tiles,X
	PHX
	.no
CODE_02D8E4:					;			||
	STA.w $0302|!addr,Y				;$02D8E4	|/
	PLX							;$02D8E7	|
	LDA.w !1534,X				;$02D8E8	|\ 
	CMP.b #$60					;$02D8EB	||
	BCS CODE_02D8F3				;$02D8ED	|| Draw the bubble.
	AND.b #$02					;$02D8EF	||  If the bubble's timer is close to running out, make it flash every 2 frames.
	BEQ CODE_02D8F6				;$02D8F1	||
CODE_02D8F3:					;			||
	JSR GfxRoutine				;$02D8F3	|/
CODE_02D8F6:				;			|
	LDA.w !14C8,X				;$02D8F6	|\ 
	CMP.b #$02					;$02D8F9	||
	BNE CODE_02D904				;$02D8FB	|| If the bubble hasn't been killed by... something, reset it to its normal state?
	LDA.b #$08					;$02D8FD	||  Not sure what the point of this is, but it's the reason you get a million points from throwing shells at bubbles.
	STA.w !14C8,X				;$02D8FF	||
	BRA CODE_02D96B				;$02D902	|/ 
CODE_02D904:					;			|
	LDA $9D						;$02D904	|\ Return if game frozen.
	BNE Return02D977			;$02D906	|/
	LDA $13						;$02D908	|\ 
	AND.b #$01					;$02D90A	||
	BNE CODE_02D91D				;$02D90C	||
	DEC.w !1534,X				;$02D90E	|| Decrease lifespan timer every 2 frames.
	LDA.w !1534,X				;$02D911	|| If about to run out, play the pop sound.
	CMP.b #$04					;$02D914	||
	BNE CODE_02D91D				;$02D916	||
	LDA.b #$19					;$02D918	||\ SFX for popping the bubble.
	STA.w $1DFC|!addr				;$02D91A	|//
CODE_02D91D:					;			|
	LDA.w !1534,X				;$02D91D	|\ 
	DEC A						;$02D920	|| Branch if time to erase the bubble and spawn the sprite inside.
	BEQ CODE_02D978				;$02D921	|/
	CMP.b #$07					;$02D923	|\ Return if the bubble is already popping.
	BCC Return02D977			;$02D925	|/
    LDA.b #$00
	%SubOffScreen()		;$02D927	| Process offscreen from -$40 to +$30.
	JSL $018022		;$02D92A	|\ Update X/Y position. SpriteXposNograv
	JSL $01801A		;$02D92D	|/ SpriteYposNograv
	JSL $019138     ;sprite-object interaction 
    LDY.w !157C,X				;$02D934	|\ 
	LDA.w BubbleSprXSpeed,Y		;$02D937	|| Store X speed.
	STA !B6,X					;$02D93A	|/
	LDA $13						;$02D93C	|\ 
	AND.b #$01					;$02D93E	||
	BNE CODE_02D958				;$02D940	||
	LDA.w !151C,X				;$02D942	||
	AND.b #$01					;$02D945	||
	TAY							;$02D947	|| Update Y speed every other frame.
	LDA !AA,X					;$02D948	||  If at the maximum Y speed in the current direction, invert the direction of acceleration.
	CLC							;$02D94A	||
	ADC.w BubbleSprYAccel,Y		;$02D94B	||
	STA !AA,X					;$02D94E	||
	CMP.w BubbleSprYMax,Y		;$02D950	||
	BNE CODE_02D958				;$02D953	||
	INC.w !151C,X				;$02D955	|/
CODE_02D958:					;			|
	LDA.w !1588,X				;$02D958	|\ Branch if hitting a block.
	BNE CODE_02D96B				;$02D95B	|/
	JSL $018032		        	;$02D95D	| Process sprite interaction.
	JSL $01A7DC         		;$02D961	|\ Return if not being touching by Mario.
	BCC Return02D9A0			;$02D965	|/
	STZ $7D						;$02D967	|\ Clear Mario's speed.
	STZ $7B						;$02D969	|/
CODE_02D96B:					;```````````| Bubble has been hit.
	LDA.w !1534,X				;$02D96B	|\ 
	CMP.b #$07					;$02D96E	||
	BCC Return02D977			;$02D970	|| Drop its lifespan timer down so it pops.
	LDA.b #$06					;$02D972	||
	STA.w !1534,X				;$02D974	|/
Return02D977:					;			|
	RTS							;$02D977	|


CODE_02D978:	;```````````| Erasing the bubble and replacing it with the sprite inside.					
	%BEC(+++) ;;if the extra bit is clear, don't check if it's special and just load c2 in Y
	PHY 
	JSR isSpecial  ;checking if it's a special sprite or not
	PLY
	LDA !sprite,X  ;if not, use C2,X for the sprite number to spawn
	BRA .no2
	+++
	LDY !C2,X
	LDA.w BubbleSprites,Y		;$02D97A	|| Get the sprite to spawn.
	STA !9E,X
	PHA 
	JSL $07F7D2
	BRA .nothrow
	.no2
	STA !9E,X					;$02D97D	|/
	PHA							;$02D97F	|
	LDA !special,X
	AND #$01
	BEQ .notspecial 
	LDA #$09
	STA !14C8,X
	.notspecial
	JSL $07F7D2		;$02D980	| Initialize the new sprite.
	LDA !special,X
	AND #$01
	BNE .nothrow
	LDA #$01					;set this to 1 because SMW is dumb
	STA !14C8,X
	.nothrow							;$02D984	|
	PLY 
	LDA.b #$20					;$02D985	|\ 
	CPY.b #$74					;$02D987	||
	BNE CODE_02D98D				;$02D989	|| Disable contact for the sprite with Mario for a bit.
	LDA.b #$04					;$02D98B	||
CODE_02D98D:					;			||
	STA.w !154C,X				;$02D98D	|/
	LDA !9E,X					;$02D990	|\ 
	CMP.b #$0D					;$02D992	|| Initialize the Bob-Omb's stun timer.
	BNE CODE_02D999				;$02D994	||
	DEC.w !1540,X				;$02D996	|/
CODE_02D999:					;			|
	%SubHorzPos()			;$02D999	|\ 
	TYA							;$02D99C	|| Turn the sprite towards Mario.
	STA.w !157C,X				;$02D99D	|/
Return02D9A0:					;			|
	RTS							;$02D9A0	|

GfxRoutine:					;-----------| Bubble GFX routine.
	%GetDrawInfo()			;$02D9D6	|
	LDA $14						;$02D9D9	|\ 
	LSR							;$02D9DB	||
	LSR							;$02D9DC	||
	LSR							;$02D9DD	|| $02 = index to the offset tables for each frame of animation.
	AND.b #$03					;$02D9DE	||
	TAY							;$02D9E0	||
	LDA.w DATA_02D9D2,Y			;$02D9E1	||
	STA $02						;$02D9E4	|/
	LDA.w !15EA,X				;$02D9E6	|
	SEC							;$02D9E9	|
	SBC.b #$14					;$02D9EA	|
	STA.w !15EA,X				;$02D9EC	|
	TAY							;$02D9EF	|
	PHX							;$02D9F0	|
	LDA.w !1534,X				;$02D9F1	|\ $03 = Timer for the popping animation.
	STA $03						;$02D9F4	|/
	LDX.b #$04					;$02D9F6	|| Number of tiles to use for the bubble (excluding the sprite inside).
CODE_02D9F8:					;			|
	PHX							;$02D9F8	|
	TXA							;$02D9F9	|
	CLC							;$02D9FA	|
	ADC $02						;$02D9FB	|
	TAX							;$02D9FD	|
	LDA $00						;$02D9FE	|\ 
	CLC							;$02DA00	|| Store X position to OAM.
	ADC.w BubbleTileDispX,X		;$02DA01	||
	STA.w $0300|!addr,Y				;$02DA04	|/
	LDA $01						;$02DA07	|\ 
	CLC							;$02DA09	|| Store Y position to OAM.
	ADC.w BubbleTileDispY,X		;$02DA0A	||
	STA.w $0301|!addr,Y				;$02DA0D	|/
	PLX							;$02DA10	|
	LDA.w BubbleTiles,X			;$02DA11	|\ Store tile number to OAM.
	STA.w $0302|!addr,Y				;$02DA14	|/
	LDA.w BubbleGfxProp,X		;$02DA17	|\ 
	ORA $64						;$02DA1A	|| Store YXPPCCCT to OAM.
	STA.w $0303|!addr,Y				;$02DA1C	|/
	LDA $03						;$02DA1F	|\ 
	CMP.b #$06					;$02DA21	|| If popping the bubble, change the tile number and YXPPCCCT.
	BCS CODE_02DA37				;$02DA23	||
	CMP.b #$03					;$02DA25	||
	LDA.b #$02					;$02DA27	||\ 
	ORA $64						;$02DA29	||| Change YXPPCCCT.
	STA.w $0303|!addr,Y				;$02DA2B	||/
	LDA.b #$64					;$02DA2E	||\\ Tile A to use for the bubble's pop animation.
	BCS CODE_02DA34				;$02DA30	|||
	LDA.b #$66					;$02DA32	|||| Tile B to use for the bubble's pop animation.
CODE_02DA34:					;			|||
	STA.w $0302|!addr,Y				;$02DA34	|//
CODE_02DA37:					;			|
	PHY							;$02DA37	|
	TYA							;$02DA38	|\ 
	LSR							;$02DA39	||
	LSR							;$02DA3A	|| Set size for the tile
	TAY							;$02DA3B	||
	LDA.w BubbleSize,X			;$02DA3C	||
	STA.w $0460|!addr,Y				;$02DA3F	|/
	PLY							;$02DA42	|
	INY							;$02DA43	|\ 
	INY							;$02DA44	||
	INY							;$02DA45	|| Loop for all of the tiles.
	INY							;$02DA46	||
	DEX							;$02DA47	||
	BPL CODE_02D9F8				;$02DA48	|/
	PLX							;$02DA4A	|
	LDY.b #$FF					;$02DA4B	|\ 
	LDA.b #$04					;$02DA4D	|| Upload 5 manually-sized tiles.
	JSL $01B7B3					;$02B7A7	|/ ;finish OAM write
	RTS							;$02B7AB	|
isSpecial: ;;this routine is just here to see if the sprite is either a throwblock sprite or a shell and set stuff accordingly, especially bit 1 of !extra_byte_4
	LDA !special,X
	AND #$02
	STA !special,X
	%BEC(.end)  ;;if the extra bit is clear what are you even doing here, go home
	LDA !sprite,X
	CMP #$53
	BEQ .set
	LDY #$05
	.loop
	LDA !sprite,X
	CMP SpecialSprites,Y
	BNE .skip
	SEC 
	SBC #$D6
	STA !sprite,X
	.set
	LDA !special,X
	ORA #$01
	STA !special,X
	BRA .end
	.skip
	DEY
	BPL .loop 
	.end
	RTS 