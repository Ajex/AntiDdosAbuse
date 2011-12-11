parse_date="Nov 20"
pref=test20
iptraf_raw_file=/var/log/iptraf/iptraf.log
echo "Грузим айпишники"
./show_ips.sh $iptraf_raw_file $parse_date > "/var/log/iptraf/ipcnt_$pref.txt"
./show_ips.sh
echo "Получаем данные из Whois"
./get_info.sh "/var/log/iptraf/ipcnt_$pref.txt" $iptraf_raw_file > "/var/log/iptraf/log_email$pref.txt"
echo "Извлекаем логи"
./get_logs.sh "/var/log/iptraf/ipcnt_$pref.txt" $iptraf_raw_file $parse_date $pref
./mail_send.sh "/var/log/iptraf/log_email$pref.txt" $pref