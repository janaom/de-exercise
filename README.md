

# Instructions
1. Download or generate 2 data sets (at least 1 GB+ per each (bigger is better), e.g. NYC taxi public data set)
2. Upload data to google cloud storage in GCP account.
3. Create data pipeline using any method of your choice in GCP which loads the data to Big Query.
4. Use as event to load the data from the files to Big query table.(Scheduling it also fine using any scheduling tool in GCP).
5. Write an SQL query in Big Query to display the number of taxis travelled from NEWYORK to all other cities on a particular week including weekends.(use any week in the data)
6. Optional - Use any of Infrastructure as a code platform(Terraform)
7. Optional – Use CICD by any of the platform like GitHub or Gitlab.


As an option you can use one of the listed environment:
- Your Own GCP account.
- Python or any of your programming language.

# Solutions

For this task, I'm using AIS data from the [National Oceanic and Atmospheric Administration](https://coast.noaa.gov/htdata/CMSP/AISDataHandler/2024/index.html) because the file sizes align better with the task requirements. I used NYC taxi data in a previous project to demonstrate a [GCP Data Engineering ETL pipeline with Mage](https://github.com/janaom/GCP-DE-project-uber-etl-pipeline).

Each CSV file contains these columns:

    - MMSI: Unique vessel identifier.
    - BaseDateTime: Timestamp of data reception.
    - LAT/LON: Vessel's position (latitude/longitude).
    - SOG: Vessel's speed over ground.
    - COG: Vessel's direction of movement.
    - Heading: Vessel's compass heading.
    - VesselName: Vessel's registered name.
    - IMO: International Maritime Organization number.
    - CallSign: Vessel's radio call sign.
    - VesselType: Type of vessel (cargo, tanker, etc.).
    - Status: Vessel's current status (underway, at anchor, etc.).
    - Length/Width/Draft: Vessel's dimensions.
    - Cargo: Type of cargo being transported.
    - TransceiverClass: Class of AIS transceiver used.


 ## First solution

![Screenshot (2130)](https://github.com/user-attachments/assets/b8deda39-a6b5-4887-b813-dbeed7865bec)

 ### 🏗️ Infrastructure

I'm using Terraform to create a GCS bucket, a VM instance, and a BigQuery dataset with tables. Terraform can also handle file uploads to the bucket, but it's more efficient for smaller files. Terraform files 'main.tf' and 'variables.tf' are added under the terraform directory.

 ### ⚙️ Automating Data Pipelines with Airflow

I'm using Airflow, running on a VM, as my orchestration tool. The workflow is scheduled to run every 10 minutes. The DAG file, `gcs_to_bigquery_dag`, incorporates an example SQL query that filters data where the latitude is between 29 and 31 degrees, the longitude is between -90 and -73 degrees, and the speed over ground (SOG) is greater than 0, loading the results into a new table.

Tasks:

- **list_gcs_objects**: Lists all objects within a specific GCS bucket, filtered by a given prefix. 

- **load_to_bigquery**: Loads the CSV file, identified by the previous task, from GCS into a pre-existing BigQuery table, preserving all data for future analysis.

- **run_bq_query**: Filters data, selecting rows where the latitude is between 29 and 31 degrees, the longitude is between -90 and -73 degrees, and the speed over ground (SOG) is greater than 0, then inserts the filtered results into a new table, overwriting any existing data in that table.

![Screenshot (2129)](https://github.com/user-attachments/assets/d365d65a-865d-4a28-9932-9e0b35bd0c59)

 ### 🧮 BigQuery

BigQuery was selected as the data sink to meet the task requirements. Here's an example of the loaded data.

![Screenshot (2131)](https://github.com/user-attachments/assets/b0fdaaa2-686b-4c53-87ae-d394fffe7a28)

## Second solution

![20240823_224651](https://github.com/user-attachments/assets/a1c72df9-0ea1-429b-a98e-d94656f01f04)

For this solution please refer to my preject [GCP Data Engineering Project: Data Pipeline with Cloud Run Functions, Airflow and BigQuery ML](https://medium.com/google-cloud/%EF%B8%8Fgcp-data-engineering-project-data-pipeline-with-cloud-run-functions-airflow-and-bigquery-ml-5120ecbf161d)

This project demonstrates how to build a data pipeline on Google Cloud using an event-driven architecture, leveraging services like GCS, Cloud Run functions, and BigQuery. I used both VM and Composer options for managing Airflow, and utilized Logging and Monitoring services to track the pipeline’s health. 
