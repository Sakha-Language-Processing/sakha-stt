#!/bin/bash

# НВК Саха, Эйге
# yt-dlp \
#   --extract-audio \
#   --audio-format opus \
#   --audio-quality 0 \
#   --postprocessor-args "-ar 16000" \
#   --output "unlabeled/%(id)s.%(ext)s" \
#   "PL19ZwiAmfPfgyF5vw_c0vOSsiyLJ8JQFn"

export AUDIO_CV=$(pwd)/cv-corpus-13.0-2023-03-09/sah/clips
export FAIRSEQ_ROOT=$(pwd)/fairseq
export RVAD_ROOT=$(pwd)/rVADfast
export KENLM_ROOT=$(pwd)/kenlm/build/bin
# export KALDI_ROOT=$(pwd)/../pykaldi

echo "Создаем манифест для исходных файлов"
python $FAIRSEQ_ROOT/examples/wav2vec/wav2vec_manifest.py $AUDIO_CV --ext mp3 --dest ./with_silence --valid-percent 0
echo "Готово"

echo "Размечаем голосовую активность"
python $FAIRSEQ_ROOT/examples/wav2vec/unsupervised/scripts/vads.py -r $RVAD_ROOT < ./with_silence/train.tsv > train.vads
echo "Готово"
