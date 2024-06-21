"""Collection of Cereal jobs"""
from dagster import job



@job
def test():
    """Example of a simple Dagster job."""
    sum(range(100000))
    print("hello!")
