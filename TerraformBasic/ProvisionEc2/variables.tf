variable "region" {
    default = "ap-southeast-1"
}

variable "amis" {
    type = string
    default = "ami-01938df366ac2d954"
}

variable "sshKey" {
    type = map(string)

    default = {
      key_name = "my-aws-key"

    }
  
}

