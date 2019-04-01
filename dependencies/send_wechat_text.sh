#!/bin/bash
  # Reference: http://stackoverflow.com/questions/59895/can-a-bash-script-tell-what-directory-its-stored-in
  SOURCE="${BASH_SOURCE[0]}"
  BIN_DIR="$( dirname "$SOURCE" )"
  while [ -h "$SOURCE" ]
  do
    SOURCE="$(readlink "$SOURCE")"
    [[ $SOURCE != /* ]] && SOURCE="$DIR/$SOURCE"
    BIN_DIR="$( cd -P "$( dirname "$SOURCE"  )" && pwd )"
  done
  BIN_DIR="$( cd -P "$( dirname "$SOURCE" )" && pwd )"

#Usage
Usage() {
        echo "sh $SOURCE [touser] [agentid] [content]"
        echo "  touser  成员ID列表 (消息接收者，多个接收者用'|'分隔)"
        echo "  agentid 应用ID (4-手游, 5-端游, 6-集群, 7-北美, 1000003-橙柚)"
        echo "  content 消息内容, 支持换行"
        return 0
}
#check input parameters
if [ $# -eq 1 ]; then
        if [ "$1" = "-h" ]; then
                Usage
                exit 0
        else
                Usage
                exit -1
        fi
elif [ $# -ne 3 ]; then
        Usage
        exit -1
fi

# 0.1 init
sdate=`date -d "1 day ago" +%Y-%m-%d`
fmtsdate=`date -d $sdate +%Y%m%d`

# 0.2 send msg
touser=$1
agentid=$2
content=$3
echo "`date "+%Y-%m-%d %H:%M:%S"` $content"

data="{\"touser\" : \"$touser\", \"msgtype\" : \"text\", \"agentid\" : $agentid, \"text\" : {\"content\" : \"${content}\"} }"

echo "`date "+%Y-%m-%d %H:%M:%S"` 发送消息..."

response=$(curl -H 'Content-Type: application/json' -d "${data}" 'http://10.129.130.162:8089/message/send')

echo "`date "+%Y-%m-%d %H:%M:%S"` 结果: $response"
