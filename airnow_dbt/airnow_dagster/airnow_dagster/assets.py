from dagster import AssetExecutionContext, asset
from dagster_dbt import DbtCliResource, dbt_assets

from .project import airnow_dbt_project

@asset(required_resource_keys={"bigquery_client"})
def airnow_hist_raw(context):
    raw_table_id = "key-polymer-434418-m6.airnow_raw.airnow_hist_raw"
    context.log.info(f"Using existing table: {raw_table_id}")
    return raw_table_id

@asset(required_resource_keys={"bigquery_client"})
def airnow_raw_realtime(context):
    realtime_table_id = "key-polymer-434418-m6.airnow_raw.airnow_raw_realtime"
    context.log.info(f"Using existing table: {realtime_table_id}")
    return realtime_table_id

@dbt_assets(manifest=airnow_dbt_project.manifest_path)
def airnow_dbt_dbt_assets(context: AssetExecutionContext, dbt: DbtCliResource):
    yield from dbt.cli(["build"], context=context).stream()
    