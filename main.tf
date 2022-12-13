resource "google_bigquery_dataset" "ds_demo" {
  dataset_id = "dstf"
}
resource "google_bigquery_table" "ds_demo_table" {
  table_id = "tabletf"
  dataset_id = google_bigquery_dataset.ds_demo.dataset_id
}


 
