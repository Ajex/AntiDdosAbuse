ip_list=$1
th_limit="3000"

#Скрипт для извлечения email для отправки абуз по данным whois
#Параметры запуска get_info.sh "ip list"
#
#Пример: get_logs.sh 20.txt > 20_email.txt
#

if [ ! -f "$ip_list" ] 
then 
    # Файл со списком ip адресов не найден!
    exit
fi

# Выбираем айпишники, из списка
ips=`cat $ip_list | egrep -o '[[:digit:]]+\s([[:digit:]]{1,3}\.){3}[[:digit:]]{1,3}' | sed 's/ /_/g'`
for ip_rec in $ips; do
 ip=`echo $ip_rec | sed 's/_/ /g ' | awk '{print $2}'`
 cnt=`echo $ip_rec | sed 's/_/ /g ' | awk '{print $1}'` 

# Если кол-во установленных за интервал соединений больше заданной границы, это бот
if  [ "$cnt" -ge "$th_limit" ]; then
email=`whois  $ip | grep mail | awk '{print tolower($0)}' | egrep -o "\w+([._-]\w)*@\w+([._-]\w)*\.\w{2,4}"`

# Если запрос не удался и не извлечено ни одного email ,пробуем еще разок
if [ ! -n "$email" ] 
then
 email=`whois  $ip | grep mail | awk '{print tolower($0)}' | egrep -o "\w+([._-]\w)*@\w+([._-]\w)*\.\w{2,4}"`
fi

# Выводим ip , кол-во попыток соединений за интервал, abuse почтовые адреса
 echo $ip $cnt $email
fi
done