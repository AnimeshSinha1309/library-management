import barcode

if __name__ == '__main__':
    ean = barcode.lib.LibraryBookIdentifier.generate(120, 1012, 'sample_book_code')
