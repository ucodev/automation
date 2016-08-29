# ISPCONFIG
#
# VERSION	0.1

FROM debian:jessie

MAINTAINER Pedro A. Hortas <pah@ucodev.org>
LABEL Description="Installs the latest version of ISPConfig3 under Debian/Jessie" Vendor="uCodev" Version="0.1"

# Inform about the used ports
EXPOSE 21 22 25 53 53/udp 80 110 143 443 465 587 993 995 3306 8080 8081


# Arguments
ARG ROOT_PASSWORD="password"
ARG HOST_FQDN="someserver1.somedomain.tld"
ARG HOST_NAME="someserver1"
ARG HOST_IP="192.168.100.2"
ARG MYSQL_ROOT_PASSWORD="password"
ARG MAILMAN_ADMIN_EMAIL="someone@somedomain.tld"
ARG MAILMAN_ADMIN_PASSWORD="password"
ARG ROUNDCUBE_VERSION="1.1.3"
ARG ROUNDCUBE_SQL_DATABASE="roundcubemail"
ARG ROUNDCUBE_SQL_USERNAME="roundcube"
ARG ROUNDCUBE_SQL_PASSWORD="password"
ARG ROUNDCUBE_ISP_USERNAME="roundcube"
ARG ROUNDCUBE_ISP_PASSWORD="password"
ARG PURE_FTPD_VERSION="1.0.36"
ARG PURE_FTPD_PATCH="3.2"
ARG CERT_COUNTRY="AU"
ARG CERT_STATE="State"
ARG CERT_CITY="City"
ARG CERT_ORG="Organization"
ARG CERT_UNIT="IT"
ARG CERT_EMAIL="someone@somedomain.tld"


# Stage 1: Setup base system
COPY files/sources.list /etc/apt/sources.list
RUN apt-get update && apt-get upgrade -y
RUN apt-get install -y apt-utils build-essential autoconf automake libtool flex bison debhelper binutils


# Stage 2: Install SSH server
RUN apt-get install -y ssh openssh-server


# Stage 3: Install utilities
RUN apt-get install -y net-tools inetutils-ping inetutils-telnet inetutils-traceroute inetutils-ftp tcpdump curl wget vim python debconf-utils expect git man rsyslog
ADD https://raw.githubusercontent.com/ucodev/utilities/master/misc/sedit.py /usr/local/bin/sedit
RUN chmod 755 /usr/local/bin/sedit


# Stage 4: Configure the Hostname
RUN cp /etc/hosts hosts
RUN /usr/local/bin/sedit hosts add "${HOST_IP} ${HOST_FQDN} ${HOST_NAME}" after "127.0.0.1"
RUN cp hosts /etc/hosts
RUN rm -f hosts
RUN echo "${HOST_NAME}" > /etc/hostname


# Stage 5: Setup root password
COPY files/passwd.exp /usr/local/bin/passwd.exp
RUN chmod 755 /usr/local/bin/passwd.exp
RUN passwd.exp root "${ROOT_PASSWORD}"
RUN rm -f /usr/local/bin/passwd.exp


# Stage 6: Change default shell
RUN echo "no" | dpkg-reconfigure dash


# Stage 7: Synchronize the System Clock
RUN apt-get install -y ntp ntpdate


# Stage 8: Install Postfix, Dovecot, MySQL, phpMyAdmin, rhunter, binutils
RUN echo "postfix postfix/main_mailer_type select Internet Site" | debconf-set-selections
RUN echo "postfix postfix/mailname string ${HOST_FQDN}" | debconf-set-selections
RUN apt-get install -y postfix postfix-mysql postfix-doc
RUN echo "mariadb-server-10.0 mysql-server/root_password password ${MYSQL_ROOT_PASSWORD}" | debconf-set-selections
RUN echo "mariadb-server-10.0 mysql-server/root_password_again password ${MYSQL_ROOT_PASSWORD}" | debconf-set-selections
RUN apt-get install -y mariadb-client mariadb-server
RUN apt-get install -y openssl getmail4 rkhunter binutils dovecot-imapd dovecot-pop3d dovecot-mysql dovecot-sieve dovecot-lmtpd sudo
COPY files/master.cf /etc/postfix/master.cf
COPY files/my.cnf /etc/mysql/my.cnf
RUN service mysql stop


# Stage 9: Install Amavisd-new, SpamAssasin and ClamAV
RUN apt-get install -y amavisd-new spamassassin clamav clamav-daemon zoo unzip bzip2 arj nomarch lzop cabextract apt-listchanges libnet-ldap-perl libauthen-sasl-perl clamav-docs daemon libio-string-perl libio-socket-ssl-perl libnet-ident-perl zip libnet-dns-perl
RUN freshclam || exit 0


