
import functions_framework
import requests
import pandas as pd
from google.cloud import bigquery
from datetime import datetime

@functions_framework.http
def load_airnow_to_bq(request):
    """HTTP Cloud Function.
    Args:
        request (flask.Request): The request object.
        <https://flask.palletsprojects.com/en/1.1.x/api/#incoming-request-data>
    Returns:
        The response text, or any set of values that can be turned into a
        Response object using `make_response`
        <https://flask.palletsprojects.com/en/1.1.x/api/#flask.make_response>.
    """
    
    # Parse request JSON for function parameters
    request_json = request.get_json()
    
    # Extract parameters from the request
    api_key = request_json.get("api_key")
    zip_code = request_json.get("zip_code")
    bq_table = request_json.get("bq_table")
    
    if not api_key or not zip_code or not bq_table:
        return "Missing required parameters", 400

    # Pull data from AirNow API
    url = "http://www.airnowapi.org/aq/observation/zipCode/current/"
    params = {
        "format": "application/json",
        "zipCode": zip_code,
        "distance": "25",
        "API_KEY": api_key
    }
    
    response = requests.get(url, params=params)
    data = response.json()
    
    # Convert JSON to DataFrame
    df = pd.DataFrame(data)
    
    # Return below string is no data is returned
    if df.empty:
        return "No data found.", 200
    
    # Ensure 'DateObserved' column is datetime format
    if 'DateObserved' in df.columns:
        df['DateObserved'] = pd.to_datetime(df['DateObserved'])
    
    # Add 'DataPulledAt' column to ensure data is not inadvertently overwritten in BigQuery (table partitions on this column)
    df['DataPulledAt'] = datetime.utcnow()  # Adds UTC timestamp
    
    # Convert all other columns to strings
    cols_to_convert = df.columns.difference(['DateObserved', 'DataPulledAt'])
    df[cols_to_convert] = df[cols_to_convert].astype(str)
    
    # Load DataFrame into BigQuery
    client = bigquery.Client()
    
    # Set the destination table
    table_id = bq_table
    
    # Load data into BigQuery
    job = client.load_table_from_dataframe(df, table_id)
    
    # Wait for the job to complete
    job.result()
    
    return f"Data successfully loaded into {table_id}", 200
