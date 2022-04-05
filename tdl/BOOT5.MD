The following can be directly entered into the TDL Zapple monitor to boot the VersaFloppy:

3E 1E D3 63 21 00 00 3E 0B D3 64 06 C8 10 FE DB 64 CB 47 20 FA 3E 01 D3 66 3E 88 D3 64 01 67 00 ED B2 ED B2 06 C8 10 FE DB 64 CB 47 20 FA E6 9D CA 00 00 18 CF 

Set your terminal character delay to 20 mS, type `S1000` and press ENTER, then paste in the above sequence. Once it has loaded, press ENTER again, type `G1000` and press ENTER. This will boot the first 5.25" drive on the controller. Example session:

```
Zapple V1.2E
>S100000-3E 00-1E 00-D3 00-63 00-21 00-00 00-00 00-3E
1008 00-0B 00-D3 00-64 00-06 00-C8 00-10 00-FE 00-DB
1010 00-64 00-CB 00-47 00-20 00-FA 00-3E 00-01 00-D3
1018 00-66 00-3E 00-88 00-D3 00-64 00-01 00-67 00-00
1020 00-ED 00-B2 00-ED 00-B2 00-06 00-C8 00-10 00-FE
1028 00-DB 00-64 00-CB 00-47 00-20 00-FA 00-E6 00-9D
1030 00-CA 00-00 00-00 00-18 00-CF 00-
>G1000


Digital Research CP/M 2.2 48K/40K TPA
VersaFloppy II BIOS

Glitch Works release 0.1
http://www.glitchwrks.com/

A>
```
