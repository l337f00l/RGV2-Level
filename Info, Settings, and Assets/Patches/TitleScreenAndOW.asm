
	; The baserom is actually setup with the capability of restoring the vanilla life system
; on a per-level basis. You can change these next two to restore the life display on the OW.

org $05DBF2        
db $6B     ; change to db $8B to restore OW life counter

org $04A530        
db $FE     ; change to db $8F to restore little X mark


org $009CB1 ; Skip Welcome To Dinosaur Land intro level
db $00 ; if you want to revert back to the original, change to E9

; Overworld scrolling

;org $048380
;db $00   ; un-comment these lines out and apply to disable looking around the overworld map