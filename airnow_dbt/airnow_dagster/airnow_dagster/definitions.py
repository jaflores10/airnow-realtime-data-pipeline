from dagster import Definitions, load_assets_from_modules, resource
from dagster_dbt import DbtCliResource
from .assets import airnow_dbt_dbt_assets, airnow_hist_raw, airnow_raw_realtime
from .project import airnow_dbt_project
from .schedules import schedules
from google.cloud import bigquery

@resource
def bigquery_client_resource(context):
    credentials_path = 'C:\\Users\\javier.flores\\Desktop\\Portfolio\\Air Quality Data Streaming and Anomaly Detection\\gcp\\service_account\\key-polymer-434418-m6-8905bf935398.json'
    return bigquery.Client.from_service_account_json(credentials_path)


defs = Definitions(
    assets=[airnow_hist_raw, airnow_raw_realtime, airnow_dbt_dbt_assets],
    schedules=schedules,
    resources={
        "dbt": DbtCliResource(project_dir=airnow_dbt_project),
        "bigquery_client": bigquery_client_resource
    },
)