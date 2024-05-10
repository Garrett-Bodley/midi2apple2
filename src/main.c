#include <stdio.h>
#include <stdint.h>
#include <stdbool.h>

#include "../include/song.h"

extern void rest(void);
extern void note(void);


// NOP takes 2 clock cycles
// 1,023,000 Hz clock speed
// Clock Speed/Desired Note frequency/2/2 (cycles per NOP) - 2 (4 cycle offset for BIT) = How many NOPS to play this frequency
// -9 offset for overhead after BIT
// jump offset = longest cycle count - cycles needed for current note



// BIT takes 4 cycles

uint16_t frequencies[] = {
  65,
  69,
  73,
  77,
  82,
  87,
  92,
  97,
  103,
  110,
  116,
  123,
  130,
  138,
  146,
  155,
  164,
  174,
  184,
  195,
  207,
  220,
  233,
  246,
  261,
  277,
  293,
  311,
  329,
  349,
  369,
  391,
  415,
  440,
  466,
  493,
  523,
  554,
  587,
  622,
  659,
  698,
  739,
  783,
  830,
  880,
  932,
  987,
  1046,
  1108,
  1174,
  1244,
  1318,
  1396,
  1479,
  1567,
  1661,
  1760,
  1864,
  1975,
  2093,
};

uint16_t notes[61];

void init_notes()
{
  int i;
  for(i = 0; i < 61; i++)
  {
    notes[i] = 3902 - (1023000/frequencies[i]/2/2 - 9);
  }
  notes[0] = 0;
}

void play_note(uint8_t note_num, uint16_t duration)
{
  uint16_t* jump_address = 0x00;
  uint16_t* dur_ptr = 0x02;

  *jump_address = ((uint16_t)note) + notes[note_num];
  *dur_ptr = duration;
  note();
}

void play_rest(uint16_t duration)
{
  uint16_t* dur_ptr = 0x04;
  *dur_ptr = duration;
  rest();
}

int main(void)
{
  init_notes();
  song();

  while(true){};
  return 0;
}