resource "aws_glue_catalog_database" "covid_db" {
  name = "covid_db"
}

resource "aws_glue_catalog_table" "vaccine_detl_table" {
  database_name = aws_glue_catalog_database.covid_db.name
  name          = "vaccine_detl"
  table_type    = "EXTERNAL_TABLE"

  storage_descriptor {
    location = "s3://covid-data-16091988/glue-catalog/vaccine-data"
  }
}


# created the role manually in console and assigned it to the crawler
resource "aws_glue_crawler" "vaccine_data_crawler" {
  name          = "vaccine_detl_crawler"
  database_name = aws_glue_catalog_database.covid_db.name
  role          = "arn:aws:iam::249961799892:role/aws-glue-crawler-role"


  s3_target {
    path = "s3://covid-data-16091988/csv/vaccine-data"
  }

  depends_on = [aws_glue_catalog_table.vaccine_detl_table]

}

# Note: Replace placeholders (your_*) with your actual values.

