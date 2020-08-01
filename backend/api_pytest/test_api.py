import pytest
import json
import requests

def test_helloworld():
    url = "https://libmate.herokuapp.com/"
    headers = {'Content-Type': 'application/json'}
    resp = requests.get(url, headers=headers)
    assert resp.status_code == 200

def test_query():
    url = "https://libmate.herokuapp.com/query"
    headers = {'Content-Type': 'application/json'}
    params = {"isbn": "9780190250713"}
    resp = requests.get(url, params=params, headers=headers)
    assert resp.status_code == 200
    resp_dict = json.loads(resp.text)
    assert len(resp_dict) != 0

def test_model():
    url = "http://54.226.130.180/"
    headers = {'Content-Type': 'application/json'}
    resp = requests.get(url, headers=headers)
    assert resp.status_code == 200

def test_model_prediction():
    url = "http://54.226.130.180/predict"
    headers = {'Content-Type': 'application/json'}
    params = {"text": "Harry Potter"}
    resp = requests.get(url, params = params,headers=headers)
    assert resp.status_code == 200
