#!/bin/bash

# ----------------------------------------------------------------------------
# Filename: mysql_slow_query_analysis.sh
# Revision: 1.1
# Auther: Denny SHENG
# Date: 2015-11-13
# Description: 脚本通过 mysqldumpslow 命令，分析慢查询的语句，记录日志并发邮件
# Usage: 加入 crontab 内，每周一凌晨执行一次 （当前处于测试阶段）
# Question: 慢查询结果中，会将脚本所在目录遍历并打印，偶发情况，还在查问题
# Notes: 每小时（测试）/ 每周（线上）
# Issue: 应修改脚本运行方式，脚本应带参数运行，例如：\
# mysql_slow_query_analysis.sh -h hostname -sp source_path -dp dest_path \
# -P port......
# ----------------------------------------------------------------------------

slowlog=/var/log/mysql/mysql_slow.log
contact=dennysheng@outlook.com
result_log=/var/log/mysql/slow_analy_result.log
slow_result=$(mysqldumpslow -s at -t 10 ${slowlog})
gen_datetime=$(date +%Y-%m-%d_%H:%M)

# 日志分析
slow_log_analysis()
{
	if [ -f ${slowlog} ]
	then
		echo "MySQL slow query result is:"
		echo "${slow_result}" >> ${result_log}
		echo 1111
	else
		echo "${slowlog} is not exists, please check!"
		echo 2222
	fi
}

# 日志分析结果发送邮件
analysis_result_sendmail()
{
	if [[ "${slow_result}" != "" ]]
	then
		echo ${slow_result}
		echo "${slow_result}" | mail -s "DB analysis result \
		${gen_datetime}" ${contact}
		echo 3333
	else
		echo "MySQL slow analysis result not found!" \
		| mail -s "DB analysis NO result!" ${contact}
		echo 4444
	fi
}

# 清空日志文件
slow_log_flush()
{
	if [ -e ${slowlog} ]
	then
		echo "" | sudo tee ${slowlog}
		echo "Slow log flush done!"
	else
		echo "slow log is not exist!"
	fi
}

# 主函数，依次执行日志分析，结果发送，日志清空
main()
{
	slow_log_analysis
	analysis_result_sendmail
	#slow_log_flush
}

main $*
