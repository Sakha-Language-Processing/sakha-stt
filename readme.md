# Sakha Speech to Text

Преобразовываем якутскую речь в текст.

## Технологии

* [Coqui.ai STT](https://stt.readthedocs.io/)
* [Mozilla CommonVoice Dataset](https://commonvoice.mozilla.org/sah/)
* [Flask](https://flask.palletsprojects.com/)

## Подход

1. Убираем записи спикеров с низким качеством и разделяем мужские и женские голоса.
2. Обучаем модели для мужских и женских голосов согласно [Playbook](https://stt.readthedocs.io/en/latest/playbook/TRAINING.html).
3. Собираем корпус текстов и компилируем языковую модель согласно [Playbook](https://stt.readthedocs.io/en/latest/playbook/SCORER.html).
4. Создаем образ контейнеров Docker для Flask API.
