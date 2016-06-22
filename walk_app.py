# -*- encoding: utf-8 -*-
# Author: Epix
import os
import uuid

from flask import Flask, send_from_directory, request, jsonify

from make_perspective import make_perspective_pics_w_800_600

app = Flask(__name__)
UPLOAD_PATH = 'upload'
GEN_PATH = 'generated'
GEN_FILE_SUFFIX = ('l', 'r', 'b', 't', 'c')


@app.route('/walk', methods=['POST'])
def walk():
    j = request.json
    pic_filename = j['picture']
    prefix = os.path.join(GEN_PATH, uuid.uuid4().hex)
    points = j['points']
    make_perspective_pics_w_800_600(pic_filename, prefix, points)
    return jsonify({'url_' + suffix: prefix + '_' + suffix + '.jpg' for suffix in GEN_FILE_SUFFIX})


@app.route('/upload', methods=['POST'])
def upload():
    upload_files = request.files.values()
    output_filename = os.path.join(UPLOAD_PATH, uuid.uuid4().hex + '.jpg')
    list(upload_files)[0].save(output_filename)
    return output_filename.replace('\\', '/')


@app.route('/generated/<path:path>', methods=['GET'])
def get_generated(path):
    return send_from_directory('generated', path)


@app.route('/upload/<path:path>', methods=['GET'])
def get_upload(path):
    return send_from_directory('upload', path)


@app.route('/', methods=['GET'])
def homepage():
    return send_from_directory('static', 'index.html')


@app.route('/<path:path>')
def send_static(path):
    return send_from_directory('static', path)


if __name__ == '__main__':
    app.run(
        # debug=True
    )
