from flask import request, url_for
from barcode import app
import barcode.lib as lib
from PIL import Image
import os
import numpy as np

@app.route("/", methods=['GET'])
def index():
    return "Hello World!"

@app.route("/barcode", methods=['GET'])
def barcode():
    print(request.args)
    acc_no = request.args.get('acc')
    dewey_no = request.args.get('dewey')
    if 'uid' in request.args:
        uid = request.args.get('uid')
    else:
        uid = ""

    filename = '/static' + '/_barcode' + str(uid)

    width, height = int(8.27 * 300), int(11.7 * 300) # A4 at 300dpi
    # blank_image = Image.new("RGB", (width, height))

    rows, cols = 8, 4
    w, h = width // cols, height // rows

    ean = lib.LibraryBookIdentifier.generate(int(acc_no), int(dewey_no), './barcode' + filename)
    
    # image = Image.open(filename)
    # image = image.resize((w, h), resample=0)
    # image.save("_barcode.png")
    # blank_image.paste(image,(0, 0))

    # blank_image.save("print_barcodes.png")
    # os.remove("temporary_barcode.png")

    return filename
