#pragma once
#include <stdint.h>

class AbsEnc {
  volatile uint32_t* reg;
public:
  AbsEnc(volatile uint32_t* addr) : reg(addr) {}

  // Get Angle
  uint32_t getAngle() { return reg[0]; };
};
