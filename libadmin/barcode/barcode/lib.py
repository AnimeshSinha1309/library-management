from barcode.ean import EuropeanArticleNumber13
from barcode.writer import ImageWriter


class LibraryBookIdentifier(EuropeanArticleNumber13):

    def __init__(self, acc_no, dewey_no, writer=None, no_checksum=False):
        self.acc_no = acc_no
        self.dewey_no = dewey_no
        data = "{0:04}{1:08}".format(self.dewey_no, self.acc_no)
        print(data)
        super().__init__(data, writer=writer, no_checksum=no_checksum)

    def get_fullcode(self):
        return "Andaman College Library Issue\nSubject Code: {0:04}\nAccession No.: {1:08}".format(
            self.dewey_no, self.acc_no)

    @staticmethod
    def generate(acc_no, dewey_no, file):
        ean = LibraryBookIdentifier(acc_no, dewey_no, writer=ImageWriter())
        return ean.save(file)
