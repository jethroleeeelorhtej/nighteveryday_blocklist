#!/bin/bash
clear
readonly locate=$(dirname "$0")
readonly opApi='Your API URL'
readonly now=`date +%Y%m%d_%H%M%S`
readonly yesterday=`date +%Y%m%d --date="-1 day"`
var="Your Directory"
log="Your Log Directory"

echo -e "\E[1;5;33m 撈取全域名中．．． \E[0m "
curl -d "Your API參數" -s "${opApi}" > $var/PDNS_All_Domain.txt

echo "##############################"
read -p "輸入要搜尋備註中寫的日期(例如20211006) ：" wordkey

############### 整理DNS error域名資訊
cat $var/PDNS_All_Domain.txt |grep -w "$wordkey檢查網址DNS劫持" |jq -c [.site_group,.domain_name,.status_id,.status_ids,.note_gm,.note_id]|sed -e 's/^\[//g;s/\]$//g'|sed 's/^\"//g;s/\"$//g'|awk -F \"\,\" '{print $1, $2, $3, $4, $5, $6}' > $log/dnserrordomain_${now}.txt

    # DNS error域名總數
    dnserrordomaincount=`cat $log/dnserrordomain_${now}.txt |wc -l`
    # grep [ALL]
    cat $log/dnserrordomain_${now}.txt |grep -w "$wordkey檢查網址DNS劫持\[全域\]" > $log/dnsallarea_${now}.txt
    dnsallarea=`cat $log/dnserrordomain_${now}.txt |grep -w "$wordkey檢查網址DNS劫持\[全域\]" |wc -l`
    # grep [HB]
    cat $log/dnserrordomain_${now}.txt |grep -w "$wordkey檢查網址DNS劫持\[湖北\]" > $log/dnsHubei_${now}.txt
    dnsHubei=`cat $log/dnserrordomain_${now}.txt |grep -w "$wordkey檢查網址DNS劫持\[湖北\]" |wc -l`
    # grep [CH]
    cat $log/dnserrordomain_${now}.txt |grep -w "$wordkey檢查網址DNS劫持\[重慶\]" > $log/dnsChongqing_${now}.txt
    dnsChongqing=`cat $log/dnserrordomain_${now}.txt |grep -w "$wordkey檢查網址DNS劫持\[重慶\]" |wc -l`
    # another area
    cat $log/dnsallarea_${now}.txt $log/dnsHubei_${now}.txt $log/dnsChongqing_${now}.txt > $log/exceptdnsanother_${now}.txt
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

echo -ne "DNS劫持：[全域]一共【$dnsallarea條】，[湖北]一共【$dnsHubei條】，[重慶]一共【$dnsChongqing條】，[其它地區]一共【$dnsanother條】"
echo -ne "DNS劫持：[全域]一共【$dnsallarea條】，[湖北]一共【$dnsHubei條】，[重慶]一共【$dnsChongqing條】，[其它地區]一共【$dnsanother條】" > $log/TG_${now}.txt
echo -ne "\n"
echo -ne "\n"
echo -ne "\n"
echo -ne "\n"

############### 整理Block域名資訊
cat $var/PDNS_All_Domain.txt |grep -w "$wordkey檢查大陸封鎖" |jq -c [.site_group,.domain_name,.status_id,.note_gm,.note_id]|sed -e 's/^\[//g;s/\]$//g'|sed 's/^\"//g;s/\"$//g'|awk -F \"\,\" '{print $1, $2, $3, $4, $5}' > $log/blockdomain_${now}.txt
#cat $var/PDNS_All_Domain.txt |grep -w "$wordkey檢查網址http劫持\[江蘇\]" |jq -c [.site_group,.domain_name,.status_id,.note_gm,.note_id]|sed -e 's/^\[//g;s/\]$//g'|sed 's/^\"//g;s/\"$//g'|awk -F \"\,\" '{print $1, $2, $3, $4, $5}' > $log/JSblockdomain_${now}.txt


    # Block域名總數
    blockdomaincount=`cat $log/blockdomain_${now}.txt |wc -l`
    # JS總數
