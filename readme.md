# Распознавание якутской речи

За основу берем пример wav2vec-U 2.0 из репозитория [wav2vec](https://github.com/pytorch/fairseq). Пример находится в каталоге `examples/wav2vec/unsupervised`. [Статья про этот пример](https://arxiv.org/abs/2204.02492). Репозиторий склонирован в текущий каталог. Создана символическая ссылка на пример.

В качестве размеченных данных взят [Mozilla Common Voice](https://commonvoice.mozilla.org/sah/datasets/). На сегодняшний день актуальной является версия 13. Набор данных распакован из архива и перенесен в каталог `without_silence`.

TODO: Данные нужно пересемплировать в 16 кГц и извлечь только валидные.

На данный момент пока нет данных по словам и фонемам.

Для удаления тишины используется [rVADfast](https://github.com/zhenghuatan/rVADfast). Репозиторий склонирован в текущий каталог.













Создание новых аудиофайлов без тишины:

```shell
# Создание файла манифеста:
python $FAIRSEQ_ROOT/examples/wav2vec/wav2vec_manifest.py /dir/to/save/audio/files --ext wav --dest /path/to/new/train.tsv --valid-percent 0

# Разметка тишины
python scripts/vads.py -r $RVAD_ROOT < /path/to/train.tsv > train.vads

# Создание новых файлов
python scripts/remove_silence.py --tsv /path/to/train.tsv --vads train.vads --out /dir/to/save/audio/files

# Создание файла манифеста:
python $FAIRSEQ_ROOT/examples/wav2vec/wav2vec_manifest.py /dir/to/save/audio/files --ext wav --dest /path/to/new/train.tsv --valid-percent 0.01
```

Далее, нужно предобработать аудио для лучшего соответствия фонемизированному тексту:

```shell
# wav2vec-U
zsh scripts/prepare_audio.sh /dir/with/{train,test,valid}.tsv /output/dir /path/to/wav2vec2/model.pt 512 14
# wav2vec-U 2.0
zsh scripts/prepare_audio_v2.sh /dir/with/{train,test,valid}.tsv /output/dir /path/to/wav2vec2/model.pt 64 14
```

Если разбиение отличается от `train/valid/test`, то нужно модифицировать этот скрипт. Третий аргумент — это PCA-размерность для wav2vec-U и число MFCC кластеров для wav2vec-U 2.0. последний аргумент это индекс (считая с 0) слоя с котого нужно начинать извлечение представлений.

Далее нужно подготовить текст:
```shell
zsh scripts/prepare_text.sh language /path/to/text/file /output/dir 1000 espeak /path/to/fasttext/lid/model sil_prob
```

Четвертный аргумент это минимальное количество хранимых наблюдений фонем. Если текстовый корпус небольшой, то можно уменьшить это число.

Пятый аргумент это используемый фонемайзер. Поддерживаются:

* [espeak](http://espeak.sourceforge.net/)
* [espeak-ng](https://github.com/espeak-ng/espeak-ng)
* [G2P](https://github.com/Kyubyong/g2p) — только для английского

Предобученные модели fasttext LID можно скачать [тут](https://fasttext.cc/docs/en/language-identification.html).

Последний аргумент это вероятность появления тишины (`<SIL>`) между границамии слов. Обнаружено, что `0.25`/`0.5` в целом являются рабочими для wav2vec-U и wav2vec 2.0 соответственно, но возможны отличия для языков, которые пока не проверялись.

**Подготовка данных TIMIT**

Транскрипции TIMIT включают тишину. Поэтому VAD не используется для подготовки аудио. Также нет нужды обертывать транскрипции тишиной или вставлять случайные паузы между словами.

Подготовка данных TIMIT для обоих вариантов (matched и unmatched):

```shell
bash scripts/prepare_timit.sh /dir/to/timit/raw/data /output/dir /path/to/wav2vec2/model.pt
```

Предлагается использование TIMIT с именами каталогов и файлов в верхнем регистре (напр., `TRAIN/DR1/FCJF0/SA1.PHN`).
