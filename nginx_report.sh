#!/bin/bash

REPORT_FILE=/tmp/report 
START_TIME=`date -d '1 hour ago' "+/%Y:%H:"`
LOG_ACCESS_FILE=/var/log/nginx/access.log
LOG_ERROR_FILE=/var/log/nginx/error.log
RECIPIENT=<your_mail>

function parse_log() {
	echo "Статистика предоставлена за промежуток с `date -d '1 hour ago' "+%Y-%m-%d %H:%M"` до  `date "+%Y-%m-%d %H:%M"`" >> $REPORT_FILE
	echo "Самые популярные IP адреса:" >> $REPORT_FILE
	grep $START_TIME $LOG_ACCESS_FILE | awk '{print $1}' | sort | uniq -c | sort -nr | head -n 5 >> $REPORT_FILE
	echo "Самые популярные URL:" >> $REPORT_FILE
	grep $START_TIME $LOG_ACCESS_FILE | awk '{print $11}' | sort | uniq -c | sort -nr | head -n 5 >> $REPORT_FILE
	echo "Коды возрата:" >> $REPORT_FILE
	grep $START_TIME $LOG_ACCESS_FILE | awk '{print $9}' | sort | uniq -c | sort -nr | head -n 5 >> $REPORT_FILE
	echo "Ошибки:" >> $REPORT_FILE
	grep $START_TIME $LOG_ERROR_FILE >> $REPORT_FILE
}

if [ -e "$REPORT_FILE" ] ; then
        echo 'Скрипт уже запущен'
    else
        > $REPORT_FILE
        parse_log
        cat $REPORT_FILE | mail -s "Otus.Lesson13.Bash" $RECIPIENT
        rm $REPORT_FILE
fi

