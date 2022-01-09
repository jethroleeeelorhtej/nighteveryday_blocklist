#!/bin/bash
clear
readonly locate=$(dirname "$0")
readonly opApi='Your API'
readonly now=`date +%Y%m%d_%H%M%S`
#readonly yesterday=`date +%Y%m%d --date="-1 day"`
var="Your Directory"
log="Your Log Directory"

echo -e "\E[1;5;33m 撈取全域名中．．． \E[0m "
curl -d "API參數" -s "${opApi}" > $var/PDNS_All_Domain.txt

echo "##############################"
read -p "輸入要搜尋備註中寫的日期(例如20211006，會一併撈取前6天的資訊) ：" wordkey
echo -ne "\n"
echo -ne "\n"
TimeStamp=`date +%s -d ${wordkey}`
TimeStamp1=`echo "${TimeStamp} - 86400" |bc`
TimeStamp2=`echo "${TimeStamp} - (86400 * 2)" |bc`
TimeStamp3=`echo "${TimeStamp} - (86400 * 3)" |bc`
TimeStamp4=`echo "${TimeStamp} - (86400 * 4)" |bc`
TimeStamp5=`echo "${TimeStamp} - (86400 * 5)" |bc`
TimeStamp6=`echo "${TimeStamp} - (86400 * 6)" |bc`
Sat=`date "+%Y%m%d" --date=@${TimeStamp1}`
Fri=`date "+%Y%m%d" --date=@${TimeStamp2}`
Thr=`date "+%Y%m%d" --date=@${TimeStamp3}`
Wen=`date "+%Y%m%d" --date=@${TimeStamp4}`
Tue=`date "+%Y%m%d" --date=@${TimeStamp5}`
Mon=`date "+%Y%m%d" --date=@${TimeStamp6}`
day1=`date "+%Y/%m/%d" --date=@${TimeStamp6}`
day7=`date "+%Y/%m/%d" --date=@${TimeStamp}`


echo -ne "本週網址異常數量 $day1 ~ $day7"
echo -ne "本週網址異常數量 $day1 ~ $day7" > $log/TG_${now}.txt
echo -ne "\n" >> $log/TG_${now}.txt

