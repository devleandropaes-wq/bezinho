@echo off
cd /d "%~dp0"
chcp 65001 >nul
title Baixador de MP3 e MP4 - Dev: Leandro

if not exist "yt-dlp.exe" (
    echo [ERRO] Nao foi encontrado o arquivo yt-dlp.exe na pasta do script.
    pause
    exit /b 1
)

if not exist "ffmpeg.exe" (
    echo [AVISO] ffmpeg.exe nao encontrado. A conversao para MP3 ou fusao de video/audio pode falhar.
    echo.
)

:inicio
cls
echo ==================================================
echo ^<Desenvolvedor /^> ^| Leandro Paes
echo Baixador de MP3 e MP4 (yt-dlp)
echo ==================================================
echo.
set /p "url=Cole o link do YouTube e aperte Enter: "
if "%url%"=="" (
    echo.
    echo Link vazio! Tente novamente.
    pause
    goto inicio
)

echo.
echo [1] MP3 (Apenas Audio)
echo [2] MP4 (Video)
echo.
set /p "formato=Escolha o formato (1 ou 2) e aperte Enter: "

if "%formato%"=="1" (
    set "filtro_video="
    goto escolher_modo
)
if "%formato%"=="2" (
    goto escolher_qualidade
)

echo.
echo Formato invalido! Tente novamente.
pause
goto inicio

:escolher_qualidade
echo.
echo [1] Melhor qualidade disponivel
echo [2] Ate 1080p (Full HD)
echo [3] Ate 720p (HD)
echo.
set /p "qualidade=Escolha a qualidade do MP4 (1, 2 ou 3) e aperte Enter: "

if "%qualidade%"=="1" (
    set "filtro_video=bv*[ext=mp4]+ba[ext=m4a]/b[ext=mp4]"
    goto escolher_modo
)
if "%qualidade%"=="2" (
    set "filtro_video=bv*[height<=1080][ext=mp4]+ba[ext=m4a]/b[height<=1080][ext=mp4]"
    goto escolher_modo
)
if "%qualidade%"=="3" (
    set "filtro_video=bv*[height<=720][ext=mp4]+ba[ext=m4a]/b[height<=720][ext=mp4]"
    goto escolher_modo
)

echo.
echo Qualidade invalida! Tente novamente.
pause
goto escolher_qualidade

:escolher_modo
echo.
echo [1] Somente este video/musica
echo [2] Playlist inteira
echo.
set /p "modo=Deseja baixar somente ele ou a playlist? (1 ou 2): "

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
goto escolher_modo

:processar
echo.
if "%formato%"=="1" (
    echo Baixando MP3... Aguarde!
    yt-dlp.exe %flag_playlist% --ffmpeg-location "%~dp0" -o "%pasta_saida%" -x --audio-format mp3 --audio-quality 0 "%url%"
) else (
    echo Baixando MP4... Aguarde!
    yt-dlp.exe %flag_playlist% --ffmpeg-location "%~dp0" -o "%pasta_saida%" -f "%filtro_video%" --merge-output-format mp4 "%url%"
)

echo.
if %errorlevel% equ 0 (
    echo Download concluido com sucesso!
) else (
    echo Ocorreu um erro durante o download. Verifique o link ou a conexao.
)
pause
goto inicio