# Stage 10: Install Apache2, PHP5, phpMyAdmin, FCGI, suExec, Pear and mcrypt
RUN apt-get install -y apache2 apache2.2-common apache2-doc apache2-mpm-prefork apache2-utils libexpat1 ssl-cert libapache2-mod-php5 php5 php5-common php5-gd php5-mysql php5-imap php5-cli php5-cgi libapache2-mod-fcgid apache2-suexec php-pear php-auth php5-mcrypt mcrypt php5-imagick imagemagick libruby libapache2-mod-python php5-curl php5-intl php5-memcache php5-memcached php5-pspell php5-recode php5-sqlite php5-tidy php5-xmlrpc php5-xsl memcached libapache2-mod-passenger

RUN echo "phpmyadmin phpmyadmin/mysql/admin-pass password ${MYSQL_ROOT_PASSWORD}" | debconf-set-selections
RUN echo "phpmyadmin phpmyadmin/dbconfig-install boolean true" | debconf-set-selections
RUN echo "phpmyadmin phpmyadmin/reconfigure-webserver multiselect apache2" | debconf-set-selections
RUN echo "phpmyadmin phpmyadmin/mysql/app-pass password" | debconf-set-selections
RUN bash -c "service mysql start && apt-get install -y phpmyadmin && service mysql stop"

RUN a2enmod suexec rewrite ssl actions include dav_fs dav auth_digest cgi


# Stage 11: Install SuPHP (NOT RECOMMENDED)


# Stage 12: XCache and PHP-FPM
RUN apt-get install -y php5-xcache
RUN apt-get install -y libapache2-mod-fastcgi php5-fpm
RUN a2enmod actions fastcgi alias


# Stage 13: Install Mailman
RUN echo "mailman mailman/site_languages multiselect en (English)" | debconf-set-selections
RUN apt-get install -y mailman
COPY files/mailman_newlist.exp /usr/src/mailman_newlist.exp
RUN chmod 755 /usr/src/mailman_newlist.exp
RUN /usr/src/mailman_newlist.exp "${MAILMAN_ADMIN_EMAIL}" "${MAILMAN_ADMIN_PASSWORD}"
RUN rm -f /usr/src/mailman_newlist.exp
RUN echo '## mailman mailing list' >> /etc/aliases
RUN echo 'mailman: "|/var/lib/mailman/mail/mailman post mailman"' >> /etc/aliases
RUN echo 'mailman-admin: "|/var/lib/mailman/mail/mailman admin mailman"' >> /etc/aliases
RUN echo 'mailman-bounces: "|/var/lib/mailman/mail/mailman bounces mailman"' >> /etc/aliases
RUN echo 'mailman-confirm: "|/var/lib/mailman/mail/mailman confirm mailman"' >> /etc/aliases
RUN echo 'mailman-join: "|/var/lib/mailman/mail/mailman join mailman"' >> /etc/aliases
RUN echo 'mailman-leave: "|/var/lib/mailman/mail/mailman leave mailman"' >> /etc/aliases
RUN echo 'mailman-owner: "|/var/lib/mailman/mail/mailman owner mailman"' >> /etc/aliases
RUN echo 'mailman-request: "|/var/lib/mailman/mail/mailman request mailman"' >> /etc/aliases
RUN echo 'mailman-subscribe: "|/var/lib/mailman/mail/mailman subscribe mailman"' >> /etc/aliases
RUN echo 'mailman-unsubscribe: "|/var/lib/mailman/mail/mailman unsubscribe mailman"' >> /etc/aliases
RUN newaliases
RUN ln -s /etc/mailman/apache.conf /etc/apache2/conf-enabled/mailman.conf


