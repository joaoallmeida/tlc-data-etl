from setuptools import find_packages, setup

setup(
    name="tlc_pipeline",
    packages=find_packages(exclude=["tlc_pipeline_tests"]),
    install_requires=[
        "dagster",
        "dagster-cloud",
        "dagster-duckdb",
        "dagster-dbt",
        "dbt-duckdb",
        "duckdb",
        "beautifulsoup4",
        "s3fs",
        "sqlescapy",
        "pandas"
    ],
    extras_require={"dev": ["dagster-webserver", "pytest"]},
)
