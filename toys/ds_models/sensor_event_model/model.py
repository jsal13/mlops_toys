import os

import joblib
import pandas as pd
import psycopg
from sklearn.compose import ColumnTransformer
from sklearn.ensemble import RandomForestClassifier
from sklearn.model_selection import train_test_split
from sklearn.pipeline import Pipeline
from sklearn.preprocessing import OrdinalEncoder, StandardScaler

from toys.ds_models.sensor_event_model.make_sample_targets import (
    invert_labels,
    make_target,
)
from toys.ds_models.utils.classification import score_printout

PG_CONNECTION_STRING: str
if os.environ.get("IN_DOCKER_CONTAINER") == "true":
    PG_CONNECTION_STRING = "postgresql://db:5432/postgres?user=postgres&password=example"
else:
    PG_CONNECTION_STRING = (
        "postgresql://localhost:5432/postgres?user=postgres&password=example"
    )


class EventModel:
    """Create a model from table data."""

    def __init__(self) -> None:
        self.X, self.y = self._get_data_from_table()
        self.X_train: pd.DataFrame
        self.X_test: pd.DataFrame
        self.y_train: pd.DataFrame
        self.y_test: pd.DataFrame
        self.clf: RandomForestClassifier

        self.preprocessor = self._create_preprocessor()

    def _get_data_from_table(self) -> tuple[pd.DataFrame, pd.DataFrame]:
        """Return Feature and Target dataframes of records from ``events`` tale."""
        # Pylint false positive here for psycopg.
        # Ref: https://github.com/pylint-dev/pylint/issues/5273
        conn = psycopg.connect(conninfo=PG_CONNECTION_STRING)
        with conn:  # pylint: disable=not-context-manager
            df = pd.read_sql(sql="SELECT * FROM events LIMIT 500;", con=conn)

        df.drop("id", axis=1, inplace=True)

        # Drop the datetime and the id, we don't wanna do timeseries stuff yet here.
        X = df.drop(["dt"], axis=1)
        y = make_target(df=df)  # Creates synthetic labels for this data.

        return (X, y)

    def _create_preprocessor(self) -> Pipeline:
        """Create preprocessor for data."""
        numeric_features = ["value_1", "value_2", "value_3"]
        numeric_transformation = Pipeline(
            steps=[
                ("scaler", StandardScaler()),
            ]
        )

        categorical_features = ["power"]
        power_categories = [["LOW", "MEDIUM", "HIGH"]]
        categorical_transformation = Pipeline(
            steps=[("ordinal_encoder", OrdinalEncoder(categories=power_categories))]
        )

        preprocessor = ColumnTransformer(
            transformers=[
                ("numeric", numeric_transformation, numeric_features),
                ("categorical", categorical_transformation, categorical_features),
            ],
            remainder="passthrough",
        )
        return preprocessor

    def train_model(self, test_size: float = 0.20) -> None:
        """Train a model."""
        self.X_train, self.X_test, self.y_train, self.y_test = train_test_split(
            self.X,
            self.y,
            test_size=test_size,
        )

        # Creates error in training set not present in test set.
        self.y_train = invert_labels(self.y_train, val_to_invert=False, percentage=0.3)

        classifier = Pipeline(
            steps=[
                ("preprocessor", self.preprocessor),
                ("rfclassifier", RandomForestClassifier()),
            ]
        )

        self.clf = classifier.fit(self.X_train, self.y_train)

    def save_model(self, loc: str) -> None:
        """Save model."""
        joblib.dump(self.clf, os.path.join(loc, "model.joblib"))

    def load_model(self, loc: str) -> None:
        """Load pickled model."""
        joblib.load(os.path.join(loc, "model.joblib"))

    def score_model(self) -> pd.DataFrame:
        """Score the current model."""
        return score_printout(self.y_test, self.clf.predict(self.X_test))


# if __name__ == "__main__":
#     em = EventModel()
#     em.train_model()
#     em.save_model(loc=".")
#     print(em.score_model())
