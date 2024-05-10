#include <stdint.h>

extern uint16_t frequencies[];
extern uint16_t notes[61];
extern void rest(void);
extern void note(void);
extern void play_note(uint8_t note_num, uint16_t duration);
extern void play_rest(uint16_t duration);

void song(){
  play_note(24, 250);
  play_rest(10);
  play_note(27, 50);
  play_rest(10);
  play_note(28, 350);
  play_rest(10);
  play_note(31, 250);
  play_rest(10);
  play_note(33, 250);
  play_rest(10);
  play_note(36, 250);
  play_rest(10);
  play_note(34, 250);
  play_rest(10);
  play_note(31, 250);
  play_rest(10);
  play_note(29, 250);
  play_rest(10);
  play_note(27, 250);
  play_rest(10);
  play_note(24, 250);

  // play_note(24, 250);
  // play_rest(10);
  // play_note(26, 250);
  // play_rest(10);
  // play_note(24, 250);
  // play_rest(10);
  // play_note(31, 250);
  // play_rest(10);
  // play_note(29, 500);
  // play_rest(10);
}