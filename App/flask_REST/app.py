
import sys
UPLOAD_FOLDER = './'
# from pip import main

from flask import Flask

app = Flask(__name__)
#app.secret_key = "secret key"
app.config['UPLOAD_FOLDER'] = UPLOAD_FOLDER
app.config['MAX_CONTENT_LENGTH'] = 16 * 1024 * 1024
