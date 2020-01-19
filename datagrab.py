"""
Everything relating to grabbing data, from WikiData to plain scraping the internet.
"""


import requests
import pandas as pd


class WikiData:
    """
    Wrapper class to get information from WikiData on Books
    """

    url = 'https://query.wikidata.org/sparql'

    def _get_all_books(self):
        """
        Returns the response JSON result when querying for all books.
        """

        query = """SELECT ?book ?bookLabel ?genre_label ?series_label ?publicationDate
        WHERE
        {
            OPTIONAL {
                ?book wdt:P31 wd:Q571 .
                ?book wdt:P136 ?genre .
                ?genre rdfs:label ?genre_label .
            }
            OPTIONAL {
                ?book wdt:P50 ?author .

            }
            OPTIONAL {
                ?book wdt:P179 ?series .
                ?series rdfs:label ?series_label .
            }
            OPTIONAL {
                ?book wdt:P577 ?publicationDate .
            }
            SERVICE wikibase:label {
                bd:serviceParam wikibase:language "en" .
            }
        }"""
        response = requests.get(
            self.url, params={'format': 'json', 'query': query})
        return response.json()

    def _get_all_books_with_genre_tagged(self):
        """
        Returns books with the tagged genre.
        """

        query = """SELECT ?book ?bookLabel ?genre_label ?series_label ?publicationDate
        WHERE
        {
            ?book wdt:P31 wd:Q571 .
            ?book wdt:P136 ?genre .
            ?genre rdfs:label ?genre_label filter (lang(?genre_label) = "en") .
            OPTIONAL {
                ?book wdt:P50 ?author .
            }
            OPTIONAL {
                ?book wdt:P179 ?series .
                ?series rdfs:label ?series_label filter (lang(?series_label) = "en").
            }
            OPTIONAL {
                ?book wdt:P577 ?publicationDate .
            }
            SERVICE wikibase:label {
                bd:serviceParam wikibase:language "en" .
            }
        }"""
        response = requests.get(
            self.url, params={'format': 'json', 'query': query})
        return response.json()

    def _get_info_on_book(self, book_id):
        query = """SELECT ?companyLabel ?wdLabel ?ps_Label ?wdpqLabel ?pq_Label {
        VALUES (?company) {(wd:""" + book_id + """)}

        ?company ?p ?statement .
        ?statement ?ps ?ps_ .

        ?wd wikibase:claim ?p.
        ?wd wikibase:statementProperty ?ps.

        OPTIONAL {
            ?statement ?pq ?pq_ .
            ?wdpq wikibase:qualifier ?pq .
        }

        SERVICE wikibase:label { 
            bd:serviceParam wikibase:language "en" }
        } ORDER BY ?wd ?statement ?ps_
        """
        response = requests.get(
            self.url, params={'format': 'json', 'query': query})
        result = ""
        try:
            result = response.json()
        except:
            result = False
        finally:
            return result

    def book_list(self, genre_tagged=False):
        """
        Returns a DataFrame of all books available (allows for filters)
        :param genre_tagged: True if filter out only books with genre available, False otherwise
        :returns: DataFrame, with list of books and series/genre details
        """
        books = self._get_all_books(
        ) if not genre_tagged else self._get_all_books_with_genre_tagged()
        info = [{key: book[key]['value'] for key in book.keys()}
                for book in books['results']['bindings']]
        df_books = pd.DataFrame(info)
        df_books = df_books.rename(columns={'book': 'URI Object', 'series_label': 'Series',
                                            'genre_label': 'Genre', 'bookLabel': 'Title',
                                            'publicationDate': 'Publication Date'})
        return df_books

    def book_data(self, book_id):
        """
        Returns a Dictionary with all info on a queried book
        :param book_id: str, WikiData Book ID of the queried book. eg. Q1093184
        :returns: dict, information on the book
        """
        facts = self._get_info_on_book(book_id)
        if facts is False:
            return False
        info = {fact['wdLabel']['value']: fact['ps_Label']['value']
                for fact in facts['results']['bindings']}
        return info

    def full_data(self, count_limit=99999):
        book_list = self.book_list(genre_tagged=True)
        full_frame = []
        count = 0
        print('{0:5} Books available. Starting DataGrab.'.format(len(book_list['URI Object'])))
        for book in book_list['URI Object']:
            book_id = book.split('/')[-1]
            data = self.book_data(book_id)
            if data is not False:
                full_frame.append(data)
            count += 1
            print('{0:5} data points complete.'.format(count))
            if count >= count_limit:
                break
        df = pd.DataFrame(full_frame)
        return df


if __name__ == '__main__':
    WK = WikiData()
    # BOOK_LIST = WK.book_list()
    # print(BOOK_LIST)
    # BOOK_DATA = WK.book_data('Q287838')
    # print(BOOK_DATA)
    res = WK.full_data()
    with open('wikidata.csv', 'w') as f:
        f.write(res.to_csv())
