#include <gb/gb.h>
#include <stdio.h>
#include "Ecklin.c"
#include "GameCharacter.c"

struct GameCharacter ecklin;
UBYTE spriteSize = 8;

void performantdelay(UINT8 numloops)
{
  UINT8 i;
  for(i =0; i < numloops; i++) {
    wait_vbl_done();
  }
}

void moveGameCharacter(struct GameCharacter *character, UINT8 x, UINT8 y)
{
  move_sprite(character->spritids[0], x, y);
  move_sprite(character->spritids[1], x + spriteSize, y);
  move_sprite(character->spritids[2], x, y + spriteSize);
  move_sprite(character->spritids[3], x + spriteSize, y + spriteSize);
}

void setupEcklin()
{
  ecklin.x = 80;
  ecklin.y = 130;
  ecklin.width = 16;
  ecklin.height = 16;

  set_sprite_tile(0, 0);
  ecklin.spritids[0] = 0;
  set_sprite_tile(1, 1);
  ecklin.spritids[1] = 1;
  set_sprite_tile(2, 2);
  ecklin.spritids[2] = 2;
  set_sprite_tile(3, 3);
  ecklin.spritids[3] = 3;

  moveGameCharacter(&ecklin, ecklin.x, ecklin.y);
}

void main()
{
  set_sprite_data(0, 8, Ecklin);
  setupEcklin();
  SHOW_SPRITES;
  DISPLAY_ON;

  while (1)
  {
    if(joypad() & J_LEFT)
    {
      ecklin.x -= 2;
      moveGameCharacter(&ecklin, ecklin.x, ecklin.y);
    }
    if(joypad() & J_RIGHT)
    {
      ecklin.x += 2;
      moveGameCharacter(&ecklin, ecklin.x, ecklin.y);
    }

     if(joypad() & J_UP)
    {
      ecklin.y -= 2;
      moveGameCharacter(&ecklin, ecklin.x, ecklin.y);
    }

     if(joypad() & J_DOWN)
    {
      ecklin.y += 2;
      moveGameCharacter(&ecklin, ecklin.x, ecklin.y);
    }
    performantdelay(5);
  }
}