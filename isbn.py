import requests as req

def getBookDetails(isbn):

	url = "https://www.googleapis.com/books/v1/volumes?q=isbn:" + isbn
	response = req.get(url)
	results = response.json()

	if results["totalItems"]:
		bookInfo = {}
		book = results["items"][0]
		bookInfo['title'] = book["volumeInfo"]["title"]
		bookInfo['categories'] = book["volumeInfo"]["categories"]
		bookInfo['authors'] = book["volumeInfo"]["authors"]
		bookInfo['printType'] = book["volumeInfo"]["printType"]
		bookInfo['pageCount'] = book["volumeInfo"]["pageCount"]
		bookInfo['ratingsCount'] = book["volumeInfo"]["ratingsCount"]
		bookInfo['averageRating'] = book["volumeInfo"]["averageRating"]
		bookInfo['publisher'] = book["volumeInfo"]["publisher"]
		bookInfo['publishedDate'] = book["volumeInfo"]["publishedDate"]
		bookInfo['previewLink'] = book["volumeInfo"]["previewLink"]
		bookInfo['thumbnail'] = book["volumeInfo"]["imageLinks"]["thumbnail"]
		bookInfo['language'] = book["volumeInfo"]["language"]
		bookInfo['description'] = book["volumeInfo"]["description"]
		bookInfo['webReaderLink'] = book["accessInfo"]["webReaderLink"]
		return bookInfo
	else:
		return None

if __name__ == '__main__':
	# isbn = input
	getBookDetails("9781451648546")			# "9781451648546" Steve Jobs