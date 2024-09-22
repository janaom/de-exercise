variable "project_id" {
  description = "The ID of the Google Cloud project"
  type        = string
  default     = "project-id"
}

variable "region" {
  description = "The region for the resources"
  type        = string
  default     = "us-central1"
}

variable "zone" {
  description = "The zone for the resources"
  type        = string
  default     = "us-central1-a"
}

variable "bucket_name" {
  description = "The name of the GCS bucket"
  type        = string
  default     = "de-task-ships"
}

variable "dataset_id" {
  description = "The ID of the BigQuery dataset"
  type        = string
  default     = "data_ships"
}

variable "table_ships" {
  description = "The name of the BigQuery conversations table"
  type        = string
  default     = "ais_data"
}

variable "table_filtered" {
  description = "The name of the BigQuery conversations table"
  type        = string
  default     = "filtered_data"
}

variable "instance_name" {
  type = string
  default = "my-instance" 
}

variable "machine_type" {
  type = string
  default = "n2-standard-2"  
}

variable "image_name" {
  type = string
  default = "debian-cloud/debian-12"
}

variable "subnetwork_name" {
  type = string
  default = "default" 
}

variable "external_ip_name" {
  default = "external-ip"
}

variable "airflow_firewall_name" {
  default = "allow-airflow-8080"
}

variable "ais_files" {
  description = "A list of AIS files to upload to GCS"
  type        = list(object({
    name   = string
    source = string
  }))
  default = [
    {
      name   = "AIS_2024_03_30.csv"
      source = "/path-to-the-file/AIS_2024_03_30.csv"
    },
    {
      name   = "AIS_2024_03_31.csv"
      source = "/path-to-the-file/AIS_2024_03_31.csv"
    }
  ]
}


variable "table_schema" {
  default = <<EOF
[
  {
    "name": "MMSI",
    "type": "INTEGER",
    "mode": "NULLABLE"
  },
  {
    "name": "BaseDateTime",
    "type": "TIMESTAMP",
    "mode": "NULLABLE"
  },
  {
    "name": "LAT",
    "type": "FLOAT",
    "mode": "NULLABLE"
  },
  {
    "name": "LON",
    "type": "FLOAT",
    "mode": "NULLABLE"
  },
  {
    "name": "SOG",
    "type": "FLOAT",
    "mode": "NULLABLE"
  },
  {
    "name": "COG",
    "type": "FLOAT",
    "mode": "NULLABLE"
  },
  {
    "name": "Heading",
    "type": "FLOAT",
    "mode": "NULLABLE"
  },
  {
    "name": "VesselName",
    "type": "STRING",
    "mode": "NULLABLE"
  },
  {
    "name": "IMO",
    "type": "INTEGER",
    "mode": "NULLABLE"
  },
  {
    "name": "CallSign",
    "type": "INTEGER",
    "mode": "NULLABLE"
  },
  {
    "name": "VesselType",
    "type": "INTEGER",
    "mode": "NULLABLE"
  },
  {
    "name": "Status",
    "type": "INTEGER",
    "mode": "NULLABLE"
  },
  {
    "name": "Length",
    "type": "INTEGER",
    "mode": "NULLABLE"
  },
  {
    "name": "Width",
    "type": "INTEGER",
    "mode": "NULLABLE"
  },
  {
    "name": "Draft",
    "type": "FLOAT",
    "mode": "NULLABLE"
  },
  {
    "name": "Cargo",
    "type": "INTEGER",
    "mode": "NULLABLE"
  },
  {
    "name": "TransceiverClass",
    "type": "STRING",
    "mode": "NULLABLE"
  }
]
EOF
}
