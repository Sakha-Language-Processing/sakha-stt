from cgitb import text
from flask import Flask, jsonify, render_template, request
from stt import Model
from scipy.io.wavfile import read

app = Flask(__name__)


def create_model(name):
    model = Model(f'model/{name}.tflite')
    model.enableExternalScorer(f'model/{name}.scorer')
    return model

def take_text(metadata):
    text = []
    transcript = ''
    for ch in metadata.tokens:
        text.append(ch.text)
    transcript = transcript.join(text)
    return transcript

@app.route('/')
def index():
    return render_template('index.html')


@app.route('/stt/', methods=['POST'])
def process():
    if not request.files:
        return {'error': 'Input audio not found'}

    male = create_model('male')
    female = create_model('female')
    itml = Model(f'model/model.tflite')


    _, file = next(iter(request.files.items()))
    # TODO: convert audio samplerate
    file.save('temp.wav')
    audio = read('temp.wav')
    

    result_as_male = male.sttWithMetadata(audio[1])
    text_as_male = take_text(result_as_male.transcripts[0])
    confidence_as_male = result_as_male.transcripts[0].confidence
    result_as_female = female.sttWithMetadata(audio[1])
    text_as_female = take_text(result_as_female.transcripts[0])
    confidence_as_female = result_as_female.transcripts[0].confidence
    result_as_itml = itml.sttWithMetadata(audio[1])
    text_as_itml = take_text(result_as_itml.transcripts[0])
    confidence_as_itml = result_as_itml.transcripts[0].confidence
    
    return render_template('result.html',
        confidence_as_male = confidence_as_male, 
        result_male = text_as_male,
        confidence_as_female = confidence_as_female, 
        result_female = text_as_female,
        confidence_as_itml = confidence_as_itml,
        result_itml = text_as_itml
    )

app.run(debug=True)
