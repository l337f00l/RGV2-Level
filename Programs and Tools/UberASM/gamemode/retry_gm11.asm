init:
    stz $0D9F
    jsl retry_level_init_1_init
    jsl retry_level_transition_init
    rtl
