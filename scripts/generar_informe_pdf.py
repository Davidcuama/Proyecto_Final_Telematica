#!/usr/bin/env python3
"""
Generador de Informe HTML + PDF para Entrega 2 - Telemática
Convierte INFORME_ENTREGA_2.md a un documento HTML con diseño académico limpio
y lo exporta a PDF con Chrome/Edge (headless) o, si no están, con LibreOffice.
"""
import os
import shutil
import subprocess
from pathlib import Path
from markdown_it import MarkdownIt

BASE_DIR = str(Path(__file__).resolve().parent.parent / "informe")
MD_PATH = os.path.join(BASE_DIR, "INFORME_ENTREGA_2.md")
HTML_PATH = os.path.join(BASE_DIR, "INFORME_ENTREGA_2.html")
PDF_PATH = os.path.join(BASE_DIR, "INFORME_ENTREGA_2.pdf")

CSS = """
@page {
    size: letter;
    margin: 2cm;
}
body {
    font-family: "DejaVu Sans", "Liberation Sans", Arial, sans-serif;
    font-size: 10.5pt;
    line-height: 1.45;
    color: #1f2937;
}
h1 {
    color: #0f3d75;
    font-size: 18pt;
    border-bottom: 2px solid #0f3d75;
    padding-bottom: 6px;
    margin-top: 0;
}
h2 {
    color: #154c91;
    font-size: 14pt;
    border-bottom: 1px solid #cbd5e1;
    padding-bottom: 4px;
    margin-top: 22px;
}
h3 {
    color: #1e3a8a;
    font-size: 11.5pt;
    margin-top: 16px;
}
table {
    border-collapse: collapse;
    width: 100%;
    margin: 12px 0;
    font-size: 9pt;
}
th, td {
    border: 1px solid #94a3b8;
    padding: 5px 7px;
    text-align: left;
}
th {
    background-color: #e2e8f0;
    color: #0f172a;
    font-weight: bold;
}
tr:nth-child(even) {
    background-color: #f8fafc;
}
pre {
    background-color: #f1f5f9;
    border: 1px solid #cbd5e1;
    padding: 10px;
    font-family: "DejaVu Sans Mono", "Liberation Mono", monospace;
    font-size: 8.5pt;
    overflow-x: auto;
    white-space: pre;
}
code {
    font-family: "DejaVu Sans Mono", "Liberation Mono", monospace;
    background-color: #f1f5f9;
    padding: 1px 4px;
    font-size: 9pt;
}
img {
    display: block;
    max-width: 100%;
    margin: 8px auto;
    border: 1px solid #cbd5e1;
    page-break-inside: avoid;
}
blockquote {
    border-left: 4px solid #2563eb;
    background-color: #eff6ff;
    margin: 12px 0;
    padding: 8px 12px;
}
"""

def main():
    with open(MD_PATH, "r", encoding="utf-8") as f:
        md_text = f.read()

    # Reemplazar notación matemática simple para visualización limpia en LibreOffice
    md_text = md_text.replace("$k = 2$", "k = 2").replace("$\\implies n = k + 1 = 3$", "=> n = k + 1 = 3")
    md_text = md_text.replace("$k = 2 \\implies \\text{AS1, AS2 y AS99}$", "k = 2 => AS1, AS2 y AS99")
    md_text = md_text.replace("$k \\ge 2$", "k >= 2")
    md_text = md_text.replace("$\\leftrightarrow$", "<->").replace("$\\rightarrow$", "->")

    md = MarkdownIt("commonmark").enable("table")
    html_body = md.render(md_text)

    full_html = f"""<!DOCTYPE html>
<html lang="es">
<head>
<meta charset="utf-8">
<title>Informe Técnico - Entrega 2 Packet Tracer</title>
<style>{CSS}</style>
</head>
<body>
{html_body}
</body>
</html>
"""
    with open(HTML_PATH, "w", encoding="utf-8") as f:
        f.write(full_html)
    print(f"[OK] HTML generado en: {HTML_PATH}")

    browsers = [
        shutil.which("google-chrome"), shutil.which("chromium"), shutil.which("chrome"),
        r"C:\Program Files\Google\Chrome\Application\chrome.exe",
        r"C:\Program Files (x86)\Microsoft\Edge\Application\msedge.exe",
    ]
    browser = next((b for b in browsers if b and os.path.exists(b)), None)
    if browser:
        cmd = [browser, "--headless", "--disable-gpu", "--no-pdf-header-footer",
               f"--print-to-pdf={PDF_PATH}", Path(HTML_PATH).as_uri()]
    else:
        cmd = ["libreoffice", "--headless", "--convert-to", "pdf:writer_web_pdf_Export",
               "--outdir", BASE_DIR, HTML_PATH]
    subprocess.run(cmd, check=True)
    print(f"[OK] PDF generado en: {PDF_PATH}")

if __name__ == "__main__":
    main()
