resource "google_sql_database_instance" "wordpress-master" {
  name = "c-db-master"
  region = "${var.default_region}"
  database_version = "MYSQL_5_7"

  settings {
    tier = "db-n1-standard-1"
    backup_configuration {
      binary_log_enabled = true
      enabled = true
      start_time = "06:00"
    }
  }
}

resource "google_sql_database_instance" "wordpress-replica" {
  name = "c-db-replica"
  region = "${var.default_region}"
  database_version = "MYSQL_5_7"
  master_instance_name = "${google_sql_database_instance.wordpress-master.name}"

  replica_configuration {
    connect_retry_interval = "30"
    failover_target = true
  }

  settings {
    tier = "db-n1-standard-1"
  }
}

resource "google_sql_database" "wordpress" {
  name     = "wordpress"
  depends_on = ["google_sql_database_instance.wordpress-master", "google_sql_database_instance.wordpress-replica"]
  instance = "${google_sql_database_instance.wordpress-master.name}"
}

resource "google_sql_user" "users" {
  name       = "wordpress"
  depends_on = ["google_sql_database.wordpress"]
  instance   = "${google_sql_database_instance.wordpress-master.name}"
  password   = "my-password"
}
