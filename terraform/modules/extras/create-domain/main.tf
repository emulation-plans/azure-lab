resource "azurerm_virtual_machine_extension" "create-active-directory-forest" {
  name                 = "create-active-directory-forest"
  virtual_machine_id   = var.virtual_machine_id
  publisher            = "Microsoft.Compute"
  type                 = "CustomScriptExtension"
  type_handler_version = "1.9"
  settings = <<SETTINGS
    {
        "commandToExecute": "powershell -command \"[System.Text.Encoding]::UTF8.GetString([System.Convert]::FromBase64String('${base64encode(data.template_file.create-domain.rendered)}')) | Out-File -filepath %PUBLIC%\\create-domain.ps1\" && powershell -ExecutionPolicy Unrestricted -File %PUBLIC%\\create-domain.ps1"
    }
SETTINGS
}

data "template_file" "create-domain" {
  template = file("${path.module}/create-domain.ps1")
  vars = {
    kibana-url  = var.kibana_url
    token       = var.fleet_token
    domain-name = var.active_directory_domain
    netbios-name = var.active_directory_netbios_name
  }
}