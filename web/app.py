import os
import shutil
import tempfile
from flask import Flask, render_template, request, send_file, after_this_request
import yt_dlp

app = Flask(__name__)


@app.get("/")
def index():
    return render_template("index.html")


@app.post("/download")
def download():
    url = (request.form.get("url") or "").strip()
    if not url:
        return "Informe uma URL válida.", 400

    temp_dir = tempfile.mkdtemp(prefix="bezinho_")

    @after_this_request
    def cleanup(response):
        shutil.rmtree(temp_dir, ignore_errors=True)
        return response

    ydl_opts = {
        "format": "bestaudio/best",
        "noplaylist": True,
        "outtmpl": os.path.join(temp_dir, "%(title)s.%(ext)s"),
        "postprocessors": [
            {
                "key": "FFmpegExtractAudio",
                "preferredcodec": "mp3",
                "preferredquality": "192",
            }
        ],
    }

    try:
        with yt_dlp.YoutubeDL(ydl_opts) as ydl:
            info = ydl.extract_info(url, download=True)
            base_title = ydl.prepare_filename(info)
            mp3_path = os.path.splitext(base_title)[0] + ".mp3"

        if not os.path.exists(mp3_path):
            arquivos = [f for f in os.listdir(temp_dir) if f.endswith(".mp3")]
            if not arquivos:
                return "Não foi possível gerar o arquivo MP3.", 500
            mp3_path = os.path.join(temp_dir, arquivos[0])

        return send_file(mp3_path, as_attachment=True)
    except Exception as exc:
        return f"Erro ao processar o link: {exc}", 500


if __name__ == "__main__":
    app.run(host="0.0.0.0", port=5000, debug=True)