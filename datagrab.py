import requests
import pandas as pd


class WikiData:

    url = 'https://query.wikidata.org/sparql'

    def _get_all_books(self):
        query = """SELECT ?book ?bookLabel ?genre_label ?series_label ?publicationDate
        WHERE
        {
            OPTIONAL {
            ?book wdt:P31 wd:Q571 .
                ?book wdt:P136 ?genre .
                ?genre rdfs:label ?genre_label filter (lang(?genre_label) = "en").
            }
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
        # gathering all info based on book name
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
        return response.json()

    def book_list(self):
        books = self._get_all_books()
        head = ['URI Object', 'Series', 'Genre',
                'Publication Date', 'Book Title']
        info = [{key: book[key]['value'] for key in book.keys()}
                for book in books['results']['bindings']]
        df = pd.DataFrame(info)
        df.rename(columns={'book': 'URI Object', 'series_label': 'Series',
                           'genre_label': 'Genre', 'publicationDate': 'Publication Date', 'bookLabel': 'Title'})
        return df

    def book_data(self, book_id):
        facts = self._get_info_on_book(book_id)
        info = {fact['wdLabel']['value']: fact['ps_Label']['value']
                for fact in facts['results']['bindings']}
        return info


if __name__ == '__main__':
    wk = WikiData()
    book_list = wk.book_list()
    print(book_list)
    book_data = wk.book_data('Q287838')
    print(book_data)
