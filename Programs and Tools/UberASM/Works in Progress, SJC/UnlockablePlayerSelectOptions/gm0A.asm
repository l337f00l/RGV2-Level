macro call_library(i)
        PHB
        LDA.b #<i>>>16
        PHA
        PLB
        JSL <i>
        PLB
    endmacro
	

main:
%call_library(PlayerSelectTextToggle_main)
%call_library(CantChooseOther2ndPlayerOptionUntilUnlock_main)
    rtl