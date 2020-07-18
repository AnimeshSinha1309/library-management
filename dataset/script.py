import os
import json
import csv

base_url = './topics'
book_list = []

label = 0

for folder in os.listdir(base_url):
	folder_path = os.path.join(base_url, folder)
	for file in os.listdir(folder_path):
		file_path = os.path.join(folder_path, file)
		with open(file_path) as f:
			books = json.load(f)
			for book in books:
				book = book['volumeInfo']
				title = book['title'] if 'title' in book else ""
				description = book['description'] if 'description' in book else ""
				if 'authors' in book:
					authors = ''
					for author in book['authors']:
						authors += author + ", "
					authors = authors.strip(', ')
				else:
					authors = ''
				text = title + " " + authors + " " + description
				text = text.strip(' ')
				book_list.append({'label': label, 'category': folder + ' ' + file.split('.')[0], 'text': text })
		label += 1
		
with open('book_dataset.csv', 'w') as f:
	w = csv.DictWriter(f, book_list[0].keys())
	w.writeheader()
	w.writerows(book_list)
