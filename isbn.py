import requests as req
# import csv
import json


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


def getBookDetailsName(name):

    url = "https://www.googleapis.com/books/v1/volumes?q=name:" + name
    response = req.get(url)
    results = response.json()

    if results["totalItems"]:
        book = results["items"][0]
        # print(book)
        bookInfo = {}
        bookInfo['title'] = book["volumeInfo"].get("title")
        bookInfo['categories'] = book["volumeInfo"].get("categories")
        bookInfo['authors'] = book["volumeInfo"].get("authors")
        bookInfo['printType'] = book["volumeInfo"].get("printType")
        bookInfo['pageCount'] = book["volumeInfo"].get("pageCount")
        bookInfo['ratingsCount'] = book["volumeInfo"].get("ratingsCount")
        bookInfo['averageRating'] = book["volumeInfo"].get("averageRating")
        bookInfo['publisher'] = book["volumeInfo"].get("publisher")
        bookInfo['publishedDate'] = book["volumeInfo"].get("publishedDate")
        bookInfo['previewLink'] = book["volumeInfo"].get("previewLink")
        if book["volumeInfo"].get("imageLinks") != None:
            bookInfo['thumbnail'] = book["volumeInfo"].get("imageLinks").get(
                "thumbnail")
        bookInfo['language'] = book["volumeInfo"].get("language")
        bookInfo['description'] = book["volumeInfo"].get("description")
        bookInfo['webReaderLink'] = book["accessInfo"].get("webReaderLink")
        return bookInfo
    else:
        return None


if __name__ == '__main__':
    # isbn = input
    # "9781451648546" Steve Jobs
    # print(getBookDetailsName("The Hound of the Baskervilles"))
    # print(getBookDetails("9781640320345"))			# "9781451648546" Steve Jobs

    data = list()
    genre = "history"
    count = 0
    cnt = 0

    with open(genre + ".txt", 'r') as file:
        books = file.readlines()
        for book in books:
            cnt += 1
            info = getBookDetailsName(book)
            if info is None:
                count += 1
            else:
                print("\r" + str(cnt), end='')
                data.append(info)

    with open(genre + ".json", 'w') as f:
        json.dump(data, f)

    print()
    print(str(count) + " not found")
