//// --- [Call modules] --- ////


// Naming-Convention Module

module "naming-convention" {
  source           = "./modules/naming-convention"
  starter_name     = "[TRAINEENAME]" // Try to not take something with more than 5 characters
  environment_name = "terraform"
}

// 1. User assigned managed identity

// 2. Keyvault

// 3. SQL server

// 4. SQL database

// 5. App service plan

// 6. App service 

// Role assignments
