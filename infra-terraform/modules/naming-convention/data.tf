//// --- [Data (Existing resources)] --- ////

locals {
    app_service_plan = "asp-${var.starter_name}-${var.environment_name}"
    api_management_service = "apim-${var.starter_name}-${var.environment_name}"
    database = "sqldb-${var.starter_name}-${var.environment_name}"
    webapp = "app-${var.starter_name}-${var.environment_name}"
    managed_identity = "id-${var.starter_name}-${var.environment_name}"
    sql_server = "sql-${var.starter_name}-${var.environment_name}"
    keyvault = "kv-${var.starter_name}-${var.environment_name}"
}