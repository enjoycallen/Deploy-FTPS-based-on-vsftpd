yum -y install vsftpd
useradd shared -d /home/shared
passwd shared
chmod +x /home/shared

cd /etc/vsftpd
cat > vsftpd.config <<EOF
anonymous_enable=NO
local_enable=YES
write_enable=YES
local_umask=022
anon_umask=022

dirmessage_enable=YES
xferlog_enable=YES
connect_from_port_20=YES
xferlog_file=/var/log/xferlog
xferlog_std_format=YES

local_root=/home/shared
chroot_local_user=YES
chroot_list_enable=YES
chroot_list_file=/etc/vsftpd/chroot_list
listen=YES

allow_writeable_chroot=YES
pasv_enable=YES
pasv_address=#Your IP address
pasv_min_port=30000
pasv_max_port=31000
pam_service_name=vsftpd

ssl_enable=YES
allow_anon_ssl=NO
force_local_logins_ssl=YES
force_local_data_ssl=YES
rsa_cert_file=/etc/vsftpd/ssl/vsftpd.pem
EOF

mkdir ssl
cat /ect/v2ray/v2ray.crt /etc/v2ray/v2ray.key > vsftpd.pem
cat > tmp.sh <<EOF
cat /ect/v2ray/v2ray.crt /etc/v2ray/v2ray.key > vsftpd.pem
EOF
cat /usr/bin/ssl_update.sh tmp.sh > tmp2.sh
rm -f tmp.sh
rm -f /usr/bin/ssl_update.sh
mv tmp2.sh /usr/bin/ssl_update.sh

systemctl enable vsftpd
systemctl start vsftpd
