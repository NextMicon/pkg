#pragma once
#include <stdint.h>

class Spectro {
  volatile uint32_t* reg;
public:
  Spectro(volatile uint32_t* addr) : reg(addr) {}
};
