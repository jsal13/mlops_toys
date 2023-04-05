"""Utilities related to classification problems."""

import pandas as pd
from sklearn.metrics import accuracy_score, precision_score, recall_score, f1_score


def score_printout(y_true: pd.Series, y_pred: pd.Series) -> pd.DataFrame:
    """
    Printout a score for a classification problem.

    Includes:
    - Accuracy
    - Precision
    - Recall
    - F1 Score
    """
    scores = [
        ("Accuracy", accuracy_score(y_true=y_true, y_pred=y_pred)),
        ("Precision", precision_score(y_true=y_true, y_pred=y_pred)),
        ("Recall", recall_score(y_true=y_true, y_pred=y_pred)),
        ("F1", f1_score(y_true=y_true, y_pred=y_pred)),
    ]
    return pd.DataFrame(scores, columns=["Score", "Value"])
