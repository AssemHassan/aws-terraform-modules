variable "app"{
    type = object({
      app_name = string
      account_number = string
      env = string
      region = string 

    })
    default = {
      app_name = "app"
      account_number = "366392838007"
      env = "prod"    
      region = "us-east-2" 
    }
}