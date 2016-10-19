#!/bin/bash

export DEBIAN_FRONTEND=noninteractive

VAGRANT_CORE_FOLDER=$(echo "$1")

OS=$(/bin/bash "${VAGRANT_CORE_FOLDER}/shell/os-detect.sh" ID)
CODENAME=$(/bin/bash "${VAGRANT_CORE_FOLDER}/shell/os-detect.sh" CODENAME)
RELEASE=$(/bin/bash "${VAGRANT_CORE_FOLDER}/shell/os-detect.sh" RELEASE)

cat "${VAGRANT_CORE_FOLDER}/shell/ascii-art/self-promotion.txt"
printf "\n"
echo ""

if [[ ! -d '/.puphpet-stuff' ]]; then
    mkdir '/.puphpet-stuff'
    echo 'Created directory /.puphpet-stuff'
fi

touch '/.puphpet-stuff/vagrant-core-folder.txt'
echo "${VAGRANT_CORE_FOLDER}" > '/.puphpet-stuff/vagrant-core-folder.txt'

# Adding this here with a datestamped filename for future issues like #1189
# apt repos become stale, Ubuntu/Debian move stuff around and break existing
# boxes that no longer require apt-get update. Force it one more time. Update
# datestamp as required for future breaks.
if [[ ! -f '/.puphpet-stuff/initial-setup-apt-get-update' ]]; then
    if [ "${OS}" == 'debian' ] || [ "${OS}" == 'ubuntu' ]; then
        echo 'Running initial-setup apt-get update'
        apt-get update >/dev/null
        echo 'Finished running initial-setup apt-get update'
    fi

    touch '/.puphpet-stuff/initial-setup-apt-get-update'
fi

# CentOS comes with tty enabled. RHEL has realized this is stupid, so we can
# also safely disable it in PuPHPet boxes.
if [[ ! -f '/.puphpet-stuff/disable-tty' ]]; then
    perl -pi'~' -e 's@Defaults(\s+)requiretty@Defaults !requiretty@g' /etc/sudoers

    touch '/.puphpet-stuff/disable-tty'
fi

# Digital Ocean seems to be missing iptables-persistent!
# See https://github.com/puphpet/puphpet/issues/1575
if [[ ! -f '/.puphpet-stuff/iptables-persistent-installed' ]] && [ "${OS}" == 'debian' ] || [ "${OS}" == 'ubuntu' ]; then
    apt-get -y install iptables-persistent > /dev/null 2>&1

    touch '/.puphpet-stuff/iptables-persistent-installed'
fi

if [[ ! -f '/.puphpet-stuff/resolv-conf-changed' ]]; then
    echo "nameserver 8.8.8.8" > /etc/resolv.conf
    echo "nameserver 8.8.4.4" >> /etc/resolv.conf

    touch '/.puphpet-stuff/resolv-conf-changed'
fi

if [[ -f '/.puphpet-stuff/initial-setup-base-packages' ]]; then
    exit 0
fi

if [ "${OS}" == 'debian' ] || [ "${OS}" == 'ubuntu' ]; then
    echo 'Installing curl'
    apt-get -y install curl >/dev/null
    echo 'Finished installing curl'

    echo 'Installing git'
    apt-get -y install git-core >/dev/null
    echo 'Finished installing git'

    if [[ "${CODENAME}" == 'lucid' || "${CODENAME}" == 'precise' ]]; then
        echo 'Installing basic curl packages'
        apt-get -y install libcurl3 libcurl4-gnutls-dev curl >/dev/null
        echo 'Finished installing basic curl packages'
    fi

    echo 'Installing Node.js'
    curl -sL https://deb.nodesource.com/setup_6.x | sudo -E bash -
    apt-get install -y nodejs >/dev/null
    echo 'Finished installing Node.js'

    echo 'Installing Bower'
    npm install -g bower
    echo 'Finished installing Bower'

    echo 'Installing Grunt-cli'
    npm install -g grunt-cli
    echo 'Finished installing Grunt-cli'

    echo 'Installing build-essential packages'
    apt-get -y install build-essential >/dev/null
    echo 'Finished installing build-essential packages'

    echo 'Installing Composer'
    php -r "copy('https://getcomposer.org/installer', 'composer-setup.php');"
    php -r "if (hash_file('SHA384', 'composer-setup.php') === '92102166af5abdb03f49ce52a40591073a7b859a86e8ff13338cf7db58a19f7844fbc0bb79b2773bf30791e935dbd938') { echo 'Installer verified'; } else { echo 'Installer corrupt'; unlink('composer-setup.php'); } echo PHP_EOL;"
    php composer-setup.php
    php -r "unlink('composer-setup.php');"
    mv composer.phar /usr/local/bin/composer
    echo 'Finished installing Composer'

    echo 'Installing php dependencies'
    apt-get install php5-gd -y >/dev/null
    echo 'finishing installing php dependencies'

elif [[ "${OS}" == 'centos' ]]; then
    echo 'Adding repos: elrepo, epel, scl'
    perl -p -i -e 's@enabled=1@enabled=0@gi' /etc/yum/pluginconf.d/fastestmirror.conf
    perl -p -i -e 's@#baseurl=http://mirror.centos.org/centos/\$releasever/os/\$basearch/@baseurl=http://mirror.rackspace.com/CentOS//\$releasever/os/\$basearch/\nenabled=1@gi' /etc/yum.repos.d/CentOS-Base.repo
    perl -p -i -e 's@#baseurl=http://mirror.centos.org/centos/\$releasever/updates/\$basearch/@baseurl=http://mirror.rackspace.com/CentOS//\$releasever/updates/\$basearch/\nenabled=1@gi' /etc/yum.repos.d/CentOS-Base.repo
    perl -p -i -e 's@#baseurl=http://mirror.centos.org/centos/\$releasever/extras/\$basearch/@baseurl=http://mirror.rackspace.com/CentOS//\$releasever/extras/\$basearch/\nenabled=1@gi' /etc/yum.repos.d/CentOS-Base.repo

    if [ "${RELEASE}" == 6 ]; then
        EL_REPO='http://www.elrepo.org/elrepo-release-6-6.el6.elrepo.noarch.rpm'
        EPEL='https://dl.fedoraproject.org/pub/epel/6/x86_64/epel-release-6-8.noarch.rpm'
    else
        EL_REPO='http://www.elrepo.org/elrepo-release-7.0-2.el7.elrepo.noarch.rpm'
        EPEL='https://dl.fedoraproject.org/pub/epel/7/x86_64/e/epel-release-7-5.noarch.rpm'
    fi

    yum -y --nogpgcheck install "${EL_REPO}" >/dev/null
    yum -y --nogpgcheck install "${EPEL}" >/dev/null
    yum -y install centos-release-SCL >/dev/null
    yum clean all >/dev/null
    yum -y check-update >/dev/null
    echo 'Finished adding repos: elrep, epel, scl'

    echo 'Installing curl'
    yum -y install curl >/dev/null
    echo 'Finished installing curl'

    echo 'Installing git'
    yum -y install git >/dev/null
    echo 'Finished installing git'

    echo 'Installing Development Tools'
    yum -y groupinstall 'Development Tools' >/dev/null
    echo 'Finished installing Development Tools'
fi

touch '/.puphpet-stuff/initial-setup-base-packages'