#    JSblockdomaincount=`cat $log/JSblockdomain_${now}.txt |wc -l`
    # grep [全域]
    cat $log/blockdomain_${now}.txt |grep -w "$wordkey檢查大陸封鎖\[全域\]" > $log/blockallarea_${now}.txt
    blockallarea=`cat $log/blockdomain_${now}.txt |grep -w "$wordkey檢查大陸封鎖\[全域\]" |wc -l`
    # grep [移動-http/https]
    cat $log/blockdomain_${now}.txt |grep -w "$wordkey檢查大陸封鎖\[移動-http\/https\]" > $log/blockmobileISP_${now}.txt
    blockmobileISP=`cat $log/blockdomain_${now}.txt |grep -w "$wordkey檢查大陸封鎖\[移動\-http\/https\]" |wc -l`
    # 其它地區網址
    cat $log/blockmobileISP_${now}.txt  > $log/exceptblockanother_${now}.txt
    cat $log/exceptblockanother_${now}.txt |sort |uniq > $log/exceptblockanother2_${now}.txt
    # MB地區加總
    exceptblockanother=`cat $log/exceptblockanother2_${now}.txt |wc -l`
    # 其它地區網址計數
    blockanother=`echo "${blockdomaincount} - ${exceptblockanother}" |bc`

for nameblock in `cat $log/blockdomain_${now}.txt |awk '{print $2}'`; do
list2check=`cat $log/exceptblockanother2_${now}.txt |awk '{print $2}' |grep -w $nameblock`
        if [ "$nameblock" = "$list2check" ]; then
                echo -ne "$nameblock  \n" >> $log/blocklistok_${now}.txt
        else
                block2another=`cat $log/blockdomain_${now}.txt |grep -w $nameblock`
                echo -ne "$block2another  \n" >> $log/blocklistanother_${now}.txt
        fi
done

echo -ne "網址被封鎖一共【$blockdomaincount條】：http封鎖共 【$blockanother條】，移動線路封鎖(http/https + 特殊port)一共【$exceptblockanother條】"
echo -ne "\n" >> $log/TG_${now}.txt
echo -ne "網址被封鎖一共【$blockdomaincount條】：http封鎖共 【$blockanother條】，移動線路封鎖(http/https + 特殊port)一共【$exceptblockanother條】" >> $log/TG_${now}.txt


echo -ne "\n"
echo -ne "\n"
echo -ne "\n"
echo -ne "\n"
echo -ne "\033[33m==========\033[0m TG通報統計LOG，請查看 $log/TG_${now}.txt  若無檔案代表皆正常  \033[33m==========\033[0m\n"
echo -ne "\033[33m==========\033[0m DNS error-ALL，清單請查看 $log/dnsallarea_${now}.txt  若無檔案代表皆正常  \033[33m==========\033[0m\n"
echo -ne "\033[33m==========\033[0m DNS error-HB，清單請查看 $log/dnsHubei_${now}.txt  若無檔案代表皆正常  \033[33m==========\033[0m\n"
echo -ne "\033[33m==========\033[0m DNS error-CH，清單請查看 $log/dnsChongqing_${now}.txt  若無檔案代表皆正常  \033[33m==========\033[0m\n"
echo -ne "\033[33m==========\033[0m DNS error-another，清單請查看 $log/dnslisterror_${now}.txt  若無檔案代表皆正常  \033[33m==========\033[0m\n"
echo -ne "\033[33m==========\033[0m Block[全域]，清單請查看 $log/blockallarea_${now}.txt  若無檔案代表皆正常  \033[33m==========\033[0m\n"
echo -ne "\033[33m==========\033[0m Block-http，清單請查看 $log/blocklistanother_${now}.txt  若無檔案代表皆正常  \033[33m==========\033[0m\n"
