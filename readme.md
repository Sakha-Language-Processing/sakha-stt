# Sakha Speech to Text

Преобразовываем якутскую речь в текст.

## Технологии

* [The Massively Multilingual Speech (MMS) by Facebook Research](https://github.com/facebookresearch/fairseq/tree/main/examples/mms)
* [Flask-RestX](https://flask-restx.readthedocs.io/)
* [ttsmms by wannaphong](https://github.com/wannaphong/ttsmms)

## Подход

- [x] Скачиваем веса для STT для 1107 языков (13.1 Gb):

    ```shell
    curl -O 'https://dl.fbaipublicfiles.com/mms/asr/mms1b_l1107.pt'
    ```

- [x] Скачиваем словарь для якутского языка:

    ```shell
    curl -O 'https://dl.fbaipublicfiles.com/mms/asr/dict/mms1b_l1107/sah.txt'
    ```

- [ ] Пробное распознавание речи в текст:

    ```shell
    cd fairseq
    python ./examples/mms/asr/infer/mms_infer.py \
        --model "../mms1b_l1107.pt" --lang sah \
        --audio "../audio_1.wav" "../audio_2.wav" "../audio_3.wav"
    cd ..
    ```

    На данный момент скрипт из примера не работает.

- [ ] Создаем прототип REST API

## Ссылки

* [Веса для STT для 1107 языков](https://dl.fbaipublicfiles.com/mms/asr/mms1b_l1107.pt)
* [Словарь для якутского языка](https://dl.fbaipublicfiles.com/mms/asr/dict/mms1b_l1107/sah.txt)
* [Веса для TTS для якутского языка](https://dl.fbaipublicfiles.com/mms/tts/sah.tar.gz)
