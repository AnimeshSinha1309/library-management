from django.shortcuts import render
from django.http import HttpResponse
import requests as req

# Create your views here.


def webapp(request):
    return render(request, 'index.html', {})


def submit(request):
    isbn_no = request.POST.get('isbn')
    dic = getBookDetails(isbn_no)
    if dic == False:
        return HttpResponse("<h2>Invalid ISBN number or Book Not Found</h2>")
    else:
        return render(request, 'result.html', {'dic': dic})


def getBookDetails(isbn):
    url = "https://www.googleapis.com/books/v1/volumes?q=isbn:" + isbn
    response = req.get(url)
    results = response.json()

    if results["totalItems"]:
        dic = {}
        book = results["items"][0]
        dic['title'] = book["volumeInfo"]["title"]
        dic['categories'] = book["volumeInfo"]["categories"]
        dic['authors'] = book["volumeInfo"]["authors"]
        dic['printType'] = book["volumeInfo"]["printType"]
        dic['pageCount'] = book["volumeInfo"]["pageCount"]
        dic['ratingsCount'] = book["volumeInfo"]["ratingsCount"]
        dic['averageRating'] = book["volumeInfo"]["averageRating"]
        dic['publisher'] = book["volumeInfo"]["publisher"]
        dic['publishedDate'] = book["volumeInfo"]["publishedDate"]
        dic['previewLink'] = book["volumeInfo"]["previewLink"]
        dic['thumbnail'] = book["volumeInfo"]["imageLinks"]["thumbnail"]
        dic['language'] = book["volumeInfo"]["language"]
        dic['description'] = book["volumeInfo"]["description"]
        dic['webReaderLink'] = book["accessInfo"]["webReaderLink"]
        return dic

    else:
        return False
