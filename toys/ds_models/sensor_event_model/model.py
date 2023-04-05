from typing import Type

import pandas as pd
import psycopg

from sklearn.pipeline import Pipeline
from sklearn.preprocessing import StandardScaler, OrdinalEncoder
from sklearn.model_selection import train_test_split
from sklearn.linear_model import LogisticRegression
from sklearn.compose import ColumnTransformer
from sklearn.base import ClassifierMixin

from ds_models.sensor_event_model import make_sample_targets
from ds_models.utils import classification

PG_CONNECTION_STRING = (
    "postgresql://localhost:5432/postgres?user=postgres&password=example"
)

print(__package__)


class EventModel:
    """Create a model from table data."""

    def __init__(self) -> None:
        self.X, self.y = self._get_data_from_table()
        self.X_train: pd.DataFrame
        self.X_test: pd.DataFrame
        self.y_train: pd.DataFrame
        self.y_test: pd.DataFrame
        self.reg: Type[ClassifierMixin]

    def _get_data_from_table(self) -> tuple[pd.DataFrame, pd.DataFrame]:
        """Return Feature and Target dataframes of records from ``events`` tale."""
        # Pylint false positive here for psycopg.
        # Ref: https://github.com/pylint-dev/pylint/issues/5273
        conn = psycopg.connect(conninfo=PG_CONNECTION_STRING)
        with conn:  # pylint: disable=not-context-manager
            df = pd.read_sql(sql="SELECT * FROM events;", con=conn)

        df.drop("id", axis=1, inplace=True)

        # Drop the datetime and the id, we don't wanna do timeseries stuff yet here.
        X = df.drop(["dt"], axis=1)
        y = make_sample_targets.make_target(df)  # Creates synthetic labels for this data.

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
            ]
        )
        return preprocessor

    def train_model(self, test_size: float = 0.33) -> None:
        """Train a linear regression model."""
        self.X_train, self.X_test, self.y_train, self.y_test = train_test_split(
            self.X, self.y, test_size=test_size
        )

        preprocessor = self._create_preprocessor()

        regressor = Pipeline(
            steps=[
                ("preprocessor", preprocessor),
                ("rf_regression", LogisticRegression()),
            ]
        )

        self.reg = regressor.fit(self.X_train, self.y_train)

    def score_model(self) -> pd.DataFrame:
        """Score the current model."""
        return classification.score_printout(self.y_test, self.reg.predict(self.X_test))


if __name__ == "__main__":
    em = EventModel()
    em.train_model()
    print(em.score_model())
