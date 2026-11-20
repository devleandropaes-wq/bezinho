@echo off
cd /d "%~dp0"
chcp 65001 >nul
title Baixador de MP3 e MP4 - Dev: Leandro

:inicio
cls
echo ==================================================
echo ^<Desenvolvedor /^> ^| Leandro Paes
echo Baixador de MP3 e MP4 (yt-dlp)
echo ==================================================
echo.
set /p url="Cole o link do YouTube e aperte Enter: "
echo.
echo [1] MP3 (Apenas Audio)
echo [2] MP4 (Video)
echo.
set /p formato="Escolha o formato (1 ou 2) e aperte Enter: "

if not "%formato%"=="1" if not "%formato%"=="2" (
    echo.
    echo Formato invalido! Tente novamente.
    pause
    goto inicio
)

echo.
echo [1] Somente este video/musica
echo [2] Playlist inteira
echo.
set /p modo="Deseja baixar somente ele ou a playlist? (1 ou 2): "

if "%modo%"=="1" (
    set "flag_playlist=--no-playlist"
    set "pasta_saida=Downloads/%%(title)s.%%(ext)s"
    goto processar
)
if "%modo%"=="2" (
    set "flag_playlist=--yes-playlist"
    set "pasta_saida=Downloads/%%(playlist_title)s/%%(title)s.%%(ext)s"
    goto processar
)

echo.
echo Opcao invalida! Tente novamente.
pause
goto inicio

:processar
echo.
if "%formato%"=="1" (
    echo Baixando MP3... Aguarde!
    yt-dlp.exe %flag_playlist% -o "%pasta_saida%" -x --audio-format mp3 --audio-quality 0 "%url%"
) else (
    echo Baixando MP4... Aguarde!
    yt-dlp.exe %flag_playlist% -o "%pasta_saida%" -f "bv*[ext=mp4]+ba[ext=m4a]/b[ext=mp4]" "%url%"
)

echo.
echo Download concluido com sucesso!
pause
goto inicio
