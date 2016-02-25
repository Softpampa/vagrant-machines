# Softpampa Vagrant Machines
Máquinas virtuais prontas para desenvolvimento. Thanks Juan Treminio by created [PuPHPet](https://www.puphpet.com) ♥.

## Pre-requisitos mínimo
 - [VirtualBox 5](virtualbox.org)
 - [Vagrant 1.8.x](vagrantup.com)

## Instalação
Apenas clonar o repositório, entrar na pasta da máquina desejada e rodar:

```
$ vagrant up
```

Pode demorar muitos bastante dependendo da sua conexão!

## Atualizações
Quando houver atualizações no repositório, basta dar um `git pull` e em seguida `vagrant provision` na máquina desejada.

## Linux Host
Se seu Host for Linux utilize a máquina **Softpampa**, na qual conterá uma pasta `webroot` que faz a sincronia dos arquivos pelo VirtualBox.
> Lembre-se de adiconar o IP 192.168.56.11 ao hosts

## Windows Host
Se seu Host for Windows, utilize a máquina **SoftpampaSMB**. Por questões de desempenho foi adicionado um Servidor Samba à máquina virtual para sincronizar os arquivos que estará disponível em `\\192.168.56.13\www`, aconselho a mapear esse rede para uma unidade.
> Lembre-se de adiconar o IP 192.168.56.13 ao hosts

## Softpampa 
 - Ubuntu Trusty 14.04 LTS x64
 - Nginx
 - PHP 7
  - mcrypt
  - mbstring
  - curl
  - gd
 - Ruby 1.9.3
  - Sass
 - Node.js 5
  - bower
  - grunt-cli
 - MySQL 5.5


* https://github.com/ashlewis/vagrant-puphpet-samba
* https://github.com/npm/npm/issues/7308
