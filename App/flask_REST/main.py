#!/usr/bin/env python
# -*- coding: utf-8 -*- 
import os
#import urllib.request
from app import app
from flask import Flask, request, redirect, jsonify
from werkzeug.utils import secure_filename
import cv2
import pytesseract
import json



pytesseract.pytesseract.tesseract_cmd = '/usr/local/bin/tesseract'

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
		
		config = ('-l eng --oem 1 --psm 7')
		result = pytesseract.image_to_string(img)
		result = result.replace('\n\f', '')
		
		# if result != "":
		# 	print('Nothing')
		# 	resp = jsonify({})
		# 	resp.status_code = 204
		# 	return resp
		# else:
		# 	print('have something')
		file.save(os.path.join(app.config['UPLOAD_FOLDER'], filename))
		resp = jsonify([{"name":"Paracetamol","accuracy":"98","morning":"1","afternoon": "1","evening":"1","info":"abc."},{"name":"Panadol","accuracy":"60","morning":"1","afternoon": "0","evening":"1","info":"cdf"}])
		# resp = jsonify(result)
		resp.status_code = 201
		return resp
	else:
		resp = jsonify({'message' : 'Allowed file types are txt, pdf, png, jpg, jpeg, gif'})
		resp.status_code = 400
		return resp

if __name__ == "__main__":
    app.run('192.168.1.2')
	# print("hello")
	# app.run()

	