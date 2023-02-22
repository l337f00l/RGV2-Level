macro call_library(i)
        PHB
        LDA.b #<i>>>16
        PHA
        PLB
        JSL <i>
        PLB
    endmacro
	
init:
    jsl retry_fade_to_level_init
	%call_library(backup_ow_sprites_init)
    rtl

main:
    jsl retry_fade_to_level_main
    rtl
