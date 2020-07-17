import json
from requests import get

subjects = ["Anatomy", "Biochemistry", "Biotechnology",
            "Botany", "Ecology", "Genetics", "Physiology", "Zoology"]
# subject = 'American History'

for subject in subjects:
    url = 'https://www.googleapis.com/books/v1/volumes?q=subject:' + \
        subject + '&langRestrict=en&startIndex=0&maxResults=40'
    res = get(url).json()
    if res['totalItems'] == 0:
        continue
    print(res)
    with open(subject+'.json', 'w') as f:
        json.dump(res, f)
