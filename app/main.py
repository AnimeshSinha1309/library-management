import json
import uuid
import pandas as pd
from fuzzywuzzy import fuzz 
from fuzzywuzzy import process
from flask import Flask,request,abort

app = Flask(__name__)

@app.route("/")
def hello():
    return "Hello World!"  

@app.route("/query",methods=['GET'])
def query():
    dict = request.args

    bookdb_path = './app/db/books-data.csv'
    df = pd.read_csv(bookdb_path)    
    
    # Run query
    for key,val in dict.items():
        if key == 'isbn' or key == 'rating':
            try:
                val = int(val)
            except:
                return abort(404)
        
        if key != 'sort' and key != 'flag' and key != 'maxResults':    
            lst = []
            if key != 'isbn' and key != 'rating' and key != id:
                #Fuzzy
                THRESHOLD = 90
                tmp = process.extract(val,df[key].unique(),limit=100)
                for val in tmp:
                    if val[1] < THRESHOLD:
                        break
                    lst.append(val[0])
            else:
                # non fuzzy
                lst.append(val)
            
            try:    
                df = df.loc[df[key].isin(lst)]
                # shuffle so that all books in returned list are not of continusoly same tag
                if key == 'tag':
                    df = df.sample(frac = 1)
            except:
                return abort(404)

    # Sort
    if 'sort' in dict.keys():
        val = dict['sort']
        try:
            if dict['flag'] == '0':
                df = df.sort_values(by=[val])
            else:
                df = df.sort_values(by=[val],ascending=False)
        except:
            return abort(404)


    # Max Results
    if 'maxResults' in dict.keys():
        try:
            val = int(dict['maxResults'])
        except:
            return abort(404)

        if(len(df) >= val):
            df = df.head(val)

    # Convert to list of dicts
    result = []

    for i,row in df.iterrows():
        row = row.to_dict()
        result.append(row)

    result_json = json.dumps(result)
    return result_json


@app.route("/request-book",methods=['POST'])
def requestbook():
    dict = request.form
    print(dict)
    return dict

    bookdb_path = './app/db/request-books.csv'
    df = pd.read_csv(bookdb_path)    

    try:
        print(type(dict['isbn']))
        return dict['isbn']
        check = (int(dict['isbn']) in df.isbn.values)
    except:
        return abort(404)    
    
    try:
        if check == False:
            id = uuid.uuid4()
            df = df.append({"id":id,'isbn':dict['isbn'],'title':dict['title'],'category':dict['category'],'reason':dict['reason'],'cnt':1},ignore_index = True)
            df.to_csv(bookdb_path,index = False)
        else:
            df.loc[df.isbn == int(dict['isbn']) , ['cnt']] += 1
            df.loc[df.isbn == int(dict['isbn']) , ['reason']] += "|" + dict['reason']
            df.to_csv(bookdb_path,index = False)
    except:
        return abort(404)

    return "Saved"
        

@app.route("/view-requested-books",methods=['GET'])
def viewrequestbooks():
    dict = request.args

    bookdb_path = './app/db/request-books.csv'
    df = pd.read_csv(bookdb_path)    
    
    # Sort by cnt
    if 'sort' in dict.keys():
        val = dict['sort']
        try:
            if dict['flag'] == '0':
                df = df.sort_values(by=[val])
            else:
                df = df.sort_values(by=[val],ascending=False)
        except:
            return abort(404)

    # Max Results
    if 'maxResults' in dict.keys():
        try:
            val = int(dict['maxResults'])
        except:
            return abort(404)

        if(len(df) >= val):
            df = df.head(val)

    # Convert to list of dicts
    result = []

    for i,row in df.iterrows():
        row = row.to_dict()
        result.append(row)

    result_json = json.dumps(result)
    return result_json

@app.route("/delete-requested-book",methods=['POST'])
def deleterequestbook():
    dict = request.form

    bookdb_path = './app/db/request-books.csv'
    df = pd.read_csv(bookdb_path)  

    try:
        df = df[df.isbn != int(dict['isbn'])]  
        df.to_csv(bookdb_path,index = False)
    except:
        return abort(404)
    
    return "Deleted"
