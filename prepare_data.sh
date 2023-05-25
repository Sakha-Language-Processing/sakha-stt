#!/bin/bash

. venv/bin/activate

FAIRSEQ_ROOT=`pwd`/fairseq
EXAMPLE=$FAIRSEQ_ROOT/examples/wav2vec
RVAD_ROOT=`pwd`/rVADfast
KENLM_ROOT=`pwd`/kenlm/build/bin
KALDI_ROOT=`pwd`/../pykaldi

read -p "Создать манифест для исходных файлов? " ans
case $ans in
	[Yy]*)
		python \
			$EXAMPLE/wav2vec_manifest.py \
			./with_silence/clips \
			--ext mp3 \
			--dest ./with_silence \
			--valid-percent 0
		echo "Готово" ;;
	*)
		echo "Пропускаем" ;;
esac

read -p "Разметить голосовую активность? " ans
case $ans in
	[Yy]*)
		python \
			$EXAMPLE/unsupervised/scripts/vads.py \
			-r $RVAD_ROOT \
			< ./with_silence/train.tsv \
			> train.vads
		echo "Готово" ;;
	*)
		echo "Пропускаем" ;;
esac

read -p "Удалить тишину? " ans
case $ans in
	[Yy]*)
		python \
			$EXAMPLE/unsupervised/scripts/remove_silence.py --tsv ./with_silence/train.tsv --vads train.vads --out ./without_silence
		echo "Готово" ;;
	*)
		echo "Пропускаем" ;;
esac

read -p "Создать манифест для файлов без тишины? " ans
case $ans in
	[Yy]*)
		python \
			$EXAMPLE/wav2vec_manifest.py \
			./without_silence/clips \
			--ext mp3 \
			--dest ./without_silence \
			--valid-percent 0
		echo "Готово" ;;
	*)
		echo "Пропускаем" ;;
esac
