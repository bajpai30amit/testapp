terraform {
  backend "gcs" {
    bucket  = "amit-test-poc-vol"
    credentials = "./creds/66-test.json"
  }
}
