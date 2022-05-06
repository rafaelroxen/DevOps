# execute 'apt-get update'
exec { 'apt-update':                    # exec resource named 'apt-update'
  command => '/usr/bin/apt-get update'  # command this resource will run
}

# install apache2 package
package { ['php7.2','php7.2-mysql']:    # Pacotes que serão instalados
  require => Exec['apt-update'],        # require 'apt-update' before installing
  ensure => installed,                  # Garantir que esteja instalado
}


exec { 'run-php7':
  require => Package['php7.2'],
  command => '/usr/bin/php -S 0.0.0.0:8888 -t /vagrant/src &'  # O -t é definir o target o código fonte para carregar, no diretorio src
}