# Stage 14: Install PureFTPd and Quota
RUN apt-get install -y openbsd-inetd
WORKDIR /usr/src/
RUN apt-get source pure-ftpd=${PURE_FTPD_VERSION}-${PURE_FTPD_PATCH}
RUN apt-get build-dep -y pure-ftpd=${PURE_FTPD_VERSION}-${PURE_FTPD_PATCH}
WORKDIR /usr/src/pure-ftpd-${PURE_FTPD_VERSION}/
RUN /usr/local/bin/sedit /usr/src/pure-ftpd-${PURE_FTPD_VERSION}/debian/rules replace '--with-rfc2640' with '--with-rfc2640 --without-capabilities'
RUN dpkg-buildpackage -uc -b
WORKDIR /usr/src/
RUN dpkg -i pure-ftpd-common_*.deb pure-ftpd-mysql_*.deb
RUN rm -rf /usr/src/*
RUN echo "pure-ftpd-common hold" | dpkg --set-selections
RUN echo "pure-ftpd-mysql hold" | dpkg --set-selections
WORKDIR /
RUN /usr/local/bin/sedit /etc/default/pure-ftpd-common replace 'VIRTUALCHROOT=false' with 'VIRTUALCHROOT=true'
RUN echo 1 > /etc/pure-ftpd/conf/TLS
RUN mkdir -p /etc/ssl/private/
RUN echo -e "${CERT_COUNTRY}\n${CERT_STATE}\n${CERT_CITY}\n${CERT_ORG}\n${CERT_UNIT}\n${HOST_FQDN}\n${CERT_EMAIL}" | openssl req -x509 -nodes -days 7300 -newkey rsa:2048 -keyout /etc/ssl/private/pure-ftpd.pem -out /etc/ssl/private/pure-ftpd.pem
RUN chmod 600 /etc/ssl/private/pure-ftpd.pem

## NOTE: Currently there will be no quota support
RUN apt-get install -y quota quotatool
RUN quotacheck -avugm || exit 0
RUN quotaon -avug || exit 0


# Stage 15: Install BIND DNS Server
RUN apt-get install -y bind9 dnsutils


# Stage 16: Install Vlogger, Webalizer and AWStats
RUN apt-get install -y vlogger webalizer awstats geoip-database libclass-dbi-mysql-perl
COPY files/awstats /etc/cron.d/awstats


# Stage 17: Install Jailkit
WORKDIR /tmp
ADD http://olivier.sessink.nl/jailkit/jailkit-2.17.tar.gz /tmp/jailkit-2.17.tar.gz
RUN tar zxvf jailkit-2.17.tar.gz
WORKDIR /tmp/jailkit-2.17
RUN ./debian/rules binary
WORKDIR /tmp
RUN dpkg -i jailkit_2.17-1_*.deb
RUN rm -rf jailkit-2.17*


# Stage 18: Install fail2ban
RUN apt-get install -y fail2ban
COPY files/jail.local /etc/fail2ban/jail.local
COPY files/pureftpd.conf /etc/fail2ban/filter.d/pureftpd.conf
COPY files/dovecot-pop3imap.conf /etc/fail2ban/filter.d/dovecot-pop3imap.conf
RUN echo "ignoreregex =" >> /etc/fail2ban/filter.d/postfix-sasl.conf


# Stage 19: Install SquirrelMail (Optional)


# Stage 20: Install ISPConfig 3
WORKDIR /tmp
ADD http://www.ispconfig.org/downloads/ISPConfig-3-stable.tar.gz /tmp/ISPConfig-3-stable.tar.gz
RUN tar zxvf ISPConfig-3-stable.tar.gz
WORKDIR /tmp/ispconfig3_install/install/
COPY files/ispconfig_install.exp /tmp/ispconfig3_install/install/ispconfig_install.exp
RUN chmod 755 ispconfig_install.exp
RUN bash -c "service mysql start && ./ispconfig_install.exp \"${HOST_FQDN}\" \"${MYSQL_ROOT_PASSWORD}\" \"${CERT_COUNTRY}\" \"${CERT_STATE}\" \"${CERT_CITY}\" \"${CERT_ORG}\" \"${CERT_UNIT}\" \"${CERT_EMAIL}\" && service mysql stop"
RUN rm -f /tmp/ispconfig3_install/install/ispconfig_install.exp
WORKDIR /


# Stage 21: Install Roundcube and Roundcube ISPConfig plugin
ADD https://downloads.sourceforge.net/project/roundcubemail/roundcubemail/${ROUNDCUBE_VERSION}/roundcubemail-${ROUNDCUBE_VERSION}-complete.tar.gz /opt/roundcube-${ROUNDCUBE_VERSION}-complete.tar.gz
WORKDIR /opt
RUN tar zxvf /opt/roundcube-${ROUNDCUBE_VERSION}-complete.tar.gz
RUN mv roundcubemail-${ROUNDCUBE_VERSION} roundcube
RUN chown -R www-data:www-data /opt/roundcube
RUN bash -c "service mysql start && echo \"CREATE DATABASE ${ROUNDCUBE_SQL_DATABASE}; GRANT ALL PRIVILEGES ON ${ROUNDCUBE_SQL_DATABASE}.* TO ${ROUNDCUBE_SQL_USERNAME}@localhost IDENTIFIED BY '${ROUNDCUBE_SQL_PASSWORD}'; FLUSH PRIVILEGES;\" | mysql -uroot -p\"${MYSQL_ROOT_PASSWORD}\" && service mysql stop"
RUN bash -c "service mysql start && mysql -uroot -p\"${MYSQL_ROOT_PASSWORD}\" \"${ROUNDCUBE_SQL_DATABASE}\" < /opt/roundcube/SQL/mysql.initial.sql && service mysql stop"
COPY files/roundcube_config.inc.php /opt/roundcube/config/config.inc.php
RUN sedit /opt/roundcube/config/config.inc.php replace ROUNDCUBE_SQL_DATABASE with "${ROUNDCUBE_SQL_DATABASE}"
RUN sedit /opt/roundcube/config/config.inc.php replace ROUNDCUBE_SQL_USERNAME with "${ROUNDCUBE_SQL_USERNAME}"
RUN sedit /opt/roundcube/config/config.inc.php replace ROUNDCUBE_SQL_PASSWORD with "${ROUNDCUBE_SQL_PASSWORD}"
RUN sedit /opt/roundcube/config/config.inc.php replace ROUNDCUBE_SMTP_HOST with localhost
COPY files/roundcube.conf /etc/apache2/conf-available/roundcube.conf
RUN a2enconf roundcube

RUN bash -c "service mysql start && echo \"INSERT INTO remote_user (remote_userid,sys_userid,sys_groupid,sys_perm_user,sys_perm_group,sys_perm_other,remote_username,remote_password,remote_functions) VALUES (1,1,1,'riud','riud',NULL,'${ROUNDCUBE_ISP_USERNAME}',MD5('${ROUNDCUBE_ISP_PASSWORD}'),'server_get,get_function_list,client_templates_get_all,server_get_serverid_by_ip,server_ip_get,server_ip_add,server_ip_update,server_ip_delete;client_get_all,client_get,client_add,client_update,client_delete,client_get_sites_by_user,client_get_by_username,client_get_by_customer_no,client_change_password,client_get_id,client_delete_everything,client_get_emailcontact;mail_user_get,mail_user_add,mail_user_update,mail_user_delete;mail_alias_get,mail_alias_add,mail_alias_update,mail_alias_delete;mail_spamfilter_user_get,mail_spamfilter_user_add,mail_spamfilter_user_update,mail_spamfilter_user_delete;mail_policy_get,mail_policy_add,mail_policy_update,mail_policy_delete;mail_fetchmail_get,mail_fetchmail_add,mail_fetchmail_update,mail_fetchmail_delete;mail_spamfilter_whitelist_get,mail_spamfilter_whitelist_add,mail_spamfilter_whitelist_update,mail_spamfilter_whitelist_delete;mail_spamfilter_blacklist_get,mail_spamfilter_blacklist_add,mail_spamfilter_blacklist_update,mail_spamfilter_blacklist_delete;mail_user_filter_get,mail_user_filter_add,mail_user_filter_update,mail_user_filter_delete');\" | mysql -uroot -p\"${MYSQL_ROOT_PASSWORD}\" dbispconfig && service mysql stop"
RUN cp /usr/local/ispconfig/interface/ssl/ispserver.crt /usr/local/share/ca-certificates/
RUN update-ca-certificates
RUN sedit /etc/php5/apache2/php.ini add "openssl.cafile=/etc/ssl/certs/ca-certificates.crt" after "openssl.cafile"
WORKDIR /tmp
RUN git clone https://github.com/w2c/ispconfig3_roundcube.git
WORKDIR /tmp/ispconfig3_roundcube/
RUN cp -r ispconfig3_* /opt/roundcube/plugins/
WORKDIR /opt/roundcube/plugins
RUN rm -rf /tmp/ispconfig3_roundcube
COPY files/ispconfig3_roundcube_config.inc.php /opt/roundcube/plugins/ispconfig3_account/config/config.inc.php
RUN sedit /opt/roundcube/plugins/ispconfig3_account/config/config.inc.php replace ROUNDCUBE_ISP_USERNAME with "${ROUNDCUBE_ISP_USERNAME}"
RUN sedit /opt/roundcube/plugins/ispconfig3_account/config/config.inc.php replace ROUNDCUBE_ISP_PASSWORD with "${ROUNDCUBE_ISP_PASSWORD}"
RUN sedit /opt/roundcube/plugins/ispconfig3_account/config/config.inc.php replace ROUNDCUBE_HOST_FQDN with "${HOST_FQDN}"


# Stage 22: Copy rc.local
COPY files/rc.local /etc/rc.local
RUN chmod 755 /etc/rc.local
WORKDIR /

