ip_list=$1 
log_file=$2
parse_date=$3
pref=$4


#Скрипт для извлечения логов по ip адресов, с которых велась аттака ";
#Параметры запуска get_logs.sh "ip list" "iptraf raw log date [pref]" ';
#Где ip list это список ip адресов, полученных скриптом show_ips.sh";
#    "iptraf raw log" это raw лог , полученный во время аттаки при помощи iptraf";
#     date - интервал выборки, например "Nov 20"
#     pref - префикс, котоырй будет ставиться перед названием файла с логом


#Пример: get_logs.sh 20.txt iptraf.log Nov 20";

if [ ! -f "$ip_list" ] 
then 
    # Файл со списком ip адресов не найден!
    exit
fi

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


th_limit="3000" # Нижная граница числа коннектов, по которой мы считаем что запросы аномальные

ips=`cat $ip_list | egrep -o '[[:digit:]]+\s([[:digit:]]{1,3}\.){3}[[:digit:]]{1,3}' | sed 's/ /_/g'`
for ip_rec in $ips; do
 ip=`echo $ip_rec | sed 's/_/ /g ' | awk '{print $2}'`
 cnt=`echo $ip_rec | sed 's/_/ /g ' | awk '{print $1}'` 

# Если кол-во установленных за интервал соединений больше заданной границы, это бот
if  [ "$cnt" -ge "$th_limit" ]; then
echo $ip;
# Выводим 
cat $log_file | grep "$parse_date" | grep "from $ip" > $pref$ip.txt
gzip $pref$ip.txt
fi
done