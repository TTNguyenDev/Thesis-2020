import os
import urllib.request
from app import app
from flask import Flask, request, redirect, jsonify
from werkzeug.utils import secure_filename
import cv2
import pytesseract


ALLOWED_EXTENSIONS = set(['txt', 'pdf', 'png', 'jpg', 'jpeg', 'gif'])

def allowed_file(filename):
	return '.' in filename and filename.rsplit('.', 1)[1].lower() in ALLOWED_EXTENSIONS

@app.route('/file-upload', methods=['POST'])
def upload_file():
	# check if the post request has the file part
	if 'file' not in request.files:
		resp = jsonify({'message' : 'No file part in the request'})
		resp.status_code = 400
		return resp
	file = request.files['file']
	if file.filename == '':
		resp = jsonify({'message' : 'No file selected for uploading'})
		resp.status_code = 400
		return resp
	if file and allowed_file(file.filename):
		filename = secure_filename(file.filename)
		filepath = os.path.join(app.config['UPLOAD_FOLDER'], filename)
		file.save(filepath)
		img = cv2.imread(filepath)
		
		# config = ('-l eng --oem 1 --psm 7')
		result = pytesseract.image_to_string(img)
		result = result.replace('\n\f', '')
		print("aloooo" + result)
		# file.save(os.path.join(app.config['UPLOAD_FOLDER'], filename))
		resp = jsonify([{"id": 1, "px": 1, "py": 1, "width": 1, "height": 1, "accuracy": 99, "name": result}, {"id": 1, "px": 1, "py": 1, "width": 1, "height": 1, "accuracy": 99, "name": result}])
		resp.status_code = 201
		return resp
	else:
		resp = jsonify({'message' : 'Allowed file types are txt, pdf, png, jpg, jpeg, gif'})
		resp.status_code = 400
		return resp

if __name__ == "__main__":
    app.run(host='172.29.71.206')