#include <stdint.h>
#include <stdbool.h>

#define X1(arg) { arg; }
#define X2(arg) { arg; arg; }
#define X3(arg) { arg; arg; arg; }
#define X4(arg) { arg; arg; arg; arg; }
#define X5(arg) { arg; arg; arg; arg; arg; }
#define X6(arg) { arg; arg; arg; arg; arg; arg; }
#define X7(arg) { arg; arg; arg; arg; arg; arg; arg; }
#define X8(arg) { arg; arg; arg; arg; arg; arg; arg; arg; }
#define X9(arg) { arg; arg; arg; arg; arg; arg; arg; arg; arg; }
#define X10(arg) { arg; arg; arg; arg; arg; arg; arg; arg; arg; arg; }
#define X100(arg) X10(X10(arg))
#define X1000(arg) X10(X10(X10(arg)))

#define NOP asm("NOP")


void note(int note)

{
  // NOP takes two clock cycles
  // 1,023,000 Hz clock speed
  // Clock Speed/Desired Note frequency/2 (cycles per NOP) - 2 (4 cycle offset for BIT) = How many NOPS to play this frequency

  // BIT takes 4 cycles
  uint16_t jmp_address = 0x100;
  //  0xC030 => Magic Memory address to drive speaker once
  // C2: 7818 NOP between driving speakers
  int i;
  while(true)
  {
    asm("BIT $C030");
    X7(X1000(NOP));
    X8(X100(NOP));
    X1(X10(NOP));
    X8(NOP);
  };
};
