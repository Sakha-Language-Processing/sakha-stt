# Sakha Speech to Text

Преобразовываем якутскую речь в текст.

## Технологии

* [The Massively Multilingual Speech (MMS) by Facebook Research](https://github.com/facebookresearch/fairseq/tree/main/examples/mms)
* [Flask-RestX](https://flask-restx.readthedocs.io/)
* [ttsmms by wannaphong](https://github.com/wannaphong/ttsmms)

## Подход

1. Скачиваем веса для STT для 1107 языков (13.1 Gb):

```shell
curl -O 'https://dl.fbaipublicfiles.com/mms/asr/mms1b_l1107.pt'
```

1. Скачиваем словарь для якутского языка:

```shell
curl -O 'https://dl.fbaipublicfiles.com/mms/asr/dict/mms1b_fl102/sah.txt'
```

1. Пробное распознавание речи в текст:

```shell
python fairseq/examples/mms/asr/infer/mms_infer.py \
    --model "/path/to/asr/model" \
    --lang lang_code \
    --audio "/path/to/audio_1.wav" "/path/to/audio_2.wav" "/path/to/audio_3.wav"
```

1. Создаем прототип REST API

## Ссылки

* [Веса для STT для 1107 языков](https://dl.fbaipublicfiles.com/mms/asr/mms1b_l1107.pt)
* [Словарь для якутского языка](https://dl.fbaipublicfiles.com/mms/asr/dict/mms1b_fl102/sah.txt)
* [Веса для TTS для якутского языка](https://dl.fbaipublicfiles.com/mms/tts/sah.tar.gz)
