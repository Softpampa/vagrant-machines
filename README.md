# Softpampa Vagrant Machines
Máquinas virtuais prontas para desenvolvimento. Thanks Juan Treminio by created PuPHPet ♥.

## Pre-requisitos mínimo
 - VirtualBox 5
 - Vagrant 1.8.x

## Instalação
Apenas clonar o repositório, entrar na pasta da máquina desejada e rodar:

```
$ vagrant up
```

Pode demorar muitos minutos dependendo da sua conexão!

## Atualizações
Quando houver atualizações no repositório, basta dar um `git pull` e em seguida `vagrant provision` na máquina desejada.

## Linux Host
Se seu Host for Linux utilize a máquina **Softpampa**, na qual conterá uma pasta `webroot` que faz a sincronia dos arquivos pelo VirtualBox.

## Windows Host
Se seu Host for Windows, utilize a máquina **SoftpampaSMB**. Por questões de desempenho foi adicionado um Servidor Samba à máquina virtual para sincronizar os arquivos que estará disponível em `\\192.168.56.13\www`, aconselho a mapear esse rede para uma unidade.