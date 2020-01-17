# The Library Management System


## Software Deliverables

### The Library Management Portal

* Backwards portability for getting all the old data on books to new data.
* A Website where you can add books, and manipulate learnt data.

The following will be the data on each book, which can be generated based on the title given:
1. Title of the book (From title or entered)
2. ISBN Number (From title or entered)
3. Tags associated (Built from the ML model), *Uses deliverable 2*.
4. Cover Image (get's directly from scraping)

### Recommender System

Built on the Google Assitant platform, this takes some sample interac



## Classification and Tag Generation of Books

### The Global Set of Tags

We shall hard code all the tags. Multiple tags will the right of the learning system.
These tags will be of the following types (sample JSON given below):
```json
{
    "subject": [
        "physics",
        "computers",
        "maths"
    ],
    "domains": [
        "artificial intelligence",
        "cryptography",
        "black hole dynamic",
        "general relativity"
    ],
    "difficulty": [
        "novice",
        "advanced"
    ]
}
```


### If the Information is Available

References for similar implementations:
* 

Let's talk about the features first:
1. Title
2. Author Name
3. Summary
4. Cover Page
5. Published Date

Now for the possible ideas:
* Feed to the Stanford Classifier (k-means): http://cs229.stanford.edu/proj2015/127_report.pdf. This seems good for the title. Believe we will need to get a **sparse explanatory feature embedding** for the titles, before we feed into the classifier. 
* Use a Decision Tree, again over some specified features.
* 

### If the book is unseen

### More complex feature tags

### 