############### 整理DNS error域名資訊
cat $var/PDNS_All_Domain.txt |grep -w "$wordkey檢查網址DNS劫持" |jq -c [.site_group,.domain_name,.status_id,.status_ids,.note_gm,.note_id]|sed -e 's/^\[//g;s/\]$//g'|sed 's/^\"//g;s/\"$//g'|awk -F \"\,\" '{print $1, $2, $3, $4, $5, $6}' > $log/dnserrordomain_${now}.txt
cat $var/PDNS_All_Domain.txt |grep -w "$Sat檢查網址DNS劫持" |jq -c [.site_group,.domain_name,.status_id,.status_ids,.note_gm,.note_id]|sed -e 's/^\[//g;s/\]$//g'|sed 's/^\"//g;s/\"$//g'|awk -F \"\,\" '{print $1, $2, $3, $4, $5, $6}' >> $log/dnserrordomain_${now}.txt
cat $var/PDNS_All_Domain.txt |grep -w "$Fri檢查網址DNS劫持" |jq -c [.site_group,.domain_name,.status_id,.status_ids,.note_gm,.note_id]|sed -e 's/^\[//g;s/\]$//g'|sed 's/^\"//g;s/\"$//g'|awk -F \"\,\" '{print $1, $2, $3, $4, $5, $6}' >> $log/dnserrordomain_${now}.txt
cat $var/PDNS_All_Domain.txt |grep -w "$Thr檢查網址DNS劫持" |jq -c [.site_group,.domain_name,.status_id,.status_ids,.note_gm,.note_id]|sed -e 's/^\[//g;s/\]$//g'|sed 's/^\"//g;s/\"$//g'|awk -F \"\,\" '{print $1, $2, $3, $4, $5, $6}' >> $log/dnserrordomain_${now}.txt
cat $var/PDNS_All_Domain.txt |grep -w "$Wen檢查網址DNS劫持" |jq -c [.site_group,.domain_name,.status_id,.status_ids,.note_gm,.note_id]|sed -e 's/^\[//g;s/\]$//g'|sed 's/^\"//g;s/\"$//g'|awk -F \"\,\" '{print $1, $2, $3, $4, $5, $6}' >> $log/dnserrordomain_${now}.txt
cat $var/PDNS_All_Domain.txt |grep -w "$Tue檢查網址DNS劫持" |jq -c [.site_group,.domain_name,.status_id,.status_ids,.note_gm,.note_id]|sed -e 's/^\[//g;s/\]$//g'|sed 's/^\"//g;s/\"$//g'|awk -F \"\,\" '{print $1, $2, $3, $4, $5, $6}' >> $log/dnserrordomain_${now}.txt
cat $var/PDNS_All_Domain.txt |grep -w "$Mon檢查網址DNS劫持" |jq -c [.site_group,.domain_name,.status_id,.status_ids,.note_gm,.note_id]|sed -e 's/^\[//g;s/\]$//g'|sed 's/^\"//g;s/\"$//g'|awk -F \"\,\" '{print $1, $2, $3, $4, $5, $6}' >> $log/dnserrordomain_${now}.txt

    # DNS error域名總數
    dnserrordomaincount=`cat $log/dnserrordomain_${now}.txt |awk '{print $2}' |sort |uniq |wc -l`
    # grep [ALL]
    cat $log/dnserrordomain_${now}.txt |grep -w "$wordkey檢查網址DNS劫持\[全域\]" > $log/dnsallarea_${now}.txt
    cat $log/dnserrordomain_${now}.txt |grep -w "$Sat檢查網址DNS劫持\[全域\]" >> $log/dnsallarea_${now}.txt
    cat $log/dnserrordomain_${now}.txt |grep -w "$Fri檢查網址DNS劫持\[全域\]" >> $log/dnsallarea_${now}.txt
    cat $log/dnserrordomain_${now}.txt |grep -w "$Thr檢查網址DNS劫持\[全域\]" >> $log/dnsallarea_${now}.txt
    cat $log/dnserrordomain_${now}.txt |grep -w "$Wen檢查網址DNS劫持\[全域\]" >> $log/dnsallarea_${now}.txt
    cat $log/dnserrordomain_${now}.txt |grep -w "$Tue檢查網址DNS劫持\[全域\]" >> $log/dnsallarea_${now}.txt
    cat $log/dnserrordomain_${now}.txt |grep -w "$Mon檢查網址DNS劫持\[全域\]" >> $log/dnsallarea_${now}.txt
    cat $log/dnsallarea_${now}.txt |awk '{print $2}' |sort |uniq > $log/dnsallarea2_${now}.txt
    dnsallarea=`cat $log/dnsallarea2_${now}.txt |wc -l`
    # grep [HB]
    cat $log/dnserrordomain_${now}.txt |grep -w "$wordkey檢查網址DNS劫持\[湖北\]" > $log/dnsHubei_${now}.txt
    cat $log/dnserrordomain_${now}.txt |grep -w "$Sat檢查網址DNS劫持\[湖北\]" >> $log/dnsHubei_${now}.txt
    cat $log/dnserrordomain_${now}.txt |grep -w "$Fri檢查網址DNS劫持\[湖北\]" >> $log/dnsHubei_${now}.txt
    cat $log/dnserrordomain_${now}.txt |grep -w "$Thr檢查網址DNS劫持\[湖北\]" >> $log/dnsHubei_${now}.txt
    cat $log/dnserrordomain_${now}.txt |grep -w "$Wen檢查網址DNS劫持\[湖北\]" >> $log/dnsHubei_${now}.txt
    cat $log/dnserrordomain_${now}.txt |grep -w "$Tue檢查網址DNS劫持\[湖北\]" >> $log/dnsHubei_${now}.txt
    cat $log/dnserrordomain_${now}.txt |grep -w "$Mon檢查網址DNS劫持\[湖北\]" >> $log/dnsHubei_${now}.txt
    cat $log/dnsHubei_${now}.txt |awk '{print $2}' |sort |uniq > $log/dnsHubei2_${now}.txt
    dnsHubei=`cat $log/dnsHubei2_${now}.txt |wc -l`
    # grep [CH]
    cat $log/dnserrordomain_${now}.txt |grep -w "$wordkey檢查網址DNS劫持\[重慶\]" > $log/dnsChongqing_${now}.txt
    cat $log/dnserrordomain_${now}.txt |grep -w "$Sat檢查網址DNS劫持\[重慶\]" >> $log/dnsChongqing_${now}.txt
    cat $log/dnserrordomain_${now}.txt |grep -w "$Fri檢查網址DNS劫持\[重慶\]" >> $log/dnsChongqing_${now}.txt
    cat $log/dnserrordomain_${now}.txt |grep -w "$Thr檢查網址DNS劫持\[重慶\]" >> $log/dnsChongqing_${now}.txt
    cat $log/dnserrordomain_${now}.txt |grep -w "$Wen檢查網址DNS劫持\[重慶\]" >> $log/dnsChongqing_${now}.txt
    cat $log/dnserrordomain_${now}.txt |grep -w "$Tue檢查網址DNS劫持\[重慶\]" >> $log/dnsChongqing_${now}.txt
    cat $log/dnserrordomain_${now}.txt |grep -w "$Mon檢查網址DNS劫持\[重慶\]" >> $log/dnsChongqing_${now}.txt
    cat $log/dnsChongqing_${now}.txt |awk '{print $2}' |sort |uniq > $log/dnsChongqing2_${now}.txt
    dnsChongqing=`cat $log/dnsChongqing2_${now}.txt |wc -l`
    # Another area
    cat $log/dnsallarea2_${now}.txt $log/dnsHubei2_${now}.txt $log/dnsChongqing2_${now}.txt > $log/exceptdnsanother_${now}.txt
    cat $log/exceptdnsanother_${now}.txt |sort |uniq > $log/exceptdnsanother2_${now}.txt
    exceptdnsanother=`cat $log/exceptdnsanother2_${now}.txt |wc -l`
    dnsanother=`echo "${dnserrordomaincount} - $exceptdnsanother" |bc`

