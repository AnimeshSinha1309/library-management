from PIL import Image
import barcode
import os
import numpy as np

if __name__ == '__main__':
    books = [(np.random.randint(100), np.random.randint(1000)) for i in range(21)]

    width, height = int(8.27 * 300), int(11.7 * 300) # A4 at 300dpi
    blank_image = Image.new("RGB", (width, height))

    rows, cols = 8, 4
    w, h = width // cols, height // rows

    y = 0
    for i in range(1):
        x = 0
        for j in range(1):
            if i + j * cols >= len(books): continue
            ean = barcode.lib.LibraryBookIdentifier.generate(books[i + j * cols][0], books[i + j * cols][1], 'temporary_barcode')
            image = Image.open("temporary_barcode.png")
            image = image.resize((w, h), resample=0)
            blank_image.paste(image,(x, y))
            x += w
        y += h
    
    blank_image.save("print_barcodes.png")
    os.remove("temporary_barcode.png")
