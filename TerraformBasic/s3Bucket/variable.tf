variable "region" {
  type = string
  default = "ap-southeast-1"
}

variable "webBucket" {
    type = string
    default = "aws-nthn-s3"
  
}
variable "privateBucket" {
    type = string
    default = "aws-nthn-private-s3"
  
}