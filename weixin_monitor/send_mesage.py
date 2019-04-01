# -*- coding: utf-8 -*-
from wxpy import *

bot = Bot()
# myself = bot.self
# bot.file_helper.send("hello")
bot.enable_puid('wxpy_puid.pkl')
my_friend = bot.friends().search('麦子')[0]
print(my_friend.puid)
my_friend.send('lalala')
