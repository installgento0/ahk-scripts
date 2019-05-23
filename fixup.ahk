#Down::WinMinimize A
#Up::
WinGet MX, MinMax, A
If MX
WinRestore A
Else WinMaximize A
return