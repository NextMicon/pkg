#pragma once
#include "cpu.hpp"
#include <stdint.h>

class DShotM {
  volatile uint32_t* reg;
public:
  struct Req {
    uint16_t throttle;  // 0~2000
    bool telem;
  };
  struct Res {
    uint16_t rot;
    bool crc_ok;
  };
public:
  DShotM(volatile uint32_t* addr) : reg(addr) {}
  // Send Control Request
  void sendCtrl(Req req) {
    reg[0] = (req.throttle + 47) << 5 + (req.telem ? 0x10 : 0);
  }
  // Get Telemetry Responce
  Res getTelem() {
    return (Res){.rot = reg[1] >> 4, .crc_ok = reg[2]};
  }
};
