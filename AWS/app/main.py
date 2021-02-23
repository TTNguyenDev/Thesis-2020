from flask import Flask, request, redirect, jsonify
from werkzeug.utils import secure_filename
from PIL import Image

import pytesseract
import json

app = Flask(__name__)

@app.route("/")
def index():
    return "<h1>Welcome to TVT Group</h1> <h1>Medical prediction</h1>"

ALLOWED_EXTENSIONS = set(["txt", "pdf", "png", "jpg", "jpeg", "gif"])


def allowed_file(filename):
    return "." in filename and filename.rsplit(".", 1)[1].lower() in ALLOWED_EXTENSIONS


@app.route("/file-upload", methods=["POST"])
def upload_file():
    if "file" not in request.files:
        resp = jsonify({"message": "No file part in the request"})
        resp.status_code = 400
        return resp
    file = request.files["file"]
    if file.filename == "":
        resp = jsonify({"message": "No file selected for uploading"})
        resp.status_code = 400
        return resp

    if file and allowed_file(file.filename):
        img = Image.open(file)

        config = "-l eng --oem 1 --psm 7"
        result = pytesseract.image_to_string(img)
        result = result.replace("\n\f", "")
        result = result.replace("\n", "")

        if result == "":
          resp = jsonify({"message": "Can't detect drug name in your image"})
          resp.status_code = 400
          return resp
        else:
          resp = jsonify([{"name":result,"accuracy":"98","morning":"1","afternoon": "1","evening":"1","info":"abc."},{"name":"Panadol","accuracy":"60","morning":"1","afternoon": "0","evening":"1","info":"cdf"}])
          resp.status_code = 200
          return resp
    else:
        resp = jsonify(
            {"message": "Allowed file types are txt, pdf, png, jpg, jpeg, gif"}
        )
        resp.status_code = 400
        return resp
