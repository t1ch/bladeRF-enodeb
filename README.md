# bladeRF-enodeb
The bladeRF-enodeb project is an open-source LTE eNodeB VHDL modem. The modem modulates and demodulates LTE radio traffic directly on the bladeRF 2.0 micro xA9’s FPGA. The bladeRF-enodeb coupled with a FAPI compatible MAC allows the bladeRF 2.0 micro xA9 to become a software defined radio eNodeB.

## Milestones
#### 4G LTE Downlink TX:
- [ ] PDSCH:
  - [x] CRC (Compute and validate)
  - [ ] Code Block Segmentation
  - [ ] Turbo Coding:
    - [ ] Constituent Encoder
    - [ ] Interleaver
    - [ ] Turbo encoder finite state machine
  - [ ] Rate Matching
  - [ ] Code block concatenation
  - [ ] Scrambling
  - [ ] Modulation
  - [ ] Layer Maping/Precoding
  - [ ] Precoding
  - [ ] Resource Element Mapping