for namedns in `cat $log/dnserrordomain_${now}.txt |awk '{print $2}'`; do
list1check=`cat $log/exceptdnsanother2_${now}.txt |awk '{print $2}' |grep -w $namedns`
        if [ "$namedns" = "$list1check" ]; then
                echo -ne "$namedns  \n" >> $log/dnslistok_${now}.txt
        else
                dns2another=`cat $log/dnserrordomain_${now}.txt |grep -w $namedns`
                echo -ne "$dns2another  \n" >> $log/dnslisterror_${now}.txt
        fi
done


echo -ne "\n"
echo -ne "\n"
############### 整理Block域名資訊
cat $var/PDNS_All_Domain.txt |grep -w "$wordkey檢查大陸封鎖" |jq -c [.site_group,.domain_name,.status_id,.status_ids,.note_gm,.note_id]|sed -e 's/^\[//g;s/\]$//g'|sed 's/^\"//g;s/\"$//g'|awk -F \"\,\" '{print $1, $2, $3, $4, $5, $6}' > $log/blockdomain_${now}.txt
cat $var/PDNS_All_Domain.txt |grep -w "$Sat檢查大陸封鎖" |jq -c [.site_group,.domain_name,.status_id,.status_ids,.note_gm,.note_id]|sed -e 's/^\[//g;s/\]$//g'|sed 's/^\"//g;s/\"$//g'|awk -F \"\,\" '{print $1, $2, $3, $4, $5, $6}' >> $log/blockdomain_${now}.txt
cat $var/PDNS_All_Domain.txt |grep -w "$Fri檢查大陸封鎖" |jq -c [.site_group,.domain_name,.status_id,.status_ids,.note_gm,.note_id]|sed -e 's/^\[//g;s/\]$//g'|sed 's/^\"//g;s/\"$//g'|awk -F \"\,\" '{print $1, $2, $3, $4, $5, $6}' >> $log/blockdomain_${now}.txt
cat $var/PDNS_All_Domain.txt |grep -w "$Thr檢查大陸封鎖" |jq -c [.site_group,.domain_name,.status_id,.status_ids,.note_gm,.note_id]|sed -e 's/^\[//g;s/\]$//g'|sed 's/^\"//g;s/\"$//g'|awk -F \"\,\" '{print $1, $2, $3, $4, $5, $6}' >> $log/blockdomain_${now}.txt
cat $var/PDNS_All_Domain.txt |grep -w "$Wen檢查大陸封鎖" |jq -c [.site_group,.domain_name,.status_id,.status_ids,.note_gm,.note_id]|sed -e 's/^\[//g;s/\]$//g'|sed 's/^\"//g;s/\"$//g'|awk -F \"\,\" '{print $1, $2, $3, $4, $5, $6}' >> $log/blockdomain_${now}.txt
cat $var/PDNS_All_Domain.txt |grep -w "$Tue檢查大陸封鎖" |jq -c [.site_group,.domain_name,.status_id,.status_ids,.note_gm,.note_id]|sed -e 's/^\[//g;s/\]$//g'|sed 's/^\"//g;s/\"$//g'|awk -F \"\,\" '{print $1, $2, $3, $4, $5, $6}' >> $log/blockdomain_${now}.txt
cat $var/PDNS_All_Domain.txt |grep -w "$Mon檢查大陸封鎖" |jq -c [.site_group,.domain_name,.status_id,.status_ids,.note_gm,.note_id]|sed -e 's/^\[//g;s/\]$//g'|sed 's/^\"//g;s/\"$//g'|awk -F \"\,\" '{print $1, $2, $3, $4, $5, $6}' >> $log/blockdomain_${now}.txt


    # Block域名總數
    ALLblockdomaincount=`cat $log/blockdomain_${now}.txt |awk '{print $2}' |sort |uniq |wc -l`
    # grep [全域]
    cat $log/blockdomain_${now}.txt |grep -w "$wordkey檢查大陸封鎖\[全域\]" > $log/blockallarea_${now}.txt
    cat $log/blockdomain_${now}.txt |grep -w "$Sat檢查大陸封鎖\[全域\]" >> $log/blockallarea_${now}.txt
    cat $log/blockdomain_${now}.txt |grep -w "$Fri檢查大陸封鎖\[全域\]" >> $log/blockallarea_${now}.txt
    cat $log/blockdomain_${now}.txt |grep -w "$Thr檢查大陸封鎖\[全域\]" >> $log/blockallarea_${now}.txt
    cat $log/blockdomain_${now}.txt |grep -w "$Wen檢查大陸封鎖\[全域\]" >> $log/blockallarea_${now}.txt
    cat $log/blockdomain_${now}.txt |grep -w "$Tue檢查大陸封鎖\[全域\]" >> $log/blockallarea_${now}.txt
    cat $log/blockdomain_${now}.txt |grep -w "$Mon檢查大陸封鎖\[全域\]" >> $log/blockallarea_${now}.txt
    cat $log/blockallarea_${now}.txt |awk '{print $2}' |sort |uniq > $log/blockallarea2_${now}.txt
    blockallarea=`cat $log/blockallarea2_${now}.txt |wc -l`
    # grep [移動-http/https]
    cat $log/blockdomain_${now}.txt |grep -w "$wordkey檢查大陸封鎖\[移動-http\/https\]" > $log/blockmobileISP_${now}.txt
    cat $log/blockdomain_${now}.txt |grep -w "$Sat檢查大陸封鎖\[移動-http\/https\]" >> $log/blockmobileISP_${now}.txt
    cat $log/blockdomain_${now}.txt |grep -w "$Fri檢查大陸封鎖\[移動-http\/https\]" >> $log/blockmobileISP_${now}.txt
    cat $log/blockdomain_${now}.txt |grep -w "$Thr檢查大陸封鎖\[移動-http\/https\]" >> $log/blockmobileISP_${now}.txt
    cat $log/blockdomain_${now}.txt |grep -w "$Wen檢查大陸封鎖\[移動-http\/https\]" >> $log/blockmobileISP_${now}.txt
    cat $log/blockdomain_${now}.txt |grep -w "$Tue檢查大陸封鎖\[移動-http\/https\]" >> $log/blockmobileISP_${now}.txt
    cat $log/blockdomain_${now}.txt |grep -w "$Mon檢查大陸封鎖\[移動-http\/https\]" >> $log/blockmobileISP_${now}.txt
    cat $log/blockmobileISP_${now}.txt |awk '{print $2}' |sort |uniq > $log/blockmobileISP2_${now}.txt
    blockmobileISP=`cat $log/blockmobileISP2_${now}.txt |wc -l`
    # 其它地區網址
    cat $log/blockmobileISP2_${now}.txt  > $log/exceptblockanother_${now}.txt
    cat $log/exceptblockanother_${now}.txt |sort |uniq > $log/exceptblockanother2_${now}.txt
    # 移動地區加總
    exceptblockanother=`cat $log/exceptblockanother2_${now}.txt |wc -l`
    # 其它地區網址計數
    blockanother=`echo "${ALLblockdomaincount} - ${exceptblockanother}" |bc`

