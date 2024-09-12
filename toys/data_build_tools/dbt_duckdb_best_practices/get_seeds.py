import io
import json
import os
import zipfile

import pandas as pd
import requests as req

URL_METADATA = "https://github.com/marianaossilva/DSW2019/raw/master/docs/assets/data/musicoset_metadata.zip"
URL_POPULARITY = "https://github.com/marianaossilva/DSW2019/raw/master/docs/assets/data/musicoset_popularity.zip"

SEEDS_DIR = "./music_o_set/seeds/"
METADATA_DIR = "musicoset_metadata"
POPULARITY_DIR = "musicoset_popularity"


def download_seeds(save_loc: str = "./music_o_set/seeds/") -> None:
    """Download and extract seeds for DBT from https://marianaossilva.github.io/DSW2019/#tables."""

    for url in [URL_METADATA, URL_POPULARITY]:
        resp = req.get(url)
        zip_file = zipfile.ZipFile(io.BytesIO(resp.content))
        zip_file.extractall(save_loc)


def clean_seeds_folder() -> None:
    """Clean seeds folder up a bit."""
    # Remove readmes.

    metadata_dir = os.path.join(SEEDS_DIR, METADATA_DIR)
    popularity_dir = os.path.join(SEEDS_DIR, POPULARITY_DIR)

    os.remove(os.path.join(metadata_dir, "ReadMe.txt"))
    os.remove(os.path.join(popularity_dir, "ReadMe.txt"))


def clean_seeds() -> None:
    """Clean certain seeds for malformed json, etc."""
    songs_loc = os.path.join(SEEDS_DIR, METADATA_DIR, "songs.csv")

    df = pd.read_csv(songs_loc, delimiter="\t")

    def f(x: str) -> str:
        """Removes errant 's from this json and makes it readable by duckdb."""
        d = eval(x)  # I'm so sorry.
        artist_list = [
            {"artist_id": k, "artist_name": v.replace("'", "").replace('"', "")}
            for k, v in d.items()
        ]
        return json.dumps(artist_list)

    df["artists"] = df["artists"].apply(f)
    df.to_csv(songs_loc, sep="\t", index=False)


if __name__ == "__main__":
    download_seeds()
    clean_seeds_folder()
    clean_seeds()
