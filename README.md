# AirNow AQI Data Pipeline, Notification System, and Analysis
## 📋 Overview
The goal of the AirNow air quality index (AQI) data pipeline, notification system, and analysis project is to implement a modern data stack with cloud platforms/tools. The project also implements an email notification system to provide a user real-time AQI measurements and an analysis of historical and real-time AQI observations. This project is designed to help professionals seeking to enhance their data ingestion, transformation, and automation workflows for complete and accurate data operational and analytical purposes.

Please note, given API limitations the data is limited to South Lake Tahoe, CA.

The following tools/technologies are used for data ingestion, warehousing, transformation, visualization, orchestration:
- Data ingestion
  - Python scripts (Cloud Functions) ✒️
- Data warehouse
  - BigQuery 🔎
- Data transformation
  - dbt (data build tool) ♻️
- Data Visualization
  - Python packages (Plotly) 📊
- Data Orchestration
  - Google Cloud Scheduler ⏲️
  - Dagster 🎻

AirNow API documentation may be obtained [here](https://docs.airnowapi.org/).

Inspiration for this project was drawn from my time living in California. Air quality has been an issue throughout the state for decades and the increasing rate of wildfires is causing more and more people to experience poor air quality.

## 💠 Modules
The modules below are organized to maintain clear separation of ELT components.
  
### Data Ingestion
Handles the extraction and loading of AirNow data.

**Location**: 
- [Historical data pull script](https://github.com/jaflores10/airnow-realtime-data-pipeline/blob/main/python_scripts/prod_scripts/airnow_historical_data_script.ipynb)
- [Real-time cloud function](https://github.com/jaflores10/airnow-realtime-data-pipeline/tree/main/python_scripts/cloud_functions/airnow_api_pull)

### BigQuery Data Warehouse
The BigQuery data warehouse contains the below three schemas and applicable tables.

#### Schema: airnow_raw
airnow_raw contains the raw data obtained from the API.

Tables:
- airnow_raw_hist
- airnow_raw_realtime

#### Schemma: airnow_staging
airnow_staging contains all historical and real-time data with updated data types.

Tables:
- airnow_staging_hist
- airnow_staging_realtime

#### Schema: airnow_analytics
airnow_analytics contains tables utlized for analyical purposes and serves as the data source for the email notification system.

Tables:
  - airnow_analytics_all_observations
  - airnow_analytics_realtime

### dbt Data Transformations
dbt models are used to clean and transform AirNow data. Key transformations include changing data types and appending historical and real-time data together to facilitate analysis and visualization.

**Location**: [airnow_dbt](https://github.com/jaflores10/airnow-realtime-data-pipeline/tree/main/airnow_dbt)

**Key Files**
- `dbt_project.yml`: dbt project configuration
- `schema.yml`: specifies data loaded into airnow_raw by the API
- `models/`: Contains dbt models for various stages of the data transformation cycle and data definitions for tables/columns (doc blocks)
- `macros/`: Contains dbt tests to validate dbt models

### Email Notifications Script
The email notifications system allows a user to input their email and receive real-time, up-to-date AQI information for South Lake Tahoe, CA. Please feel free to follow the link [here](https://us-central1-key-polymer-434418-m6.cloudfunctions.net/airnow_email_notification) and recieve AQI measurements for PM2.5, PM10, and O3!

*Please note, data schedules have been turned off to not exceed GCP credits.

**Location**: [airnow_email_notification](https://github.com/jaflores10/airnow-realtime-data-pipeline/tree/main/python_scripts/cloud_functions/airnow_email_notification)

### Data Visualization
The data is visualized using the Plotly package in Python. You may interactive with the visualizations [here](https://nbviewer.org/github/jaflores10/airnow-realtime-data-pipeline/blob/main/python_scripts/visualization_scripts/AirNow%20South%20Lake%20Tahoe%20Visualizations%20and%20Analysis.ipynb).

### Analysis Summary
The above visualizations demonstrate air quality is typically good throughout South Lake Tahoe, CA! However, there are clear instances where air quality is extrememly bad. The area does not experience more typical air quality issues such as smog or inversion layers; however, the more recent large wildfires brought prolonged periods of poor air quality.

Also, an analysis of gaining AQI measurement averages by day was done; however, the results did not yield much information. There are no specific days which yield better or worse air quality compared to others.

### Google Cloud Scheduler/Dagster Data Orchestration
Google Cloud Scheduler is used to automatically pull real-time AQI observations twice every hour from the API. The below screenshot details the configuration settings for the schedule:

![Cloud Scheduler Configurations](https://github.com/jaflores10/airnow-realtime-data-pipeline/blob/main/gcp/gcp_airnow_api_cloud_schedulerpng.png)

Dagster was integrated to orhestrate and manage the dbt models for transforming AirNow data.

**Location**: [airnow_dagster](https://github.com/jaflores10/airnow-realtime-data-pipeline/tree/main/airnow_dbt/airnow_dagster)

**Key files**
- `definitions.py`: This file contains the core configuration for Dagster, defining the repository that includes assets, jobs, and schedules
- `assests.py`: This file is used to define data assets (python scripts, dbt models, etc.)

The below DAG demonstrates how assets are connected, successful materialization, and scheduled to regulary run dbt models.
![airnow_dag](https://github.com/jaflores10/airnow-realtime-data-pipeline/blob/main/airnow_dbt/airnow_dagster/dag_screenshots/airnow_dag.png)

## 🚀 Getting Started
### Prerequisites
Ensure the following accounts and tools are set up before beginning this project:

#### Accounts
- **GitHub**: For version control and collaboration.

#### Tools
- **VS Code or other IDE**: Allows for easy code editing. [Download VSCode](https://code.visualstudio.com/download)
- **Python**: [Download Python](https://www.python.org/downloads/)
- **Google Cloud Platform***: [Obtain GCP trial](https://cloud.google.com/?utm_source=google&utm_medium=cpc&utm_campaign=na-US-all-en-dr-bkws-all-all-trial-e-dr-1707554&utm_content=text-ad-none-any-DEV_c-CRE_665665924744-ADGP_Hybrid+%7C+BKWS+-+MIX+%7C+Txt-Google+Cloud-General+GCP-KWID_43700077224933103-kwd-527294295527&utm_term=KW_gcp%20trial-ST_gcp+trial&gad_source=1&gclid=Cj0KCQjw7Py4BhCbARIsAMMx-_Iiy_aEt9g1-YYZWY9hNWe-KRjlaojOsz0hFvp58KpDCru_yEawfPwaAh5LEALw_wcB&gclsrc=aw.ds)
- **dbt Core**: [Install dbt Core](https://github.com/dbt-labs/dbt-core)
- **Dagster**: [Install Dagster](https://github.com/dagster-io/dagster)

### Project Starting Guide
To get started with this project, follow these steps:
1. **Clone the repository**: `git clone https://github.com/jaflores10/nfirs-realtime-data-pipeline/tree/main`
2. **Create virtual environment**: `python -m venv env` `source env/bin/activate` `# On Windows: `env\Scripts\activate`
3. **Set up the environment**: Install the required dependencies using `pip install -r requirements.txt`.
4. **Ingest the data**: Run the ingestion scripts to load data into DuckDB.
5. **Run dbt models**: Execute dbt models to transform the data.
6. **Visualize the data**: Access the Tableau dashboards to explore the visualizations and analyze data.

## Contributing
Contributions are welcome! Please submit a pull request or open an issue to discuss changes.

## Credits
- **Tools and Technologies**: Python, GCP, dbt, Tableau, Dagster