for nameblock in `cat $log/blockdomain_${now}.txt |awk '{print $2}'`; do
list2check=`cat $log/exceptblockanother2_${now}.txt |awk '{print $2}' |grep -w $nameblock`
        if [ "$nameblock" = "$list2check" ]; then
                echo -ne "$nameblock  \n" >> $log/blocklistok_${now}.txt
        else
                block2another=`cat $log/blockdomain_${now}.txt |grep -w $nameblock`
                echo -ne "$block2another  \n" >> $log/blocklistanother_${now}.txt
        fi
done


echo -ne "DNS劫持網址數量共【$dnserrordomaincount條】、封鎖網址數量共【$ALLblockdomaincount條】"
echo -ne "\n" >> $log/TG_${now}.txt
echo -ne "DNS劫持網址數量共【$dnserrordomaincount條】、封鎖網址數量共【$ALLblockdomaincount條】" >> $log/TG_${now}.txt
echo -ne "\n"
echo -ne "\n"
echo -ne "詳細分類如下："
echo -ne "\n" >> $log/TG_${now}.txt
echo -ne "詳細分類如下：" >> $log/TG_${now}.txt
echo -ne "\n"
echo -ne "\n"
echo -ne "DNS劫持：[全域]一共【$dnsallarea條】，[湖北]一共【$dnsHubei條】，[重慶]一共【$dnsChongqing條】，[其它地區]一共【$dnsanother條】"
echo -ne "\n" >> $log/TG_${now}.txt
echo -ne "DNS劫持：[全域]一共【$dnsallarea條】，[湖北]一共【$dnsHubei條】，[重慶]一共【$dnsChongqing條】，[其它地區]一共【$dnsanother條】" >> $log/TG_${now}.txt
echo -ne "\n"
echo -ne "\n"
echo -ne "網址被封鎖：http封鎖一共【$blockanother條】，移動線路封鎖(http/https + 特殊port)一共【$exceptblockanother條】"
echo -ne "\n" >> $log/TG_${now}.txt
echo -ne "網址被封鎖：http封鎖一共【$blockanother條】，移動線路封鎖(http/https + 特殊port)一共【$exceptblockanother條】" >> $log/TG_${now}.txt

