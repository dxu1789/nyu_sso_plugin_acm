require "net/http"
require "uri"
require "yaml"

ArchivesSpace::Application.extend_aspace_routes(File.join(File.dirname(__FILE__), "routes.rb"))

sso_url="archivesspace-stage.library.nyu.edu"
sso_backend_port="8489"
sso_login_url="dev.login.library.nyu.edu"
env_list=['development','stage','production']
env_list.each do 
   file_path = "/etc/puppetlabs/code/environments/#{env_value}/data/aspace_plugins.yaml"
   
   if File.exists?(file_path)

     heira_hash=YAML::load_file(AppConfig[:heira_path])

     heira_hash.each do |key,value|
       sso_url=value if key.include? "sso_url"
       sso_backend_port=value if key.include? "backend_port"
       sso_login_url=value if key.include? "sso_login_url"
     end
  end
end

sso_backend_port.empty? ? AppConfig[:backend_sso_url]= "https://#{sso_url}":AppConfig[:backend_sso_url]= "https://#{sso_url}:#{sso_backend_port}"

AppConfig[:ssologin_url]="#{AppConfig[:backend_sso_url]}/auth/nyulibraries"

AppConfig[:ssologout_url]="https://#{sso_login_url}/logged_out"

