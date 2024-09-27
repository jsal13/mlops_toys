import json
from bs4 import BeautifulSoup
from elasticsearch import Elasticsearch

# Get API from the Kibana "API Ingestion" page.
API_KEY = "this_was_that_cool_API_key_I_had"
ES_ADDRESS = "https://localhost:9200"

es = Elasticsearch(hosts=ES_ADDRESS, api_key=API_KEY, verify_certs=False)

# Open the sgm files... for now, just pick one.
reut_sgm_id = "000"
with open(f"reut2-{reut_sgm_id}.sgm", "r", encoding="utf-8") as f:
    soup = BeautifulSoup(f.read(), "lxml")

# Find all the "reuters" tags, which each article has as an outer tag.
soup_reuters_tags = soup.find_all("reuters")

# For each article, get the title and the body.
# We have to append the index before each article.
operations = []
for idx, soup_reuter_tag in enumerate(soup_reuters_tags):
    title = soup_reuter_tag.find("title")
    title_txt = "" if not title else title.get_text(strip=True)
    content = soup_reuter_tag.get_text(strip=True).replace("\n", " ")

    operations.append({"index": {"_index": "search-reuters"}})
    operations.append({"title": title_txt, "content": content})

es.bulk(operations=operations)
