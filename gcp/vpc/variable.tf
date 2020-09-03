variable "project" { 
  default = ""
}

variable "region" { 
  default = "us-central1"
}

variable "zone" { 
  default = "us-central1-c"
}

variable "cidr" { 
  default = "10.0.0.0/16" 
}

variable "key" { 
  default = "/home/shumondal/t.json"
}

variable "subnet1" {
  default = "10.10.10.0/24"
}

variable "subnet2" {
  default = "10.10.20.0/24"
}


variable "subnetname1" {
  default = "subnet-01"
}

variable "subnetname2" {
  default = "subnet-02"
}

variable "vpc_name" {
  default = "myvpc"
}

variable "ip_cidr_range" {
  default = "192.168.64.0/24"
}


