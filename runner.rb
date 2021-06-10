require 'ruby-terraform'
require 'tty-prompt'

puts " ▄▄▄· ·▄▄▄▄•▄• ▄▌▄▄▄  ▄▄▄ .    ▄▄▌   ▄▄▄· ▄▄▄▄· "
puts "▐█ ▀█ ▪▀·.█▌█▪██▌▀▄ █·▀▄.▀·    ██•  ▐█ ▀█ ▐█ ▀█▪"
puts "▄█▀▀█ ▄█▀▀▀•█▌▐█▌▐▀▀▄ ▐▀▀▪▄    ██▪  ▄█▀▀█ ▐█▀▀█▄"
puts "▐█ ▪▐▌█▌▪▄█▀▐█▄█▌▐█•█▌▐█▄▄▌    ▐█▌▐▌▐█ ▪▐▌██▄▪▐█"
puts " ▀  ▀ ·▀▀▀ • ▀▀▀ .▀  ▀ ▀▀▀     .▀▀▀  ▀  ▀ ·▀▀▀▀ "

puts "Welcome to Azure Lab - please follow the prompts to get started. Happy hunting."
def prompts
  prompt = TTY::Prompt.new

  admin_user = prompt.ask("What do you want to call your admin user?", default: "admin-user") do |q|
    q.required true
  end

  ENV['TF_VAR_admin_user'] = admin_user

  admin_password = prompt.mask("What do you want the admin password to be?") do |q|
    q.required true
  end

  ENV['TF_VAR_admin_password'] = admin_password

  active_directory_domain = prompt.ask("What name do you want to use for your domain?", default: "attackrange.com") do |q|
    q.required true
  end

  ENV['TF_VAR_active_directory_domain'] = active_directory_domain

  active_directory_netbios_name = prompt.ask("What do you want to use for the netbios domain name?", default: "attackrange") do |q|
    q.required true
  end

  ENV['TF_VAR_active_directory_netbios_name'] = active_directory_netbios_name

  kali_password = prompt.mask("What password shall do you want to set for the Kali ssh user?") do |q|
    q.required true
  end

  ENV['TF_VAR_kali_password'] = kali_password

  kibana_url = prompt.ask("What Kibana URL do you want to use?") do |q|
    q.required true
  end

  ENV['TF_VAR_kibana_url'] = kibana_url

  fleet_token = prompt.mask("What enrollment token do you wish to set for Elastic Agent to authenticate with?") do |q|
    q.required true
  end

  ENV['TF_VAR_fleet_token'] = fleet_token

  mode = prompt.select("What do you want to do next?") do |options|
    options.choice "Plan"
    options.choice "Plan and Run"
    options.choice "Destroy"
    options.choice "Do Nothing"
  end
  puts "\n"
  confirm = prompt.select("Are you sure you want to continue on? Changes you make to the Terraform state are usually permanent.") do |yesno|
    yesno.choice "Yes"
    yesno.choice "No"
  end
  if confirm == "Yes"
    terraform(mode)
  else
    exit
  end
end

def terraform(mode)
  if mode == "Plan"
    init = RubyTerraform::Commands::Init.new
    init.execute(
      chdir: 'terraform',
      out: 'attack-range.tfplan'
    )
    plan = RubyTerraform::Commands::Plan.new
    plan.execute(
       chdir: 'terraform',
       out: 'attack-range.tfplan'
    )
    exit
  elsif mode == "Plan and Run"
    init = RubyTerraform::Commands::Init.new
    init.execute(
      chdir: 'terraform',
      out: 'attack-range.tfplan'
    )
    plan = RubyTerraform::Commands::Plan.new
    plan.execute(
      chdir: 'terraform',
      out: 'attack-range.tfplan'
    )
    run = RubyTerraform::Commands::Apply.new
    run.execute(
      chdir: 'terraform',
      out: 'attack-range.tfplan',
      auto_approve: true
    )
  elsif mode == "Destroy"
    destroy = RubyTerraform::Commands::Destroy.new
    destroy.execute(
      chdir: 'terraform',
      out: 'attack-range.tfplan',
      auto_approve: true
    )
  else exit
  end
end

prompts()
