resource "aws_glue_catalog_database" "db" {
  name = "exercise-001-catalog"
}

resource "aws_glue_crawler" "data_table_crawler" {
  database_name = aws_glue_catalog_database.db.name
  name          = "DataTableCrawler"

  role = aws_iam_role.glue_crawler_role.id

  # schema_change_policy {
  #   delete_behavior = "LOG"
  #   update_behavior = "LOG"
  # }

  s3_target {
    path       = "s3://${module.s3_bucket_data.s3_bucket_id}/data"
    exclusions = ["*.json", "exercise-001-catalog.db/**"]
  }

  provisioner "local-exec" {
    command = "aws glue start-crawler --name ${self.name}"
  }

  depends_on = [aws_glue_catalog_table.data_table]
}

resource "aws_glue_catalog_table" "data_table" {
  name          = "data"
  database_name = aws_glue_catalog_database.db.name

  table_type = "EXTERNAL_TABLE"

  parameters = {
    EXTERNAL              = "TRUE"
    "parquet.compression" = "SNAPPY"
  }

  open_table_format_input {
    iceberg_input {
      metadata_operation = "CREATE"
      version            = 2
    }
  }

  storage_descriptor {
    # location      = "s3://${module.s3_bucket_data.s3_bucket_id}/data"
    input_format  = "org.apache.hadoop.hive.ql.io.parquet.MapredParquetInputFormat"
    output_format = "org.apache.hadoop.hive.ql.io.parquet.MapredParquetOutputFormat"

    ser_de_info {
      name                  = "data-ser-de"
      serialization_library = "org.apache.hadoop.hive.ql.io.parquet.serde.ParquetHiveSerDe"

      parameters = {
        "serialization.format" = 1
      }
    }

    columns {
      name = "id"
      type = "int"
    }

    columns {
      name = " name"
      type = "string"
    }

    columns {
      name = "invoice_amt"
      type = "int"
    }

    columns {
      name = "date"
      type = "string"
    }
  }
}
