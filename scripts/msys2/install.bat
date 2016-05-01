SET MSYS2_PATH=c:\msys64

IF "%APPVEYOR%"=="False" (
  SET MSYS2_BASE=msys2-base-x86_64-%MSYS2_BASEVER%.tar.xz
  ECHO.Downloading %MSYS2_BASE%...
  appveyor DownloadFile http://kent.dl.sourceforge.net/project/msys2/Base/x86_64/%MSYS2_BASE%
  ECHO.Installing MSYS2...
  rem mkdir %MSYS2_PATH%
  7z x %APPVEYOR_BUILD_FOLDER%\%MSYS2_BASE% -so | 7z x -aoa -si -ttar > nul

  move msys64 %MSYS2_PATH%
  rem %MSYS2_PATH%\autorebase.bat > nul
)

ECHO.Updating MSYS2...
(
	echo.pacman --noconfirm -Sy pacman
	echo.pacman --noconfirm -Syuu
)>script.sh
SET CHERE_INVOKING=1
%MSYS2_PATH%\usr\bin\bash -lc "./script.sh"
SET PATH=%MSYS2_PATH%;%PATH%
(
	echo.pacman --noconfirm --needed -Syu patch make unzip git mingw-w64-%MSYS2_ARCH%-cmake mingw-w64-%MSYS2_ARCH%-gcc
	echo.exit
)>script.sh
%MSYS2_PATH%\usr\bin\bash -lc "./script.sh"

#%MSYS2_PATH%\autorebase.bat > nul
