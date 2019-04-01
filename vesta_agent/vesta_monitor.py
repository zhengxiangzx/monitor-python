# -*- coding: utf-8 -*-
import json
from configparser import ConfigParser

import pymysql
import requests


def load_data_mysql(url, username, password, db_name, sql):
    db = pymysql.connect(url, username, password, db_name, charset='utf8')
    cursor = db.cursor()
    cursor.execute(sql)
    data_all = cursor.fetchall()
    db.close()
    data_list = []
    for data in data_all:
        data_list.append('停止的agent：' + data[0] + ' ' + data[2] + ' ' + str(data[1]))
    return data_list


def main():
    cfg = ConfigParser()
    cfg.read('./dependencies/config.ini')
    cfg.sections()
    url = cfg.get('vesta-agent', 'url')
    username = cfg.get('vesta-agent', 'username')
    password = cfg.get('vesta-agent', 'password')
    db_name = cfg.get('vesta-agent', 'db_name')
    sql = cfg.get('vesta-agent', 'sql')
    data = load_data_mysql(url, username, password, db_name, sql)
    string = ''
    for d in data:
        string = string + d.strip()
    print(string)
    name = 'zhengxiang'
    data = {"touser": name, "msgtype": "text", "agentid": 4, "content": 'test'}
    # data = json.dumps(data)
    url_wx = 'http://10.129.130.162:8089/message/send'
    headers = {
        'Content-Type': 'application/json'
    }

    # response = requests.Request(method='POST', url=url_wx, headers=headers,
    #                             data=data)
    response = requests.post(url=url_wx, json=data, data=data)
    #
    print(response.text)
    # print('two===', response2.text)


if __name__ == '__main__':
    main()
