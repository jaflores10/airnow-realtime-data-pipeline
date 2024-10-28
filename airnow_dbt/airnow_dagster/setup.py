from setuptools import find_packages, setup

setup(
    name="airnow_dagster",
    version="0.0.1",
    packages=find_packages(),
    package_data={
        "airnow_dagster": [
            "dbt-project/**/*",
        ],
    },
    install_requires=[
        "dagster",
        "dagster-cloud",
        "dagster-dbt",
        "dbt-bigquery<1.9",
        "dbt-duckdb<1.9",
        "dbt-duckdb<1.9",
    ],
    extras_require={
        "dev": [
            "dagster-webserver",
        ]
    },
)