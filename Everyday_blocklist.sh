#!/bin/bash
clear
readonly opApi='Your API URL'
readonly now=`date +%Y%m%d_%H%M%S`
readonly yesterday=`date +%Y%m%d --date="-1 day"`
var="Your Directory"
log="Your Log Directory"

echo -e "\E[1;5;33m 撈取全域名中．．． \E[0m "
curl -d "Your API參數" -s "${opApi}" > $var/PDNS_All_Domain.txt

echo "##############################"
read -p "輸入要搜尋備註中寫的日期(例如20211006) ：" wordkey

############### 整理DNS劫持域名資訊
cat $var/PDNS_All_Domain.txt |grep -w "$wordkey檢查網址DNS劫持" |jq -c [.site_group,.domain_name,.status_id,.note_gm,.note_id]|sed -e 's/^\[//g;s/\]$//g'|sed 's/^\"//g;s/\"$//g'|awk -F \"\,\" '{print $1, $2, $3, $4, $5}' > $log/dnserrordomain_${now}.txt

    # DNS劫持域名總數
    dnserrordomaincount=`cat $log/dnserrordomain_${now}.txt |wc -l`
    # grep [全域]
    cat $log/dnserrordomain_${now}.txt |grep -w "$wordkey檢查網址DNS劫持\[全域\]" > $log/dnsallarea_${now}.txt
    dnsallarea=`cat $log/dnserrordomain_${now}.txt |grep -w "$wordkey檢查網址DNS劫持\[全域\]" |wc -l`
    # grep [湖北]
    cat $log/dnserrordomain_${now}.txt |grep -w "$wordkey檢查網址DNS劫持\[湖北\]" > $log/dnsHubei_${now}.txt
    dnsHubei=`cat $log/dnserrordomain_${now}.txt |grep -w "$wordkey檢查網址DNS劫持\[湖北\]" |wc -l`
    # grep [重慶]
    cat $log/dnserrordomain_${now}.txt |grep -w "$wordkey檢查網址DNS劫持\[重慶\]" > $log/dnsChongqing_${now}.txt
    dnsChongqing=`cat $log/dnserrordomain_${now}.txt |grep -w "$wordkey檢查網址DNS劫持\[重慶\]" |wc -l`
    # 其它地區
    cat $log/dnsallarea_${now}.txt $log/dnsHubei_${now}.txt $log/dnsChongqing_${now}.txt > $log/exceptdnsanother_${now}.txt
    dnsanother=`echo "${dnserrordomaincount} - ${dnsallarea} - ${dnsHubei} - ${dnsChongqing}" |bc`

for namedns in `cat $log/dnserrordomain_${now}.txt |awk '{print $2}'`; do
list1check=`cat $log/exceptdnsanother_${now}.txt |awk '{print $2}' |grep -w $namedns`
        if [ "$namedns" = "$list1check" ]; then
                echo -ne "$namedns  \n" >> $log/dnslistok_${now}.txt
        else
                dns2another=`cat $log/dnserrordomain_${now}.txt |grep -w $namedns`
                echo -ne "$dns2another  \n" >> $log/dnslisterror_${now}.txt
        fi
done

echo -ne "DNS劫持：[全域]一共【$dnsallarea條】，[湖北]一共【$dnsHubei條】，[重慶]一共【$dnsChongqing條】，[其它地區]一共【$dnsanother條】"

echo -ne "\n"
echo -ne "\n"
echo -ne "\n"
echo -ne "\n"
############### 整理封鎖域名資訊
cat $var/PDNS_All_Domain.txt |grep -w "$wordkey檢查大陸封鎖" |jq -c [.site_group,.domain_name,.status_id,.note_gm,.note_id]|sed -e 's/^\[//g;s/\]$//g'|sed 's/^\"//g;s/\"$//g'|awk -F \"\,\" '{print $1, $2, $3, $4, $5}' > $log/blockdomain_${now}.txt


    # 封鎖域名總數
    blockdomaincount=`cat $log/blockdomain_${now}.txt |wc -l`
    # grep [全域]
    cat $log/blockdomain_${now}.txt |grep -w "$wordkey檢查大陸封鎖\[全域\]" > $log/blockallarea_${now}.txt
    blockallarea=`cat $log/blockdomain_${now}.txt |grep -w "$wordkey檢查大陸封鎖\[全域\]" |wc -l`
    # grep [移動-http/https]
    cat $log/blockdomain_${now}.txt |grep -w "$wordkey檢查大陸封鎖\[移動-http\/https\]" > $log/blockmobileISP_${now}.txt
    blockmobileISP=`cat $log/blockdomain_${now}.txt |grep -w "$wordkey檢查大陸封鎖\[移動\-http\/https\]" |wc -l`
    # 其它地區
    cat $log/blockallarea_${now}.txt $log/blockmobileISP_${now}.txt > $log/exceptblockanother_${now}.txt
    blockanother=`echo "${blockdomaincount} - ${blockallarea} - ${blockmobileISP}" |bc`

for nameblock in `cat $log/blockdomain_${now}.txt |awk '{print $2}'`; do
list2check=`cat $log/exceptblockanother_${now}.txt |awk '{print $2}' |grep -w $nameblock`
        if [ "$nameblock" = "$list2check" ]; then
                echo -ne "$nameblock  \n" >> $log/blocklistok_${now}.txt
        else
                block2another=`cat $log/blockdomain_${now}.txt |grep -w $nameblock`
                echo -ne "$block2another  \n" >> $log/blocklisterror_${now}.txt
        fi
done

echo -ne "網址被封鎖一共【$blockdomaincount條】：http封鎖共 【$blockanother條】，移動線路封鎖(http/https + 特殊port)一共【$blockmobileISP條】"

echo -ne "\n"
echo -ne "\n"
echo -ne "\n"
echo -ne "\n"
echo -ne "\033[33m==========\033[0m DNS劫持-全域，清單請查看 $log/dnsallarea_${now}.txt  若無檔案代表皆正常  \033[33m==========\033[0m\n"
echo -ne "\033[33m==========\033[0m DNS劫持-湖北，清單請查看 $log/dnsHubei_${now}.txt  若無檔案代表皆正常  \033[33m==========\033[0m\n"
echo -ne "\033[33m==========\033[0m DNS劫持-重慶，清單請查看 $log/dnsChongqing_${now}.txt  若無檔案代表皆正常  \033[33m==========\033[0m\n"
echo -ne "\033[33m==========\033[0m DNS劫持-其它，清單請查看 $log/dnslisterror_${now}.txt  若無檔案代表皆正常  \033[33m==========\033[0m\n"
echo -ne "\033[33m==========\033[0m 封鎖-全域，清單請查看 $log/blockallarea_${now}.txt  若無檔案代表皆正常  \033[33m==========\033[0m\n"
echo -ne "\033[33m==========\033[0m 封鎖-移動，清單請查看 $log/blockmobileISP_${now}.txt  若無檔案代表皆正常  \033[33m==========\033[0m\n"
echo -ne "\033[33m==========\033[0m 封鎖-http，清單請查看 $log/blocklisterror_${now}.txt  若無檔案代表皆正常  \033[33m==========\033[0m\n"
