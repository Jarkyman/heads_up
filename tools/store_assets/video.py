"""Render subtle seamless 8-second header/search loops from approved stills.

Run from the repository root after render.swift. No synthetic app UI is made.
"""
from pathlib import Path
import subprocess

for source in sorted(Path('docs/store-assets/creative').glob('*/*.png')):
    if source.stem not in ('header', 'search'):
        continue
    size = '3840x1646' if source.stem == 'header' else '1920x1280'
    effect = ("zoompan=z='1.01+0.005*sin(2*PI*on/240)':"
              "x='iw/2-iw/zoom/2':y='ih/2-ih/zoom/2':"
              f'd=240:s={size}:fps=30,format=yuv420p')
    subprocess.run(['ffmpeg', '-hide_banner', '-loglevel', 'error', '-y',
                    '-i', str(source), '-vf', effect, '-t', '8', '-an',
                    '-c:v', 'libx264', '-threads', '2', '-crf', '20',
                    '-preset', 'fast', '-movflags', '+faststart',
                    str(source.with_suffix('.mp4'))], check=True)
