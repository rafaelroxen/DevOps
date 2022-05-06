
$script_mysql = <<-SCRIPT
  apt-get update && \
  apt-get install -y mysql-server-5.7 && \
  mysql -e "create user 'phpuser'@'%' identified by 'pass';"
SCRIPT

$script_puppet = <<-SCRIPT
  apt-get update && \
  apt-get install -y puppet
SCRIPT

Vagrant.configure("2") do |config|
  config.vm.box = "ubuntu/bionic64"
  config.vm.box_download_insecure = true

# #Nova máquina para o Mysql
#   config.vm.define "mysqldb" do |mysql|
#     mysql.vm.network "forwarded_port", guest: 80, host: 8089 #Redirecionamento de portas
#     mysql.vm.network "public_network", ip: "192.168.15.121"
#
#     mysql.vm.provision "shell",
#     inline: "cat /configs/id_bionic.pub >> .ssh/authorized_keys"
#     mysql.vm.provision "shell", inline: $script_mysql
#     mysql.vm.provision "shell",
#     inline: "cat /configs/mysqld.cnf  > /etc/mysql/mysql.conf.d/mysqld.cnf"
#
#     mysql.vm.provision "shell",
#     inline:"service mysql restart "
#
#     mysql.vm.synced_folder "./configs", "/configs"	#O que tiver dentro da pasta configs no Windows vai estar também na pasta configs da VM
#     mysql.vm.synced_folder ".", "/vagrant", disabled: true
#   end

  #Máquina criada para o PHP
  config.vm.define "phpweb" do |phpweb|
  phpweb.vm.network "forwarded_port", guest: 8888, host: 8888 # Redirecionamento de portas
  phpweb.vm.network "public_network", ip: "192.168.15.125"
  phpweb.vm.provision "shell", inline: $script_puppet       # Script que roda a instalação do Puppet no Linux

        phpweb.vm.provider "virtualbox" do |vb|
            vb.memory = 1024
            vb.cpus = 2
            vb.name = "ubuntu_bionic_php7"
        end

  # Maneira de executar o Puppet através do vagrant
   phpweb.vm.provision "puppet" do |puppet|
   puppet.manifests_path = "./configs/manifests"    # Apontando o diretório onde está o arquivo puppet
   puppet.manifest_file = "phpweb.pp"               # Nome do arquivo .pp que é o puppet
 end
  end

config.vm.define "mysqlserver" do |mysqlserver|
  mysqlserver.vm.network "public_network", ip: "192.168.15.134"

  mysqlserver.vm.provision "shell",
  inline: "cat /vagrant/configs/id_bionic.pub >> .ssh/authorized_keys"
end

config.vm.define "ansible" do |ansible|
  ansible.vm.network "public_network", ip: "192.168.15.135"

  ansible.vm.provision "shell",
  inline: "cp /vagrant/id_bionic /home/vagrant && \
  chmod 600 /home/vagrant/id_bionic && \
  sudo chown vagrant:vagrant /home/vagrant/id_bionic"


  ansible.vm.provision "shell",
  inline:"sudo apt update && \
sudo apt install --yes software-properties-common && \
sudo add-apt-repository --yes --update ppa:ansible/ansible && \
sudo apt install --yes ansible"

ansible.vm.provision "shell",
inline:"ansible-playbook -i /vagrant/configs/ansible/hosts \
/vagrant/configs/ansible/playbook.yml"
end

config.vm.define "memcached" do |memcached|
    memcached.vm.box = "centos/7"
    memcached.vm.provider "virtualbox" do |vb|
        vb.memory = 512
        vb.cpus = 1
        vb.name = "centos7_memcached"
    end

end

#Essa configuração desativa o acesso a pasta Vragant


#---------------------------------------------------------------
#Para configurar um IP privado
#config.vm.network "private_network", ip: "192.168.50.4"
#config.vm.network "private_network", type:"dhcp"
#Para configurar um IP DHCP com o bloco da rede
#----------------------------------------------------------------
