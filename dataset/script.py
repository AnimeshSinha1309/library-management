import os
import json
import csv

base_url = './topics'
book_list = []

for folder in os.listdir(base_url):
    folder_path = os.path.join(base_url, folder)
    for file in os.listdir(folder_path):
        file_path = os.path.join(folder_path, file)
        with open(file_path) as f:
            books = json.load(f)
            for book in books:
                book = book['volumeInfo']
                if 'description' in book:
                    description = book['description']
                else:
                    description = ''
                book_list.append({'label': folder + " " + file.split('.')[0], 'text': book['title'] + " " + description })
                
with open('book_dataset.csv', 'w') as f:
    w = csv.DictWriter(f, book_list[0].keys())
    w.writerows(book_list)
