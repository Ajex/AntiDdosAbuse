emails=$1
pref=$2

#������ ��� �������� Email �� ������� ������";
#��������� ������� mail_send "mail list";
#��� mail list ��� ������ ip �������, ���������� �������� get_info.sh";

#������: mail_send.sh 20_email.txt";

if [ ! -f "$emails" ] 
then 
    # ���� �� ������� email ������� , ���������� �������� get_info.sh �� ������!
    exit
fi


ips=`cat $emails | sed 's/ /_/g'`
for ip_rec in $ips; do
 ip=`echo $ip_rec | sed 's/_/ /g ' | awk '{print $1}'`
 cnt=`echo $ip_rec | sed 's/_/ /g ' | awk '{print $2}'` 
 email=`echo $ip_rec | sed 's/_/ /g ' | awk '{print $3 " " $4 " " $5 " " $6 " " $7}' | uniq` 
 em_prev=''
 # ��������� ������
 for email_row in $email; do
      # ������ ��������� �����, �������������
      if [ "$email_row" != "$em_prev" ]
      then
         echo $email_row; 
         # ����� ���� ��������� �� ������ �����
         echo "Hi, today,  our server x.x.x.x was attacked from your or your client's server $ip 
               Here are the logs http://yourcompany.com/abuse/$pref$ip.txt.gz (TZ - Europe/Moscow) The Company Name Ltd." # |  mail -s "[Abuse] ddos attack from your $ip" $email_row
      # �������� ����� ��������� ��������� ������
      sleep 5;
      fi
      em_prev=$email_row;
 done

 echo $ip $cnt
done