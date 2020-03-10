import requests as req

def getBookDetails(title):

    url = "https://www.googleapis.com/books/v1/volumes?q=intitle:" + title
    response = req.get(url)
    results = response.json()
    print(results)
    if results["totalItems"]:
        book = results["items"][0]
        title = book["volumeInfo"]["title"]
        categories = book["volumeInfo"]["categories"]
        authors = book["volumeInfo"]["authors"]
        printType = book["volumeInfo"]["printType"]
        pageCount = book["volumeInfo"]["pageCount"]
        ratingsCount = book["volumeInfo"]["ratingsCount"]
        averageRating = book["volumeInfo"]["averageRating"]
        publisher = book["volumeInfo"]["publisher"]
        publishedDate = book["volumeInfo"]["publishedDate"]
        previewLink = book["volumeInfo"]["previewLink"]
        thumbnail = book["volumeInfo"]["imageLinks"]["thumbnail"]
        language = book["volumeInfo"]["language"]
        description = book["volumeInfo"]["description"]
        webReaderLink = book["accessInfo"]["webReaderLink"]


if __name__ == '__main__':
    # title = input
    getBookDetails("Concepts of Physics")		
