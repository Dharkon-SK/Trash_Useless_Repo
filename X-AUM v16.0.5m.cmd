@echo off
title Xbox Among Us Menu (v16.0.5m)
setlocal enabledelayedexpansion

:: Caracteres de control
for /f %%x in ('"prompt $E & for %%y in (0) do rem"') do (set ESC=%%x)
for /f %%x in ('"prompt $H & for %%y in (0) do rem"') do (set BS=%%x)
set /p NULL=<nul
set true=1
set false=0

:: Path al hack
set HACK_FILE=%~f0

:: Constantes
set /a INT_LIMIT=0x7FFFFFFF
set MEM_COMMIT=0x1000
set PAGE_READWRITE=0x04

if /i "%~1" == "Execute-Thread" (call :%~2 %3 %4 %5 %6 %7 %8 %9 & exit)

call :VolatileLog Configure-System BUFFER_SIZE = 9
call :VolatileLog Configure-System MAX_LENGTH = 46

call :VolatileLog Configure-System POS_X = 7
call :VolatileLog Configure-System POS_Y = 11

for /f "tokens=1,2,5 delims=," %%a in ('tasklist /fi "imagename eq Among Us.exe" /fo csv /nh') do (
      if /i "%%~b" == "%NULL%" (
         mode con: cols=60 lines=40 >nul
         call :VolatileLog Add-LogToBuffer Warning "Among Us.exe no esta corriendo"
         call :VolatileLog Add-LogToBuffer Warning "Solicitando PID..."
         echo %ESC%[02;22f%ESC%[38;5;75mXbox Among Us Menu
         echo %ESC%[04;05f%ESC%[97mX-AUM es una poderosa utilidad creada para dar una
         echo %ESC%[05;05f%ESC%[97mmejor experiencia de juego al usuario, agregando
         echo %ESC%[06;05f%ESC%[97mmas caracteristiscas al juego y controlando todo
         echo %ESC%[07;05f%ESC%[97mdesde el terminal.
         echo %ESC%[11;11f%ESC%[38;5;40m\\\      ///
         echo %ESC%[12;11f%ESC%[38;5;40m \\\    ///
         echo %ESC%[13;11f%ESC%[38;5;40m  \\\  ///
         echo %ESC%[14;11f%ESC%[38;5;40m   \\\///      %ESC%[38;5;55m#####   %ESC%[38;5;56m##    ##  %ESC%[38;5;57m##    ##
         echo %ESC%[15;11f%ESC%[38;5;40m   ///\\\     %ESC%[38;5;55m##   ##  %ESC%[38;5;56m##    ##  %ESC%[38;5;57m###  ###
         echo %ESC%[16;11f%ESC%[38;5;40m  ///  \\\    %ESC%[38;5;55m#######  %ESC%[38;5;56m##    ##  %ESC%[38;5;57m## ## ##
         echo %ESC%[17;11f%ESC%[38;5;40m ///    \\\   %ESC%[38;5;55m##   ##  %ESC%[38;5;56m##    ##  %ESC%[38;5;57m##    ##
         echo %ESC%[18;11f%ESC%[38;5;40m///      \\\  %ESC%[38;5;55m##   ##   %ESC%[38;5;56m######   %ESC%[38;5;57m##    ##
         echo %ESC%[26;5f%ESC%[38;5;172m------------- ^| Creado por Dharkon SK ^| -------------
         echo %ESC%[30;05f%ESC%[31mNota: %ESC%[97mEste menu para Among Us es totalmente gratis
         echo %ESC%[31;05fy funciona solo en la version 16.0.5m
         set /p GameProc="%ESC%[22;05fProceso del juego (PID) > %ESC%[22;31f%ESC%[90m"
         echo %ESC%[?25l
         for /f "tokens=1,2,5 delims=," %%x in ('tasklist /fi "PID eq !GameProc!" /fo csv /nh 2^>nul') do (
            if /i "%%~y" == "%NULL%" (
               echo %ESC%[23;05f%ESC%[31mNo se encontro el proceso del juego
               pause >nul
               exit
            ) else (
               call :VolatileLog Add-LogToBuffer Information "PID encontrado: !ProcessID!"
               set ProcessID=%%~y
               echo.%ESC%[?25l
               goto Config
            )
         )
      ) else (
         set ProcessID=%%~b
         call :VolatileLog Add-LogToBuffer Information "PID encontrado: !ProcessID!"
      )
   )

echo.%ESC%[?25l
if /i "%~1" == "Execute-Cheat-Thread" (call :AmongUsMenuThread[%~2] & exit)
goto Config

:ReadProcessMemoryCMD
   if defined %~4 (set %~4=%NULL%)
   for /f "delims=" %%x in ('powershell -ex bypass -nol -nop -noni -c "Add-Type -TypeDefinition 'using System; using System.Runtime.InteropServices; public class WinAPI { [DllImport(\"kernel32.dll\")] public static extern IntPtr OpenProcess(UInt32 dwDesiredAccess, bool bInheritHandle, UInt32 dwProcessId); [DllImport(\"kernel32.dll\")] public static extern bool ReadProcessMemory(IntPtr hProcess, IntPtr lpBaseAddress, byte[] lpBuffer, int dwSize, out IntPtr lpNumberOfBytesRead); [DllImport(\"kernel32.dll\")] public static extern bool CloseHandle(IntPtr hObject); }'; $ProcessHandle = [WinAPI]::OpenProcess(0x1F0FFF, $false, %~1); $buffer = New-Object byte[] %~3; $BytesRead = [IntPtr]::Zero; $null = [WinAPI]::ReadProcessMemory($processHandle, %~2, $buffer, $buffer.Length, [ref]$BytesRead); ($buffer | ForEach-Object { $_.ToString('X2') }); $Null = [WinAPI]::CloseHandle($ProcessHandle);"') do (
      set %~4=!%~4! 0x%%x
   )
goto :eof

:WriteProcessMemoryCMD
   powershell -ex bypass -nol -nop -noni -c "Add-Type -TypeDefinition 'using System; using System.Runtime.InteropServices; public class WinAPI { [DllImport(\"kernel32.dll\")] public static extern IntPtr OpenProcess(UInt32 dwDesiredAccess, bool bInheritHandle, UInt32 dwProcessId); [DllImport(\"kernel32.dll\")] public static extern bool WriteProcessMemory(IntPtr hProcess, IntPtr lpBaseAddress, byte[] lpBuffer, int nSize, out IntPtr lpNumberOfBytesWritten); [DllImport(\"kernel32.dll\")] public static extern bool CloseHandle(IntPtr hObject); }'; $ProcessHandle = [WinAPI]::OpenProcess(0x1F0FFF, %false%, %~1); $NewData = [BitConverter]::GetBytes([%~2]%~3); [WinAPI]::WriteProcessMemory($ProcessHandle, [IntPtr]%~4, $NewData, $NewData.Length, [ref]([IntPtr]::Zero)); [WinAPI]::CloseHandle($ProcessHandle);" >nul 2>nul
goto :eof

:VirtualAllocExCMD
   if /i "%~2" == "%NULL%" (set WinAPI.VirtualAllocExCMD.tmp=[IntPtr]::Zero) else (set WinAPI.VirtualAllocExCMD.tmp=%~2)
   for /f "tokens=*" %%x in ('powershell -ex bypass -nol -nop -noni -c "Add-Type -TypeDefinition 'using System; using System.Runtime.InteropServices; public class WinAPI { [DllImport(\"kernel32.dll\")] public static extern IntPtr OpenProcess(UInt32 dwDesiredAccess, bool bInheritHandle, int dwProcessId); [DllImport(\"kernel32.dll\")] public static extern IntPtr VirtualAllocEx(IntPtr hProcess, IntPtr lpAddress, uint dwSize, uint flAllocationType, uint flProtect); [DllImport(\"kernel32.dll\")] public static extern bool IsWow64Process(IntPtr hProcess, out bool wow64Process); }'; $ProcessHandle = [WinAPI]::OpenProcess(0x1F0FFF, $false, %~1); $MemoryAlloc = [WinAPI]::VirtualAllocEx($ProcessHandle, !WinAPI.VirtualAllocExCMD.tmp!, %~3, %~4, %~5); $ProcBool = %true%; [WinAPI]::IsWow64Process($ProcessHandle, [ref]$ProcBool); if ($ProcBool -eq %false%) { '{0:X}' -f $MemoryAlloc.ToInt64() } else { '{0:X}' -f $MemoryAlloc.ToInt32() }"') do (
      set %~6=0x%%x
   )
   set WinAPI.VirtualAllocExCMD.tmp=%NULL%
goto :eof

:MultiGetPointers
   set element_count=0

   for /f "delims=" %%x in ('powershell -ex bypass -nol -nop -noni -c "Add-Type 'using System; using System.Runtime.InteropServices; public class WinAPI { [DllImport(\"kernel32.dll\")] public static extern IntPtr OpenProcess(int access, bool inherit, int pid); [DllImport(\"kernel32.dll\")] public static extern bool ReadProcessMemory(IntPtr hProc, IntPtr addr, byte[] buffer, int size, out int read); [DllImport(\"kernel32.dll\")] public static extern bool CloseHandle(IntPtr handle); }'; $proc = Get-Process -Id %~1; $module = $proc.Modules | Where-Object { $_.ModuleName -ieq '%~2' }; $chains = '!%~3!' -split ';'; ForEach($c in $chains) { $offs = ($c -split ',') | ForEach-Object { $_.Trim() -as [Int64] }; $addr = [Int64]$module.BaseAddress + $offs[0]; $ProcessHandle = [WinAPI]::OpenProcess(0x10, $false, $proc.Id); for ($i = 1; $i -lt $offs.Count; $i++) { $buf = New-Object byte[] 8; [WinAPI]::ReadProcessMemory($ProcessHandle, [IntPtr]$addr, $buf, 8, [ref]0) | Out-Null; $addr = [BitConverter]::ToInt64($buf, 0) + $offs[$i]; }; $null = [WinAPI]::CloseHandle($ProcessHandle); Write-Output ('0x{0:X}' -f $addr) }"') do (
      set /a element_count+=1
      if /i "%~4" == "-SaveAs" (
         set %~5[!element_count!].IntPtr=%%x
      )
   )
   set element_count=%NULL%
goto :eof

:FileDialog
   for /f "tokens=*" %%x in ('powershell -ex bypass -nol -nop -noni -c "Add-Type -AssemblyName System.Windows.Forms; $dialog = New-Object System.Windows.Forms.OpenFileDialog; $dialog.Filter = '%~1'; $dialog.Title = '%~2'; $dialog.Multiselect = $false; $dialog.ShowDialog(); Write-Output $dialog.FileName;"') do (
      set %~3=%%x
   )
goto :eof

:InjectLibraryMalloc
   powershell -ex bypass -nol -nop -noni -c "Add-Type -TypeDefinition 'using System; using System.Runtime.InteropServices; public class WinAPI { [DllImport(\"kernel32.dll\")] public static extern IntPtr OpenProcess(UInt32 dwDesiredAccess, bool bInheritHandle, int dwProcessId); [DllImport(\"kernel32.dll\")] public static extern bool WriteProcessMemory(IntPtr hProcess, IntPtr lpBaseAddress, byte[] buffer, uint size, out IntPtr lpNumberOfBytesWritten); [DllImport(\"kernel32.dll\")] public static extern IntPtr CreateRemoteThread(IntPtr hProcess, IntPtr lpThreadAttributes, uint dwStackSize, IntPtr lpStartAddress, IntPtr lpParameter, uint dwCreationFlags, out IntPtr lpThreadId); [DllImport(\"kernel32.dll\")] public static extern IntPtr GetProcAddress(IntPtr hModule, string lpProcName); [DllImport(\"kernel32.dll\")] public static extern IntPtr GetModuleHandle(string lpModuleName); }'; $ProcessHandle = [WinAPI]::OpenProcess(0x1F0FFF, $false, %~1); $bytes = [System.Text.Encoding]::ASCII.GetBytes('%~2' + [char]0); [WinAPI]::WriteProcessMemory($ProcessHandle, %~3, $bytes, %~4, [ref]([IntPtr]::Zero)); $LoadLibraryAddress = [WinAPI]::GetProcAddress([WinAPI]::GetModuleHandle('kernel32.dll'), 'LoadLibraryA'); [WinAPI]::CreateRemoteThread($ProcessHandle, [IntPtr]::Zero, 0, $LoadLibraryAddress, %~3, 0, [ref]([IntPtr]::Zero));" >nul 2>nul
goto :eof

:HexToStr
   for %%x in (%~1) do (
      set /a dec[x]=%%x
      cmd /c exit /b !dec[x]! >nul 2>nul
      set %~2=!%~2!!=ExitCodeASCII!
   )
goto :eof

:HexToStr
   for %%x in (%~1) do (
      set /a HexToStr.Byte.Dword=%%x
      cmd /c exit /b !HexConverter.Byte.Dword! >nul 2>nul
      set %~2=!%~2!!=ExitCodeASCII!
   )
goto :eof

:HexToInt
   set HexToInt.ElementCount=1
   for %%x in (%~1) do (
      set /a HexToInt.Byte[!HexToInt.ElementCount!]=%%x
      set /a HexToInt.ElementCount+=1
   )
   set /a %~2=(HexToInt.Byte[4] ^<^< 24) ^| (HexToInt.Byte[3] ^<^< 16) ^| ^(HexToInt.Byte[2] ^<^< 8) ^| HexToInt.Byte[1]
   set HexToInt.ElementCount=%NULL%
goto :eof

:HexToFloat
   set HexToFloat.ElementCount=1

   for %%x in (%~1) do (
      set /a HexToFloat.Byte[!HexToFloat.ElementCount!]=%%x
      set /a HexToFloat.ElementCount+=1
   )

   set /a HexToFloat.Raw=^(HexToFloat.Byte[4] ^<^< 24^) ^| ^(HexToFloat.Byte[3] ^<^< 16^) ^| ^(HexToFloat.Byte[2] ^<^< 8^) ^| HexToFloat.Byte[1]

   set /a HexToFloat.Exp=^(HexToFloat.Raw ^>^> 23^) ^& 255
   set /a HexToFloat.Exp-=127

   set /a HexToFloat.Mant=^(HexToFloat.Raw ^& 0x7FFFFF^) ^| ^(1 ^<^< 23^)
   set /a HexToFloat.Sign=^(HexToFloat.Raw ^>^> 31^) ^& 1

   if !HexToFloat.Exp! LSS 0 (
      set %~2=0
   ) else if !HexToFloat.Exp! GEQ 31 (
      set %~2=2147483647
   ) else if !HexToFloat.Exp! GTR 23 (
      set /a %~2=^(HexToFloat.Mant ^<^< ^(!HexToFloat.Exp! - 23^)^)
   ) else (
      set /a %~2=^(HexToFloat.Mant ^>^> ^(23 - !HexToFloat.Exp!^)^)
   )

   if !HexToFloat.Sign! EQU 1 (
      set /a %~2*=-1
   )

   set HexToFloat.ElementCount=%NULL%

goto :eof

:GetStringLength
   set %~1.tmp=!%~1!
   set %~1.length=%NULL%
   if /i "!%~1.tmp!" == "%NULL%" (set /a %~1.length=0 & goto :eof)
   for /l %%x in (1,1,8192) do (
      set %~1.tmp=!%~1.tmp:~1!
      set /a %~1.length+=1
      if /i "!%~1.tmp!" == "%NULL%" (goto :eof)
   )
goto :eof

:FrameSleep
   for /l %%x in (1,1,%~1) do rem
goto :eof

:GetAddresses
   for %%x in (
      "0x03292F60, 0x40, 0xC8, 0x8, 0xB8, 0x0, 0x48, 0x20;"
      "0x03273018, 0x40, 0x90, 0x78, 0xB8, 0x0, 0x40, 0x20;"
      "0x32A9EF0, 0xC0, 0x138, 0x20, 0xB8, 0x20, 0x40, 0x54;"
      "0x03292DE0, 0x40, 0xC8, 0x8, 0xB8, 0x10, 0x30, 0x2C;"
      "0x032B9FA8, 0x1D0, 0x98, 0x430, 0x78, 0xB8, 0x0, 0xB8;"
      "0x03276DD8, 0xB8, 0x0, 0x10, 0xA8, 0x28, 0x78, 0x78;"
      "0x0328A6C0, 0x90, 0x28, 0xB8, 0x18, 0x10, 0x28, 0x23C;"
      "0x0324DB00, 0xC8, 0xD0, 0xB8, 0x0, 0x40, 0x30, 0x10;"
   ) do (
      set GameAssembly.AddressList.PointerChains=!GameAssembly.AddressList.PointerChains! %%~x
   )

   for %%x in (
      "0x01CE3038, 0x2E0, 0x18, 0x48, 0x60, 0xC0, 0x80, 0x2C;"
      "0x01C7EA30, 0x30, 0x28, 0x0, 0x0, 0x20, 0x60, 0x30;"
   ) do (
      set UnityPlayer.AddressList.PointerChains=!UnityPlayer.AddressList.PointerChains! %%~x
   )

   call :MultiGetPointers !ProcessID! "GameAssembly.dll" GameAssembly.AddressList.PointerChains -SaveAs GameAssembly.MemoryAddress
   call :MultiGetPointers !ProcessID! "UnityPlayer.dll" UnityPlayer.AddressList.PointerChains -SaveAs UnityPlayer.MemoryAddress

   set adr[speed]=!GameAssembly.MemoryAddress[1].IntPtr!&rem                Velocidad del jugador
   set adr[player_color]=!GameAssembly.MemoryAddress[2].IntPtr!&rem         Color del jugador
   set adr[vote_time]=!GameAssembly.MemoryAddress[3].IntPtr!&rem            Timer de la votacion
   set adr[kill_cooldown][0]=!GameAssembly.MemoryAddress[4].IntPtr!&rem     Timer entre asesinatos (Configuracion)
   set adr[kill_cooldown][1]=!GameAssembly.MemoryAddress[5].IntPtr!&rem     Timer entre asesinatos (En tiempo real)
   set adr[is_dead]=!GameAssembly.MemoryAddress[6].IntPtr!&rem              Flag de muerte
   set adr[meetings_counter]=!GameAssembly.MemoryAddress[7].IntPtr!&rem     Reuniones urgentes pendientes
   set adr[sabotage_cooldown]=!GameAssembly.MemoryAddress[8].IntPtr!&rem    Cooldown de sabotaje

   set adr[pos_x]=!UnityPlayer.MemoryAddress[1].IntPtr!&rem                 Posicion X del jugador
   set adr[pos_y]=!UnityPlayer.MemoryAddress[2].IntPtr!&rem                 Posicion Y del jugador
goto :eof

:ChangePlayerSpeed
   :Loop[1]
      echo %ESC%[97m%ESC%[20;40f(%ESC%[96mx!actual_speed!%ESC%[97m) 
      choice /c:asd /n >nul 2>nul
      if /i "!errorlevel!" == "1" (if !actual_speed! gtr 1 (set /a actual_speed-=1))
      if /i "!errorlevel!" == "2" (
         call :WriteProcessMemoryCMD !ProcessID! Float !actual_speed! !adr[speed]!
         goto :eof
      )
      if /i "!errorlevel!" == "3" (if !actual_speed! lss 20 (set /a actual_speed+=1))
   goto Loop[1]
   )
goto :eof

:VectorControlSystem
   set vect_options_selected=1
   :Loop[2]
      if /i "!vect_options_selected!" == "1" (echo %ESC%[13;41f%ESC%[97m[%ESC%[106mVer%ESC%[0m%ESC%[97m ^| Cambiar])
      if /i "!vect_options_selected!" == "2" (echo %ESC%[13;41f%ESC%[97m[Ver ^| %ESC%[106mCambiar%ESC%[0m%ESC%[97m])
      choice /c:asd /n >nul 2>nul
      if /i "!errorlevel!" == "1" (set vect_options_selected=1)
      if /i "!errorlevel!" == "2" (goto Break[1])
      if /i "!errorlevel!" == "3" (set vect_options_selected=2)
   goto Loop[2]
   :Break[1]
      echo %ESC%[13;41f                  
      if /i "!vect_options_selected!" == "1" (
         call :ReadProcessMemoryCMD !ProcessID! !adr[pos_x]! 4 actual_x.hex
         call :ReadProcessMemoryCMD !ProcessID! !adr[pos_y]! 4 actual_y.hex
         call :HexToFloat "!actual_x.hex!" actual_x
         call :HexToFloat "!actual_y.hex!" actual_y
         goto :eof
      )
      if /i "!vect_options_selected!" == "2" (
         echo !ESC![13;41f                  
         set /p new_x="%ESC%[13;41f%ESC%[97mX: %ESC%[96m%ESC%[?25h"
         echo !ESC![13;41f%ESC%[12X
         set /p new_y="%ESC%[13;41f%ESC%[97mY: %ESC%[96m%ESC%[?25h"
         echo %ESC%[?25l%ESC%[13;41f%ESC%[12X
         <nul start /b "" cmd /q /c "%HACK_FILE%" Execute-Thread WriteProcessMemoryCMD !ProcessID! Float !new_x! !adr[pos_x]!
         <nul start /b "" cmd /q /c "%HACK_FILE%" Execute-Thread WriteProcessMemoryCMD !ProcessID! Float !new_y! !adr[pos_y]!
         set actual_x=!new_x!&set new_x=%NULL%
         set actual_y=!new_y!&set new_y=%NULL%
         timeout /nobreak 1 >nul
         goto :eof
      )
goto :eof

:PrintPlayerColor
   if %~1 == 0 (set PlayerActualColor=198;17;17)
   if %~1 == 1 (set PlayerActualColor=19;46;210)
   if %~1 == 2 (set PlayerActualColor=17;128;45)
   if %~1 == 3 (set PlayerActualColor=238;84;187)
   if %~1 == 4 (set PlayerActualColor=240;125;13)
   if %~1 == 5 (set PlayerActualColor=246;246;87)
   if %~1 == 6 (set PlayerActualColor=63;71;78)
   if %~1 == 7 (set PlayerActualColor=215;225;241)
   if %~1 == 8 (set PlayerActualColor=107;47;188)
   if %~1 == 9 (set PlayerActualColor=113;73;30)
   if %~1 == 10 (set PlayerActualColor=56;255;221)
   if %~1 == 11 (set PlayerActualColor=80;240;57)
   if %~1 == 12 (set PlayerActualColor=95;29;46)
   if %~1 == 13 (set PlayerActualColor=236;192;211)
   if %~1 == 14 (set PlayerActualColor=240;231;168)
   if %~1 == 15 (set PlayerActualColor=117;133;147)
   if %~1 == 16 (set PlayerActualColor=145;136;119)
   if %~1 == 17 (set PlayerActualColor=215;100;100)
   if %~1 geq 18 (set PlayerActualColor=29)
   echo %ESC%[24;27f%ESC%[48;2;!PlayerActualColor!m  %ESC%[0m
goto :eof

:GetTypeEntry
   set type_selected=1
   :Loop[4]
      if /i "!type_selected!" == "1" (echo %ESC%[97m%ESC%[28;07f[%ESC%[7mINT%ESC%[27m ^| BOOL ^| FLOAT])
      if /i "!type_selected!" == "2" (echo %ESC%[97m%ESC%[28;07f[INT ^| %ESC%[7mBOOL%ESC%[27m ^| FLOAT])
      if /i "!type_selected!" == "3" (echo %ESC%[97m%ESC%[28;07f[INT ^| BOOL ^| %ESC%[7mFLOAT%ESC%[27m])
      choice /c:asd /n >nul 2>nul
      if /i "!errorlevel!" == "1" (if not !type_selected! == 1 (set /a type_selected-=1))
      if /i "!errorlevel!" == "2" (exit /b !type_selected!)
      if /i "!errorlevel!" == "3" (if not !type_selected! == 3 (set /a type_selected+=1))
   goto Loop[4]
goto :eof

:VolatileLog
   if not defined VolatileLog.BufferSize (set /a VolatileLog.BufferSize=0)
   if not defined VolatileLog.MaxLength (set /a VolatileLog.MaxLength=0)
   if not defined VolatileLog.TotalLogs (set VolatileLog.TotalLogs=1)
   if not defined VolatileLog.LogPosX (set VolatileLog.LogPosX=0)
   if not defined VolatileLog.LogPosY (set VolatileLog.LogPosY=0)
   if /i "%~1" == "Configure-System" (
      if /i "%~2" == "BUFFER_SIZE" (set VolatileLog.BufferSize=%~3)
      if /i "%~2" == "MAX_LENGTH" (set VolatileLog.MaxLength=%~3)
      if /i "%~2" == "POS_X" (set VolatileLog.LogPosX=%~3)
      if /i "%~2" == "POS_Y" (set VolatileLog.LogPosY=%~3)
      goto :eof
   )
   if /i "%~1" == "Add-LogToBuffer" (
      if !VolatileLog.TotalLogs! == 0 (set /a VolatileLog.TotalLogs+=1)
      if /i "%~2" == "Null" (set VolatileLog.LogID[!VolatileLog.TotalLogs!].Color=97)
      if /i "%~2" == "Error" (set VolatileLog.LogID[!VolatileLog.TotalLogs!].Color=91)
      if /i "%~2" == "Warning" (set VolatileLog.LogID[!VolatileLog.TotalLogs!].Color=93)
      if /i "%~2" == "Information" (set VolatileLog.LogID[!VolatileLog.TotalLogs!].Color=94)
      set VolatileLog.LogID[!VolatileLog.TotalLogs!].Text=%~3
      set VolatileLog.LogID[!VolatileLog.TotalLogs!].Time=!time:~0,8!

      if !VolatileLog.BufferSize! geq !VolatileLog.TotalLogs! (set /a VolatileLog.TotalLogs+=1) else (
         for /l %%x in (1,1,!VolatileLog.TotalLogs!) do (
            set /a VolatileLog.TotalLogs.tmp=%%x - 1
            set VolatileLog.LogID[!VolatileLog.TotalLogs.tmp!].Color=!VolatileLog.LogID[%%x].Color!
            set VolatileLog.LogID[!VolatileLog.TotalLogs.tmp!].Text=!VolatileLog.LogID[%%x].Text!
            set VolatileLog.LogID[!VolatileLog.TotalLogs.tmp!].Time=!VolatileLog.LogID[%%x].Time!
         ) & ((set VolatileLog.LogID[0].Color=%NULL%) & (set VolatileLog.LogID[0].Text=%NULL%) & (set VolatileLog.LogID[0].Time=%NULL%))
         goto :eof
      )
      goto :eof
   )
   if /i "%~1" == "Show-AllLogs" (
      echo.%ESC%[!VolatileLog.LogPosY!;!VolatileLog.LogPosX!f
      for /l %%x in (1,1,!VolatileLog.BufferSize!) do (
         if /i not "!VolatileLog.LogID[%%x].Text!" == "%NULL%" (echo.%ESC%[!VolatileLog.LogPosX!C%ESC%[!VolatileLog.MaxLength!X%ESC%[90m[!VolatileLog.LogID[%%x].Time!] %ESC%[!VolatileLog.LogID[%%x].Color!m!VolatileLog.LogID[%%x].Text!)
      )
      goto :eof
   )
goto :eof

:Config
echo %ESC%[?25l
set STATE[1]=OFF
set STATE[2]=OFF
mode con: cols=60 lines=40 >nul
echo %ESC%[18;20f%ESC%[97mObteniendo direcciones...
call :GetAddresses
set actual_speed=1
set IsDead=%false%
set /a IsDeadNegativeFlag=^^!IsDead
set actual_x=0
set actual_y=0
set MenuPageSelected=1
cls
goto MainHost

:AmongUsMenuPage[1]
echo %ESC%[06;07f%ESC%[92m[1]%ESC%[97m Ver o modificar cordenadas X ^& Y actuales
echo %ESC%[07;07f%ESC%[92m[2]%ESC%[97m Forzar flag IsDead a %ESC%[36m%IsDeadNegativeFlag%
echo %ESC%[08;07f%ESC%[92m[3]%ESC%[97m Actualizar color del jugador
echo %ESC%[13;07f%ESC%[97mX:%ESC%[93m %ESC%[10X%actual_x%
echo %ESC%[14;07f%ESC%[97mY:%ESC%[93m %ESC%[10X%actual_y%
echo %ESC%[13;31f%ESC%[97mENTRADA ^>
echo %ESC%[14;31f%ESC%[97mSALIDA ^>
echo %ESC%[17;18f%ESC%[31m--- HOST REQUERIDO ---
echo %ESC%[19;07f%ESC%[90m[5]%ESC%[97m Quitar tiempo de espera para matar (%STATE[1]%) 
echo %ESC%[20;07f%ESC%[90m[6]%ESC%[97m Cambiar velocidad de jugador %ESC%[20;40f(%ESC%[94mx!actual_speed!%ESC%[97m) 
echo %ESC%[21;07f%ESC%[90m[7]%ESC%[97m Terminar la reunion urgente actual
echo %ESC%[24;07f%ESC%[97mColor seleccionado:
echo %ESC%[27;07f%ESC%[95mNota: %ESC%[97mEs necesario recargar las direcciones de
echo %ESC%[28;07f%ESC%[97mmemoria entre partidas, para ello, presione 0.
if not defined PlayerColorInt (
   call :ReadProcessMemoryCMD !ProcessID! !adr[player_color]! 4 PlayerColor.hex
   call :HexToInt "!PlayerColor.hex!" PlayerColorInt
)
call :PrintPlayerColor !PlayerColorInt!
choice /c:1234567890nmx /n >nul 2>nul
if /i "!errorlevel!" == "1" (
   call :VectorControlSystem
   goto :eof
)
if /i "!errorlevel!" == "2" (
   if %IsDead% == %true% (
      call :WriteProcessMemoryCMD !ProcessID! Bool %false% !adr[is_dead]!
      set /a IsDead=^^!IsDead
      set /a IsDeadNegativeFlag=^^!IsDeadNegativeFlag
      goto :eof
   )
   if %IsDead% == %false% (
      call :WriteProcessMemoryCMD !ProcessID! Bool %true% !adr[is_dead]!
      set /a IsDead=^^!IsDead
      set /a IsDeadNegativeFlag=^^!IsDeadNegativeFlag
      goto :eof
   )
)
if /i "!errorlevel!" == "3" (
   call :ReadProcessMemoryCMD !ProcessID! !adr[player_color]! 4 PlayerColor.hex
   call :HexToInt "!PlayerColor.hex!" PlayerColorInt
   goto :eof
)
if /i "!errorlevel!" == "5" (
   if /i "!STATE[1]!" == "OFF" (
      if not defined old_kill_cooldown (
         call :ReadProcessMemoryCMD !ProcessID! !adr[kill_cooldown][0]! 4 old_kill_cooldown.hex
         call :HexToFloat "!old_kill_cooldown.hex!" old_kill_cooldown
      )
      call :WriteProcessMemoryCMD !ProcessID! Float 0 !adr[kill_cooldown][1]!
      call :WriteProcessMemoryCMD !ProcessID! Float 0 !adr[kill_cooldown][0]!
      set STATE[1]=ON
      goto :eof
   )
   if /i "!STATE[1]!" == "ON" (
      call :WriteProcessMemoryCMD !ProcessID! Float !old_kill_cooldown! !adr[kill_cooldown][0]!
      call :WriteProcessMemoryCMD !ProcessID! Float !old_kill_cooldown! !adr[kill_cooldown][1]!
      set STATE[1]=OFF
      goto :eof
   )
)
if /i "!errorlevel!" == "6" (call :ChangePlayerSpeed&goto :eof)
if /i "!errorlevel!" == "7" (
   call :ReadProcessMemoryCMD !ProcessID! !adr[vote_time]! 4 actual_vote_time.hex
   call :HexToInt "!actual_vote_time.hex!" actual_vote_time
   call :WriteProcessMemoryCMD !ProcessID! Int32 1 !adr[vote_time]!
   timeout /nobreak 1 >nul
   call :WriteProcessMemoryCMD !ProcessID! Int32 !actual_vote_time! !adr[vote_time]!
   goto :eof
)
if /i "!errorlevel!" == "10" (
   echo %ESC%[97m%ESC%[14;40fRecargando...
   call :GetAddresses
   echo %ESC%[97m%ESC%[14;40fMemoria recargada^^!
   pause >nul
   echo %ESC%[14;40f                       
   goto :eof
)
if /i "!errorlevel!" == "11" (exit /b 11)
if /i "!errorlevel!" == "12" (exit /b 12)
if /i "!errorlevel!" == "13" (exit /b 13)
goto :eof

:AmongUsMenuPage[2]
:: PAGINA EN DESARROLLO
echo %ESC%[06;07f%ESC%[92m[1]%ESC%[97m Tener reuniones urgentes ilimitadas (%STATE[2]%) 
echo %ESC%[07;07f%ESC%[92m[2]%ESC%[97m Quitar el tiempo de espera entre sabotajes
choice /c:1234567890nmx /n >nul 2>nul
if /i "!errorlevel!" == "1" (
   if /i "%STATE[2]%" == "OFF" (
      if not defined meetings_remaining (
         call :ReadProcessMemoryCMD !ProcessID! !adr[meetings_counter]! 4 old_meetings_remaining.hex
         call :HexToInt "!old_meetings_remaining.hex!" old_meetings_remaining
      )
      call :WriteProcessMemoryCMD !ProcessID! Int32 %INT_LIMIT% !adr[meetings_counter]!
      set STATE[2]=ON
      goto :eof
   )
   if /i "%STATE[2]%" == "ON" (
      call :WriteProcessMemoryCMD !ProcessID! Int32 !old_meetings_remaining! !adr[meetings_counter]!
      set STATE[2]=OFF
      goto :eof
   )
)
if /i "!errorlevel!" == "2" (call :WriteProcessMemoryCMD !ProcessID! Float 0 !adr[sabotage_cooldown]! & goto :eof)
if /i "!errorlevel!" == "11" (exit /b 11)
if /i "!errorlevel!" == "12" (exit /b 12)
if /i "!errorlevel!" == "13" (exit /b 13)
goto :eof

:AmongUsMenuPage[3]
if not defined SltAddress.IntPtr (set SltAddress.IntPtr=0x00000000)
if not defined SltAddress.Data (set SltAddress.Data=0)
echo %ESC%[06;07f%ESC%[90m[1]%ESC%[97m Seleccionar direccion de memoria del juego
echo %ESC%[07;07f%ESC%[90m[2]%ESC%[97m Leer los datos de la direccion actual
echo %ESC%[08;07f%ESC%[90m[3]%ESC%[97m Editar los datos de la direccion actual
echo %ESC%[09;07f%ESC%[90m[4]%ESC%[97m Inyectar DLL al proceso del juego

echo %ESC%[12;07f^|%ESC%[13;07f^|%ESC%[14;07f^|%ESC%[15;07f^|%ESC%[16;07f^|%ESC%[17;07f^|%ESC%[18;07f^|%ESC%[19;07f^|%ESC%[20;07f^|%ESC%[21;07f^|%ESC%[12;54f^|%ESC%[13;54f^|%ESC%[14;54f^|%ESC%[15;54f^|%ESC%[16;54f^|%ESC%[17;54f^|%ESC%[18;54f^|%ESC%[19;54f^|%ESC%[20;54f^|%ESC%[21;54f^|  %ESC%[11;08f______________________________________________%ESC%[21;08f______________________________________________
call :VolatileLog Show-AllLogs

echo %ESC%[24;07f%ESC%[97mDireccion de memoria seleccionada: %ESC%[16X%ESC%[90m!SltAddress.IntPtr!
echo %ESC%[25;07f%ESC%[97mValor leido de la direccion: %ESC%[10X%ESC%[90m!SltAddress.Data!

echo %ESC%[28;07f%ESC%[97m[INT ^| BOOL ^| FLOAT]
echo %ESC%[28;28f%ESC%[4m                           %ESC%[0m

choice /c:1234567890nmx /n >nul 2>nul
if /i "!errorlevel!" == "1" (
   set /p SltAddress.IntPtr="%ESC%[32m%ESC%[24;42f%ESC%[12X%ESC%[?25h"
   call :VolatileLog Add-LogToBuffer Information "Direccion actual: !SltAddress.IntPtr!"
   echo.%ESC%[?25l
   goto :eof
)
if /i "!errorlevel!" == "2" (
   call :GetTypeEntry
   if /i "!errorlevel!" == "1" (
      call :ReadProcessMemoryCMD !ProcessID! !SltAddress.IntPtr! 4 SltAddress.Data.Hex
      call :HexToInt "SltAddress.Data.Hex" SltAddress.Data
      call :VolatileLog Add-LogToBuffer Information "!SltAddress.IntPtr! leido como Int32"
      goto :eof
   )
   if /i "!errorlevel!" == "2" (
      call :ReadProcessMemoryCMD !ProcessID! !SltAddress.IntPtr! 1 SltAddress.Data.Hex
      set /a SltAddress.Data=!SltAddress.Data.Hex!
      call :VolatileLog Add-LogToBuffer Information "!SltAddress.IntPtr! leido como Bool"
      goto :eof
   )
   if /i "!errorlevel!" == "3" (
      call :ReadProcessMemoryCMD !ProcessID! !SltAddress.IntPtr! 4 SltAddress.Data.Hex
      call :HexToFloat "!SltAddress.Data.Hex!" SltAddress.Data
      call :VolatileLog Add-LogToBuffer Information "!SltAddress.IntPtr! leido como Float"
      goto :eof
   )
   goto :eof
)
if /i "!errorlevel!" == "3" (
   call :GetTypeEntry
   set LastError=!errorlevel!
   set /p SltAddress.NewData="%ESC%[97m%ESC%[28;29f%ESC%[4m"
   <nul set /p="%ESC%[0m"
   if /i "!LastError!" == "1" (
      call :WriteProcessMemoryCMD !ProcessID! Int32 "!SltAddress.NewData!" !SltAddress.IntPtr!
      goto :eof
   )
   if /i "!LastError!" == "2" (
      call :WriteProcessMemoryCMD !ProcessID! Bool "!SltAddress.NewData!" !SltAddress.IntPtr!
      goto :eof
   )
   if /i "!LastError!" == "3" (
      call :WriteProcessMemoryCMD !ProcessID! Float "!SltAddress.NewData!" !SltAddress.IntPtr!
      goto :eof
   )
   goto :eof
)
if /i "!errorlevel!" == "4" (
   call :FileDialog "Librerias de enlace dinamico|*.dll|Archivos de componentes ActiveX|*.ocx" "Seleccione el archivo" dll_path
   if /i "!dll_path!" == "Cancel" (goto :eof)
   call :GetStringLength dll_path
   set /a dll_path.length+=1
   call :VirtualAllocExCMD !ProcessID! "%NULL%" !dll_path.length! %MEM_COMMIT% %PAGE_READWRITE% dll_alloc
   call :InjectLibraryMalloc !ProcessID! "!dll_path!" !dll_alloc! !dll_path.length!
   set dll_path=%NULL%
   goto :eof
)
if /i "!errorlevel!" == "11" (exit /b 11)
if /i "!errorlevel!" == "12" (exit /b 12)
if /i "!errorlevel!" == "13" (exit /b 13)
goto :eof

:AmongUsMenuPage[4]
echo %ESC%[16;08f%ESC%[94mVersion 1.1
echo %ESC%[17;08f%ESC%[38;5;40mX%ESC%[97m-%ESC%[38;5;55mA%ESC%[38;5;56mU%ESC%[38;5;57mM %ESC%[97m
echo %ESC%[18;08f%ESC%[90mPID del juego: %ESC%[97m!ProcessID!
echo %ESC%[20;08f%ESC%[97mX-AUM programado en: %ESC%[34mMS-DOS Batch
echo %ESC%[21;08f%ESC%[97mJuego creado por: %ESC%[34mInnersloth
echo %ESC%[21;08f%ESC%[97mSesion iniciada 
echo %ESC%[25;08f%ESC%[97mArquitectura del hack: %ESC%[34mx64

choice /c:1234567890nmx /n >nul 2>nul
if /i "!errorlevel!" == "11" (exit /b 11)
if /i "!errorlevel!" == "12" (exit /b 12)
if /i "!errorlevel!" == "13" (exit /b 13)
goto :eof

:MainHost
   if not !MenuPageSelected! == !MenuPageSelected.old! (cls)
   echo %ESC%[02;24f%ESC%[97mAmong Us Menu
   echo %ESC%[03;20f%ESC%[38;5;99mCreado por Dharkon SK
   call :AmongUsMenuPage[!MenuPageSelected!]
   set lasterror=!errorlevel!
   set MenuPageSelected.old=!MenuPageSelected!
   if /i "!lasterror!" == "13" (exit)
   if /i "!lasterror!" == "11" (
      if not !MenuPageSelected! == 1 (set /a MenuPageSelected-=1)
      goto MainHost
   )
   if /i "!lasterror!" == "12" (
      if not !MenuPageSelected! == 4 (set /a MenuPageSelected+=1)
      goto MainHost
   )
goto MainHost