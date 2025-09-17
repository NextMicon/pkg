#pragma once
#include <stdint.h>

class RotEnc {
  volatile uint32_t* reg;
public:
  RotEnc(volatile uint32_t* addr) : reg(addr) {}

  // Get Angle
  uint32_t getAngle() { return reg[0]; };
};
