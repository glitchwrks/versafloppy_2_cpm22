The following can be directly entered into the SD Systems monitor to boot the VersaFloppy:

3E
1E
D3
63
21
00
00
3E
0B
D3
64
06
C8
10
FE
DB
64
CB
47
20
FA
3E
01
D3
66
3E
88
D3
64
01
67
00
ED
B2
ED
B2
06
C8
10
FE
DB
64
CB
47
20
FA
E6
9D
CA
00
00
18
CF


Set your terminal character delay to 20 mS. Reset the SBC-200 and press ENTER to autobaud. When you get the SD Systems monitor `.` prompt, type `E1000` and press ENTER, then paste in the above sequence. Once it has loaded, type `.`, type `G1000` and press ENTER. This will boot the first 5.25" drive on the controller. Example session:

```
.E 1000
1000 00-3E
1001 00-1E
1002 00-D3
1003 00-63
1004 00-21
1005 00-00
1006 00-00
1007 00-3E
1008 00-0B
1009 00-D3
100A 00-64
100B 00-06
100C 00-C8
100D 00-10
100E 00-FE
100F 00-DB
1010 00-64
1011 00-CB
1012 00-47
1013 00-20
1014 00-FA
1015 00-3E
1016 00-01
1017 00-D3
1018 00-66
1019 00-3E
101A 00-88
101B 00-D3
101C 00-64
101D 00-01
101E 00-67
101F 00-00
1020 00-ED
1021 00-B2
1022 00-ED
1023 00-B2
1024 00-06
1025 00-C8
1026 00-10
1027 00-FE
1028 00-DB
1029 00-64
102A 00-CB
102B 00-47
102C 00-20
102D 00-FA
102E 00-E6
102F 00-9D
1030 00-CA
1031 00-00
1032 00-00
1033 00-18
1034 00-CF
1035 00-.
.G 1000


Digital Research CP/M 2.2 64K/56K TPA
VersaFloppy II BIOS

Glitch Works release 0.1
http://www.glitchwrks.com/

A>
```
