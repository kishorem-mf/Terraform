locals {
  glue_src_path = "${path.root}/../glue/"
}

variable "s3_bucket" {
  type=string
}

variable "s3_filepath" {
  type=string
}

variable "project" {
  type=string
}

variable "projectcovid" {
  type=string
}

variable "s3_bucket_covid" {
  type=string
}