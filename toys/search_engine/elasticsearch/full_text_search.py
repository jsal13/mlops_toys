import json

from elasticsearch import Elasticsearch


class Search:
    def __init__(self):
        self.es = Elasticsearch("http://localhost:9200")
        client_info = self.es.info()
        print("Connected to Elasticsearch!")
        print(client_info.body)

    def create_index(self):
        self.es.indices.delete(index="my_documents", ignore_unavailable=True)
        self.es.indices.create(index="my_documents")

    def insert_documents(self, documents):
        operations = []
        for document in documents:
            operations.append({"index": {"_index": "my_documents"}})
            operations.append(document)
        return self.es.bulk(operations=operations)

    def search(self, **query_args):
        return self.es.search(index="my_documents", **query_args)

    def match_search(self, text):
        return self.search(query={"match": {"name": {"query": text}}})


es = Search()
es.create_index()


with open("sample-data.json", "r", encoding="utf-8") as f:
    documents = json.load(f)
es.insert_documents(documents=documents)

result = es.match_search(text="work from home")
print(result)
