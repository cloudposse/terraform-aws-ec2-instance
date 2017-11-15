data "template_file" "user_data" {
  template = "${file("${path.module}/user-data/user_data.sh")}"

  vars {
    user_data       = "${join("\n", compact(concat(var.user_data, list(module.github_authorized_keys.user_data))))}"
    welcome_message = "${var.welcome_message}"
  }
}
