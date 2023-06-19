variable "user_pool_id" {
  description = "User Pool Id"
  type        = string
}
variable "namespace" {
  type = string
}
variable "app_client_list" {
	description = "Describes App clients"
	type = list(object({              
		env_name = string      
		signout_urls = list(string) 
		callback_urls = list(string) 
		}))
}

variable "cognito_group_list" {
	default = [
	  {  
		name = "System_Admin" 
		desc = "System Administrator"
	 },
	  {  
		name = "Business_Admin" 
		desc = "Business Administrator"
	 } 
]
}



