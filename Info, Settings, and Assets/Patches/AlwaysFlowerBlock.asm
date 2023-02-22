; Makes blocks 117, 118, 11F, and 120 always spawn a flower powerup (instead of mushroom) when hit in some instances.
; Unfortunately you have to choose the same sprite for all four blocks. 
; But since you have an always-mushroom and always-feather block elsewhere (see 16A-D, switch palace blocks),
; the only thing missing was a flower block.

org $0288A4 
db $75  ; vanilla $74

org $0288B5
db $75  ; vanilla db $74

