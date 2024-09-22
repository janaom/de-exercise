from airflow import DAG
from airflow.providers.google.cloud.operators.bigquery import BigQueryInsertJobOperator
from airflow.providers.google.cloud.operators.gcs import GCSListObjectsOperator
from airflow.providers.google.cloud.transfers.gcs_to_bigquery import GCSToBigQueryOperator
from airflow.utils.dates import days_ago

#Define your DAG
default_args = {
    'start_date': days_ago(1),
    'retries': 1,
}
with DAG(
    dag_id='gcs_to_bigquery_dag',
    default_args=default_args,
    schedule_interval='*/10 * * * *',
    catchup=False,
) as dag:
    #Task to list objects in the GCS bucket with a specific prefix
    list_gcs_objects = GCSListObjectsOperator(
        task_id='list_gcs_objects',
        bucket='your-bucket',
        prefix='AIS',
        delimiter='/',
        gcp_conn_id='google_cloud_default',
    )
    #Task to load all CSV files from GCS bucket to BigQuery
    load_to_bigquery = GCSToBigQueryOperator(
        task_id='load_to_bigquery',
        bucket='your-bucket',
        source_objects=list_gcs_objects.output,
        destination_project_dataset_table='project-id.dataset.ais_data',
        source_format='CSV',
        create_disposition='CREATE_IF_NEEDED',
        write_disposition='WRITE_TRUNCATE',
        autodetect=True,
        gcp_conn_id='google_cloud_default',
    )
    #Task to run a BigQuery query and insert the result into another table
    run_bq_query = BigQueryInsertJobOperator(
        task_id='run_bq_query',
        configuration={
            "query": {
                "query": """
                    SELECT *
                    FROM `project-id.dataset.ais_data`
                    WHERE LAT BETWEEN 29 AND 31
                    AND LON BETWEEN -90 AND -73
                    AND SOG > 0 
                """,
                "useLegacySql": False,
                "destinationTable": {
                    "projectId": "project-id",
                    "datasetId": "dataset",
                    "tableId": "filtered_data"
                },
                "writeDisposition": "WRITE_TRUNCATE",
            }
        },
        gcp_conn_id='bigquery_default',
    )
    #Define task dependencies
    list_gcs_objects >> load_to_bigquery >> run_bq_query
