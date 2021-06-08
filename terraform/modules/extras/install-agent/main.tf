
resource "azurerm_virtual_machine_extension" "install-elastic-agent" {
  name                 = var.name
  virtual_machine_id   = var.machine_id
  publisher            = "Microsoft.Compute"
  type                 = "CustomScriptExtension"
  type_handler_version = "1.9"
  settings = <<SETTINGS
    {
        "commandToExecute": "powershell -command \"[System.Text.Encoding]::UTF8.GetString([System.Convert]::FromBase64String('${base64encode(data.template_file.tf.rendered)}')) | Out-File -filepath %PUBLIC%\\install.ps1\" && powershell -ExecutionPolicy Unrestricted -File %PUBLIC%\\install.ps1"
    }
SETTINGS
}

data "template_file" "tf" {
  template = file("${path.module}/elastic-agent.ps1")
  vars = {
    kibana-url  = var.kibana_url
    token       = var.fleet_token
  }
}