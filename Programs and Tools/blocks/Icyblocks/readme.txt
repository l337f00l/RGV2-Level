 Proper Iceblocks for SMW, brought to you by Ersanio
 SA-1 conversion, code optimizations and fix for vertical levels by KevinM

  First of all, make sure you make every single icy block tile act like:
   - TILE 130

  Also, make sure to move the routines/fireball_smoke.asm file inside GPS's routines folder.

  This package doesn't include:
   - Icy block GFX. Download some from SMWcentral or draw them yourself. For example, you can use these graphics: https://www.smwcentral.net/?p=section&a=details&id=19889 which were made with this block pack in mind. You can find a list.txt in this folder that works well with the default map16 included in that GFX pack.

  This package includes:
   - 1 Regular Iceblock
      (iceblock.asm)

   - 2 Ice coin block
      (icecoinblock.asm)

   - 3 Ice multiple coins block
      (icemultiplecoinquestionblock.asm)

   - 4 Ice Note Block
      (icenoteblock.asm)

   - 5 Ice On/Off block
      (iceonoffblock.asm)

   - 6 Ice coin block "from range"
      (icecoinonrange.asm)

   - 7 Ice any map16-tile block (currently set to Muncher)
      (ice_anytile_block.asm)

   - 8 32x32 Ice block which splits into four 16x16 iceblocks
      (ice_divide_topright.asm, ice_divide_topleft.asm, ice_divide_bottomright.asm, 
       ice_divide_bottomleft.asm)

   - 9 32x32 Ice block which melts down completely (no splitting)
      (ice_32x32_bottomleft.asm, ice_32x32_topright.asm, ice_32x32_topleft.asm, 
       ice_32x32_bottomright.asm)

   - 10 Frozen P-switch ice block (spawn any sprite)
      (frozen_pswitch.asm)

   - 11 Frozen Yoshi Coin
      (ice_yoshicoin_top.asm, ice_yoshicoin_bottom.asm)

   - 12 Ice block which turns into the next map16 tile when hit.
      (ice_map16++.asm)

   - 13 Ice block which turns into the previous map16 tile when hit.
      (ice_map16--.asm)

1) This blocks melts like the SMB3 Ice blocks; they don't melt with a
   turn block shatter while launching the fireball above, causing a complete
   "meltdown" of the "iceblocks". This was simply done by erasing the fireball
   when it hit the block in any way. Also, the smoke effect isn't aligned to
   a '16x16' grid; They spawn at the location of the erased fireball.

2) This block melts into a regular coin. When the P-switch is active, the coin
   is still affected by it. You could use it for puzzles and stuff!

3) This block melts into the multiple coins block. Nothing special about it, really.

4) This block melts into the note block. Also nothing special about it, really.

5) This block melts into the on/off block. Also nothing special about it, really.

6) This block is more neat. Remember when you hit a coin block, a small rolling
   coin spawns above then disappears after a while? This ice block does that too.
   You hit it, you gain the coin immediately. That's why I call it "coin-from-range".

7) You can do A LOT of stuff with this block. You could change this block into a
   muncher... coin... door... water tile... Lava tile... ...whatever else you want!
   Just change the number of !Map16tile in "ice_anytile_block.asm" to whatever
   map16 tile you want! In addition, it IS possible to change the map16 tile to
   ANOTHER custom block. This means you could have frozen mushroom blocks,
   frozen donut blocks, frozen walljump blocks, and so on.


8) This block, when hit by a fireball, splits into four 16x16 tile iceblocks.
   The 4 spawned blocks could be anything. Frozen coin iceblocks, regular
   iceblocks, whatever you want. Just change the number of !RegularIce to
   the map16 tile you want. How to set up this block:

   [A][B] this is how they should be placed in the level through direct map16
   [C][D]

   A being ice_divide_topleft.asm
   B being ice_divide_topright.asm
   C being ice_divide_bottomleft.asm
   D being ice_divide_bottomright.asm

9) This block is the same as the splitting 32x32 frozen blocks, except this one
   completely melts down into nothing! How to set up this block:

   [A][B] this is how they should be placed in the level through direct map16
   [C][D]

   A being ice_32x32_topleft.asm
   B being ice_32x32_topright.asm
   C being ice_32x32_bottomleft.asm
   D being ice_32x32_bottomright.asm

10) This block spawns a sprite of your choice. Currently, it is set to a P-switch.
    Change !sprite_number in the asm file to the sprite number you want. Change !is_custom to 1 to spawn a custom sprite.

11) This block melts into a Yoshi Coin through an any-map16-tile change. This means
    that you can also make stuff like frozen doors, stacked munchers and whatnot!
    Place ice_yoshicoin_bottom.asm as the bottom tile, and ice_yoshicoin_top.asm 
    as the top tile to get the correct effect.

12) This block changes into the next map16 tile when hit. Nothing big.

13) This block changes into the previous map16 tile when hit. Nothing big.

 That's it. Credits are not needed, but it would be nice if you credited me. :)
