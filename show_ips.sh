log_file=$1
parse_date=$2

#Скрипт для получения списка ип адресов и количества попыток соединения для каждого";
#Параметры запуска show_ips.sh "iptraf raw log" date';
#Где iptraf raw log это raw лог , полученный во время аттаки при помощи iptraf";
#date - интервал выборки, например "Nov 20"

#Пример: show_ips.sh iptraf_nov20.log "Nov 20" > nov20.txt';

if [ ! -f "$log_file" ]
then 
   # Файл лога iptraf не найден!
   exit
fi

if [ -e "$parse_date" ]
then 
   # Укажите дату, за которую выбирать логи!
   exit
fi

cat $log_file | grep "$parse_date" | sed 's/:/ /g' | egrep -o 'from ([[:digit:]]{1,3}\.){3}[[:digit:]]{1,3}' |awk '{print $2}' | sort | uniq -c | sort -n 
