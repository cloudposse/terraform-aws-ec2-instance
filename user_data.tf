data "template_file" "user_data" {
  count    = "${local.instance_count && length(var.custom_user_data) == 0 ? 1 : 0}"
  template = "${file("${path.module}/user-data/user_data.sh")}"

  vars {
    user_data       = "${join("\n", compact(concat(var.user_data, list(module.github_authorized_keys.user_data))))}"
    welcome_message = "${var.welcome_message}"
  }
}