echo -ne "\n"
echo -ne "\n"
echo -ne "\n"
echo -ne "\n"
echo -ne "\033[33m==========\033[0m TG通報統計數量LOG，請查看 $log/TG_${now}.txt  \033[33m==========\033[0m\n"
echo -ne "\033[33m==========\033[0m DNS error-全域，清單請查看 $log/dnsallarea_${now}.txt  若無檔案代表皆正常  \033[33m==========\033[0m\n"
echo -ne "\033[33m==========\033[0m DNS error-湖北，清單請查看 $log/dnsHubei_${now}.txt  若無檔案代表皆正常  \033[33m==========\033[0m\n"
echo -ne "\033[33m==========\033[0m DNS error-重慶，清單請查看 $log/dnsChongqing_${now}.txt  若無檔案代表皆正常  \033[33m==========\033[0m\n"
echo -ne "\033[33m==========\033[0m DNS error-其它，清單請查看 $log/dnslisterror_${now}.txt  若無檔案代表皆正常  \033[33m==========\033[0m\n"
echo -ne "\033[33m==========\033[0m Block  [全域]，清單請查看 $log/blockallarea_${now}.txt  若無檔案代表皆正常  \033[33m==========\033[0m\n"
echo -ne "\033[33m==========\033[0m Block  [移動-http/https]，清單請查看 $log/blockmobileISP_${now}.txt  若無檔案代表皆正常  \033[33m==========\033[0m\n"
echo -ne "\033[33m==========\033[0m Block-http，清單請查看 $log/blocklistanother_${now}.txt  若無檔案代表皆正常  \033[33m==========\033[0m\n"


