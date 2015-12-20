#!/bin/bash
# --------------------------------------------------------------------------------------------------------
# Filename: db_slow_query_analysis.sh
# Revision: 1.2
# Author: Denny SHENG
# Date: 2015/12/20
# Description: 本工具为线上数据库所写，目的为汇总线上数据库的慢查询日志，并进行统计，最后将统计结果发送给相应的收件人。
#	脚本可接受几个参数:
#	-h, --host 目的数据库地址，
#	-t, --top-queries 慢查询请求数，
#	-r, --recipients 结果收件人地址，
# Usage: Crontab 中添加: 30 04 * * * /bin/bash /opt/dsheng/db_slow_query_analysis.sh -h db.lan -t 10 -r dennysheng@outlook.com &> /var/log/nginx/ops/mysql/db_slow_query.log

showhelp()
{
	echo "Please use this script following this way:"
	echo "This script accepting three arguments: \
		-h and/or --host means the database 's host address, \
		-t and/or --top-queries means how many querys you want to get, \
		-r and/or --recipients means to whom you want to send result to."
	echo "For example:"
	echo "sudo bash -x db_slow_query_analysis.sh \
		-h 192.168.0.90 -t 10 -r dennysheng@outlook.com"
}


main ()
{
	showhelp
	getopts *
	get_slow_log
	slow_log_analysis
	analysis_result_sendmail
	flush_origin_logs
}

main $*
