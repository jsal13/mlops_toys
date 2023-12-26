import random
import streamlit as st
import numpy as np
from sklearn.model_selection import train_test_split
from sklearn.ensemble import RandomForestClassifier
from sklearn.metrics import f1_score, precision_score, recall_score, accuracy_score

import polars as pl
from faker import Faker

faker = Faker()

st.write("# My Steamlit App!")

st.write(
    "Here is a lot of text.  This is the app, and it's pretty okay.  Lots of things you can do.  Welp, see ya later."
)


@st.cache_data
def generate_fake_dataframe() -> pl.DataFrame:
    """Generate a fake dataframe."""
    fake_data_nrows = 10000
    fake_data = {
        "name": [faker.name() for _ in range(fake_data_nrows)],
        "age": [random.randint(10, 100) for _ in range(fake_data_nrows)],
        "salary": [random.randint(10000, 1000000) for _ in range(fake_data_nrows)],
        "married": [random.random() < 0.3 for _ in range(fake_data_nrows)],
    }

    return pl.DataFrame(fake_data)


df_fake = generate_fake_dataframe()

st.code(
    """
# Aggregated salary by age.
df_salary_gb_age = (
    df_fake.group_by("age")
    .agg(pl.col("salary").mean().alias("mean_salary"))
    .sort("mean_salary", descending=True)
    .head(5)
)
""",
    language="python",
)

# Aggregated salary by age.
df_salary_gb_age = (
    df_fake.group_by("age")
    .agg(pl.col("salary").mean().alias("mean_salary"))
    .sort("mean_salary", descending=True)
)

st.write(df_salary_gb_age.head(5))

st.scatter_chart(df_salary_gb_age, x="age", y="mean_salary")

st.divider()
# LATEX STUFF

latex_expressions = [
    r"""
\int_{0}^{\infty}f(x)g(x)\,dx = \sum_{k=1}^{m}x_{k}""",
    r"""
\begin{array}{lcr}
\text{First number} & x & 8 \\
\text{Second number} & y & 15 \\
\text{Sum} & x + y & 23 \\
\text{Difference} & x - y & -7 \\
\text{Product} & xy & 120 \end{array}
""",
    r"""
\left( \begin{array}{ccc}
a & b & c \\
d & e & f \\
g & h & i \end{array} \right)
""",
    r"""
\chi(\lambda) = \left| \begin{array}{ccc}
\lambda - a & -b & -c \\
-d & \lambda - e & -f \\
-g & -h & \lambda - i \end{array} \right|
""",
]

for expr in latex_expressions:
    st.latex(expr)

st.divider()
# SCIKIT MODEL

data = df_fake.select(["age", "salary", "married"]).to_numpy()
X = data[:, 0:2]
y = data[:, 2]

X_train, X_test, y_train, y_test = train_test_split(
    X, y, test_size=0.33, random_state=42
)

clf = RandomForestClassifier()
clf.fit(X=X_train, y=y_train)

metrics = [f1_score, precision_score, recall_score, accuracy_score]
metric_map = {
    metric.__name__: metric(y_true=y_test, y_pred=clf.predict(X_test))
    for metric in metrics
}
st.dataframe(pl.DataFrame(metric_map))

# PREDICT!
user_age = st.number_input(label="Age", min_value=20, max_value=100)
user_salary = st.slider(label="Salary", min_value=1000, max_value=100000, step=10000)
X = np.array([user_age, user_salary]).reshape(1, -1)
st.write(
    "Prediction: ",
    "Not Married" if clf.predict(X=X) else "Married",
    "For age",
    user_age,
    "and salary",
    user_salary,
)
