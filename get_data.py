import json
import os
from requests import get

subjects = ["Anatomy", "Biochemistry", "Biotechnology",
            "Botany", "Ecology", "Genetics", "Physiology", "Zoology"]
# subject = 'American History'
folders = ['History', 'Crafts & Hobbies',
           'Home & Garden', 'Horror', 'Kids', 'Biology']

for folder in folders:
    subjects = os.listdir('dataset/topics/'+folder)
    subjects = [s.split(sep='.')[0] for s in subjects]

    for subject in subjects:
        arr = []
        for times in range(3):
            url = 'https://www.googleapis.com/books/v1/volumes?q=subject:' + \
                subject + '&langRestrict=en&startIndex=' + \
                str(40*times)+'&maxResults=40'
            res = get(url).json()
            if not res['totalItems']:
                break
            arr += res['items']
            if len(res['items']) < 40:
                break
        print(arr)
        if len(arr) != 0:
            with open('dataset/topics/'+folder+'/'+subject+'.json', 'w') as f:
                json.dump(arr, f)
