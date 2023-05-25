#!./venv/bin/python

import csv
import os

PWD = os.getcwd()
INP = "cv-corpus-13.0-2023-03-09/sah/clips/"
OUT = "with_silence/clips/"

with open(f"{PWD}/{INP}/validated.tsv") as f:
    reader = csv.DictReader(f, delimiter="\t")
    for row in reader:
        inp = INP + row["path"]
        out = OUT + row["path"]
        os.system("ffmpeg -i '{inp}' -ac 0 -ar 16000 -q:a 9 '{out}'")
