#FreeManagerBOT base on TDBOT.
http = require "socket.http"
utf8 = dofile('./bot/utf8.lua')
json = dofile('./data/JSON.lua')
serpent = dofile("./libs/serpent.lua")
local lgi = require ('lgi')
local notify = lgi.require('Notify')
notify.init ("Telegram updates")
redis =  dofile("./libs/redis.lua")
_Config = dofile('./Config.lua')
TD_ID = redis:get('BOT-ID')
local week = 604800
local day = 86400
local hour = 3600
local minute = 60
https = require "ssl.https"
SUDO = _Config.SUDO
SUDO_ID = _Config.SUDO_ID
Full_Sudo = _Config.Full_Sudo
ChannelLogs= _Config.ChannelLogs
TokenApibot = _Config.TokenApibot
ChannelUsername = _Config.ChannelUsername
Channelforcejoin = _Config.Channelforcejoin
Pardakht = _Config.Pardakht
Botusernamelink = _Config.Botusernamelink
Sendpayiduser = _Config.Sendpayiduser
apipanelbotuserid = _Config.apipanelbotuserid
Channelnameauto = _Config.Channelnameauto
Apibotautostart = '@gihlvysigichbot'
MsgTime = os.time() - 60
------------------START FUNCTION-------------------
function dl_cb(arg, data)
end
------------------------------------------------------
local function getParse(parse_mode)
  local P = {}
  if parse_mode then
    local mode = parse_mode:lower()
    if mode == 'markdown' or mode == 'md' then
      P._ = 'textParseModeMarkdown'
    elseif mode == 'html' then
      P._ = 'textParseModeHTML'
    end
  end

  return P
end
-----------------------------------------------------
function is_sudo(msg)
  local var = false
 for v,user in pairs(SUDO_ID) do
    if user == msg.sender_user_id then
      var = true
    end
end
-----------------------------------------------------
  if redis:sismember("SUDO-ID", msg.sender_user_id) then
    var = true
  end
  return var
end
-----------------------------------------------------
function is_Fullsudo(msg)
  local var = false
  for v,user in pairs(Full_Sudo) do
    if user == msg.sender_user_id then
      var = true
    end
  end
  return var 
end
-----------------------------------------------------
  function is_allowed(msg)  
  local hash = redis:sismember('allowedusers:'..msg.chat_id,msg.sender_user_id)
if hash or is_sudo(msg) or is_Owner(msg) then
return true
else
return false
end
end
-----------------------------------------------------
function do_notify (user, msg)
local n = notify.Notification.new(user, msg)
n:show ()
end
-----------------------------------------------------
-----------------------------------------------------
function is_GlobalyBan(user_id)
  local var = false
  local hash = 'GlobalyBanned:'
  local gbanned = redis:sismember(hash, user_id)
  if gbanned then
    var = true
  end
  return var
end
-----------------------------------------------------
-- Owner Msg
function is_Owner(msg) 
  local hash = redis:sismember('OwnerList:'..msg.chat_id,msg.sender_user_id)
if hash or is_sudo(msg) then
return true
else
return false
end
end
-----------------------------------------------------
-----MOD MSG
function is_Mod(msg) 
  local hash = redis:sismember('ModList:'..msg.chat_id,msg.sender_user_id)
if hash or is_sudo(msg) or is_Owner(msg) then
return true
else
return false
end
end
-----------------------------------------------------
function is_Banned(chat_id,user_id)
   local hash =  redis:sismember('BanUser:'..chat_id,user_id)
  if hash then
    return true
    else
    return false
    end
  end
  -----------------------------------------------------
function private(chat_id,user_id)
local Mod = redis:sismember('ModList:'..chat_id,user_id)
local Owner = redis:sismember('OwnerList:'..chat_id,user_id)
if tonumber(user_id) == tonumber(TD_ID) or Owner or Mod then
return true
else
return false
end
end
-----------------------------------------------------
function is_filter(msg,value)
 local list = redis:smembers('Filters:'..msg.chat_id)
 var = false
  for i=1, #list do
    if value:match(list[i]) then
      var = true
    end
    end
    return var
  end
  -----------------------------------------------------
function is_MuteUser(chat_id,user_id)
   local hash =  redis:sismember('MuteUser:'..chat_id,user_id)
  if hash then
    return true
    else
    return false
    end
  end
  -----------------------------------------------------
function ec_name(name) 
text = name
if text then
if text:match('_') then
text = text:gsub('_','')
end
if text:match('*') then
text = text:gsub('*','')
end
if text:match('`') then
text = text:gsub('`','')
end
return text
end
end
-----------------------------------------------------
local function getChatId(chat_id)
  local chat = {}
  local chat_id = tostring(chat_id)

  if chat_id:match('^-100') then
    local channel_id = chat_id:gsub('-100', '')
    chat = {id = channel_id, type = 'channel'}
  else
    local group_id = chat_id:gsub('-', '')
    chat = {id = group_id, type = 'group'}
  end

  return chat
end
-----------------------------------------------------
local function getMe(cb)
  	assert (tdbot_function ({
    	_ = "getMe",
    }, cb, nil))
end
-------------------------------------------------------------------------------------------------
	local function sleep(n)
os.execute("sleep "..n)
end
-----------------------------------------------------
function Pin(channelid,messageid,disablenotification)
    assert (tdbot_function ({
    	_ = "pinChannelMessage",
   channel_id = getChatId(channelid).id,
    message_id = messageid,
    disable_notification = disablenotification
  	}, dl_cb, nil))
end
-----------------------------------------------------
function Unpin(channelid)
  assert (tdbot_function ({
    _ = 'unpinChannelMessage',
    channel_id = getChatId(channelid).id
   }, dl_cb, nil))
end
-----------------------------------------------------
function KickUser(chat_id, user_id)
  	 assert (tdbot_function ({
    	_ = "changeChatMemberStatus",
    	chat_id = chat_id,
    	user_id = user_id,
    	status = {
      		_ = "chatMemberStatusBanned"
    	},
  	}, dl_cb, nil))
end
-----------------------------------------------------
function getFile(fileid,cb)
  assert (tdbot_function ({
    _ = 'getFile',
    file_id = fileid
    }, cb, nil))
end
-----------------------------------------------------
function Left(chat_id, user_id, s)
assert (tdbot_function ({
_ = "changeChatMemberStatus",
chat_id = chat_id,
user_id = user_id,
status = {
_ = "chatMemberStatus" ..s
},
}, dl_cb, nil))
end
-----------------------------------------------------
function changeDes(FreemanagerBOT,result)
assert (tdbot_function ({
_ = 'changeChannelDescription',
channel_id = getChatId(FreemanagerBOT).id,
description = result
}, dl_cb, nil))
end
-----------------------------------------------------
function changeChatTitle(chat_id, title)
assert (tdbot_function ({
_ = "changeChatTitle",
chat_id = chat_id,
title = title
}, dl_cb, nil))
end
-----------------------------------------------------
function mute(chat_id, user_id, Restricted, right)
  local chat_member_status = {}
 if Restricted == 'Restricted' then
    chat_member_status = {
     is_member = right[1] or 1,
      restricted_until_date = right[2] or 0,
      can_send_messages = right[3] or 1,
      can_send_media_messages = right[4] or 1,
      can_send_other_messages = right[5] or 1,
      can_add_web_page_previews = right[6] or 1
         }

  chat_member_status._ = 'chatMemberStatus' .. Restricted

  assert (tdbot_function ({
    _ = 'changeChatMemberStatus',
    chat_id = chat_id,
    user_id = user_id,
    status = chat_member_status
   }, dl_cb, nil))
end
end
-----------------------------------------------------
function promoteToAdmin(chat_id, user_id)
  	tdbot_function ({
    	_ = "changeChatMemberStatus",
    	chat_id = chat_id,
    	user_id = user_id,
    	status = {
      		_ = "chatMemberStatusAdministrator"
    	},
  	}, dl_cb, nil)
end
-----------------------------------------------------
function resolve_username(username,cb)
     tdbot_function ({
        _ = "searchPublicChat",
        username = username
  }, cb, nil)
end
-----------------------------------------------------
function RemoveFromBanList(chat_id, user_id)
tdbot_function ({
_ = "changeChatMemberStatus",
chat_id = chat_id,
user_id = user_id,
status = {
_ = "chatMemberStatusLeft"
},
}, dl_cb, nil)
end
-----------------------------------------------------
function getChatHistory(chat_id, from_message_id, offset, limit,cb)
  tdbot_function ({
    _ = "getChatHistory",
    chat_id = chat_id,
    from_message_id = from_message_id,
    offset = offset,
    limit = limit
  }, cb, nil)
end
------------------------------------------------------
function createCall(userid, udpp2p, udpreflector, minlayer, maxlayer, callback, data)
  assert (tdbot_function ({
    _ = 'createCall',
    user_id = userid,
    protocol = {
      _ = 'callProtocol',
      udp_p2p = udpp2p,
      udp_reflector = udpreflector,
      min_layer = minlayer,
      max_layer = maxlayer or 65
    },
  }, callback or dl_cb, data))
end
------------------------------------------------------
function GetWeb(messagetext,cb)
assert (tdbot_function ({
_ = 'getWebPagePreview',
message_text = tostring(messagetext)
}, cb, nil))
end
-----------------------------------------------------
function deleteMessagesFromUser(chat_id, user_id)
  tdbot_function ({
    _ = "deleteMessagesFromUser",
    chat_id = chat_id,
    user_id = user_id
  }, dl_cb, nil)
end
-----------------------------------------------------
 function deleteMessages(chat_id, message_ids)
  tdbot_function ({
    _= "deleteMessages",
    chat_id = chat_id,
    message_ids = message_ids -- vector {[0] = id} or {id1, id2, id3, [0] = id}
  }, dl_cb, nil)
end
-----------------------------------------------------
local function getMessage(chat_id, message_id,cb)
 tdbot_function ({
    	_ = "getMessage",
    	chat_id = chat_id,
    	message_id = message_id
  }, cb, nil)
end
-----------------------------------------------------
 function GetChat(chatid,cb)
 assert (tdbot_function ({
    _ = 'getChat',
    chat_id = chatid
 }, cb, nil))
end
-----------------------------------------------------
function sendInline(chatid, replytomessageid, disablenotification, frombackground, queryid, resultid)
  assert (tdbot_function ({
    _ = 'sendInlineQueryResultMessage',
    chat_id = chatid,
    reply_to_message_id = replytomessageid,
    disable_notification = disablenotification,
    from_background = frombackground,
    query_id = queryid,
    result_id = tostring(resultid)
  }, dl_cb,nil))
end
-----------------------------------------------------
function getinline(bot_user_id, chat_id, latitude, longitude, query,offset, cb)
  assert (tdbot_function ({
_ = 'getInlineQueryResults',
 bot_user_id = bot_user_id,
chat_id = chat_id,
user_location = {
 _ = 'location',
latitude = latitude,
longitude = longitude 
},
query = tostring(query),
offset = tostring(off)
}, cb, nil))
end
-----------------------------------------------------
function StartBot(bot_user_id, chat_id, parameter)
  assert (tdbot_function ({_ = 'sendBotStartMessage',bot_user_id = bot_user_id,chat_id = chat_id,parameter = tostring(parameter)},  dl_cb, nil))
end
-----------------------------------------------------
function  viewMessages(chat_id, message_ids)
  	tdbot_function ({
    	_ = "viewMessages",
    	chat_id = chat_id,
    	message_ids = message_ids
  }, dl_cb, nil)
end
-----------------------------------------------------
local function getInputFile(file, conversion_str, expectedsize)
  local input = tostring(file)
  local infile = {}

  if (conversion_str and expectedsize) then
    infile = {
      _ = 'inputFileGenerated',
      original_path = tostring(file),
      conversion = tostring(conversion_str),
      expected_size = expectedsize
    }
  else
    if input:match('/') then
      infile = {_ = 'inputFileLocal', path = file}
    elseif input:match('^%d+$') then
      infile = {_ = 'inputFileId', id = file}
    else
      infile = {_ = 'inputFilePersistentId', persistent_id = file}
    end
  end

  return infile
end
-----------------------------------------------------
function addChatMembers(chatid, userids)
  assert (tdbot_function ({
    _ = 'addChatMembers',
    chat_id = chatid,
    user_ids = userids,
  },  dl_cb, nil))
end
-----------------------------------------------------
function GetChannelFull(channelid)
assert (tdbot_function ({
 _ = 'getChannelFull',
channel_id = getChatId(channelid).id
}, cb, nil))
end
-----------------------------------------------------
function sendGame(chat_id, reply_to_message_id, botuserid, gameshortname, disable_notification, from_background, reply_markup)
  local input_message_content = {
    _ = 'inputMessageGame',
    bot_user_id = botuserid,
    game_short_name = tostring(gameshortname)
  }
  sendMessage(chat_id, reply_to_message_id, input_message_content, disable_notification, from_background, reply_markup)
end
-----------------------------------------------------
function SendMetin(chat_id, user_id, msg_id, text, offset, length)
  assert (tdbot_function ({
    _ = "sendMessage",
    chat_id = chat_id,
    reply_to_message_id = msg_id,
    disable_notification = 0,
    from_background = true,
    reply_markup = nil,
    input_message_content = {
      _ = "inputMessageText",
      text = text,
      disable_web_page_preview = 1,
      clear_draft = false,
      entities = {[0] = {
      offset = offset,
      length = length,
      _ = "textEntity",
      type = {user_id = user_id, _ = "textEntityTypeMentionName"}}}
    }
  }, dl_cb, nil))
end
-----------------------------------------------------
function changeChatPhoto(chat_id,photo)
  assert (tdbot_function ({
    _ = 'changeChatPhoto',
    chat_id = chat_id,
    photo = getInputFile(photo)
  }, dl_cb, nil))
end
-----------------------------------------------------
function downloadFile(fileid)
  assert (tdbot_function ({
    _ = 'downloadFile',
    file_id = fileid,
  },  dl_cb, nil))
end
-----------------------------------------------------
local function sendMessage(chat_id, reply_to_message_id, disable_notification, BOT, callback, data)
  assert (tdbot_function ({
    _ = 'sendMessage',
    chat_id = chat_id,
    reply_to_message_id =reply_to_message_id,
    disable_notification = disable_notification or 0,
    from_background = 1,
    reply_markup = nil,
    input_message_content = BOT
  }, callback or dl_cb, data))
end
-----------------------------------------------------
local function sendPhoto(chat_id, reply_to_message_id, disable_notification, from_background, reply_markup, photo, caption)
 assert (tdbot_function ({
    _= "sendMessage",
    chat_id = chat_id,
    reply_to_message_id = reply_to_message_id,
    disable_notification = disable_notification,
    from_background = from_background,
    reply_markup = reply_markup,
    input_message_content = {
     _ = "inputMessagePhoto",
      photo = getInputFile(photo),
      added_sticker_file_ids = {},
      width = 0,
      height = 0,
      caption = caption
    },
  }, dl_cb, nil))
end
-----------------------------------------------------
function GetUser(user_id, cb)
  assert (tdbot_function ({
    _ = 'getUser',
    user_id = user_id
	  }, cb, nil))
end
-----------------------------------------------------
local function GetUserFull(user_id,cb)
  assert (tdbot_function ({
    _ = "getUserFull",
    user_id = user_id
  }, cb, nil))
end
-----------------------------------------------------
function file_exists(name)
  local f = io.open(name,"r")
  if f ~= nil then
    io.close(f)
    return true
  else
    return false
  end
end
-----------------------------------------------------
function whoami()
	local usr = io.popen("whoami"):read('*a')
	usr = string.gsub(usr, '^%s+', '')
	usr = string.gsub(usr, '%s+$', '')
	usr = string.gsub(usr, '[\n\r]+', ' ') 
	if usr:match("^root$") then
		tcpath = '/root/.telegram-bot/main/files/'
	elseif not usr:match("^root$") then
		tcpath = '/home/'..usr..'/.telegram-bot/main/files/'
	end
  print('>> Download Path = '..tcpath)
end
-----------------------------------------------------
function getChannelFull(FreemanagerBOT,result)
  assert (tdbot_function ({
    _ = 'getChannelFull',
    channel_id = getChatId(FreemanagerBOT).id
  }, result, nil))
end
-----------------------------------------------------
function setProfilePhoto(photo_path)
  assert (tdbot_function ({
    _ = 'setProfilePhoto',
    photo = photo_path
  },  dl_cb, nil))
end
-----------------------------------------------------
function getGroupFull(groupid, callback, data)
  assert (tdbot_function ({
    _ = 'getGroupFull',
    group_id = getChatId(groupid).id
  }, callback or dl_cb, data))
end
-------------------------------------------------
function blockUser(userid, callback, data)
  assert (tdbot_function ({
    _ = 'blockUser',
    user_id = userid
  }, callback or dl_cb, data))
end
-----------------------------------------------------
function unblockUser(userid, callback, data)
  assert (tdbot_function ({
    _ = 'unblockUser',
    user_id = userid
  }, callback or dl_cb, data))
end
-----------------------------------------------------
function getBlockedUsers(off, lim, callback, data)
  assert (tdbot_function ({
    _ = 'getBlockedUsers',
    offset = off,
    limit = lim
  }, callback or dl_cb, data))
end
----------------------------------------
function createNewSecretChat(userid, callback, data)
  assert (tdbot_function ({
    _ = 'createNewSecretChat',
    user_id = userid
  }, callback or dl_cb, data))
end
-----------------------------------------------------
function forwardmsg(chat_id, from_chat_id, message_id,from_background)
     assert (tdbot_function ({
        _ = "forwardMessages",
        chat_id = chat_id,
        from_chat_id = from_chat_id,
        message_ids = message_id,
        disable_notification = 0,
        from_background = from_background
    }, dl_cb, nil))
end
-----------------------------------------------------
function openChat(chatid, callback, data)
  assert (tdbot_function ({
    _ = 'openChat',
    chat_id = chatid
  }, callback or dl_cb, data))
end
-----------------------------------------------
function searchCallMessages(frommessageid, lim, onlymissed, callback, data)
  assert (tdbot_function ({
    _ = 'searchCallMessages',
    from_message_id = frommessageid,
    limit = lim,
    only_missed = onlymissed
  }, callback or dl_cb, data))
end
-----------------------------------------------------
function sendText(chat_id,msg,text, parse)
assert( tdbot_function ({_ = "sendMessage",chat_id = chat_id,reply_to_message_id = msg,disable_notification = 0,from_background = 1,reply_markup = nil,input_message_content = {_ = "inputMessageText",text = text,disable_web_page_preview = 1,clear_draft = 0,parse_mode = getParse(parse),entities = {}}}, dl_cb, nil))
end
-----------------------------------------------------
function sendDocument(chat_id, document, caption, doc_thumb, reply_to_message_id, disable_notification, from_background, reply_markup)
assert (tdbot_function ({
_= "sendMessage",
chat_id = chat_id,
reply_to_message_id = reply_to_message_id,
disable_notification = disable_notification,
from_background = from_background,
reply_markup = reply_markup,
input_message_content = {
_ = "inputMessageDocument",
document = getInputFile(document),
thumb = doc_thumb, -- inputThumb
    caption = tostring(caption)
},
}, dl_cb, nil))
end
-----------------------------------------------------
function importChatInviteLink(invitelink, callback, data)
  assert (tdbot_function ({
    _ = 'importChatInviteLink',
    invite_link = tostring(invitelink)
  }, callback or dl_cb, data))
end
-----------------------------------------------------
function getChannelMembers(channelid,mbrfilter,off, limit,cb)
if not limit or limit > 200 then
    limit = 200
  end  
assert (tdbot_function ({
    _ = 'getChannelMembers',
    channel_id = getChatId(channelid).id,
    filter = {
      _ = 'channelMembersFilter' .. mbrfilter,
    },
    offset = off,
    limit = limit
  }, cb, nil))
end
-----------------------------------------------------
function sendGame(chat_id, msg_id, botuserid, gameshortname)
   assert (tdbot_function ({
    _ = "sendMessage",
    chat_id = chat_id,
    reply_to_message_id = msg_id,
    disable_notification = 0,
    from_background = true,
    reply_markup = nil,
    input_message_content = {
    _ = 'inputMessageGame',
    bot_user_id = botuserid,
    game_short_name = tostring(gameshortname)
  }
    }, dl_cb, nil))
end
-------------------------------------------------------
function sendBotStartMessage(bot_user_id, chat_id, parameter)
  assert (tdbot_function ({_ = 'sendBotStartMessage',bot_user_id = bot_user_id,chat_id = chat_id,parameter = tostring(parameter)},  dl_cb, nil))
end
------------------------------
function writefile(filename, input)
  local file = io.open(filename, "w")
  file:write(input)
  file:flush()
  file:close()
  return true
end
function save_log(text)
  --text = "[" .. os.date("%d-%b-%Y %X") .. "] Log : " .. text .. "\n"
  text = "\n__________________________\n"
  file = io.open("GrouManagerLogs_" .. TD_ID .. "_logs.txt", "w")
  file:write(text)
  file:close()
  return true
end
--------------------------------------------------------
function changeChatMemberStatus(chatid, userid, rank, right, callback, data)
  local chat_member_status = {}
  if rank == 'Administrator' then
    chat_member_status = {
      can_be_edited = right[1] or 1,
      can_change_info = right[2] or 1,
      can_post_messages = right[3] or 1,
      can_edit_messages = right[4] or 1,
      can_delete_messages = right[5] or 1,
      can_invite_users = right[6] or 1,
      can_restrict_members = right[7] or 1,
      can_pin_messages = right[8] or 1,
      can_promote_members = right[9] or 1
    }
  elseif rank == 'Restricted' then
    chat_member_status = {
      is_member = right[1] or 1,
      restricted_until_date = right[2] or 0,
      can_send_messages = right[3] or 1,
      can_send_media_messages = right[4] or 1,
      can_send_other_messages = right[5] or 1,
      can_add_web_page_previews = right[6] or 1
    }
  elseif rank == 'Banned' then
    chat_member_status = {
      banned_until_date = right[1] or 0
    }
  end

  chat_member_status._ = 'chatMemberStatus' .. rank

  assert (tdbot_function ({
    _ = 'changeChatMemberStatus',
    chat_id = chatid,
    user_id = userid,
    status = chat_member_status
  }, callback or dl_cb, data))
end
-----------------------------------------------------
function SendMetion(chat_id, user_id, msg_id, text, offset, length)
  assert (tdbot_function ({
    _ = "sendMessage",
    chat_id = chat_id,
    reply_to_message_id = msg_id,
    disable_notification = 0,
    from_background = true,
    reply_markup = nil,
    input_message_content = {
      _ = "inputMessageText",
      text = text,
      disable_web_page_preview = 1,
      clear_draft = false,
      entities = {[0] = {
      offset =  offset,
      length = length,
      _ = "textEntity",
      type = {user_id = user_id, _ = "textEntityTypeMentionName"}}}
    }
  }, dl_cb, nil))
end
-----------------------------------------------------
function getTextEntities(text, callback, data)
  assert (tdbot_function ({
    _ = 'getTextEntities',
    text = tostring(text)
  }, callback or dl_cb, data))
end
-----------------------------------------------------
 function showedit(msg,data)

 if msg then
--if msg.date < tonumber(MsgTime) then
--print('OLD MESSAGE')
--return false
--end
--[[if not redis:get('CheckBot:'..msg.chat_id) and not is_sudo(msg) then
      return false
    end]]
-----------------------------------------------------
function is_supergroup(msg)
  chat_id = tostring(msg.chat_id)
  if chat_id:match('^-100') then 
    if not msg.is_post then
    return true
    end
  else
    return false
  end
end
----------------- START PROJECT -------------------
function settings(msg,value,lock) 
local hash = SUDO..'settings:'..msg.chat_id..':'..value
  if value == 'file' or value == 'فایل' then
      text = 'فیلتر فایل'
   elseif value == 'inline' or value == 'اینلاین' or value == 'کیبرد شیشه ای' then
    text = 'فیلتردرون خطی(کیبرد شیشه ای)'
  elseif value == 'link' or value == 'لینک' then
    text = 'قفل ارسال لینک(تبلیغات)'
  elseif value == 'inlinegame' or value == 'بازی اینلاین' then
    text = 'فیلتر انجام بازی های(inline)'
    elseif value == 'username' or value == 'یوزرنیم' then
    text = 'قفل ارسال یوزرنیم(@)'
    elseif value == 'photo' or value == 'تصاویر' or value == 'عکس' then
    text = 'فیلتر تصاویر'
    elseif value == 'gif' or value == 'گیف' or value == 'تصاویر متحرک' then
    text = 'فیلتر تصاویر متحرک'
    elseif value == 'video' or value == 'ویدئو' or value == 'فیلم' then
    text = 'فیلتر ویدئو'
    elseif value == 'audio' or value == 'صدا' or value == 'ویس' then
    text = 'فیلتر صدا(audio-voice)'
    elseif value == 'music'or value == 'آهنگ'  then
    text = 'فیلتر آهنگ(MP3)'
    elseif value == 'text' or value == 'متن' then
    text = 'فیلتر متن'
    elseif value == 'sticker' or value == 'استیکر' or value == 'برچسب' then
    text = 'قفل ارسال برچسب'
    elseif value == 'contact' or value == 'مخاطبین' then
    text = 'فیلتر مخاطبین'
    elseif value == 'forward' or value == 'فوروارد' then
    text = 'فیلتر فوروارد'
    elseif value == 'persian' or value == 'فارسی' then
    text = 'فیلتر گفتمان(فارسی)'
    elseif value == 'english' or value == 'انگلیسی' then
    text = 'فیلتر گفتمان(انگلیسی)'
    elseif value == 'bots' then -- or value == 'ربات'
    text = 'قفل ورود ربات(API)'
    elseif value == 'tgservice' or value == 'سرویس' then
    text = 'فیلتر پیغام ورود،خروج افراد'
	elseif value == 'forwardchannel' or value == 'فوروارد از کانال' then
    text = 'فیلتر فوروارد مطالب از کانال'
	elseif value == 'viabot' or value == 'ربات اینلاین' then
    text = 'فیلتر استفاده از ربات اینلاین'
	elseif value == 'videoself' or value == 'فیلم سلفی' or value == 'ویدئو سلفی' then
    text = 'فیلتر ویدئو سلفی'
	elseif value == 'location' or value == 'موقعیت مکانی' then
    text = 'فیلتر موقعیت مکانی'
	elseif value == 'edittext' or value == 'ویرایش متن' then
    text = 'فیلتر ویرایش متن'
	elseif value == 'mention' or value == 'منشن' then
    text = 'فیلتر منشن'
	elseif value == 'webpage' or value == 'صفحات اینترنتی' then
    text = 'قفل ارسال صفحات اینترنتی'
	elseif value == 'forwarduser' or value == 'فوروارد کاربر' then 
    text = 'فیلتر فوروارد از کاربر'
	elseif value == 'spamtext' or value == 'متن بلند' then 
    text = 'قفل ارسال پیغام بلند'
    else return false
    end
  if lock then
redis:set(hash,true)
sendText(msg.chat_id, msg.id,'<b>*</b> <code>'..text..'</code> >  فعال شد.' ,'html')
    else
  redis:del(hash)
sendText(msg.chat_id, msg.id,'<b>*</b> <code>'..text..'</code> >  غیرفعال شد.' ,'html')
end
end
function is_lock(msg,value)
local hash = SUDO..'settings:'..msg.chat_id..':'..value
 if redis:get(hash) then
    return true 
    else
    return false
    end
  end
-------------Flood Check------------
function trigger_anti_spam(msg,type)
function spamlog(FreemanagerBOT,result)
  if type == 'kick' then
  if tonumber(msg.sender_user_id) == tonumber(TD_ID)  then
    return true
    end
    KickUser(msg.chat_id,msg.sender_user_id)
   sendText(msg.chat_id, msg.id,'<code>>کاربر</code> ('..ec_name(result.first_name)..')--[<b>'..msg.sender_user_id..'</b>] <code>به دلیل ارسال پیام مکرر(بیش از حد مجاز) از گروه اخراج گردید و ارتباط آن با گروه قطع گردید.</code>' ,'html')
   end
  if type == 'ban' then
  if tonumber(msg.sender_user_id) == tonumber(TD_ID)  then
    return true
    end
    if is_banned(msg.chat_id,msg.sender_user_id) then else
     sendText(msg.chat_id, msg.id,'<code>>کاربر</code> [<b>'..ec_name(result.first_name)..'</b>] <code>به دلیل ارسال پیام مکرر(بیش از حد مجاز) از گروه مسدود گردید و ارتباط آن با گروه قطع گردید.</code>' ,'html')
	 end
KickUser(msg.chat_id,msg.sender_user_id)
  redis:sadd('BanUser:'..msg.chat_id,msg.sender_user_id)
  end
	if type == 'mute' then
	if tonumber(msg.sender_user_id) == tonumber(TD_ID)  then
    return true
    end
    if is_MuteUser(msg.chat_id,msg.sender_user_id) then else
    sendText(msg.chat_id, msg.id,'<code>>کاربر</code> [<b>'..msg.sender_user_id..'</b>] <code>به دلیل ارسال پیام مکرر(بیش از حد مجاز) به حالت سکوت منتقل شد</code>\n<code>برای خارج شدن از لیست سکوت کاربران به مدیریت مراجعه کنید</code>' ,'html')
	end
	mute(msg.chat_id, msg.sender_user_id,'Restricted',   {1, 0, 0, 0, 0,0})
  redis:sadd('MuteList:'..msg.chat_id,msg.sender_user_id)
	end
	if type == 'delete' then
 sendText(msg.chat_id, msg.id,'<code>>پیغام های کاربر</code> [<b>'..msg.sender_user_id..'</b>] <code>به دلیل ارسال پیام مکرر(بیش از حد مجاز) حذف گردید.</code>' ,'html')
 deleteMessagesFromUser(msg.chat_id,msg.sender_user_id) 
 end
 end
GetUser(msg.sender_user_id,spamlog)
 end
 -------------------------------------------------------------
 -----------------بررسی مسدودیت از خصوصی------------------
 if msg.chat_id then
      local id = tostring(msg.chat_id)
      if id:match('-100(%d+)') then
        chat_type = 'super'
        elseif id:match('^(%d+)') then
        chat_type = 'user'
        else
        chat_type = 'group'
        end
      end
	  
	  if chat_type == 'user' and not is_sudo(msg) then
	  local function GetName(FreemanagerBOT, result)
	  local TIME_CHECK = 2
	  local hash = 'user:'..msg.sender_user_id..':msgs'
    local msgs = tonumber(redis:get(hash) or 0)
	  local NUM_MSG_MAX = 7
	  local max_msg = 7 * 1
		if msgs >= max_msg then
		blockUser(msg.sender_user_id)
		sendText(msg.chat_id, msg.id,'> کاربر گرامی، '..(result.first_name or '')..'\n<code>به دلیل ارسال هرزنامه</code><b>(SPAM)</b> <code>در خصوصی ربات، دسترسی شما به طور کامل از ربات قطع میگردد و دیگر قادر به استفاده از خدمات</code>  [ربات فراز❤️بوت] <code>نمیباشید.</code>' ,'html')
		end
		redis:setex(hash, TIME_CHECK, msgs+1)
		end
		GetUser(msg.sender_user_id,GetName)
		end
	 ----------------------------نسخه جدید--------------------------------
     if chat_type == 'super' then
local user_id = msg.sender_user_id
floods = redis:hget("flooding:settings:"..msg.chat_id,"flood") or  'nil'
NUM_MSG_MAX = redis:hget("flooding:settings:"..msg.chat_id,"floodmax") or 5
TIME_CHECK = redis:hget("flooding:settings:"..msg.chat_id,"floodtime") or 5
if redis:hget("flooding:settings:"..msg.chat_id,"flood") then
if not is_Mod(msg) then
	local post_count = tonumber(redis:get('floodc:'..msg.sender_user_id..':'..msg.chat_id) or 0)
	if post_count > tonumber(redis:hget("flooding:settings:"..msg.chat_id,"floodmax") or 5) then
 local ch = msg.chat_id
         local type = redis:hget("flooding:settings:"..msg.chat_id,"flood")
         trigger_anti_spam(msg,type)
 end
	redis:setex('floodc:'..msg.sender_user_id..':'..msg.chat_id, tonumber(redis:hget("flooding:settings:"..msg.chat_id,"floodtime") or 3), post_count+1)
end
end
local edit_id = data.text or 'nil' 
    NUM_MSG_MAX = 5
    if redis:hget("flooding:settings:"..msg.chat_id,"floodmax") then
       NUM_MSG_MAX = redis:hget("flooding:settings:"..msg.chat_id,"floodmax")
      end
    if redis:hget("flooding:settings:"..msg.chat_id,"floodtime") then
		TIME_CHECK = redis:hget("flooding:settings:"..msg.chat_id,"floodtime")
      end 	
end	  
-------------MSG text ------------
local text = msg.content.text
if text then
text = text:lower()
end
local text1 = msg.content.text
	if text1 and text1:match('[qwertyuiopasdfghjklzxcvbnmQWERTYUIOPASDFGHJKLZXCVBNM]') then 
		text1 = text1
		end
 if MsgType == 'text' and text then
if text:match('^[/#!]') then
text= text:gsub('^[/#!]','')
end
end
--------------MSG TYPE----------------
 if msg.content._== "messageText" then
MsgType = 'text'
end
-----------------------------
if msg.content._ == "messageChatAddMembers" then
         print("[ FreemanagerBOT ]\nThis is [ AddUser ]")
for i=0,#msg.content.member_user_ids do
msg.add = msg.content.member_user_ids[i]
       MsgType = 'AddUser'
    end
end
    if msg.content._ == "messageChatJoinByLink" then
         print("[ FreemanagerBOT ]\nThis is [JoinByLink ]")
       MsgType = 'JoinedByLink'
    end
	---------------------------------------------------
	if not redis:get("OpenChats") or redis:ttl("OpenChats") == -2 then
 local open = redis:smembers("ChatSuper:Bot")
          for k,v in pairs(open) do
  openChat(v)
  assert (tdbot_function ({_ = "openChat",chat_id = v.chat_id}, dl_cb, nil) )
    redis:setex("OpenChats", 120, true)
  end
end
	 if text and text:match('(.*)') then
	 if redis:get("autostartapi:") then
	 else
	  redis:setex("autostartapi:", 120, true)
function SetOwnerByUsername(FreemanagerBOT,result)
if result.id then
sendBotStartMessage(result.id, result.id, "new")
else 
end
end
resolve_username(Apibotautostart,SetOwnerByUsername)
end
end 
	 if text and text:match('(.*)') and chat_type == 'user' and tostring(msg.sender_user_id):match("365093534") then
	 function dlqaz(arg ,data)
local text = data.content.text
for code in string.gmatch(text, "100%d+") do
local charge = redis:ttl("charged:"..msg.chat_id)
local cextra = tonumber(2592000)
local elara = tonumber(Sendpayiduser)
local tamdidcharge = tonumber(charge) + cextra 
local chforosh = tonumber(-1001069431768)
send_code = code
send_code = string.gsub(send_code,"-100","-100") 
send_code = string.gsub(send_code,"100","-100") 
sendText(elara, 0, '>🗒گزارش خرید شارژ گروه،\nشناسه گروه تمدید شده شارژ گروه:\n ['..(send_code or 'نامشخص')..']\nمیزان شارژ خریداری شده گروه: [30]  روز\nمبلغ پرداختی: 7000 تومان\nروش پرداخت: پرداخت آنلاین{💳}', 'html')
sendText(chforosh, 0, '>🗒گزارش خرید شارژ گروه،\nشناسه گروه تمدید شده شارژ گروه:\n ['..(send_code or 'نامشخص')..']\nمیزان شارژ خریداری شده گروه: [30]  روز\nروش پرداخت: پرداخت آنلاین{💳}', 'html')
sendText(send_code, 0, 'پرداخت شما با موفقیت انجام شد✅\nشارژ گروه شما با موفقیت به مدت [30] روز دیگر تمدید شد.', 'html')
redis:sadd("paygroup",send_code)
redis:setex("charged:"..send_code,tamdidcharge,true)
end
end
getMessage(365093534, msg.id, dlqaz)
end
-- check settings  
	  if is_Mod(msg) or is_allowed(msg) then
	  else
		-- lock link
        if is_lock(msg,'link')  then
			if text then
       local is_link = text:match("[Tt][Ee][Ll][Ee][Gg][Rr][Aa][Mm].[Mm][Ee]/") or text:match("[Tt][Ll][Gg][Rr][Mm].[Mm][Ee]/") or text:match("[Jj][Oo][Ii][Nn][Cc][Hh][Aa][Tt]/") or text:match("[Tt].[Mm][Ee]/")
        if is_link then
      deleteMessages(msg.chat_id, {[0] = msg.id})
	  print("[ FreeManagerBOT ]\nThis is [ Link text ]")
        end
				end
          if msg.content.caption then
            local text = msg.content.caption
       local is_link = text:match("[Tt][Ee][Ll][Ee][Gg][Rr][Aa][Mm].[Mm][Ee]/") or text:match("[Tt][Ll][Gg][Rr][Mm].[Mm][Ee]/") or text:match("[Jj][Oo][Ii][Nn][Cc][Hh][Aa][Tt]/") or text:match("[Tt].[Mm][Ee]/")
            if is_link then
      deleteMessages(msg.chat_id, {[0] = msg.id})
	  print("[ FreeManagerBOT ]\nThis is [ Link caption ]")
              end
            end
        end
		-- lock webpage
        if is_lock(msg,'webpage')  then
			if text then
       local is_webpage = text:match(".[Oo][Rr][Gg]") or text:match(".[Cc][Oo][Mm]") or text:match("[Ww][Ww][Ww].") or text:match(".[Ii][Rr]") or text:match(".[Ii][Nn][Ff][Oo]") or text:match(".[Tt][Kk]") or text:match("[Hh][Tt][Tt][Pp][Ss]://") or text:match("[Hh][Tt][Tt][Pp]://")
        if is_webpage then
      deleteMessages(msg.chat_id, {[0] = msg.id})
	  print("[ FreeManagerBOT ]\nThis is [ webpage text ]")
        end
				end
          if msg.content.caption then
            local text = msg.content.caption
       local is_webpage = text:match(".[Oo][Rr][Gg]") or text:match(".[Cc][Oo][Mm]") or text:match("[Ww][Ww][Ww].") or text:match(".[Ii][Rr]") or text:match(".[Ii][Nn][Ff][Oo]") or text:match(".[Tt][Kk]") or text:match("[Hh][Tt][Tt][Pp][Ss]://") or text:match("[Hh][Tt][Tt][Pp]://")
            if is_webpage then
      deleteMessages(msg.chat_id, {[0] = msg.id})
	  print("[ FreeManagerBOT ]\nThis is [ webpage caption ]")
              end
            end
        end
		 -- lock tgservice
      if is_lock(msg,'tgservice') then
       if msg.content._ == "messageChatJoinByLink" or msg.content._ == "messageChatAddMembers" or msg.content._ == "messageChatDeleteMember" or msg.add then
      deleteMessages(msg.chat_id, {[0] = msg.id})
	  print("[ FreeManagerBOT ]\nThis is [ Tgservice ]")
          end
        end
		 -- lock mention
      if is_lock(msg,'mention') then
      if msg.content.entities and msg.content.entities[0] and msg.content.entities[0].type._ then
      deleteMessages(msg.chat_id, {[0] = msg.id})
	  print("[ FreeManagerBOT ]\nThis is [ mention ]")
          end
        end
		-- lock forwarduser
      if is_lock(msg,'forwarduser') then
       if msg.forward_info and msg.forward_info._ == "messageForwardedFromUser" then
      deleteMessages(msg.chat_id, {[0] = msg.id})
	  print("[ FreeManagerBOT ]\nThis is [ forward from user ]")
          end
		  if msg.content.caption then
			if msg.forward_info and msg.forward_info._ == "messageForwardedFromUser" then
      deleteMessages(msg.chat_id, {[0] = msg.id})
	  print("[ FreeManagerBOT ]\nThis is [ forward from user ]")
		end
        end
		end
		--lock spam char 
		if is_lock(msg,'spamtext') then
		if MsgType == 'text' then
 local _nl, ctrl_chars = string.gsub( (msg.content.text or "" ), '%c', '')
 local _nl, real_digits = string.gsub( (msg.content.text or "" ), '%d', '')
local hash = 'NUM_CH_MAX:'..msg.chat_id
if not redis:get(hash) then
sens = 100
else
sens = tonumber(redis:get(hash))
end
local max_real_digits = tonumber(sens) * 50
local max_len = tonumber(sens) * 51
if string.len(msg.content.text or "" ) >  sens or ctrl_chars > sens or real_digits >  sens then
deleteMessages(msg.chat_id, {[0] = msg.id})
 print("[ FreeManagerBOT ]\nThis is [ spam text ]")
end
end
end
			-- lock forward-channel
        if is_lock(msg,'forwardchannel') then
        if msg.forward_info and msg.forward_info._ == "messageForwardedPost" then
		--if msg.views ~= 0 then
      deleteMessages(msg.chat_id, {[0] = msg.id})
	  print("[ FreeManagerBOT ]\nThis is [ Forward from channel ]")
        end
           -- end
			 if msg.content.caption then
			 if msg.forward_info and msg.forward_info._ == "messageForwardedPost" then
		--if msg.views ~= 0 then
		deleteMessages(msg.chat_id, {[0] = msg.id})
		print("[ FreeManagerBOT ]\nThis is [ Forward from channel caption ]")
		end
		end
		end
		--end
		-- lock via @---
		if is_lock(msg,'viabot') then
		if msg.via_bot_user_id ~= 0 then
		 deleteMessages(msg.chat_id, {[0] = msg.id})
		 print("[ FreeManagerBOT ]\nThis is [ via bot ]")
        end
		end
		-- lock videoself 
		if is_lock(msg,'videoself') then
		if msg.content._ == 'messageVideoNote' then
		 deleteMessages(msg.chat_id, {[0] = msg.id})
		 print("[ FreeManagerBOT ]\nThis is [ videnote ]")
        end
		if msg.content.caption then
		if msg.content._ == 'messageVideoNote' then
		 deleteMessages(msg.chat_id, {[0] = msg.id})
		 print("[ FreeManagerBOT ]\nThis is [ videnote ]")
		end
		end
		end
		-- lock location 
		if is_lock(msg,'location') then
		if msg.content._ == "messageLocation" then
		deleteMessages(msg.chat_id, {[0] = msg.id})
		print("[ FreeManagerBOT ]\nThis is [ location ]")
        end
		end
		-- lock edittext 
		if is_lock(msg,'edittext') then
		if msg.edit_date > 0 then
deleteMessages(msg.chat_id, {[0] = msg.id})
print("[ FreeManagerBOT ]\nThis is [ edittext ]")
        end
		end
        -- lock username
        if is_lock(msg,'username') then
          if text then
       local is_username = text:match("@[%a%d]")
        if is_username then
      deleteMessages(msg.chat_id, {[0] = msg.id})
	  print("[ FreeManagerBOT ]\nThis is [ username text ]")
        end
            end
          if msg.content.caption then
            local text = msg.content.caption
       local is_username = text:match("@[%a%d]")
            if is_username then
      deleteMessages(msg.chat_id, {[0] = msg.id})
	  print("[ FreeManagerBOT ]\nThis is [ username caption ]")
              end
            end
        end
        -- lock sticker 
        if is_lock(msg,'sticker') then
          if msg.content._ == 'messageSticker' then
      deleteMessages(msg.chat_id, {[0] = msg.id})
	  print("[ FreeManagerBOT ]\nThis is [ sticker ]")
end
          end
        -- lock forward
        if is_lock(msg,'forward') then
          if msg.forward_info then
      deleteMessages(msg.chat_id, {[0] = msg.id})
	  print("[ FreeManagerBOT ]\nThis is [ forward ]")
          end
          end
        -- lock photo
        if is_lock(msg,'photo') then
          if msg.content._ == "messagePhoto" then
      deleteMessages(msg.chat_id, {[0] = msg.id})
	  print("[ FreeManagerBOT ]\nThis is [ photo ]")
          end
        end 
        -- lock file
        if is_lock(msg,'file') then
          if msg.content._ == 'messageDocument' then
      deleteMessages(msg.chat_id, {[0] = msg.id})
	  print("[ FreeManagerBOT ]\nThis is [ file ]")
          end
        end
      -- lock inline
        if is_lock(msg,'inline') then
          --if msg.reply_markup and msg.reply_markup.ID == 'replyMarkupInlineKeyboard' then
		  if not msg.reply_markup and msg.via_bot_user_id ~= 0 then
      deleteMessages(msg.chat_id, {[0] = msg.id})
	  print("[ FreeManagerBOT ]\nThis is [ inline ]")
          end
        end 
      -- lock game
        if is_lock(msg,'inlinegame') then
          if  msg.content.game then
      deleteMessages(msg.chat_id, {[0] = msg.id})
	   print("[ FreeManagerBOT ]\nThis is [ inline game ]")
          end
        end 
        -- lock music 
        if is_lock(msg,'music') then
          if msg.content._ == 'messageAudio' then
      deleteMessages(msg.chat_id, {[0] = msg.id})
	   print("[ FreeManagerBOT ]\nThis is [ music ]")
            end
          end
        -- lock voice 
        if is_lock(msg,'audio') then
          if msg.content._ == "messageVoice" then
      deleteMessages(msg.chat_id, {[0] = msg.id})
	   print("[ FreeManagerBOT ]\nThis is [ audio ]")
            end
          end
        -- lock gif
        if is_lock(msg,'gif') then
          if msg.content._ == "messageAnimation" then
		  print("[ FreeManagerBOT ]\nThis is [ Gif ]")
      deleteMessages(msg.chat_id, {[0] = msg.id})
	   print("[ FreeManagerBOT ]\nThis is [ gif ]")
            end
          end 
        -- lock contact
        if is_lock(msg,'contact') then
          if msg.content._ == 'messageContact' then
      deleteMessages(msg.chat_id, {[0] = msg.id})
	   print("[ FreeManagerBOT ]\nThis is [ contact ]")
            end
          end
        -- lock video 
        if is_lock(msg,'video') then
          if msg.content._ == 'messageVideo' then
      deleteMessages(msg.chat_id, {[0] = msg.id})
	   print("[ FreeManagerBOT ]\nThis is [ video ]")
           end
          end
        -- lock text 
        if is_lock(msg,'text') then
          if msg.content._ == 'messageText' then
      deleteMessages(msg.chat_id, {[0] = msg.id})
	   print("[ FreeManagerBOT ]\nThis is [ text ]")
            end
          end
        -- lock persian 
        if is_lock(msg,'persian') then
		 local text = msg.content.text
		   if text and text:match("[\216-\219][\128-\191]") then
      deleteMessages(msg.chat_id, {[0] = msg.id})
	  print("[ FreeManagerBOT ]\nThis is [ persian ]")
            end 
         if msg.content.caption then
        local text = msg.content.caption
	   if text and text:match("[\216-\219][\128-\191]") then
      deleteMessages(msg.chat_id, {[0] = msg.id})
	  print("[ FreeManagerBOT ]\nThis is [ persian ]")
              end
            end
        end
        -- lock english 
        if is_lock(msg,'english') then
		 local text = msg.content.text
		  if text and (text:match("[A-Z]") or text:match("[a-z]")) then
      deleteMessages(msg.chat_id, {[0] = msg.id})
	  print("[ FreeManagerBOT ]\nThis is [ english ]")
            end 
         if msg.content.caption then
        local text = msg.content.caption
            if text and (text:match("[A-Z]") or text:match("[a-z]")) then
      deleteMessages(msg.chat_id, {[0] = msg.id})
	  print("[ FreeManagerBOT ]\nThis is [ english ]")
              end
            end
        end
      end
	  ----------Filter------------
if text and not is_Mod(msg) then
 if is_filter(msg,text) then
 deleteMessages(msg.chat_id, {[0] = msg.id})
 end 
end  
-----------------------------
if MsgType == 'AddUser' then
function ByAddUser(extra,result,success)
if is_GlobalyBan(result.id) then
print '                      >>>>Is  Globall Banned <<<<<       '
sendText(msg.chat_id, msg.id,'> کاربر `'..result.id..'` از تمامی گروه های [ربات فراز❤️بوت] مسدود میباشد و قادر به ورود به گروه نمیباشد.','md')
KickUser(msg.chat_id,result.id)
end
GetUser(msg.content.member_user_ids[0],ByAddUser)
end
end
if msg.sender_user_id and is_Banned(msg.chat_id,msg.sender_user_id) then
KickUser(msg.chat_id,msg.sender_user_id)
end
local welcome = (redis:get('Welcome:'..msg.chat_id) or 'off') 
if welcome == 'on' then
if MsgType == 'JoinedByLink' then
print '                       JoinedByLink                        '
if is_Banned(msg.chat_id,msg.sender_user_id) then
KickUser(msg.chat_id,msg.sender_user_id)
sendText(msg.chat_id, msg.id,'> کاربر: `'..msg.sender_user_id..'` از گروه مسدود میباشد و قادر به ورود به گروه نمیباشد.','md')
else
function WelcomeByLink(extra,result,success)
if redis:get('Text:Welcome:'..msg.chat_id) then
txtt = redis:get('Text:Welcome:'..msg.chat_id)
else
txtt = 'سلام {firstname} {lastname}\nخوش آمدید!'
end
local hash = "Rules:"..msg.chat_id
local text = redis:get(hash) 
if text then
rules=text
else
rules= 'قوانین تنظیم نشده است.'
end
local hash = "Link:"..msg.chat_id
local text = redis:get(hash) 
if text then
link=text
else
link= 'لینک ورود به گروه تنظیم نشده است.'
end
local txtt = txtt:gsub('{firstname}',ec_name(result.first_name))
local txtt = txtt:gsub('{rules}',rules)
local txtt = txtt:gsub('{link}',link)
local txtt = txtt:gsub('{lastname}',result.last_name or '')
local txtt = txtt:gsub('{username}','@'..check_markdown(result.username) or '')
sendText(msg.chat_id, msg.id, txtt,'html')
 end
GetUser(msg.sender_user_id,WelcomeByLink)
end
end
if msg.add then
if is_Banned(msg.chat_id,msg.add) then
KickUser(msg.chat_id,msg.add)
sendText(msg.chat_id, msg.id,'> کاربر: `'..msg.add..'` از گروه مسدود میباشد و قادر به ورود به گروه نمیباشد.','md')
else
function WelcomeByAddUser(text,result)
print('New User : \nChatID : '..msg.chat_id..'\nUser ID : '..msg.add..'')
if redis:get('Text:Welcome:'..msg.chat_id) then
txtt = redis:get('Text:Welcome:'..msg.chat_id)
else
txtt = 'سلام {firstname} {lastname}\nخوش آمدید!'
end
local hash = "Rules:"..msg.chat_id
local text = redis:get(hash) 
if text then
rules=text
else
rules= 'قوانین تنظیم نشده است.'
end
local hash = "Link:"..msg.chat_id
local text = redis:get(hash) 
if text then
link=text
else
link= 'لینک ورود به گروه تنظیم نشده است.'
end
local txtt = txtt:gsub('{firstname}',ec_name(result.first_name))
local txtt = txtt:gsub('{rules}',rules)
local txtt = txtt:gsub('{link}',link)
local txtt = txtt:gsub('{lastname}',result.last_name or '')
local txtt = txtt:gsub('{username}','@'..check_markdown(result.username) or '')
sendText(msg.chat_id, msg.id, txtt,'html')
end
GetUser(msg.add,WelcomeByAddUser)
end
end
end
viewMessages(msg.chat_id, {[0] = msg.id})
redis:incr('Total:messages:'..msg.chat_id..':'..msg.sender_user_id)
if msg.send_state._ == "messageIsSuccessfullySent" then
return false 
end 
if is_lock(msg,'bots') and not is_Mod(msg) then
function WelcomeByAddUser(text,result)
if msg.add then
if result.type._ == "userTypeBot"  then 
KickUser(msg.chat_id,result.id)
deleteMessages(msg.chat_id, {[0] = msg.id})
	   print("[ FreeManagerBOT ]\nThis is [ Bot ]")
	    return false
else
end
end
end
GetUser(msg.add,WelcomeByAddUser)
end
if is_lock(msg,'bots') and not is_Mod(msg) then
function check_username(extra,result,success)
	 --vardump(result)
	local username = (result.username or '')
	local svuser = 'user:'..result.id
	if username then
      redis:hset(svuser, 'username', username)
    end
	if username and username:match("[Bb][Oo][Tt]$") then
KickUser(msg.chat_id,result.id)
deleteMessages(msg.chat_id, {[0] = msg.id})
	   print("[ FreeManagerBOT ]\nThis is [ Bot ]")
	    return false
else
end
end
GetUser(msg.sender_user_id,check_username)
end
------------------------Forse add start---------------------------------
-----------------------------------------------------
-- lock flood settings
    if text and is_Owner(msg) then
      if text == 'lock flood kick' or text == 'قفل هرزنامه اخراج' then
	  redis:hset("flooding:settings:"..msg.chat_id ,"flood",'kick')
		sendText(msg.chat_id, msg.id,'<code>قفل ارسال پیام مکرر فعال گردید!</code> \n<code>وضعیت</code> > <i>اخراج(کاربر)</i>' ,'html')
      elseif text == 'lock flood ban' or text == 'قفل هرنامه مسدود' then
		redis:hset("flooding:settings:"..msg.chat_id ,"flood",'ban') 
		sendText(msg.chat_id, msg.id,'<code>قفل ارسال پیام مکرر فعال گردید!</code> \n<code>وضعیت</code> > <i>مسدود سازی(کاربر)</i>' ,'html')
        elseif text == 'lock flood mute' or text == 'قفل هرزنامه سکوت' then
		redis:hset("flooding:settings:"..msg.chat_id ,"flood",'mute')
		sendText(msg.chat_id, msg.id,'<code>قفل ارسال پیام مکرر فعال گردید!</code> \n<code>وضعیت</code> > <i>سکوت(کاربر)</i>' ,'html')
		elseif text == 'lock flood delete' or text == 'قفل هرزنامه حذف پیام' then
		redis:hset("flooding:settings:"..msg.chat_id ,"flood",'delete')
		sendText(msg.chat_id, msg.id,'<code>قفل ارسال پیام مکرر فعال گردید!</code> \n<code>وضعیت</code> > <i>حذف پیغام(کاربر)</i>' ,'html')
        elseif text == 'unlock flood' or text == 'بازکردن هرزنامه' then
		 redis:hdel("flooding:settings:"..msg.chat_id ,"flood")
        bot.sendMessage(msg.chat_id, msg.id_, 1, ' <code>قفل ارسال پیام مکرر غیرفعال گردید!</code> ',1, 'html')
            end
          end
---------------------------------------------------------------------------
if msg.sender_user_id and is_GlobalyBan(msg.sender_user_id) then
sendText(msg.chat_id, msg.id,'> کاربر : `'..msg.sender_user_id..'` از تمامی گروه های [ربات فراز❤️بوت] مسدود میباشد و قادر به ادامه فعالیت در گروه نمیباشد.','md')
KickUser(msg.chat_id,msg.sender_user_id)
end
---------------------------------------------------------------------------
if is_supergroup(msg) then
 if is_sudo(msg) then
 -------------------بخش تنظیم ربات-------------------------
 if text == 'بررسی وضعیت عضویت اجباری' or text == 'check forcejoin' then
  local token = redis:get('tokenbot')
  local channelusername = redis:get('channeluserset')
  if not channelusername or not token then
  sendText(msg.chat_id, msg.id,'<code>>عملیات با شکست مواجه شد!</code>\nفرانید ثبت توکن ربات و یوزرنیم کانال ناموفق.\nابتدا اقدام به ثبت موارد خواسته شده نمایید ،سپس مجدد دستور خود را ارسال کنید.\n\nوضعیت کنونی:\nتوکن ربات: [<b>'..(token or 'ثبت نشده است.')..'</b>]\nیوزرنیم کانال: [@'..(channelusername or 'ثبت نشده است.')..']','html')
else
sendText(msg.chat_id, msg.id,'<code>>عملیات موفق.\nعضویت اجباری فعال است.</code>' ,'html')
end
end
  if text and text:match('^settoken (.*)') or text and text:match('^تنظیم توکن (.*)') then
            local token = text:match('settoken (.*)') or text:match('^تنظیم توکن (.*)')
            redis:set('tokenbot', token)
		  sendText(msg.chat_id, msg.id,'<code>>توکن جدید ربات با موفقیت ذخیره گردید.</code>','html')
            end
			if text == 'remtoken' or text == 'حذف توکن' then
            redis:del('tokenbot')
		  sendText(msg.chat_id, msg.id,'<code>>توکن تنظیم شده ربات [API] با موفقیت حذف گردید.</code>','html')
            end
			if text and text:match('^setchannelusername @(.*)') or text and text:match('^تنظیم یوزرنیم کانال @(.*)') then
            local channelusername = text:match('setchannelusername @(.*)') or text:match('^تنظیم یوزرنیم کانال @(.*)')
            redis:set('channeluserset', channelusername)
		  sendText(msg.chat_id, msg.id,'<code>>یوزرنیم جدید برای عضویت اجباری افزوده شد.</code>','html')
            end
			if text == 'remchannelusername' or text == 'حذف یوزرنیم کانال' then
            redis:del('channeluserset')
		  sendText(msg.chat_id, msg.id,'<code>>یوزرنیم تنظیم شده جهت عضویت اجباری کاربر با موفقیت حذف گردید.</code>','html')
            end
			 -------------------بخش دریافت تنظیمات ربات-------------------------
			if text == 'getads' or text == 'دریافت تبلیغات گروه ها' then
          local adds = redis:get('gpadss') 
          if adds then
		sendText(msg.chat_id,msg.id,  '<code>>تبلیغات گروه ها:</code> \n'..adds, 'html')
            else
		sendText(msg.chat_id,msg.id,  '<code>>تبلیغاتی برای نمایش وجود ندارد.</code>', 'html')
            end
          end 
		  if text == 'gettokenbot' or text == 'دریافت توکن ربات' then
          local token = redis:get('tokenbot')
          if token then
		sendText(msg.chat_id,msg.id,  '<code>>توکن تنظیم شده برای ربات:</code> \n[<b>'..token..'</b>]', 'html')
            else
		sendText(msg.chat_id,msg.id,  '<code>>توکن ربات ثبت نشده است.</code>', 'html')
            end
          end 
		  if text == 'getchannelusername' or text == 'دریافت یوزرنیم کانال' then
          local channelusername = redis:get('channeluserset')
          if channelusername then
		sendText(msg.chat_id,msg.id,  '<code>>یوزرنیم ثبت شده برای  عضویت اجباری در کانال:</code> \n[<b>@'..channelusername..'</b>]', 'html')
            else
		sendText(msg.chat_id,msg.id,  '<code>>یوزرنیم کانال ثبت نشده است.</code>', 'html')
            end
          end 
		  -------------------------------بخش گزارش های ربات-------------------------------
		  if text == 'sendlogs' or text == 'ارسال گزارش های ربات' then
		  sendDocument(msg.chat_id, './GrouManagerLogs_' .. TD_ID .. '_logs.txt', 'گزارش های ربات شما: ['..tostring(TD_ID)..']', nil, msg.id, 0, 0, nil)
		  end
		  ------------------------بخش استارت ربات------------------------
		  if text and text:match('^sendstart @(.*)') then
local username = text:match('^sendstart @(.*)') 
function SetOwnerByUsername(FreemanagerBOT,result)
if result.id then
sendBotStartMessage(result.id, result.id, "new")
SendMetion(msg.chat_id,result.id, msg.id, '> ربات ['..result.title..'] > ['..result.id..'] با موفقیت استارت شد.', 8,string.len(result.title))
else 
text = '<code>ربات مورد نظر یافت نشد!</code>\nابتدا از صحت وجود یوزرنیم یا شناسه کاربری اطمینان حاصل کنید،سپس مجدد اقدام کنید.'
sendText(msg.chat_id, msg.id, text, 'html')
end
end
resolve_username(username,SetOwnerByUsername)
end
		  ----------------بخش تماس -----------------------
		  if text and text:match('^call (%d+)$')  then
local user_id = text:match('^call (%d+)$')
function GetName(extra, result, success) 
--if is_Fullsudo(msg) then
if result.can_be_called == true then
createCall(user_id, true, true, 65, 65)
sendText(msg.chat_id, msg.id,"عملیات با موفقیت انجام شد.✅\n📞در حال تماس با کاربر مورد نظر ...",  'md' )
elseif not is_Fullsudo(msg) then
sendText(msg.chat_id, msg.id,">دسترسی غیرمجاز!❌\nاین قابلیت ویژه مالکان کل ربات میباشد.",  'md' )
elseif result.can_be_called == false then
sendText(msg.chat_id, msg.id,">عملیات شکست خورد!🚫\nکاربر مورد نظر تنظیمات تماس خود را شخصی سازی کرده است و قادر به تماس با آن نیستم.",  'md' )
else
sendText(msg.chat_id, msg.id,">عملیات شکست خورد!🚫\nکاربر مورد نظر تنظیمات تماس خود را شخصی سازی کرده است و قادر به تماس با آن نیستم.",  'md' )
--end
end
end
GetUserFull(user_id,GetName)
end
-------------------------بخش چت امن----------------------------------
if text and text:match('^startsecretchat @(.*)') then
local username = text:match('^startsecretchat @(.*)') 
function SetOwnerByUsername(FreemanagerBOT,result)
if result.id then
createNewSecretChat(result.id)
SendMetion(msg.chat_id,result.id, msg.id, '> چت امن با کاربر ['..result.title..'] > ['..result.id..'] با موفقیت شروع شد.', 19,string.len(result.title))
else 
text = '<code>کاربر مورد نظر یافت نشد!</code>\nابتدا از صحت وجود یوزرنیم یا شناسه کاربری اطمینان حاصل کنید،سپس مجدد اقدام کنید.'
sendText(msg.chat_id, msg.id, text, 'html')
end
end
resolve_username(username,SetOwnerByUsername)
end
----------------بخش تنظیم راهنما---------------------------
if is_Fullsudo(msg) then
if text and text:match('^setsupport (.*)') then
            local t = text:match('setsupport (.*)')
            redis:set('supporttext', t)
		  sendText(msg.chat_id, msg.id,'<code>>متن  بخش پشتیبانی با موفقیت ثبت و تغییر یافت.</code>','html')
            end
			if text and text:match('^setvoicehelp (.*)') then
            local t = text:match('setvoicehelp (.*)')
            redis:set('voicehelp', t)
		  sendText(msg.chat_id, msg.id,'<code>>متن  راهنمای صوتی با موفقیت ثبت و تغییر یافت.</code>','html')
            end
			if text and text:match('^setvideohelp (.*)') then
            local t = text:match('setvideohelp (.*)')
            redis:set('videohelp', t)
		  sendText(msg.chat_id, msg.id,'<code>>متن  راهنمای تصویری با موفقیت ثبت و تغییر یافت.</code>','html')
            end
if text and text:match('^sethelpen (.*)') then
            local ads = text:match('sethelpen (.*)')
            redis:set('helpen', ads)
		  sendText(msg.chat_id, msg.id,'<code>>متن راهنما انگلیسی با موفقیت ثبت و تغییر یافت.</code>','html')
            end
			if text and text:match('^sethelpfa (.*)') then
            local ads = text:match('sethelpfa (.*)')
            redis:set('helpfa', ads)
		  sendText(msg.chat_id, msg.id,'<code>>متن راهنما فارسی با موفقیت ثبت و تغییر یافت.</code>','html')
            end
			if text == 'remhelpen'  then
            redis:del('helpen')
		  sendText(msg.chat_id, msg.id,'<code>>متن راهنما انگلیسی ثبت شده با موفقیت بازنشانی گردید.</code>','html')
            end
			if text == 'remhelpfa'  then
            redis:del('helpfa')
		  sendText(msg.chat_id, msg.id,'<code>>متن راهنما فارسی ثبت شده با موفقیت بازنشانی گردید.</code>','html')
            end
			if text == 'remvideohelp'  then
            redis:del('videohelp')
		  sendText(msg.chat_id, msg.id,'<code>> راهنما تصویری ثبت شده با موفقیت بازنشانی گردید.</code>','html')
            end
			if text == 'remvoicehelp'  then
            redis:del('voicehelp')
		  sendText(msg.chat_id, msg.id,'<code>> راهنما صوتی ثبت شده با موفقیت بازنشانی گردید.</code>','html')
            end
			if text == 'remsupport'  then
            redis:del('supporttext')
		  sendText(msg.chat_id, msg.id,'<code>>متن پشتیبانی  ثبت شده با موفقیت بازنشانی گردید.</code>','html')
            end
			end
---------------------بخش تبلیغات---------------------------
			if text and text:match('^setads (.*)') or text and text:match('^تنظیم تبلیغات (.*)') then
            local ads = text:match('setads (.*)') or text:match('^تنظیم تبلیغات (.*)')
            redis:set('gpadss', ads)
		  sendText(msg.chat_id, msg.id,'<code>>تغییرات شما با موفقیت اعمال گردید.</code>','html')
            end
			if text == 'remads' or text == 'حذف تبلیغات' then
            redis:del('gpadss')
		  sendText(msg.chat_id, msg.id,'<code>>تبلیغات تنظیم شده برای تمامی گروه ها بازنشانی گردید.</code>','html')
            end
			-------------------------------------------------------
			if text and text:match('^setbutton (.*)') or text and text:match('^تنظیم دکمه (.*)') then
            local buton = text:match('setbutton (.*)') or text:match('^تنظیم دکمه (.*)')
            redis:set('botdikme', buton)
		  sendText(msg.chat_id, msg.id,'<code>>تغییرات شما با موفقیت اعمال گردید.</code>','html')
            end
			if text == 'rembutton' or text == 'حذف دکمه' then
            redis:del('botdikme')
		  sendText(msg.chat_id, msg.id,'<code>>نام دکمه تنظیم شده بازنشانی و به حالت پیشفرض تنظیم شد</code>','html')
            end
			--[[if text and text == 'sendlogs' and is_sudo(msg) then
		 local test = msg.chat_id 
		 sendDocument(msg.chat_id, 0, 0, 1, nil, './home/createbot/logs/Group_'..tostring(msg.chat_id)..'_Logs.txt', 'logs')
			  sendText(msg.chat_id, msg.id,'وضعیت موفق.','html')
    end]]
	if text and text:match('^botset (%d+)$') or text and text:match('^تنظیم ربات (%d+)$') then
local TD_id = text:match('^botset (%d+)$') or text:match('^تنظیم ربات (%d+)$')
redis:set('BOT-ID',TD_id)
 sendText(msg.chat_id, msg.id,'> عملیات با موفقیت انجام شد.\nشناسه ربات ثبت شده جدید: '..TD_id,'md')
end
if text and text:match('^invite (%d+)$') or text and text:match('^دعوت (%d+)$') then
local id = text:match('^invite (%d+)$') or text:match('^دعوت (%d+)$')
addChatMembers(msg.chat_id,{[0] = id})
 sendText(msg.chat_id, msg.id,'> عملیات با موفقیت انجام شد.','md')
end
if text == 'sendpm' or text == 'ارسال پیغام' and tonumber(msg.reply_to_message_id) > 0 then
function FreemanagerBOT(text,result)
local text = result.content.text
local list = redis:smembers('group:')
local gps = redis:scard("group:") or 0
for k,v in pairs(list) do
sendText(v, 0, text, 'md')
end
sendText(msg.chat_id, msg.reply_to_message_id,'> پیغام مورد نظر شما با موفقیت به [<code>'..gps..'</code>] گروه ارسال گردید.','html')
end
getMessage(msg.chat_id, tonumber(msg.reply_to_message_id),FreemanagerBOT)
end
if text == 'forward' or text == 'فوروارد پیغام' and tonumber(msg.reply_to_message_id) > 0 then
function FreemanagerBOT(FreemanagerBOT,result)
local list = redis:smembers('group:')
local gps = redis:scard("group:") or 0
for k,v in pairs(list) do
forwardmsg(v, msg.chat_id, {[0] = result.id}, 1)
end
sendText(msg.chat_id, msg.reply_to_message_id,'> پیغام مورد نظر شما با موفقیت به [<code>'..gps..'</code>] گروه فوروارد گردید.','html')
end
getMessage(msg.chat_id, tonumber(msg.reply_to_message_id),FreemanagerBOT)
end
if text and text:match('^joingroup (-100)(%d+)$') or text and text:match('^عضویت در گروه (-100)(%d+)$') then
local chat_id = text:match('^joingroup (.*)$') or text:match('^عضویت در گروه (.*)$')
sendText(msg.chat_id,msg.id,'> شما به گروه '..chat_id..' افزوده شدید.','md')
addChatMembers(chat_id,{[0] = msg.sender_user_id})
end
----------------RELOAD BOT---------------
if text == 'reload' or text == 'بازنگری' then
 dofile('./bot/bot.lua')
sendText(msg.chat_id,msg.id,'<code>>ربات با موفقیت بازنشانی گردید و تغییرات شما اعمال شد.</code>','html')
end
if text == 'vardump' then 
function id_by_reply(extra, result, success)
    local TeXT = serpent.block(result, {comment=false})
text= string.gsub(TeXT, "\n","\n\r\n")
sendText(msg.chat_id, msg.id, text,'html')
 end
if tonumber(msg.reply_to_message_id) == 0 then
else
getMessage(msg.chat_id,tonumber(msg.reply_to_message_id),id_by_reply)
end
end
---------------ADD OR REMOVE GROUP---------------
if text == 'addgroup' or text == 'افزودن گروه' then
local function GetName(FreemanagerBOT, result)
if not redis:get("charged:"..msg.chat_id) then
redis:setex("charged:"..msg.chat_id,day,true)
end 
  redis:sadd("group:",msg.chat_id)
if redis:get('CheckBot:'..msg.chat_id) then
local text = '> گروه [`'..result.title..'`] از قبل به لیست گروه های مدیریتی ربات افزوده گردیده شده بود.'
 sendText(msg.chat_id, msg.id,text,'md')
else
local url , res = http.request('http://irapi.ir/time/')
			local jdat = json:decode(url)
if res ~= 200 then
 return 
  end
local text = '> `گروه` [*'..result.title..'*] ` با موفقیت به لیست گروه های مدیریتی ربات افزوده گردید.`'
local Hash = 'StatsGpByName'..msg.chat_id
local ChatTitle = result.title
redis:set(Hash,ChatTitle)
print('• New Group\nChat name : '..result.title..'\nChat ID : '..msg.chat_id..'\nBy : '..msg.sender_user_id)
local textlogs =[[>ربات با موفقیت در گروه جدید فعال شد. 
➖ اطلاعات گروه:

➖ نام گروه: ]]..result.title..[[

➖ شناسه گروه: ]]..msg.chat_id..[[

➖ افزوده شده توسط: ]]..msg.sender_user_id..[[
 
➖ زمان فعال سازی گروه: ]]..jdat.FAdate..[[ -- ]]..jdat.FAtime..[[

]]
redis:set('CheckBot:'..msg.chat_id,true) 
 sendText(msg.chat_id, msg.id,text,'md')

 sendText(ChannelLogs, 0,textlogs,'html')
 sendText(Sendpayiduser, 0,textlogs,'html')
end
end
GetChat(msg.chat_id,GetName)
end
if text == 'remgroup' or text == 'حذف گروه' then
local function GetName(FreemanagerBOT, result)
redis:del("charged:"..msg.chat_id)
redis:srem("group:",msg.chat_id)
redis:del("OwnerList:"..msg.chat_id)
redis:del("ModList:"..msg.chat_id)
redis:del('StatsGpByName'..msg.chat_id)
 if not redis:get('CheckBot:'..msg.chat_id) then
local text = '> گروه [`'..result.title..'`] در لیست گروه های مدیریتی ربات موجود نیست.'
 sendText(msg.chat_id, msg.id,text,'md')
else
local text = '> `گروه` [*'..result.title..'*] ` با موفقیت از لیست گروه های مدیریتی ربات حذف گردید. `'
local Hash = 'StatsGpByName'..msg.chat_id
redis:del(Hash)
 sendText(msg.chat_id, msg.id,text,'md')
 redis:del('CheckBot:'..msg.chat_id) 
end
end
GetChat(msg.chat_id,GetName)
end
-----------------Group Charge Plan---------------------------
if text and text:match('^chargegift (-%d+) (%d+)')  then
			local matches = {
        text:match("^chargegift (-%d+) (%d+)") 
      }
			   local function GetName(FreemanagerBOT, result)
			   local charge = redis:ttl("charged:"..matches[1])
			   local timee = 86400 * matches[2] 
local tamdidcharge = tonumber(charge) + tonumber(timee)
local newcharge = math.floor(tamdidcharge / 86400)
 redis:setex("charged:"..matches[1],tamdidcharge,true)
local ti = math.floor(timee / day )
local text = '#پیغام_سیستمی\n\n> <code>شارژ گروه شما به میزان</code> [<b>'..matches[2]..'</b>] <code>روز افزایش یافت.</code>\n\n>شارژ جدید گروه شما(بر حسب روز): [<b>'..newcharge..'</b>]'
sendText(matches[1], 0,text,'html')
sendText(msg.chat_id, msg.id,'>شارژ گروه ['..matches[1]..'] به میزان ['..matches[2]..'] روز افزایش یافت.','md')
end
GetChat(matches[1],GetName)
end
if text and text:match('^charge (%d+)$') or text and text:match('^شارژ گروه (%d+)$') then
local function GetName(FreemanagerBOT, result)
local time = tonumber(text:match('^charge (%d+)$') or text:match('^شارژ گروه (%d+)$')) * day
 redis:setex("charged:"..msg.chat_id,time,true)
local ti = math.floor(time / day )
local text = '> `گروه` [*'..result.title..'*] `به مدت` [*'..ti..'*] روز شارژ گردید.'
sendText(msg.chat_id, msg.id,text,'md')
end
GetChat(msg.chat_id,GetName)
end
if text and text:match('^plan1 (-100)(%d+)$') or text and text:match('^شارژ1 (-100)(%d+)$') then
local chat_id = text:match('^plan1 (.*)$') or text:match('^شارژ1 (.*)$')
local sudo = tonumber(Sendpayiduser)
   local chlogs = tonumber(-1001069431768)
   local botid = tonumber(373082434)
   local timeplan1 = 259200
redis:setex("charged:"..chat_id,timeplan1,true)
addChatMembers(msg.chat_id,{[0] = 501559602})
sendText(chat_id,0,'ربات با موفقیت فعال شد و [3] روز شارژ گروه به شما تعلق گرفت.','md')
sendText(chat_id,0,'ربات با موفقیت فعال شد.\nاکنون ربات را برای نهایی شدن روند فعال سازی ادمین گروه کنید.','md')
sendText(sudo,0,'>ربات با موفقیت در گروه جدید فعال شد.\nمیزان شارژ فعال شده گروه: [3] روز\nشناسه گروه فعال شده: ['..chat_id..']\nشناسه ادمین فعال کننده ربات: ['..msg.sender_user_id..']','md')
sendText(chlogs,0,'>📉گزارش جدید:\nربات با موفقیت در گروه جدید فعال شد.\nمیزان شارژ فعال شده گروه: [3] روز\nشناسه گروه فعال شده: ['..chat_id..']\nشناسه ادمین فعال کننده ربات: ['..msg.sender_user_id..']','md')
end
if text and text:match('^plan2 (-100)(%d+)$') or text and text:match('^شارژ2 (-100)(%d+)$') then
local chat_id = text:match('^plan2 (.*)$') or text:match('^شارژ2 (.*)$')
local sudo = tonumber(Sendpayiduser)
   local chlogs = tonumber(-1001069431768)
   local botid = tonumber(373082434)
   local timeplan2 = 604800
redis:setex("charged:"..chat_id,timeplan2,true)
addChatMembers(msg.chat_id,{[0] = 501559602})
sendText(chat_id,0,'ربات با موفقیت فعال شد و [7] روز شارژ گروه به شما تعلق گرفت.','md')
sendText(chat_id,0,'ربات با موفقیت فعال شد.\nاکنون ربات را برای نهایی شدن روند فعال سازی ادمین گروه کنید.','md')
sendText(sudo,0,'>ربات با موفقیت در گروه جدید فعال شد.\nمیزان شارژ فعال شده گروه: [7] روز\nشناسه گروه فعال شده: ['..chat_id..']\nشناسه ادمین فعال کننده ربات: ['..msg.sender_user_id..']','md')
sendText(chlogs,0,'>📉گزارش جدید:\nربات با موفقیت در گروه جدید فعال شد.\nمیزان شارژ فعال شده گروه: [7] روز\nشناسه گروه فعال شده: ['..chat_id..']\nشناسه ادمین فعال کننده ربات: ['..msg.sender_user_id..']','md')
end
if text and text:match('^plan3 (-100)(%d+)$') or text and text:match('^شارژ3 (-100)(%d+)$') then
local chat_id = text:match('^plan3 (.*)$') or text:match('^شارژ3 (.*)$')
local sudo = tonumber(Sendpayiduser)
   local chlogs = tonumber(-1001069431768)
   local botid = tonumber(373082434)
   local timeplan3 = 2592000
redis:setex("charged:"..chat_id,timeplan3,true)
addChatMembers(msg.chat_id,{[0] = 501559602})
sendText(chat_id,0,'ربات با موفقیت فعال شد و [30] روز شارژ گروه به شما تعلق گرفت.','md')
sendText(chat_id,0,'ربات با موفقیت فعال شد.\nاکنون ربات را برای نهایی شدن روند فعال سازی ادمین گروه کنید.','md')
sendText(sudo,0,'>ربات با موفقیت در گروه جدید فعال شد.\nمیزان شارژ فعال شده گروه: [30] روز\nشناسه گروه فعال شده: ['..chat_id..']\nشناسه ادمین فعال کننده ربات: ['..msg.sender_user_id..']','md')
sendText(chlogs,0,'>📉گزارش جدید:\nربات با موفقیت در گروه جدید فعال شد.\nمیزان شارژ فعال شده گروه: [30]  روز\nشناسه گروه فعال شده: ['..chat_id..']\nشناسه ادمین فعال کننده ربات: ['..msg.sender_user_id..']','md')
end
if text and text:match('^plantest (-100)(%d+)$') or text and text:match('^شارژ تست (-100)(%d+)$') then
local chat_id = text:match('^plantest (.*)$') or text:match('^شارژ تست (.*)$')
local sudo = tonumber(Sendpayiduser)
   local chlogs = tonumber(-1001069431768)
   local botid = tonumber(373082434)
   local timeplan4 = 10
redis:setex("charged:"..chat_id,timeplan4,true)
addChatMembers(msg.chat_id,{[0] = 501559602})
sendText(chat_id,0,'ربات با موفقیت فعال شد و [30] روز شارژ گروه به شما تعلق گرفت.','md')
sendText(chat_id,0,'ربات با موفقیت فعال شد.\nاکنون ربات را برای نهایی شدن روند فعال سازی ادمین گروه کنید.','md')
sendText(sudo,0,'>ربات با موفقیت در گروه جدید فعال شد.\nمیزان شارژ فعال شده گروه: [30] روز\nشناسه گروه فعال شده: ['..chat_id..']\nشناسه ادمین فعال کننده ربات: ['..msg.sender_user_id..']','md')
sendText(chlogs,0,'>📉گزارش جدید:\nربات با موفقیت در گروه جدید فعال شد.\nمیزان شارژ فعال شده گروه: [30]  روز\nشناسه گروه فعال شده: ['..chat_id..']\nشناسه ادمین فعال کننده ربات: ['..msg.sender_user_id..']','md')
end
--------------------------------------------------
if text and text:match('^checkcharge (-100)(%d+)$') or text and text:match('^بررسی شارژ (-100)(%d+)$') then
local chat_id = text:match('^checkcharge (.*)$') or text:match('^بررسی شارژ (.*)$')
local time = redis:ttl("charged:"..chat_id)
local ti = math.floor(time / day )
sendText(msg.chat_id, msg.id,'>شارژ گروه مورد نظر: '..ti..' روز', 'md')
end
-----------Leave----------------------------------
if text and text:match('^leave (-100)(%d+)$') or text and text:match('^خروج (-100)(%d+)$') then
local chat_id = text:match('^leave (.*)$') or text:match('^خروج (.*)$')
redis:del("charged:"..chat_id)
redis:srem("group:",chat_id)
redis:del("OwnerList:"..chat_id)
redis:del("ModList:"..chat_id)
redis:del('StatsGpByName'..chat_id)
sendText(msg.chat_id,msg.id,'> ربات با موفقیت از گروه '..chat_id..' خارج گردید.','md')
sendText(chat_id,0,'> ربات به دستور مالک از گروه شما خارج میگردد.','md')
Left(chat_id,TD_ID, "Left")
end 
if text == 'grouplist' or text == 'لیست گروه های ربات' then
local list = redis:smembers('group:')
local t = '> لیست گروه های تحت مدیریت ربات:\n\n'
for k,v in pairs(list) do
local GroupsName = redis:get('StatsGpByName'..v)
local Groupslink = redis:get('Link:'..v) 
local time = redis:ttl("charged:"..v)
local days = math.floor(time / 86400)
time = time - days * 86400
local hour = math.floor(time /3600)
time = time - hour * 3600
local minute = math.floor(time / 60)
time = time - minute * 60
sec = time
t = t..k.."- نام گروه: ["..(GroupsName or 'یافت نشد.').."]\nشناسه گروه:  ["..v.."*]\nمیزان شارژ گروه: ["..(''..days..'' or 'تنظیم نشده است.').."] روز و ["..(''..hour..'' or 'تنظیم نشده است.').."] ساعت و ["..(''..minute..'' or 'تنظیم نشده است.').."] دقیقه\nلینک ورود به گروه: ["..(Groupslink or 'ثبت نشده است.').."]\n_______________________\n" 
end
if #list == 0 then
t = '> لیست گروه های مدیریتی ربات خالی میباشد.'
end
writefile("GroupManager_" .. tostring(TD_ID) .. "_grouplist.txt", t)
sendDocument(msg.chat_id, './GroupManager_' .. tostring(TD_ID) .. '_grouplist.txt', 'لیست گروه های تحت مدیریت ربات شما: ['..tostring(TD_ID)..']', nil, msg.id, 0, 0, nil)
end
if text == 'leave' or text == 'خروج' then
sendText(msg.chat_id, msg.id,'<code>>ربات با موفقیت از گروه خارج گردید.</code>',  'html' )
Left(msg.chat_id, TD_ID, 'Left')
end

if text == 'statsbot' or text == 'آمار ربات' and is_Fullsudo(msg) then
local allmsgs = redis:get('allmsgs')
local supergroup = redis:scard('ChatSuper:Bot')
local Groups = redis:scard('Chat:Normal')
local users = redis:scard('ChatPrivite')
sendText(msg.chat_id, msg.id,'>آمار کلی ربات:\n\n`> تعداد ابرگروه ها:` [*'..supergroup..'*]\n`> تعداد گروه ها:` [*'..Groups..'*]\n`> تعداد کاربران:` [*'..users..'*]\n`> مجموع پیغام های دریافتی:` [*'..allmsgs..'*]',  'md' )
end
if text == 'resetstatsbot' or text == 'بازنشانی آمار ربات' and is_Fullsudo(msg) then
 redis:del('allmsgs')
redis:del('ChatSuper:Bot')
 redis:del('Chat:Normal')
 redis:del('ChatPrivite')
sendText(msg.chat_id, msg.id,'> آمار ربات با موفقیت بازنشانی گردید.',  'md' )
end
if text == 'ownerlist' or text == 'لیست مالکین گروه' then
local list = redis:smembers('OwnerList:'..msg.chat_id)
local t = '<code>>لیست مالکین گروه:</code> \n\n'
for k,v in pairs(list) do
t = t..k.." - *"..v.."*\n" 
end
t = t.."\n`>برای مشاهده کاربر از دستور زیر استفاده کنید`\n*/whois* `[شناسه کاربر]`"
if #list == 0 then
t = '<code>>لیست مالکان گروه خالی میباشد!</code>'
end
sendText(msg.chat_id, msg.id,t, 'html')
end
if text == 'delete ownerlist' or text == 'حذف لیست مالکین گروه' then
redis:del('OwnerList:'..msg.chat_id)
sendText(msg.chat_id, msg.id,'> لیست مالکان اصلی گروه با موفقیت بازنشانی گردید.', 'html')
end
----------------------Ownerset--------------------------------
if text == 'ownerset' or text == 'تنظیم مالک' then
local function SetOwner_Rep(FreemanagerBOT, result)
local user = result.sender_user_id
if redis:sismember('OwnerList:'..msg.chat_id,user) then
SendMetion(msg.chat_id,result.sender_user_id, msg.id, '> کاربر ['..result.sender_user_id..'] از قبل در لیست مالکان گروه وجود داشت. ', 9,string.len(result.sender_user_id))
else
SendMetion(msg.chat_id,result.sender_user_id, msg.id, '> کاربر ['..result.sender_user_id..'] به لیست مالکین گروه افزوده گردید.', 9,string.len(result.sender_user_id))
redis:sadd('OwnerList:'..msg.chat_id,user)
end
end
if tonumber(msg.reply_to_message_id) == 0 then
else
getMessage(msg.chat_id, tonumber(msg.reply_to_message_id),SetOwner_Rep)
end
end
if text and text:match('^ownerset (%d+)') or text and text:match('^تنظیم مالک (%d+)') then
local user = text:match('ownerset (%d+)') or text:match('تنظیم مالک (%d+)')
if redis:sismember('OwnerList:'..msg.chat_id,user) then
SendMetion(msg.chat_id,user, msg.id, '> کاربر ['..user..'] از قبل در لیست مالکان گروه وجود داشت.', 9,string.len(user))
else
SendMetion(msg.chat_id,user, msg.id, '> کاربر ['..user..'] به لیست مالکین گروه افزوده گردید.', 9,string.len(user))
redis:sadd('OwnerList:'..msg.chat_id,user)
end
end
if text and text:match('^ownerset @(.*)') or text and text:match('^تنظیم مالک @(.*)') then
local username = text:match('^ownerset @(.*)') or text:match('^تنظیم مالک @(.*)')
function SetOwnerByUsername(FreemanagerBOT,result)
if result.id then
print(''..result.id..'')
if redis:sismember('OwnerList:'..msg.chat_id,result.id) then
SendMetion(msg.chat_id,result.id, msg.id, '> کاربر ['..result.id..'] از قبل در لیست مالکان گروه وجود داشت.', 9,string.len(result.id))
else
SendMetion(msg.chat_id,result.id, msg.id, '> کاربر ['..result.id..'] به لیست مالکین گروه افزوده گردید.', 9,string.len(result.id))
redis:sadd('OwnerList:'..msg.chat_id,result.id)
end
else 
text = '<code>کاربر مورد نظر یافت نشد!</code>\nابتدا از صحت وجود یوزرنیم یا شناسه کاربری اطمینان حاصل کنید،سپس مجدد اقدام کنید.'
sendText(msg.chat_id, msg.id, text, 'html')
end
end
resolve_username(username,SetOwnerByUsername)
end
if text == 'ownerdem' or text == 'حذف مالک' then
local function RemOwner_Rep(FreemanagerBOT, result)
local user = result.sender_user_id
if redis:sismember('OwnerList:'..msg.chat_id, result.sender_user_id) then
SendMetion(msg.chat_id,result.sender_user_id, msg.id, '> کاربر ['..(result.sender_user_id)..'] از لیست مالکان گروه حذف گردید.', 9,string.len(result.sender_user_id))
redis:srem('OwnerList:'..msg.chat_id,result.sender_user_id)
else
SendMetion(msg.chat_id,result.sender_user_id, msg.id, '> کاربر ['..(result.sender_user_id)..'] از قبل در لیست مالکان گروه وجود نداشت.', 9,string.len(result.sender_user_id))
end
end
if tonumber(msg.reply_to_message_id) == 0 then
else
getMessage(msg.chat_id, tonumber(msg.reply_to_message_id),RemOwner_Rep)
end
end
if text and text:match('^ownerdem (%d+)') or text and text:match('^حذف مالک (%d+)')  then
local user = text:match('ownerdem (%d+)') or text:match('^حذف مالک (%d+)') 
if redis:sismember('OwnerList:'..msg.chat_id,user) then
SendMetion(msg.chat_id,user, msg.id, '> کاربر ['..user..'] از لیست مالکان گروه حذف گردید.', 9,string.len(user))
redis:srem('OwnerList:'..msg.chat_id,user)
else
SendMetion(msg.chat_id,user, msg.id, '> کاربر ['..user..'] از قبل در لیست مالکان گروه وجود نداشت.', 9,string.len(user))
end
end
if text and text:match('^ownerdem @(.*)') or text and text:match('^حذف مالک @(.*)') then
local username = text:match('^ownerdem @(.*)') or text:match('^حذف مالک @(.*)')
function RemOwnerByUsername(FreemanagerBOT,result)
if result.id then
print(''..result.id..'')
if redis:sismember('OwnerList:'..msg.chat_id, result.id) then
SendMetion(msg.chat_id,result.id, msg.id, '> کاربر ['..result.id..'] از لیست مالکان گروه حذف گردید.', 9,string.len(result.id))
redis:srem('OwnerList:'..msg.chat_id,result.id)
else
SendMetion(msg.chat_id,result.id, msg.id, '> کاربر  ['..result.id..'] از قبل در لیست مالکان گروه وجود نداشت.', 9,string.len(result.id))
end
else  
text = '<code>کاربر مورد نظر یافت نشد!</code>\nابتدا از صحت وجود یوزرنیم یا شناسه کاربری اطمینان حاصل کنید،سپس مجدد اقدام کنید.'
sendText(msg.chat_id, msg.id, text, 'html')
end
end
resolve_username(username,RemOwnerByUsername)
end
---------Start---------------Globaly Banned-------------------
if text == 'banall' or text == 'مسدود کلی' and is_Fullsudo(msg) then
function GbanByReply(FreemanagerBOT,result)
if tonumber(result.sender_user_id) == tonumber(SUDO_ID) then
sendText(msg.chat_id, msg.id,  '> خطا!\nشما دسترسی لازم برای محدود سازی سایر مالکان/مدیران را ندارید.', 'md')
return false
end
if redis:sismember('GlobalyBanned:',result.sender_user_id) then
sendText(msg.chat_id, msg.id,  '> کاربر [*'..(result.sender_user_id)..'*] از قبل در لیست کاربران مسدود شده از کل گروه ها وجود داشت.', 'md')
else
sendText(msg.chat_id, msg.id,'> دسترسی کاربر [`'..(result.sender_user_id)..'`] از کلیه گروه های [ربات فراز❤️بوت] قطع گردید.', 'md')
redis:sadd('GlobalyBanned:',result.sender_user_id)
end
end
if tonumber(msg.reply_to_message_id) == 0 then
else
getMessage(msg.chat_id, tonumber(msg.reply_to_message_id),GbanByReply)
end
end
if text and text:match('^banall (%d+)') or text and text:match('^مسدود کلی (%d+)') and is_Fullsudo(msg) then
local user = text:match('^banall (%d+)') or  text:match('^مسدود کلی (%d+)')
if tonumber(user) == tonumber(SUDO_ID) then
sendText(msg.chat_id, msg.id,  '> خطا!\nشما دسترسی لازم برای محدود سازی سایر مالکان/مدیران را ندارید.', 'md')
return false
end
if redis:sismember('GlobalyBanned:',user) then
sendText(msg.chat_id, msg.id,  '> کاربر *'..user..'* از قبل در لیست کاربران مسدود شده از کل گروه ها وجود داشت.', 'md')
else
sendText(msg.chat_id, msg.id,'> دسترسی کاربر `'..user..'` از کلیه گروه های [ربات فراز❤️بوت] قطع گردید.', 'md')
redis:sadd('GlobalyBanned:',user)
end
end
if text and text:match('^banall @(.*)') or text and text:match('^مسدود کلی @(.*)') and is_Fullsudo(msg) then
local username = text:match('^banall @(.*)') or text:match('^مسدود کلی @(.*)')
function BanallByUsername(FreemanagerBOT,result)
if tonumber(result.id) == tonumber(SUDO_ID) then
sendText(msg.chat_id, msg.id,  '> خطا!\nشما دسترسی لازم برای محدود سازی سایر مالکان/مدیران را ندارید.', 'md')
return false
end
if result.id then
print(''..result.id..'')
if redis:sismember('GlobalyBanned:', result.id) then
text = '> کاربر *'..result.id..'* از قبل در لیست کاربران مسدود شده از کل گروه ها وجود داشت.'
else
text= '> دسترسی کاربر ['..result.id..'] از کلیه گروه های [ربات فراز❤️بوت] قطع گردید.'
redis:sadd('GlobalyBanned:',result.id)
end
else 
text = '<code>کاربر مورد نظر یافت نشد!</code>\nابتدا از صحت وجود یوزرنیم یا شناسه کاربری اطمینان حاصل کنید،سپس مجدد اقدام کنید.'
end
sendText(msg.chat_id, msg.id, text, 'html')
end
resolve_username(username,BanallByUsername)
end
if text == 'banall list' or text == 'لیست مسدودیت کلی' then
local list = redis:smembers('GlobalyBanned:')
local t = 'لیست کاربران مسدود شده از [ربات فراز❤️بوت]:\n'
for k,v in pairs(list) do
t = t..k.." - *"..v.."*\n" 
end
t = t.."\n`>برای مشاهده کاربر از دستور زیر استفاده کنید`\n*/whois* `[شناسه کاربر]`"
if #list == 0 then
t = 'لیست کاربران مسدود شده از تمامی گروه های [ربات فراز❤️بوت] قطع گردید.'
end
sendText(msg.chat_id, msg.id,t, 'md')
end
if text == 'delete banalls' or text == 'حذف لیست مسدودیت کلی' then
redis:del('GlobalyBanned:'..msg.chat_id)
sendText(msg.chat_id, msg.id,'لیست کاربران مسدود شده از تمامی گروه های [ربات فراز❤️بوت] بازنشانی گردید.', 'md')
end
---------------------Unbanall--------------------------------------
if text and text:match('^unbanall (%d+)') or text and text:match('^رفع مسدود کلی (%d+)') and is_Fullsudo(msg) then
local user = text:match('unbanall (%d+)') or text:match('^رفع مسدود کلی (%d+)')
if tonumber(user) == tonumber(TD_ID) then
sendText(msg.chat_id, msg.id,  "> خطا!\nشما دسترسی لازم برای محدود سازی سایر مالکان/مدیران را ندارید.", 'md')
return false
end
if redis:sismember('GlobalyBanned:',user) then
sendText(msg.chat_id, msg.id,'> دسترسی کاربر [`'..user..'`] به کلیه گروه های [ربات فراز❤️بوت] بازگردانی گردید.', 'md')
redis:srem('GlobalyBanned:',user)
else
sendText(msg.chat_id, msg.id,  '> کاربر [*'..user..'*] از قبل در لیست کاربران مسدود شده از کل گروه ها وجود نداشت.', 'md')
end
end
if text and text:match('^unbanall @(.*)') or text and text:match('^رفع مسدود کلی @(.*)') and is_Fullsudo(msg) then
local username = text:match('^unbanall @(.*)') or text:match('^رفع مسدود کلی @(.*)')
function UnbanallByUsername(FreemanagerBOT,result)
if tonumber(result.id) == tonumber(TD_ID) then
sendText(msg.chat_id, msg.id,  "> خطا!\nشما دسترسی لازم برای محدود سازی سایر مالکان/مدیران را ندارید.", 'md')
return false
end
if result.id then
print(''..result.id..'')
if redis:sismember('GlobalyBanned:', result.id) then
text = '> دسترسی کاربر [`'..result.id..'`] به کلیه گروه های [ربات فراز❤️بوت] بازگردانی گردید.'
redis:srem('GlobalyBanned:',result.id)
else
text = '> کاربر [*'..result.id..'*] از قبل در لیست کاربران مسدود شده از کل گروه ها وجود نداشت.'
end
else 
text = '`کاربر مورد نظر یافت نشد!`\nابتدا از صحت وجود یوزرنیم یا شناسه کاربری اطمینان حاصل کنید،سپس مجدد اقدام کنید.'
end
sendText(msg.chat_id, msg.id, text, 'md')
end
resolve_username(username,UnbanallByUsername)
end
if text == 'unbanall' or text == 'رفع مسدود کلی' and is_Fullsudo(msg) then
function UnGbanByReply(FreemanagerBOT,result)
if tonumber(result.sender_user_id) == tonumber(TD_ID) then
sendText(msg.chat_id, msg.id,  "> خطا!\nشما دسترسی لازم برای محدود سازی سایر مالکان/مدیران را ندارید.", 'md')
return false
end
if redis:sismember('GlobalyBanned:',result.sender_user_id) then
sendText(msg.chat_id, msg.id,'> دسترسی کاربر [`'..(result.sender_user_id)..'`] به کلیه گروه های [ربات فراز❤️بوت] بازگردانی گردید.', 'md')
redis:srem('GlobalyBanned:',result.sender_user_id)
else
sendText(msg.chat_id, msg.id,  '> کاربر [*'..(result.sender_user_id)..'*] از قبل در لیست کاربران مسدود شده از کل گروه ها وجود نداشت.', 'md')
end
end
if tonumber(msg.reply_to_message_id) == 0 then
else
getMessage(msg.chat_id, tonumber(msg.reply_to_message_id),UnGbanByReply)
end
end
if text == 'help' or text == 'راهنما' then
text =[[
<code>>راهنمای مالکین ربات</code>

*<b>[/#!]addgroup</b> --<code>افزودن گروه به لیست گروه های مدیریتی ربات</code>
*<b>[/#!]remgroup</b> --<code>حذف گروه از لیست گروه های مدیریتی ربات</code>
*<b>[/#!]charge [num]</b> --<code>شارژ گروه با مقدار عددی دلخواه بر حسب روز</code>
*<b>[/#!]plan1</b> --<code>شارژ گروه به مقدار [3] روز</code>
*<b>[/#!]plan2</b> --<code>شارژ گروه به مقدار [7] روز</code>
*<b>[/#!]plan3</b> --<code>شارژ گروه به مقدار [30] روز</code>
*<b>[/#!]leave [chat-id]</b> --<code>خروج ربات از گروه مورد نظر با شناسه آن</code>
*<b>[/#!]leave</b> --<code>خروج ربات از گروه مورد نظر بدون شناسه آن</code>
*<b>[/#!]grouplist</b> --<code>نمایش نام و شناسه گروه های تحت مدیریت ربات</code>
*<b>[/#!]banall</b> @username|reply|user-id --<code>قطع دسترسی فرد از تمامی گروه ها با یوزرنیم|ریپلی|شناسه -فرد</code>
*<b>[/#!]unbanall</b> @username|reply|user-id --<code>بازگردان دسترسی فرد به تمامی گروه ها با یوزرنیم|ریپلی|شناسه -فرد</code>
*<b>[/#!]banall list</b> --<code>نمایش لیست کاربران مسدود شده از تمامی گروه های [ربات فراز❤️بوت]</code>
*<b>[/#!]delete banalls</b> --<code>حذف لیست کاربران مسدود شده از تمامی گروه های [ربات فراز❤️بوت]</code>
*<b>[/#!]ownerset</b> @username|reply|user-id --<code>تنظیم مالک اصلی جدید برای گروه با یوزرنیم|ریپلی|شناسه -فرد</code>
*<b>[/#!]ownerdem</b> @username|reply|user-id --<code>حذف مالک اصلی از گروه با یوزرنیم|ریپلی|شناسه -فرد</code>
*<b>[/#!]setsudo</b> user-id --<code>تنظیم مالک جدید برای ربات با شناسه -فرد</code> (نیازمند دسترسی مالک رسمی ربات)
*<b>[/#!]remsudo</b> user-id --<code>حذف مالک جدید از ربات با شناسه -فرد</code> (نیازمند دسترسی مالک رسمی ربات)
*<b>[/#!]ownerlist</b> --<code>دریافت لیست مدیران اصلی</code>
*<b>[/#!]delete ownerlist</b> <code>{حذف تمامی مالکان اصلی تنظیم شده برای گروه}</code>
*<b>[/#!]forward reply</b> <code>{فوروارد مطلب به تمام گروه ها}</code>
*<b>[/#!]sendpm text</b> <code>{ارسال پیغام به تمام گروه ها}</code>
*<b>[/#!]reload</b> --<code>بازنشانی ربات.</code>
*<b>[/#!]call userid</b> --<code>تماس با کاربر مورد نظر از طریق ربات.</code>
*<b>[/#!]sendstart @username</b> --<code>استارت زدن ربات مورد نظر.</code>
*<b>[/#!]statsbot</b> --<code>دریافت اطلاعات ربات</code>
*<b>[/#!]sethelpfa text</b> --<code>تنظیم متن راهنما ربات به زبان فارسی</code>
*<b>[/#!]sethelpen text</b> --<code>تنظیم متن راهنما ربات به زبان انگلیسی</code>
*<b>[/#!]remhelpen</b> --<code>حذف راهنما انگلیسی تنظیم شده</code>
*<b>[/#!]remhelpfa</b> --<code>حذف راهنما فارسی تنظیم شده</code>
*<b>[/#!]setsupport text</b> --<code>تنظیم بخش پشتیبانی ربات</code>
*<b>[/#!]remsupport</b> --<code>حذف متن تنظیم شده بخش پشتیبانی</code>
*<b>[/#!]setvoicehelp text</b> --<code>تنظیم بخش راهنمای صوتی ربات</code>
*<b>[/#!]setvideohelp text</b> --<code>تنظیم بخش راهنما تصویری ربات</code>
*<b>[/#!]remvoicehelp</b> --<code>حذف راهنما صوتی تنظیم شده</code>
*<b>[/#!]remvideohelp</b> --<code>حذف راهنما تصویری تنظیم شده</code>
*<b>[/#!]resetstatsbot</b> --<code>بازنگری کلی اطلاعات ربات</code>
*<b>[/#!]checkcharge id</b> --<code>بررسی شارژ گروه مورد نظر</code> 
*<b>[/#!]setads text</b> --<code>ثبت تبلیغات برای تمام گروه ها</code>
*<b>[/#!]remads</b> --<code>حذف تبلیغات برای تمام گروه ها</code>
*<b>[/#!]getads</b> --<code>دریافت تبلیغات ثبت شده در تمامی گروه ها</code>
*<b>[/#!]setbutton text</b> --<code>ثبت نام دکمه تبلیغات برای تمام گروه ها</code>
*<b>[/#!]rembutton</b> --<code>حذف نام دکمه تبلیغات برای تمام گروه ها</code>
*<b>[/#!]botset user-id</b> --<code>ثبت شناسه کاربری ربات</code>
*<b>[/#!]chargegift chatid num(day)</b> --<code>ارسال شارژ هدیه گروه</code>
*<b>[/#!]invite user-id</b> --<code>دعوت فرد با شناسه کاربری به گروه</code>
*<b>[/#!]joingroup chat-id</b> --<code>افزوده شدن به گروه تحت مدیریتی ربات با شناسه گروه</code>
*<b>[/#!]settoken [token]</b> --<code>تنظیم توکن ربات</code>
*<b>[/#!]remtoken</b> --<code>حذف توکن ربات ثبت شده</code>
*<b>[/#!]gettokenbot</b> --<code>دریافت توکن ربات ثبت شده</code>
*<b>[/#!]setchannelusername @userchannel</b> --<code>تنظیم یوزرنیم کانال جهت عضویت اجباری</code>
*<b>[/#!]remchannelusername </b> --<code>حذف یوزرنیم ثبت شده کانال.</code>
*<b>[/#!]getchannelusername</b> --<code>دریافت یوزرنیم کانال ثبت شده</code>
]]
sendText(msg.chat_id, msg.id, text, 'html')
end
end
----------###################### START LOCKS ########################------------
 if text and is_Mod(msg) then
       local lock = text:match('^lock (.*)$') or text:match('^قفل (.*)$')
       local unlock = text:match('^unlock (.*)$') or text:match('^بازکردن (.*)$')
        if lock then
          settings(msg,lock,'lock')
        elseif unlock then
          settings(msg,unlock)
        end
		end
------------Chat Type------------
function check_markdown(text)
str = text
if str:match('_') then
output = str:gsub('_',[[\_]])
elseif str:match('*') then
output = str:gsub('*','\\*')
elseif str:match('`') then
output = str:gsub('`','\\`')
else
output = str
end
return output
end
----------###################### END LOCKS ########################------------         
if is_Fullsudo(msg) then
if text and text:match('^setsudo (%d+)') or text and text:match('^تنظیم سودو (%d+)') then
local sudo = text:match('^setsudo (%d+)') or text:match('^تنظیم سودو (%d+)')
redis:sadd('SUDO-ID',sudo)
sendText(msg.chat_id, msg.id, '> کاربر `'..sudo..'` *به لیست مالکان ربات افزوده گردید.*', 'md')
end
if text and text:match('^remsudo (%d+)') or text and text:match('^حذف سودو (%d+)') then
  local sudo = text:match('^remsudo (%d+)') or text:match('^حذف سودو (%d+)')
  redis:srem('SUDO-ID',sudo)
  sendText(msg.chat_id, msg.id, '> کاربر `'..sudo..'` *از لیست مالکان ربات حذف گردید.*', 'md')
end
if text == 'sudolist' or text == 'لیست سودو ها' then
local hash =  "SUDO-ID"
local list = redis:smembers(hash)
local t = '*> لیست مالکان ربات: *\n'
for k,v in pairs(list) do 
local user_info = redis:hgetall('user:'..v)
if user_info and user_info.username then
local username = user_info.username
t = t..k.." - @"..username.." ["..v.."]\n"
else
t = t..k.." - "..v.."\n"
end
end
if #list == 0 then
t = '*> لیست مالکان ربات خالی میباشد.*'
end
sendText(msg.chat_id, msg.id,t, 'md')
end
if is_supergroup(msg) then
if text == 'ids' or  text == 'شناسه گروه' then 
sendText(msg.chat_id,msg.id,'>شناسه گروه شما:\n'..msg.chat_id..'','md')
end
end
end
-------------------------------
if is_supergroup(msg) then
if is_Owner(msg) then
-------------------------------
--[[if not redis:get("charged:"..msg.chat_id) then
if redis:get('CheckBot:'..msg.chat_id) then -- more if
      local sudo = tonumber(Sendpayiduser)
	  local botid = tonumber(373082434)
	 local linkgroup = redis:get('Link:'..msg.chat_id)
	 local groupwarn_hash = 'groupwarn:'..msg.chat_id
        redis:incr(groupwarn_hash)
        local groupwarn_redis = redis:get(groupwarn_hash)
         if tonumber(groupwarn_redis) == 1 then
		--if redis:get("warncharge:"..msg.chat_id) then
--else
	 -- redis:setex("warncharge:"..msg.chat_id, 3600, true)
		 sendText(sudo,0,'>شارژ گروه به اتمام رسید.\n>مشخصات کامل گروه:\n__________________________\n>نام گروه:\n\n>شناسه گروه: '..msg.chat_id..'\n__________________________\n>لینک ورود به گروه: '..(linkgroup or 'لینک برای این گروه تنظیم نشده است')..'','html')
	 	sendText(msg.chat_id,msg.id,'🛑هشدار اول🛑\n<code>>مالک گرامی گروه;</code>\nشارژ گروه شما به اتمام رسید، روش تمدید شارژ گروه شما به خصوصی شما ارسال شد.\nاگر پیغامی از ربات دریافت نکردید ابتدا به خصوصی ربات یک پیغام ارسال کنید،سپس  بعد از گذشت [30] دقیقه مجدد پیغام به خصوصی شما ارسال میگردد.\nبا احترام، مدیریت ربات فراز❤️بوت','html')
	 local list = redis:smembers('OwnerList:'..msg.chat_id)
          for k,v in pairs(list) do
	  sendText(v,0,'مالک گرامی گروه;\nبا سلام\nاز اینکه لحظاتی در فعالیت شما با ربات [https://t.me/'..Botusernamelink..'] وقفه ایجاد گردید عذر خواسته و از توجه کامل شما به این پیام سپاسگزاریم.\nدر صورتی که در طی مدت فعالیت ربات فراز❤️بوت از خدمات ما راضی بوده اید، جهت تمدید سرویس خود میتوانید از طریق روش زیر اقدام کنید،\nهزینه تمدید سرویس خود(ربات فراز❤️بوت) بصورت ماهانه مبلغ 7000 تومان میباشد که میتوانید از روش زیر پرداخت خود را انجام دهید.\n '..Pardakht..' \n___________________________\nبه موارد زیر دقت کنید:\nدر هنگام پرداخت و در قسمت توضیحات کد زیر را بدون تغییر وارد کنید(وارد کردن - در کد اجباری نمیباشد):\n '..msg.chat_id..'\nپس از پرداخت هزینه ماهیانه ذکر شده شارژ گروه شما به صورت خودکار تمدید میگردد.\nبا تشکر','html')
	 -- end
	   end
	   end
				end --more end
				if tonumber(groupwarn_redis) == 2 then
				--if redis:get("warncharge:"..msg.chat_id) then
--else
	 -- redis:setex("warncharge:"..msg.chat_id, 3600, true)
				sendText(sudo,0,'>دریافت اخطار دوم برای تمدید شارژ گروه\n>شناسه گروه: '..msg.chat_id..'\n__________________________\n>لینک ورود به گروه: '..(linkgroup or 'لینک برای این گروه تنظیم نشده است')..'','html')
		sendText(msg.chat_id,msg.id,'🛑هشدار دوم🛑\n<code>>مالک گرامی گروه;</code>\nلطفا نسبت به تمدید شارژ گروه خود اقدام کنید،این پیغام به منزله آخرین هشدار ارسالی برای شما میباشد.در صورت عدم شارژ گروه خود ربات از گروه شما خارج میگردد.\nبا احترام، مدیریت ربات فراز❤️بوت','html')
	local list = redis:smembers('OwnerList:'..msg.chat_id)
          for k,v in pairs(list) do
	  sendText(v,0,'مالک گرامی گروه;\nبا سلام\nاز اینکه لحظاتی در فعالیت شما با ربات [https://t.me/'..Botusernamelink..'] وقفه ایجاد گردید عذر خواسته و از توجه کامل شما به این پیام سپاسگزاریم.\nدر صورتی که در طی مدت فعالیت ربات فراز❤️بوت از خدمات ما راضی بوده اید، جهت تمدید سرویس خود میتوانید از طریق روش زیر اقدام کنید،\nهزینه تمدید سرویس خود(ربات فراز❤️بوت) بصورت ماهانه مبلغ 7000 تومان میباشد که میتوانید از روش زیر پرداخت خود را انجام دهید.\n '..Pardakht..' \n___________________________\nبه موارد زیر دقت کنید:\nدر هنگام پرداخت و در قسمت توضیحات کد زیر را بدون تغییر وارد کنید(وارد کردن - در کد اجباری نمیباشد):\n '..msg.chat_id..'\nپس از پرداخت هزینه ماهیانه ذکر شده شارژ گروه شما به صورت خودکار تمدید میگردد.\nبا تشکر','html')
	 --end
	  end
	   end
	   if tonumber(groupwarn_redis) == 3 then
	--if redis:get("warncharge:"..msg.chat_id) then
--else
	 -- redis:setex("warncharge:"..msg.chat_id, 3600, true)
	   sendText(sudo,0,'>دریافت اخطار سوم برای تمدید شارژ گروه\n>شناسه گروه: '..msg.chat_id..'\n__________________________\n>لینک ورود به گروه: '..(linkgroup or 'لینک برای این گروه تنظیم نشده است')..'','html')
	sendText(msg.chat_id,msg.id,'🛑هشدار سوم🛑\n<code>>مالک گرامی گروه;</code>\nلطفا نسبت به تمدید شارژ گروه خود اقدام کنید،این پیغام به منزله آخرین هشدار ارسالی برای شما میباشد.در صورت عدم شارژ گروه خود ربات از گروه شما خارج میگردد.\n\nبا احترام، مدیریت ربات فراز❤️بوت','html')
	local list = redis:smembers('OwnerList:'..msg.chat_id)
          for k,v in pairs(list) do
	  sendText(v,0,'مالک گرامی گروه;\nبا سلام\nاز اینکه لحظاتی در فعالیت شما با ربات [https://t.me/'..Botusernamelink..'] وقفه ایجاد گردید عذر خواسته و از توجه کامل شما به این پیام سپاسگزاریم.\nدر صورتی که در طی مدت فعالیت ربات فراز❤️بوت از خدمات ما راضی بوده اید، جهت تمدید سرویس خود میتوانید از طریق روش زیر اقدام کنید،\nهزینه تمدید سرویس خود(ربات فراز❤️بوت) بصورت ماهانه مبلغ 7000 تومان میباشد که میتوانید از روش زیر پرداخت خود را انجام دهید.\n '..Pardakht..' \n___________________________\nبه موارد زیر دقت کنید:\nدر هنگام پرداخت و در قسمت توضیحات کد زیر را بدون تغییر وارد کنید(وارد کردن - در کد اجباری نمیباشد):\n '..msg.chat_id..'\nپس از پرداخت هزینه ماهیانه ذکر شده شارژ گروه شما به صورت خودکار تمدید میگردد.\nبا تشکر','html')
	  -- end
	   end
	   end
	   if tonumber(groupwarn_redis) == 4 then
	  --if redis:get("warncharge:"..msg.chat_id) then
--else
	 -- redis:setex("warncharge:"..msg.chat_id, 3600, true)
	    redis:del('groupwarn:'..msg.chat_id)
		sendText(sudo,0,'>به دلیل عدم تمدید و دریافت اخطار سوم تمدید شارژ ربات از گروه مورد نظر خارج شد.\n>شناسه گروه: '..msg.chat_id..'\n__________________________\n>لینک ورود به گروه: '..(linkgroup or 'لینک برای این گروه تنظیم نشده است')..'','html')
	sendText(msg.chat_id,msg.id,'<code>>مالک گرامی گروه;</code>\nبه دلیل عدم تمدید شارژ گروه خود، ربات از گروه شما خارج میگردد.\nبا تشکر ، واحد پشتیبانی ربات فراز❤️بوت','html')
	Left(msg.chat_id,TD_ID, "Left")
	 -- end
	   end
	   end]]
	   if not redis:get("charged:"..msg.chat_id) then
	   if redis:get('CheckBot:'..msg.chat_id) then 
		local sudo = tonumber(Sendpayiduser)
		 local linkgroup = redis:get('Link:'..msg.chat_id)
	   if redis:get("fincharge:"..msg.chat_id) then
	  else
	  redis:setex("fincharge:"..msg.chat_id, 1800, true)
	  redis:srem("groupuserss",msg.chat_id)
		 sendText(sudo,0,'>شارژ گروه به اتمام رسید.\n>مشخصات کامل گروه:\n__________________________\n>نام گروه:\n\n>شناسه گروه: '..msg.chat_id..'\n__________________________\n>لینک ورود به گروه: '..(linkgroup or 'لینک برای این گروه تنظیم نشده است')..'','html')
	 	sendText(msg.chat_id,msg.id,'🛑هشدار اول🛑\n<code>>مالک گرامی گروه;</code>\nشارژ گروه شما به اتمام رسید، روش تمدید شارژ گروه شما به خصوصی شما ارسال شد.\nاگر پیغامی از ربات دریافت نکردید ابتدا به خصوصی ربات یک پیغام ارسال کنید،سپس  بعد از گذشت [30] دقیقه مجدد پیغام به خصوصی شما ارسال میگردد.\nبا احترام، مدیریت ربات فراز❤️بوت','html')
		  local list = redis:smembers('OwnerList:'..msg.chat_id)
          for k,v in pairs(list) do
	  sendText(v,0,'مالک گرامی گروه;\nبا سلام\nاز اینکه لحظاتی در فعالیت شما با ربات [https://t.me/'..Botusernamelink..'] وقفه ایجاد گردید عذر خواسته و از توجه کامل شما به این پیام سپاسگزاریم.\nدر صورتی که در طی مدت فعالیت ربات فراز❤️بوت از خدمات ما راضی بوده اید، جهت تمدید سرویس خود میتوانید از طریق روش زیر اقدام کنید،\nهزینه تمدید سرویس خود(ربات فراز❤️بوت) بصورت ماهانه مبلغ 7000 تومان میباشد که میتوانید از روش زیر پرداخت خود را انجام دهید.\n '..Pardakht..' \n___________________________\nبه موارد زیر دقت کنید:\nدر هنگام پرداخت و در قسمت توضیحات کد زیر را بدون تغییر وارد کنید(وارد کردن - در کد اجباری نمیباشد):\n '..msg.chat_id..'\nپس از پرداخت هزینه ماهیانه ذکر شده شارژ گروه شما به صورت خودکار تمدید میگردد.\nبا تشکر','html')
	   end
	   end
	   end
		end
		-----------------------------------------------------------
		if text == 'allowed' or text == 'مجاز' then
 function PromoteByReply(FreemanagerBOT,result)
 redis:sadd('allowedusers:'..msg.chat_id,result.sender_user_id)
 local user = result.sender_user_id
sendText(msg.chat_id, msg.id, '> کاربر [`'..(user)..'`] به لیست کاربران مجاز اضاف گردید.','md')
end
if tonumber(msg.reply_to_message_id_) == 0 then
else
getMessage(msg.chat_id, tonumber(msg.reply_to_message_id), PromoteByReply)  
end
end
if text and text:match('^allowed (%d+)') or text and text:match('^مجاز (%d+)') then
local user = text:match('allowed (%d+)') or text:match('^مجاز (%d+)')
redis:sadd('allowedusers:'..msg.chat_id,user)
sendText(msg.chat_id, msg.id, '> کاربر [`'..user..'`] به لیست کاربران مجاز اضاف گردید.', 'md')
end
if text and text:match('^allowed @(.*)') or text and text:match('^مجاز @(.*)') then
local username = text:match('^allowed @(.*)') or text:match('^مجاز @(.*)')
function PromoteByUsername(FreemanagerBOT,result)
if result.id then
print(''..result.id..'')
redis:sadd('allowedusers:'..msg.chat_id,result.id)
text = '> کاربر [`'..result.id..'`] به لیست کاربران مجاز اضاف گردید.'
else 
text = '`کاربر مورد نظر یافت نشد!`\nابتدا از صحت وجود یوزرنیم یا شناسه کاربری اطمینان حاصل کنید،سپس مجدد اقدام کنید.'
end
sendText(msg.chat_id, msg.id, text, 'md')
end
resolve_username(username,PromoteByUsername)
end
if text == 'notallowed' or text == 'غیرمجاز' then
function DemoteByReply(FreemanagerBOT,result)
if tonumber(result.sender_user_id) == tonumber(TD_ID) then
sendText(msg.chat_id, msg.id,  '> خطا!\nشما دسترسی لازم برای محدود سازی سایر مالکان/مدیران را ندارید.', 'md')
return false
end
if tonumber(result.sender_user_id) == tonumber(SUDO_ID) then
sendText(msg.chat_id, msg.id,  '> خطا!\nشما دسترسی لازم برای محدود سازی سایر مالکان/مدیران را ندارید.', 'md')
return false
end
if private(msg.chat_id,result.sender_user_id) then
sendText(msg.chat_id, msg.id, "> خطا!\nشما دسترسی لازم برای محدود سازی سایر مالکان/مدیران را ندارید.", 'md')
else
redis:srem('allowedusers:'..msg.chat_id,result.sender_user_id)
sendText(msg.chat_id, msg.id, '> کاربر [`'..(result.sender_user_id)..'`] از لیست کاربران مجاز حذف گردید.', 'md')
end
end
if tonumber(msg.reply_to_message_id) == 0 then
else
getMessage(msg.chat_id, tonumber(msg.reply_to_message_id),DemoteByReply)  
end
end
if text and text:match('^notallowed (%d+)') or text and text:match('^غیرمجاز (%d+)') then
local user = text:match('notallowed (%d+)') or text:match('^غیرمجاز (%d+)')
if tonumber(user) == tonumber(SUDO_ID) then
sendText(msg.chat_id, msg.id,  '> خطا!\nشما دسترسی لازم برای محدود سازی سایر مالکان/مدیران را ندارید.', 'md')
return false
end
redis:srem('allowedusers:'..msg.chat_id,user)
sendText(msg.chat_id, msg.id, '> کاربر [`'..user..'`] از لیست کاربران مجاز حذف گردید.', 'md')
end
if text and text:match('^notallowed @(.*)') or text and text:match('^غیرمجاز @(.*)') then
local username = text:match('^notallowed @(.*)') or text:match('^غیرمجاز @(.*)')
if tonumber(result.id) == tonumber(SUDO_ID) then
sendText(msg.chat_id, msg.id,  '> خطا!\nشما دسترسی لازم برای محدود سازی سایر مالکان/مدیران را ندارید.', 'md')
return false
end
function DemoteByUsername(FreemanagerBOT,result)
if result.id then
print(''..result.id..'')
redis:srem('allowedusers:'..msg.chat_id,result.id)
text = '> کاربر [`'..result.id..'`] از لیست کاربران مجاز حذف گردید.'
else 
text = '`کاربر مورد نظر یافت نشد!`\nابتدا از صحت وجود یوزرنیم یا شناسه کاربری اطمینان حاصل کنید،سپس مجدد اقدام کنید.'
end
sendText(msg.chat_id, msg.id, text, 'md')
end
resolve_username(username,DemoteByUsername)
end
  if text == 'delete allowedlist' or text == 'حذف لیست مجاز'  then
redis:del('allowedusers:'..msg.chat_id)
sendText(msg.chat_id, msg.id,  '<code>>لیست کاربران مجاز با موفقیت بازنشانی گردید.</code>', 'html')
end
-------------------------------------------------------------------------
 if text == 'modset' or text == 'ترفیع' then
 function PromoteByReply(FreeManagerBOT,result)
 redis:sadd('ModList:'..msg.chat_id,result.sender_user_id)
 local user = result.sender_user_id
sendText(msg.chat_id, msg.id, '> کاربر [`'..(user)..'`] به مقام مدیریت گروه ارتقاء یافت.','md')
end
if tonumber(msg.reply_to_message_id_) == 0 then
else
getMessage(msg.chat_id, tonumber(msg.reply_to_message_id), PromoteByReply)  
end
end
if text and text:match('^modset @(.*)') or text and text:match('^ترفیع @(.*)') then
local username = text:match('^modset @(.*)') or text:match('^ترفیع @(.*)')
function PromoteByUsername(FreeManagerBOT,result)
if result.id then
print(''..result.id..'')
redis:sadd('ModList:'..msg.chat_id,result.id)
text = '> کاربر [`'..result.id..'`] به مقام مدیریت گروه ارتقاء یافت.'
else 
text = '`کاربر مورد نظر یافت نشد!`\nابتدا از صحت وجود یوزرنیم یا شناسه کاربری اطمینان حاصل کنید،سپس مجدد اقدام کنید.'
end
sendText(msg.chat_id, msg.id, text, 'md')
end
resolve_username(username,PromoteByUsername)
end
if text and text:match('^modset (%d+)') or text and text:match('^ترفیع (%d+)') then
local user = text:match('modset (%d+)') or text:match('ترفیع (%d+)')
redis:sadd('ModList:'..msg.chat_id,user)
sendText(msg.chat_id, msg.id, '> کاربر [`'..user..'`] به مقام مدیریت گروه ارتقاء یافت.', 'md')
end
if text == 'moddem' or text == 'عزل'then
function DemoteByReply(FreeManagerBOT,result)
redis:srem('ModList:'..msg.chat_id,result.sender_user_id)
sendText(msg.chat_id, msg.id, '> کاربر [`'..(result.sender_user_id)..'`] از مقام مدیریت گروه عزل گردید.', 'md')
end
if tonumber(msg.reply_to_message_id) == 0 then
else
getMessage(msg.chat_id, tonumber(msg.reply_to_message_id),DemoteByReply)  
end
end
if text and text:match('^moddem @(.*)') or text and text:match('^عزل @(.*)')then
local username = text:match('^moddem @(.*)') or text:match('^عزل @(.*)')
function DemoteByUsername(FreeManagerBOT,result)
if result.id then
print(''..result.id..'')
redis:srem('ModList:'..msg.chat_id,result.id)
text = '> کاربر [`'..result.id..'`] از مقام مدیریت گروه عزل گردید.'
else 
text = '`کاربر مورد نظر یافت نشد!`\nابتدا از صحت وجود یوزرنیم یا شناسه کاربری اطمینان حاصل کنید،سپس مجدد اقدام کنید.'
end
sendText(msg.chat_id, msg.id, text, 'md')
end
resolve_username(username,DemoteByUsername)
end
if text and text:match('^moddem (%d+)') or text and text:match('^عزل (%d+)') then
local user = text:match('moddem (%d+)') or text:match('^عزل (%d+)')
redis:srem('ModList:'..msg.chat_id,user)
sendText(msg.chat_id, msg.id, '> کاربر [`'..user..'`] از مقام مدیریت گروه عزل گردید.', 'md')
end
-------------------------------------------------------------------------
if text == 'delete managers' or text == 'حذف لیست مدیران' then
redis:del('ModList:'..msg.chat_id)
sendText(msg.chat_id, msg.id,  '<code>>لیست مدیران گروه با موفقیت بازنشانی شد</code>', 'html')
end
---------------------------------------------------
	if text == 'exlink' or text == 'ساخت لینک گروه'  then
			 local url , res = https.request('https://api.telegram.org/bot'..TokenApibot..'/exportChatInviteLink?chat_id='..msg.chat_id)
if res ~= 200 then
end
local jdat = json:decode(url)
if jdat.result then
 sendText(msg.chat_id, msg.id,  '<code>>لینک جدید برای گروه شما ساخته شد:</code>\n '..(jdat.result or '---')..'', 'html')
 else
 sendText(msg.chat_id, msg.id,  '> برای استفاده از این قابلیت باید ربات [@NewFarazBot2bot] را به گروه خود افزوده کنید و دسترسی ادمین به آن بدهید.\nسپس مجدد دستور خود را ارسال کنید.', 'html')
      end
	  end
	 if text == 'help' or text == 'راهنما' then
text =[[
<code>>راهنمای مالکین گروه(اصلی-فرعی)--حالت دستی</code>

*<b>[/#!]panel</b> --<code>دریافت تنظیمات گروه(inline)</code>
*<b>[/#!]panel pv</b> --<code>دریافت تنظیمات گروه(inline) در خصوصی</code>
*<b>[/#!]setrules</b> --<code>تنظیم قوانین گروه</code>
*<b>[/#!]modset</b> @username|reply|user-id --<code>تنظیم مالک فرعی جدید برای گروه با یوزرنیم|ریپلی|شناسه -فرد</code>
*<b>[/#!]moddem</b> @username|reply|user-id --<code>حذف مالک فرعی از گروه با یوزرنیم|ریپلی|شناسه -فرد</code>
*<b>[/#!]allowed</b> @username|reply|user-id —-<code>تنظیم کاربر لیست مجاز جدید برای گروه با یوزرنیم|ریپلی|شناسه -فرد</code>
*<b>[/#!]notallowed</b> @username|reply|user-id —-<code>حذف کاربر لیست مجاز جدید برای گروه با یوزرنیم|ریپلی|شناسه -فرد</code>
*<b>[/#!]managers</b> --<code>دریافت لیست مدیران فرعی گروه</code>
*<b>[/#!]allowedlist</b> --<code>دریافت لیست کاربران مجاز گروه</code>
*<b>[/#!]setlink</b> <code>link</code> <code>{لینک-گروه} --تنظیم لینک گروه</code>
*<b>[/#!]link</b> <code>دریافت لینک گروه</code>
*<b>[/#!]exlink</b> دریافت و ساخت لینک جدید گروه(برای استفاده از این قابلیت ربات @APIsecurityBOT باید در گروه ادمین باشد)
*<b>[/#!]kick</b> @username|reply|user-id <code>اخراج کاربر با ریپلی|یوزرنیم|شناسه</code>
<b>-------------------------------</b>
<code>>راهنمای بخش حذف ها</code> 
*<b>[/#!]delete managers</b> <code>{حذف تمامی مدیران فرعی تنظیم شده برای گروه}</code>
*<b>[/#!]delete allowedlist</b> <code>{حذف لیست کاربران مجاز گروه}</code>
*<b>[/#!]delete welcome</b> <code>{حذف پیغام خوش آمدگویی تنظیم شده برای گروه}</code>
*<b>[/#!]delete bots</b> <code>{حذف تمامی ربات های موجود در ابرگروه}</code>
*<b>[/#!]delete silentlist</b> <code>{حذف لیست سکوت کاربران}</code>
*<b>[/#!]delete filterlist</b> <code>{حذف لیست کلمات فیلتر شده در گروه}</code>
*<b>[/#!]delete restricts</b> <code>{حذف لیست افراد محدود شده در گروه(تنظیمات تلگرام)}</code>
<b>-------------------------------</b>
<code>>راهنمای بخش خوش آمدگویی</code>
*<b>[/#!]welcome on</b> --<code>(فعال کردن پیغام خوش آمدگویی در گروه)</code>
*<b>[/#!]welcome off</b> --<code>(غیرفعال کردن پیغام خوش آمدگویی در گروه)</code>
*<b>[/#!]setwelcome text</b> --<code>(تنظیم پیغام خوش آمدگویی جدید در گروه)</code>
<b>-------------------------------</b>
<code>>راهنمای بخش اخطار کاربران</code>
*[/#!]warn userid|reply --<code>(اخطار دادن به فرد با ریپلی|شناسه کاربر)</code>
*[/#!]unwarn userid|reply --<code>(حذف اخطار فرد با ریپلی|شناسه گروه)</code>
*[/#!]setwarnmax number --<code>(تنظیم حداکثر اخطار مجاز برای کاربران)</code>
*[/#!]warnlist --<code>(نمایش لیست اخطار های کاربران)</code>
<b>-------------------------------</b>
<code>>راهنمای بخش فیلترگروه</code>
*<b>[/#!]mutechat</b> --<code>فعال کردن فیلتر تمامی گفتگو ها</code> 
*<b>[/#!]mutechat stats</b> --<code>مشاهده زمان باقی مانده برای رفع فیلتر تمامی گفتگو ها</code>
*<b>[/#!]unmutechat</b> --<code>غیرفعال کردن فیلتر تمامی گفتگو ها</code>
*<b>[/#!]mutechat number(h|m|s)</b> --<code>فیلتر تمامی گفتگو ها بر حسب زمان[ساعت|دقیقه|ثانیه] با محدودیت کاربران</code>
*<b>[/#!]nomutechat number(h|m|s)</b> --<code>فیلتر تمامی گفتگو ها بر حسب زمان[ساعت|دقیقه|ثانیه] بدون محدودیت کاربران</code>
<b>-------------------------------</b>
<code>>راهنمای دستورات حالت سکوت کاربران</code>
*<b>[/#!]silentuser</b> @username|reply|user-id <code>--افزودن کاربر به لیست سکوت با یوزرنیم|ریپلی|شناسه -فرد</code>
*<b>[/#!]unsilentuser</b> @username|reply|user-id <code>--افزودن کاربر به لیست سکوت با یوزرنیم|ریپلی|شناسه -فرد</code>
*<b>[/#!]silentlist</b> <code>--دریافت لیست کاربران حالت سکوت</code>
<b>-------------------------------</b>
<code>>راهنمای بخش فیلتر-کلمات</code>
*<b>[/#!]filter word</b> <code>--افزودن عبارت جدید به لیست کلمات فیلتر شده</code>
*<b>[/#!]unfilter word</b> <code>--حذف عبارت جدید از لیست کلمات فیلتر شده</code>
*<b>[/#!]filterlist</b> <code>--دریافت لیست کلمات فیلتر شده</code>
<b>-------------------------------</b>
<code>>راهنمای بخش حذف پیغام</code>
*<b>[/#!]rmsg [number]</b> <code>حذف پیام های اخیر گروه</code>
*<b>[/#!]rempms</b> <code>--کاهش حجم پیغام های گروه تا حد ممکن</code>
<b>-------------------------------</b>
<code>>راهنمای بخش تنظیم پیغام مکرر</code>
*<b>[/#!]setfloodmsg number</b> --<code>تنظیم حساسیت نسبت به ارسال پیام مکرر</code>
*<b>[/#!]setfloodtime</b> --<code>تنظیم حساسیت نسبت به ارسال پیام مکرر برحسب زمان</code>
<b>-------------------------------</b>
<code>>راهنمای بخش اضافه</code>
*<b>[/#!]delete blocklist</b> --<code>حذف کاربران موجود در لیست سیاه گروه</code>
*<b>[/#!]delete deleted</b> --<code>حذف کاربران حذف حساب کاربری شده از گروه</code>
*<b>[/#!]id</b> --<code>دیافت اطلاعات خود و گروه</code>
*<b>[/#!]groupinfo</b> --<code>دریافت اطلاعات گروه</code>
*<b>[/#!]about me</b> --<code>دریافت اطلاعات مشترک خود</code>
*<b>[/#!]me</b> --<code>دریافت اطلاعات خود</code>
*<b>[/#!]bot</b> --<code>تست بررسی فعال بودن ربات</code>
]]
sendText(msg.chat_id, msg.id, text, 'html')
end
		-----------------------------------------------------------
if text == 'addadmins' or text == 'ترفیع ادمین ها' then
if not limit or limit > 200 then
    limit = 200
  end  
local function GetMod(extra,result,success)
local c = result.members
for i=0 , #c do
redis:sadd('ModList:'..msg.chat_id,c[i].user_id)
end
sendText(msg.chat_id,msg.id,"<code>>تمامی ادمین های گروه به لیست مدیران فرعی ربات افزوده گردیدند.</code>", "html")
end
getChannelMembers(msg.chat_id,'Administrators',0,limit,GetMod)
end
if text == 'delete members' or text == 'حذف کاربران' then 
    function CleanMembers(FreemanagerBOT, result) 
    for k, v in pairs(result.members) do 
 if tonumber(v.user_id) == tonumber(TD_ID)  then
    return true
    end
KickUser(msg.chat_id,v.user_id)
end
end
getChannelMembers(msg.chat_id,"Recent",0, 2000000,CleanMembers)
sendText(msg.chat_id, msg.id,'<code>>تمامی عضو های گروه اخراج گردیدند.</code>', 'md') 
end 
end  
end
----
if is_Mod(msg) then
if is_supergroup(msg) then
---------------------------------
      local function getsettings(value)
        if value == 'muteall' then
        local hash = redis:set('MuteAll:'..msg.chat_id)
        if hash then
         return '<code>فعال</code>'
          else
          return '<code>غیرفعال</code>'
          end
        elseif value == 'welcome' then
        local hash = redis:get('Welcome:'..msg.chat_id)
        if hash == 'on' then
         return '<code>فعال</code>'
          else
          return '<code>غیرفعال</code>'
          end
        elseif value == 'spam' then
		local hash = redis:hget("flooding:settings:"..msg.chat_id,"flood")
        if hash then
			 if redis:hget("flooding:settings:"..msg.chat_id, "flood") == "kick" then
         return '<code>User-kick</code>'
			  elseif redis:hget("flooding:settings:"..msg.chat_id,"flood") == "ban" then
              return '<code>User-ban</code>'
							elseif redis:hget("flooding:settings:"..msg.chat_id,"flood") == "mute" then
              return '<code>Mute</code>'
              end
          else
          return '<code>مجاز</code>'
          end
        elseif is_lock(msg,value) then
          return '<code>غیرمجاز</code>'
          else
          return '<code>مجاز</code>'
          end
        end
		--------------------------------------
		if text == 'bot' or text == 'ربات' then
txts = [[ربات فعال است.
]]
sendText(msg.chat_id, msg.id, txts, 'md')
end
		-----------------------------------------------------
		if text == 'mutechat' or text == 'قفل گفتگو ها' then
redis:set('MuteAll:'..msg.chat_id,true)
sendText(msg.chat_id, msg.id,'<code>فیلتر تمامی گفتگو ها فعال گردید!</code>' ,'html')
end
if text and text:match('^mutechat (%d+)[mhs]') or text and text:match('^قفل گفتگو ها (%d+) [mhs]') then
          local matches = text:match('^mutechat (.*)') or text:match('^قفل گفتگو ها (.*)')
          if matches:match('(%d+)h') then
          time_match = matches:match('(%d+)h')
          time = time_match * 3600
          end
          if matches:match('(%d+)s') then
          time_match = matches:match('(%d+)s')
          time = time_match
          end
          if matches:match('(%d+)m') then
          time_match = matches:match('(%d+)m')
          time = time_match * 60
          end
          local hash = 'MuteAll:'..msg.chat_id
          redis:setex(hash, tonumber(time), true)
		  sendText(msg.chat_id, msg.id,'<code>>فیلتر تمامی گفتگو ها برای مدت زمان</code> [<b>'..time..'</b>] <code>ثانیه فعال گردید.</code>' ,'html')
          end
		  if text and text:match('^nomutechat (%d+)[mhs]') or text and text:match('^قفل گفتگو ها بدون محدودیت کاربران (%d+) [mhs]') then
          local matches = text:match('^nomutechat (.*)') or text:match('^قفل گفتگو ها بدون محدودیت کاربران (.*)')
          if matches:match('(%d+)h') then
          time_match = matches:match('(%d+)h')
          time = time_match * 3600
          end
          if matches:match('(%d+)s') then
          time_match = matches:match('(%d+)s')
          time = time_match
          end
          if matches:match('(%d+)m') then
          time_match = matches:match('(%d+)m')
          time = time_match * 60
          end
          local hash = 'MuteAlllimit:'..msg.chat_id
          redis:setex(hash, tonumber(time), true)
		  sendText(msg.chat_id, msg.id,'<code>>فیلتر تمامی گفتگو ها بدون محدودیت کاربران برای مدت زمان</code> [<b>'..time..'</b>] <code>ثانیه فعال گردید.</code>\n<code>پس از پایان مدت زمان تنظیم شده گروه به طور خودکار از حالت فیلتر خارج میگردد و نیاز به غیرفعال سازی به طور دستی نیست!</code>' ,'html')
          end
if text and text:match('^mutechat (%d+) (%d+) (%d+)')  then
			local matches = {
        text:match("^mutechat (%d+) (%d+) (%d+)") 
      }
               local hour = string.gsub(matches[1], "h", "")
                local num1 = tonumber(hour) * 3600
                local minutes = string.gsub(matches[2], "m", "")
                local num2 = tonumber(minutes) * 60
                local second = string.gsub(matches[3], "s", "")
                local num3 = tonumber(second)
                local num4 = tonumber(num1 + num2 + num3)
				local hash = 'MuteAll:'..msg.chat_id
          redis:setex(hash, num4, true)
		  sendText(msg.chat_id, msg.id,'*<code>فیلتر تمامی گفتگو ها برای مدت زمان</code>\n>[<b>'..matches[1]..'</b>]{ساعت}\n>[<b>'..matches[2]..'</b>]{دقیقه}\n>[<b>'..matches[3]..'</b>]{ثانیه}\n <code>فعال گردید</code>\n------------\n<code>پس از پایان مدت زمان تنظیم شده گروه به طور خودکار از حالت فیلتر خارج میگردد و نیاز به غیرفعال سازی به طور دستی نیست!</code>' ,'html')
              end
			  if text == 'mutechat stats' or text == 'آمار قفل گفتگو ها' then
		  local time = redis:ttl('MuteAll:'..msg.chat_id)
local days = math.floor(time / 86400)
time = time - days * 86400
local hour = math.floor(time /3600)
time = time - hour * 3600
local minute = math.floor(time / 60)
time = time - minute * 60
sec = time
          if tonumber(time) < 0 then
          sendText(msg.chat_id, msg.id,'<code>فیتلر تمامی گفتگو ها غیرفعال میباشد.</code>' ,'html')
            else
          t = '<code>>تا غیرفعال شدن فیلتر تمامی گفتگو ها</code> [<b>'..hour..'</b>] <code>ساعت و</code>  [<b>'..minute..'</b>] <code>و دقیقه</code> [<b>'..sec..'</b>] <code>ثانیه دیگر باقی مانده است.</code>'
          sendText(msg.chat_id, msg.id,t ,'html')
          end
          end
if text == 'unmutechat' or text == 'بازکردن گفتگو ها' then
redis:del('MuteAll:'..msg.chat_id)
redis:del('MuteAlllimit:'..msg.chat_id)
local mutes =  redis:smembers('Mutes:'..msg.chat_id)
for k,v in pairs(mutes) do
redis:srem('MuteList:'..msg.chat_id,v)
mute(msg.chat_id,v,'Restricted',   {1, 1, 1, 1, 1,1})
end
sendText(msg.chat_id, msg.id,'<code>فیلتر تمامی گفتگو ها غیرفعال گردید!</code>' ,'html')
end
		-----------------------------------------------------
		if text and text:lower() == 'panel' or text and text:lower() == 'add' or text and text:lower() == 'help' or text and text:lower() == 'setme' and not is_Mod(msg) then
	  local apisec = tonumber(501559602)
	    addChatMembers(msg.chat_id,{[0] = 501559602})
		end
        ---------------------------------------------------
	   if text and text:match('^panel$') or text and text:match('^پنل$') and redis:get("charged:"..msg.chat_id) then
function GetPanel(FreeManagerBOT,result)
if result.results and result.results[0] then
sendInline(msg.chat_id,msg.id, 0, 1, result.inline_query_id,result.results[0].id)
else
sendText(msg.chat_id, msg.id, '> مشکل در برقراری ارتباط پیش آمد.\nمجدد دستور خود را ارسال نمایید.\nدر صورت عدم پاسخدهی ، مشکل را با مالک ربات در میان بگذارید.','md')
end
end
getinline(apipanelbotuserid, msg.chat_id, 0, 0, msg.chat_id,0, GetPanel)
end
if text and text:match('^panel pv$') or text and text:match('^پنل خصوصی$') and redis:get("charged:"..msg.chat_id) then
function GetPanel(FreeManagerBOT,result)
if result.results and result.results[0] then
sendInline(msg.sender_user_id,0, 0, 1, result.inline_query_id,result.results[0].id)
  sendText(msg.chat_id, msg.id, '<code>>پنل کاربری گروه به خصوصی شما ارسال گردید.</code>\nدر صورتی که پنل کاربری را دریافت نکردید،ابتدا یک پیغام به خصوصی ربات ارسال کنید،سپس مجدد دستور خود را ارسال کنید.', 'html')
else
sendText(msg.chat_id, msg.id, '> مشکل در برقراری ارتباط پیش آمد.\nدر صورت عدم پاسخدهی ، مشکل را با مالک ربات در میان بگذارید.','md')
end
end
getinline(apipanelbotuserid, msg.chat_id, 0, 0, msg.chat_id,0, GetPanel)
end
	   ---------------------------------------------------
	   if text and text:match('panel') and not redis:get("charged:"..msg.chat_id) then
	sendText(msg.chat_id, msg.id, '<code>>مالک،مدیر گرامی، </code>\nمتاسفانه به دلیل به اتمام رسیدن شارژ گروه شما دسترسی برای تغییر تنظیمات گروه را ندارید.\nابتدا شارژ گروه خود را تمدید کنید سپس مجدد سعی کنید.\nبا احترام ، مدیریت ربات فراز❤️بوت', 'html')
	local list = redis:smembers('OwnerList:'..msg.chat_id)
          for k,v in pairs(list) do
	  sendText(v,0,'مالک گرامی گروه;\nبا سلام\nاز اینکه لحظاتی در فعالیت شما با ربات [https://t.me/'..Botusernamelink..'] وقفه ایجاد گردید عذر خواسته و از توجه کامل شما به این پیام سپاسگزاریم.\nدر صورتی که در طی مدت فعالیت ربات فراز❤️بوت از خدمات ما راضی بوده اید، جهت تمدید سرویس خود میتوانید از طریق روش زیر اقدام کنید،\nهزینه تمدید سرویس خود(ربات فراز❤️بوت) بصورت ماهانه مبلغ 7000 تومان میباشد که میتوانید از روش زیر پرداخت خود را انجام دهید.\n '..Pardakht..' \n___________________________\nبه موارد زیر دقت کنید:\nدر هنگام پرداخت و در قسمت توضیحات کد زیر را بدون تغییر وارد کنید(وارد کردن - در کد اجباری نمیباشد):\n '..msg.chat_id..'\nپس از پرداخت هزینه ماهیانه ذکر شده شارژ گروه شما به صورت خودکار تمدید میگردد.\nبا تشکر','html')
	end
	end
	   ----------------------------------------
-----------Delete All-------------
if text == 'delall' then
function DelallByReply(FreemanagerBOT,result)
if tonumber(result.sender_user_id) == tonumber(TD_ID) then
sendText(msg.chat_id, msg.id, "خطا!", 'md')
return false
end
if private(msg.chat_id,result.sender_user_id) then
print '                     Private                          '
sendText(msg.chat_id, msg.id, "خطا!", 'md')
else
sendText(msg.chat_id, msg.id, '> تمام پیغام های کاربر  `'..(result.sender_user_id)..'` حذف گردید.', 'md')
deleteMessagesFromUser(msg.chat_id,result.sender_user_id) 
end
end
if tonumber(msg.reply_to_message_id) == 0 then
else
getMessage(msg.chat_id, tonumber(msg.reply_to_message_id),DelallByReply)  
end
end
if text and text:match('^delall @(.*)') then
local username = text:match('^delall @(.*)')
function DelallByUsername(FreemanagerBOT,result)
if tonumber(result.id) == tonumber(TD_ID) then
  sendText(msg.chat_id, msg.id, "خطا!", "md")
return false
    end
  if private(msg.chat_id,result.id) then
print '                     Private                          '
sendText(msg.chat_id, msg.id, "خطا!", "md")
else
if result.id then
text= '> تمام پیغام های کاربر  `'..result.id..'` حذف گردید.'
deleteMessagesFromUser(msg.chat_id,result.id) 
else 
text = '`کاربر مورد نظر یافت نشد!`\nابتدا از صحت وجود یوزرنیم یا شناسه کاربری اطمینان حاصل کنید،سپس مجدد اقدام کنید.'
end
sendText(msg.chat_id, msg.id, text, 'md')
end
end
resolve_username(username,DelallByUsername)
end
if text and text:match('^delall (%d+)') then
local user_id = text:match('^delall (%d+)')
if tonumber(user_id) == tonumber(TD_ID) then
  sendText(msg.chat_id, msg.id, "خطا!", "md")
return false
    end
  if private(msg.chat_id,user_id) then
print '                      Private                          '
sendText(msg.chat_id, msg.id, "خطا!", "md")   
else
text= '> تمام پیغام های کاربر  `'..user_id..'` حذف گردید.'
deleteMessagesFromUser(msg.chat_id,user_id) 
sendText(msg.chat_id, msg.id, text, 'md')
end
end
if tonumber(msg.reply_to_message_id) > 0 then
    if text == "del" or  text == "حذف" then
	deleteMessages(msg.chat_id, {[0] = tonumber(msg.reply_to_message_id)})
		deleteMessages(msg.chat_id, {[0] = msg.id})
    end
        end
---------------------------------
if text == 'banlist' or text == 'لیست مسدود' then
local list = redis:smembers('BanUser:'..msg.chat_id)
local t = '<code>>لیست افراد مسدود شده از گروه:</code> \n\n'
for k,v in pairs(list) do
t = t..k.." - *"..v.."*\n" 
end
t = t.."\n`>برای مشاهده کاربر از دستور زیر استفاده کنید`\n*/whois* `[شناسه کاربر]`"
if #list == 0 then
t = '<code>>لیست افراد مسدود شده از گروه خالی میباشد.</code>'
end
sendText(msg.chat_id, msg.id,t, 'html')
end
  if text == 'delete banlist' or text == 'حذف لیست مسدود ها' then
local function Clean(FreemanagerBOT,result)
redis:del('BanUser:'..msg.chat_id)
end
sendText(msg.chat_id, msg.id,  '<code>>لیست کاربران مسدود شده از گروه با موفقیت بازنشانی گردید.</code>', 'html')
getChannelMembers(msg.chat_id, "Banned", 0, 100000000000,Clean)
end
if text == 'managers' or text == 'لیست مدیران' then
local list = redis:smembers('ModList:'..msg.chat_id)
local t = '`>لیست مدیران گروه:`\n\n'
for k,v in pairs(list) do
t = t..k.." - *"..v.."*\n" 
end
t = t.."\n`>برای مشاهده کاربر از دستور زیر استفاده کنید`\n*/whois* `[شناسه کاربر]`"
if #list == 0 then
t = '`>مدیریت برای این گروه ثبت نشده است.`'
end
sendText(msg.chat_id, msg.id,t, 'md')
end
if text == 'allowedlist' or text == 'لیست مجاز' then
local list = redis:smembers('allowedusers:'..msg.chat_id)
local t = '<code>>لیست کاربران مجاز گروه:</code>\n\n'
for k,v in pairs(list) do
t = t..k.." - <b>"..v.."</b>\n" 
end
t = t.."\n`>برای مشاهده کاربر از دستور زیر استفاده کنید`\n*/whois* `[شناسه کاربر]`"
if #list == 0 then
t = '<code>>لیست کاربران مجاز گروه خالی میباشد.</code>'
end
sendText(msg.chat_id, msg.id,t, 'html')
end
if text == 'delete blocklist' or text == 'حذف بلاک لیست گروه' then
local function Clean(FreemanagerBOT,result)
for k,v in pairs(result.members) do
RemoveFromBanList(msg.chat_id, v.user_id) 
end
sendText(msg.chat_id, msg.id,  '<code>>تمامی افراد لیست سیاه(Blocklist) گروه شما با موفقیت حذف گردیدند.</code>', 'html')
end
getChannelMembers(msg.chat_id, "Banned", 0, 100000000000,Clean)
end
if text == "delete deleted" or text == 'حذف کاربران دلیت اکانت' then
function list(FreemanagerBOT,result)
for k,v in pairs(result.members) do
local function Checkdeleted(FreemanagerBOT,result)
if result.type._ == "userTypeDeleted" then
KickUser(msg.chat_id,result.id)
end
end
GetUser(v.user_id,Checkdeleted)
--print(v.user_id)
end
sendText(msg.chat_id, msg.id,'<code>>تمامی کاربران حذف حساب کاربری شده(Delete Account) گروه با موفقیت حذف گردیدند.</code>' ,'html')
end
tdbot_function ({_= "getChannelMembers",channel_id = getChatId(msg.chat_id).id,offset = 0,limit= 1000}, list, nil)
end
if text == 'silentlist' or text == 'لیست سکوت' then
local list = redis:smembers('MuteList:'..msg.chat_id)
local t = '<code>لیست کاربران حالت سکوت:</code> \n\n'
for k,v in pairs(list) do
t = t..k.." - *"..v.."*\n" 
end
t = t.."\n`>برای مشاهده کاربر از دستور زیر استفاده کنید`\n/whois [شناسه کاربر]"
if #list == 0 then
t = 'لیست کاربران حالت سکوت خالی میباشد.'
end
sendText(msg.chat_id, msg.id,t, 'html')
end
 if text == 'delete silentlist' or text == 'حذف لیست سکوت'  then
local mutee = redis:smembers('MuteList:'..msg.chat_id)
for k,v in pairs(mutee) do
redis:del('MuteList:'..msg.chat_id)
mute(msg.chat_id, v,'Restricted',   {1, 1, 0, 0, 0,0})
end
sendText(msg.chat_id, msg.id,  '<code>>لیست  کاربران حالت سکوت با موفقیت حذف گردید.</code>', 'html')
end
if text == 'delete bots' or text == 'حذف ربات ها' then
local function CleanBot(FreemanagerBOT,result)
for k,v in pairs(result.members) do
if tonumber(v.user_id) == tonumber(TD_ID) then
return false
end
 if private(msg.chat_id,v.user_id) then
print '                      Private                          '
else
end
KickUser(msg.chat_id, v.user_id) 
end
end
sendText(msg.chat_id, msg.id,  '<code>>تمامی ربات های گروه با موفقیت حذف گردیدند.</code>', 'html')
getChannelMembers(msg.chat_id, "Bots", 0, 100000000000,CleanBot)
end 
if text and text:match('^filterlist$') or text and text:match('^لیست فیلتر$') then
local list = redis:smembers('Filters:'..msg.chat_id)
local t = '<code>>لیست کلمات فیلتر شده در گروه:</code> \n\n'
for k,v in pairs(list) do
t = t..k.." - <b>"..v.."</b>\n" 
end
if #list == 0 then
t = '<code>>لیست کلمات فیلتر شده خالی میباشد</code>'
end
sendText(msg.chat_id, msg.id,t, 'html')
end
if text == 'delete filterlist' or text == 'حذف فیلتر لیست' then
redis:del('Filters:'..msg.chat_id)
sendText(msg.chat_id, msg.id,  '<code>>تمامی کلمات فیلتر شده با موفقیت حذف گردیدند.</code>', 'html')
end
 if text == 'rempms' or text == 'کاهش حجم پیغام ها' then
 if redis:get("timeforrempms:"..msg.chat_id) then
 local time = redis:ttl("timeforrempms:"..msg.chat_id)
local days = math.floor(time / 86400)
time = time - days * 86400
local hour = math.floor(time /3600)
time = time - hour * 3600
local minute = math.floor(time / 60)
time = time - minute * 60
sec = time
sendText(msg.chat_id, msg.id,  'استفاده از این دستور در هر [15] دقیقه تنها یکبار قابل استفاده است.\nلطفا ['..minute..'] دقیقه و ['..sec..'] ثانیه دیگر مجدد دستور خود را ارسال فرمایید.', 'html')
	 else
	  redis:setex("timeforrempms:"..msg.chat_id, 900, true)
local function groupcreator(FreemanagerBOT,result)
local list = result.members
           local t = '> لیست کاربران گروه:\n'
          local n = 0
            for k,v in pairs(list) do
           n = (n + 1)
              t = t..n.." - "..v.user_id.."\n"
			  deleteMessagesFromUser(msg.chat_id,v.user_id)
end
for k,v in pairs(list) do
           n = (n + 1)
              t = t..n.." - "..v.user_id.."\n"
			  deleteMessagesFromUser(msg.chat_id,v.user_id)
end
for k,v in pairs(list) do
           n = (n + 1)
              t = t..n.." - "..v.user_id.."\n"
			  deleteMessagesFromUser(msg.chat_id,v.user_id)
end
sendText(msg.chat_id, msg.id,  '<code>>در حال انجام عملیات ...</code>', 'html')
sleep(5)
sendText(msg.chat_id, msg.id,  '<code>>کاهش پیغام های گروه انجام شد.</code>', 'html')
end
getChannelMembers(msg.chat_id, "Search", 0, 100000000000,groupcreator)
end
end
--------------------------------------------------------------------------
---------------------------------------------------------------
if text == 'silentuser' or text == 'سکوت' then
local function Restricted(FreemanagerBOT,result)
if tonumber(result.sender_user_id or 00000000) == tonumber(TD_ID) then
sendText(msg.chat_id, msg.id,  '> خطا!\nشما دسترسی لازم برای محدود سازی سایر مالکان/مدیران را ندارید.', 'md')
return false
end
if tonumber(result.sender_user_id or 00000000) == tonumber(SUDO_ID) then
sendText(msg.chat_id, msg.id,  '> خطا!\nشما دسترسی لازم برای محدود سازی سایر مالکان/مدیران را ندارید.', 'md')
return false
end
if private(msg.chat_id,result.sender_user_id or 00000000) then
sendText(msg.chat_id, msg.id, "> خطا!\nشما دسترسی لازم برای محدود سازی سایر مالکان/مدیران را ندارید.", 'md')
else
--mute(msg.chat_id, result.sender_user_id or 00000000,'Restricted',   {1, 0, 0, 0, 0,0})
redis:sadd('MuteList:'..msg.chat_id,result.sender_user_id or 00000000)
SendMetion(msg.chat_id,result.sender_user_id, msg.id, "> کاربر ["..result.sender_user_id.."] به لیست حالت سکوت کاربران افزوده گردید.", 9,string.len(result.sender_user_id))
end
end
if tonumber(msg.reply_to_message_id) == 0 then
else
getMessage(msg.chat_id, tonumber(msg.reply_to_message_id),Restricted)  
end
end
if text and text:match('^silentuser (%d+)$') or text and text:match('^سکوت (%d+)$') then
local mutess = text:match('^silentuser (%d+)$') or text:match('^سکوت (%d+)$') 
if tonumber(mutess) == tonumber(TD_ID) then
sendText(msg.chat_id, msg.id,  '> خطا!\nشما دسترسی لازم برای محدود سازی سایر مالکان/مدیران را ندارید.', 'md')
return false
end
if tonumber(mutess) == tonumber(SUDO_ID) then
sendText(msg.chat_id, msg.id,  '> خطا!\nشما دسترسی لازم برای محدود سازی سایر مالکان/مدیران را ندارید.', 'md')
return false
end
if private(msg.chat_id,mutess) then
sendText(msg.chat_id, msg.id, "> خطا!\nشما دسترسی لازم برای محدود سازی سایر مالکان/مدیران را ندارید.", 'md')
else
--mute(msg.chat_id, mutess,'Restricted',   {1, 0, 0, 0, 0,0})
redis:sadd('MuteList:'..msg.chat_id,mutess)
sendText(msg.chat_id, msg.id,"> کاربر `"..mutess.."` به لیست حالت سکوت کاربران افزوده گردید.",  'md' )
end
end
if text and text:match('^silentuser @(.*)') or text and text:match('^سکوت @(.*)') then
local mutess = text:match('^silentuser @(.*)') or text:match('^سکوت @(.*)')
function Restricted(FreemanagerBOT,result)
if tonumber(result.id) == tonumber(TD_ID) then
sendText(msg.chat_id, msg.id,  '> خطا!\nشما دسترسی لازم برای محدود سازی سایر مالکان/مدیران را ندارید.', 'md')
return false
end
if tonumber(result.id) == tonumber(SUDO_ID) then
sendText(msg.chat_id, msg.id,  '> خطا!\nشما دسترسی لازم برای محدود سازی سایر مالکان/مدیران را ندارید.', 'md')
return false
end
if private(msg.chat_id,result.id) then
sendText(msg.chat_id, msg.id, "> خطا!\nشما دسترسی لازم برای محدود سازی سایر مالکان/مدیران را ندارید.", 'md')
else
if result.id then
print(''..result.id..'')
--mute(msg.chat_id, result.id,'Restricted',   {1, 0, 0, 0, 0,0})
redis:sadd('MuteList:'..msg.chat_id,result.id)
text = '> کاربر [<b>'..result.id..'</b>] به لیست حالت سکوت کاربران افزوده گردید.'
else 
text = '<code>کاربر مورد نظر یافت نشد!</code>\nابتدا از صحت وجود یوزرنیم یا شناسه کاربری اطمینان حاصل کنید،سپس مجدد اقدام کنید.'
end
sendText(msg.chat_id, msg.id, text, 'html')
end
end
resolve_username(mutess,Restricted)
end
if text == 'unsilentuser' or text == 'لغو سکوت' then
function Restricted(FreemanagerBOT,result)
if tonumber(result.sender_user_id) == tonumber(TD_ID) then
sendText(msg.chat_id, msg.id,  '> خطا!\nشما دسترسی لازم برای محدود سازی سایر مالکان/مدیران را ندارید.', 'md')
return false
end
redis:srem('MuteList:'..msg.chat_id,result.sender_user_id)
--mute(msg.chat_id,result.sender_user_id,'Restricted',   {1, 1, 1, 1, 1,1})
SendMetion(msg.chat_id,result.sender_user_id, msg.id, "> کاربر ["..result.sender_user_id.."] از لیست کاربران حالت سکوت حذف گردید.", 9,string.len(result.sender_user_id))
end
if tonumber(msg.reply_to_message_id) == 0 then
else
getMessage(msg.chat_id, tonumber(msg.reply_to_message_id),Restricted)  
end
end
if text and text:match('^unsilentuser (%d+)$') or text and text:match('^لغو سکوت (%d+)$') then
local mutes =  text:match('^unsilentuser (%d+)$') or text:match('^لغو سکوت (%d+)$')
if tonumber(mutes) == tonumber(TD_ID) then
sendText(msg.chat_id, msg.id,  '> خطا!\nشما دسترسی لازم برای محدود سازی سایر مالکان/مدیران را ندارید.', 'md')
return false
end
redis:srem('MuteList:'..msg.chat_id,mutes)
--mute(msg.chat_id, mutes,'Restricted',   {1, 1, 1, 1, 1,1})
sendText(msg.chat_id, msg.id,"> کاربر `"..mutes.."` از لیست کاربران حالت سکوت حذف گردید.",  'md' )
end
if text and text:match('^unsilentuser @(.*)') or text and text:match('^لغو سکوت @(.*)') then
local mutess = text:match('^unsilentuser @(.*)') or text:match('^لغو سکوت @(.*)')
function Restricted(FreemanagerBOT,result)
if result.id then
print(''..result.id..'')
redis:srem('MuteList:'..msg.chat_id,result.id)
--mute(msg.chat_id, result.id,'Restricted',   {1, 1, 1, 1, 1,1})
text = '> کاربر [<b>'..result.id..'</b>] از لیست کاربران حالت سکوت حذف گردید.'
else 
text = '<code>کاربر مورد نظر یافت نشد!</code>\nابتدا از صحت وجود یوزرنیم یا شناسه کاربری اطمینان حاصل کنید،سپس مجدد اقدام کنید.'
end
sendText(msg.chat_id, msg.id, text, 'html')
end
resolve_username(mutess,Restricted)
end
---------------------------------------Silentuser by time-------------------------------------------------
if text and text:match('^silentuser (%d+)[mhd]$') or text and text:match('^سکوت (%d+)[mhd]$') then
local mutess = text:match('^silentuser (.*)$') or text:match('^سکوت (.*)$') 
local function Restricted(FreemanagerBOT,result)
if mutess:match('(%d+)d') then
          time_match = mutess:match('(%d+)d')
          time = time_match * 86400
          end
if mutess:match('(%d+)h') then
          time_match = mutess:match('(%d+)h')
          time = time_match * 3600
          end
          if mutess:match('(%d+)m') then
          time_match = mutess:match('(%d+)m')
          time = time_match * 60
          end
if tonumber(result.sender_user_id) == tonumber(TD_ID) then
sendText(msg.chat_id, msg.id,  '> خطا!\nشما دسترسی لازم برای محدود سازی سایر مالکان/مدیران را ندارید.', 'md')
return false
end
if tonumber(result.sender_user_id) == tonumber(SUDO_ID) then
sendText(msg.chat_id, msg.id,  '> خطا!\nشما دسترسی لازم برای محدود سازی سایر مالکان/مدیران را ندارید.', 'md')
return false
end
if private(msg.chat_id,result.sender_user_id) then
sendText(msg.chat_id, msg.id, "> خطا!\nشما دسترسی لازم برای محدود سازی سایر مالکان/مدیران را ندارید.", 'md')
else
mute(msg.chat_id, result.sender_user_id,'Restricted',   {1, msg.date+time, 0, 0, 0,0})
SendMetion(msg.chat_id,result.sender_user_id, msg.id, "> کاربر ["..result.sender_user_id.."] برای مدت زمان ["..time.."] ثانیه به لیست حالت سکوت کاربران افزوده گردید.", 9,string.len(result.sender_user_id))
end
end
if tonumber(msg.reply_to_message_id) == 0 then
else
getMessage(msg.chat_id, tonumber(msg.reply_to_message_id),Restricted)  
end
end
----------------------------------------------------------------------------------------
if text1 == 'setlink' or text1 == 'تنظیم لینک' and tonumber(msg.reply_to_message_id) > 0 then
function GeTLink(FreemanagerBOT,result)
local getlink = result.content.text or result.content.caption
for link in getlink:gmatch("(https://t.me/joinchat/%S+)") or getlink:gmatch("t.me", "telegram.me") do
redis:set('Link:'..msg.chat_id,link)
print(link)
end
sendText(msg.chat_id, msg.id,"<code>>لینک گروه در متن یافت شد و  با موفقیت ذخیره و تغییر یافت.</code>",  'html' )
end
getMessage(msg.chat_id, tonumber(msg.reply_to_message_id),GeTLink)
end
if text == 'remlink' or text == 'حذف لینک' then
redis:del('Link:'..msg.chat_id)
sendText(msg.chat_id, msg.id,"<code>>لینک تنظیم شده با موفقیت بازنشانی گردید.</code>",  'html' )
end
--------------------------START BAN function-----------------------------------------------
if text == 'ban' or text == 'مسدود' and tonumber(msg.reply_to_message_id) > 0 then
function BanByReply(FreemanagerBOT,result)
if tonumber(result.sender_user_id) == tonumber(TD_ID) then
sendText(msg.chat_id, msg.id,"> خطا!\nشما دسترسی لازم برای محدود سازی سایر مالکان/مدیران را ندارید.",  'md' )
return false
end
if tonumber(result.sender_user_id) == tonumber(SUDO_ID) then
sendText(msg.chat_id, msg.id,  '> خطا!\nشما دسترسی لازم برای محدود سازی سایر مالکان/مدیران را ندارید.', 'md')
return false
end
  if private(msg.chat_id,result.sender_user_id) then
print '                     Private                          '
  sendText(msg.chat_id, msg.id, "> خطا!\nشما دسترسی لازم برای محدود سازی سایر مالکان/مدیران را ندارید.", 'md')
    else
SendMetion(msg.chat_id,result.sender_user_id, msg.id, "> کاربر ["..(result.sender_user_id).."] از گروه مسدود گردید.", 9,string.len(result.sender_user_id))
redis:sadd('BanUser:'..msg.chat_id,result.sender_user_id)
KickUser(msg.chat_id,result.sender_user_id)
end
end
getMessage(msg.chat_id, tonumber(msg.reply_to_message_id),BanByReply)
end
if text and text:match('^ban (%d+)') or text and text:match('^مسدود (%d+)') then
local user_id = text:match('^ban (%d+)') or text:match('^مسدود (%d+)')
if tonumber(user_id) == tonumber(TD_ID) then
sendText(msg.chat_id, msg.id,"> خطا!\nشما دسترسی لازم برای محدود سازی سایر مالکان/مدیران را ندارید.",  'md' )
return false
end
if tonumber(user_id) == tonumber(SUDO_ID) then
sendText(msg.chat_id, msg.id,  '> خطا!\nشما دسترسی لازم برای محدود سازی سایر مالکان/مدیران را ندارید.', 'md')
return false
end
if private(msg.chat_id,user_id) then
print '                     Private                          '
sendText(msg.chat_id, msg.id, "> خطا!\nشما دسترسی لازم برای محدود سازی سایر مالکان/مدیران را ندارید.", 'md')
else
redis:sadd('BanUser:'..msg.chat_id,user_id)
KickUser(msg.chat_id,user_id)
SendMetion(msg.chat_id,user_id, msg.id, "> کاربر ["..(user_id).."] از گروه مسدود گردید.", 9,string.len(user_id))
end
end
if text and text:match('^ban @(.*)') or text and text:match('^مسدود @(.*)') then
local username = text:match('^ban @(.*)') or text:match('^مسدود @(.*)')
print '                     Private                          '
function BanByUserName(FreemanagerBOT,result)
if tonumber(result.id) == tonumber(TD_ID) then
sendText(msg.chat_id, msg.id,"> خطا!\nشما دسترسی لازم برای محدود سازی سایر مالکان/مدیران را ندارید.",  'md' )
return false
end
if tonumber(result.id) == tonumber(SUDO_ID) then
sendText(msg.chat_id, msg.id,  '> خطا!\nشما دسترسی لازم برای محدود سازی سایر مالکان/مدیران را ندارید.', 'md')
return false
end
if private(msg.chat_id,result.id) then
print '                     Private                          '
sendText(msg.chat_id, msg.id, "> خطا!\nشما دسترسی لازم برای محدود سازی سایر مالکان/مدیران را ندارید.", 'md')
else
if result.id then
redis:sadd('BanUser:'..msg.chat_id,result.id)
KickUser(msg.chat_id,result.id)
SendMetion(msg.chat_id,result.id, msg.id, "> کاربر ["..(result.id).."] از گروه مسدود گردید.", 9,string.len(result.id))
else 
t = '<code>کاربر مورد نظر یافت نشد!</code>\nابتدا از صحت وجود یوزرنیم یا شناسه کاربری اطمینان حاصل کنید،سپس مجدد اقدام کنید.'
sendText(msg.chat_id, msg.id, t,  'html')
end
end
end
resolve_username(username,BanByUserName)
end
if text == 'unban' or text == 'لغو مسدود' and tonumber(msg.reply_to_message_id) > 0 then
function UnBan_by_reply(FreemanagerBOT,result)
if tonumber(result.sender_user_id) == tonumber(TD_ID) then
sendText(msg.chat_id, msg.id,  "> خطا!\nشما دسترسی لازم برای محدود سازی سایر مالکان/مدیران را ندارید.", 'md')
return false
end
redis:srem('BanUser:'..msg.chat_id,result.sender_user_id)
SendMetion(msg.chat_id,result.sender_user_id, msg.id, "> کاربر ["..(result.sender_user_id).."] از لیست کاربران مسدود شده خارج گردید.", 9,string.len(result.sender_user_id))
RemoveFromBanList(msg.chat_id,result.sender_user_id)
 end
getMessage(msg.chat_id, tonumber(msg.reply_to_message_id),UnBan_by_reply)
end
if text and text:match('^unban (%d+)') or text and text:match('^لغو مسدود (%d+)') then
local user_id = text:match('^unban (%d+)') or text:match('^لغو مسدود (%d+)')
if tonumber(user_id) == tonumber(TD_ID) then
sendText(msg.chat_id, msg.id,  "> خطا!\nشما دسترسی لازم برای محدود سازی سایر مالکان/مدیران را ندارید.", 'md')
return false
end
redis:srem('BanUser:'..msg.chat_id,user_id)
RemoveFromBanList(msg.chat_id,user_id)
SendMetion(msg.chat_id,user_id, msg.id, "> کاربر ["..(user_id).."] از لیست کاربران مسدود شده خارج گردید.", 9,string.len(user_id))
end
if text and text:match('^unban @(.*)') or text and text:match('^لغو مسدود @(.*)') then
local username = text:match('unban @(.*)') or text:match('لغو مسدود @(.*)')
function UnBanByUserName(FreemanagerBOT,result)
if tonumber(result.id) == tonumber(TD_ID) then
sendText(msg.chat_id, msg.id,  "> خطا!\nشما دسترسی لازم برای محدود سازی سایر مالکان/مدیران را ندارید.", 'md')
return false
end
if result.id then
print('UserID : '..result.id..'\nUserName : @'..username)
redis:srem('BanUser:'..msg.chat_id,result.id)
SendMetion(msg.chat_id,result.id, msg.id, "> کاربر ["..(result.id).."] از لیست کاربران مسدود شده خارج گردید.", 9,string.len(result.id))
else 
sendText(msg.chat_id, msg.id, '<code>کاربر مورد نظر یافت نشد!</code>\nابتدا از صحت وجود یوزرنیم یا شناسه کاربری اطمینان حاصل کنید،سپس مجدد اقدام کنید.',  'html')

end
print('Send')
end
resolve_username(username,UnBanByUserName)
end
----------------------------END BAN function---------------------------------------------
----------------------------START KICK function---------------------------------------------
if text == 'kick' or text == 'اخراج' and tonumber(msg.reply_to_message_id) > 0 then
function kick_by_reply(FreemanagerBOT,result)
if tonumber(result.sender_user_id) == tonumber(TD_ID) then
sendText(msg.chat_id, msg.id,"> خطا!\nشما دسترسی لازم برای محدود سازی سایر مالکان/مدیران را ندارید.",  'md' )
return false
end
if tonumber(result.sender_user_id) == tonumber(SUDO_ID) then
sendText(msg.chat_id, msg.id,  '> خطا!\nشما دسترسی لازم برای محدود سازی سایر مالکان/مدیران را ندارید.', 'md')
return false
end
if private(msg.chat_id,result.sender_user_id) then
print '                     Private                          '
sendText(msg.chat_id, msg.id, "> خطا!\nشما دسترسی لازم برای محدود سازی سایر مالکان/مدیران را ندارید.", 'md')
else
SendMetion(msg.chat_id,result.sender_user_id, msg.id, "> کاربر ["..(result.sender_user_id).."] از گروه حذف گردید.", 9,string.len(result.sender_user_id))
KickUser(msg.chat_id,result.sender_user_id)
RemoveFromBanList(msg.chat_id,result.sender_user_id)
 end
end
getMessage(msg.chat_id, tonumber(msg.reply_to_message_id),kick_by_reply)
end
if text and text:match('^kick (%d+)') or text and text:match('^اخراج (%d+)') then
local user_id = text:match('^kick (%d+)') or text:match('^اخراج (%d+)')
if tonumber(user_id) == tonumber(TD_ID) then
sendText(msg.chat_id, msg.id,"> خطا!\nشما دسترسی لازم برای محدود سازی سایر مالکان/مدیران را ندارید.",  'md' )
return false
end
if tonumber(user_id) == tonumber(SUDO_ID) then
sendText(msg.chat_id, msg.id,  '> خطا!\nشما دسترسی لازم برای محدود سازی سایر مالکان/مدیران را ندارید.', 'md')
return false
end
if private(msg.chat_id,user_id) then
print '                     Private                          '
sendText(msg.chat_id, msg.id, "> خطا!\nشما دسترسی لازم برای محدود سازی سایر مالکان/مدیران را ندارید.", 'md')
else
KickUser(msg.chat_id,user_id)
text= '> کاربر ['..user_id..'] از گروه حذف گردید.'
SendMetion(msg.chat_id,user_id, msg.id, text,8, string.len(user_id))
RemoveFromBanList(msg.chat_id,user_id)
end
end
if text and text:match('^kick @(.*)') or text and text:match('^اخراج @(.*)') then
local username = text:match('^kick @(.*)') or text:match('^اخراج @(.*)')
function KickByUserName(FreemanagerBOT,result)
if result.id then
KickUser(msg.chat_id,result.id)
RemoveFromBanList(msg.chat_id,result.id)
SendMetion(msg.chat_id,result.id, msg.id, "> کاربر ["..(result.id).."] از گروه حذف گردید.", 9,string.len(result.id))
else 
txtt = '<code>کاربر مورد نظر یافت نشد!</code>\nابتدا از صحت وجود یوزرنیم یا شناسه کاربری اطمینان حاصل کنید،سپس مجدد اقدام کنید.'
sendText(msg.chat_id, msg.id,txtt,  'html')
--end
end
end
resolve_username(username,KickByUserName)
end
----------------------------END KICK function---------------------------------------------
if text == 'delete restricts' or text == 'حذف لیست محدود ها' then
local function pro(arg,data)
for k,v in pairs(data.members) do
redis:del('MuteAll:'..msg.chat_id)
 mute(msg.chat_id, v.user_id,'Restricted',    {1, 1, 1, 1, 1,1})
end
end
getChannelMembers(msg.chat_id,"Recent", 0, 100000000000,pro)
sendText(msg.chat_id, msg.id,'<code>> لیست افراد محدود شده در گروه بازنشانی گردید.</code> ' ,'html')
end 
if text and text:match('^setfloodmsg (%d+)$') or text and text:match('^تنظیم پیام هرزنامه (%d+)$') then
local num = text:match('^setfloodmsg (%d+)$') or text:match('^تنظیم پیام هرزنامه (%d+)$')
if tonumber(num) < 2 then
sendText(msg.chat_id, msg.id, 'لطفا عددی بالاتر از [2] انتخاب کنید.','md')
else
		  redis:hset("flooding:settings:"..msg.chat_id ,"floodmax" ,num)
        sendText(msg.chat_id, msg.id, '<code>>حداکثر پیام تشخیص ارسال پیام مکرر تنظیم شد به:</code> [<b>'..num..'</b>] <code>تغییر یافت.</code>', 'html')
		end
		end
        if text and text:match('^setfloodtime (%d+)$') or text and text:match('^تنظیم زمان هرزنامه (%d+)$') then
		local num = text:match('^setfloodtime (%d+)$') or text:match('^تنظیم زمان هرزنامه (%d+)$')
		if tonumber(num) == 0 then
sendText(msg.chat_id, msg.id, 'لطفا عددی بالاتر از [0] انتخاب کنید.','md')
else
		  redis:hset("flooding:settings:"..msg.chat_id ,"floodtime" ,num)
       sendText(msg.chat_id, msg.id, '<code>>حداکثر زمان تشخیص ارسال پیام مکرر تنظیم شد به:</code> [<b>'..num..'</b>] <code>ثانیه.</code>', 'html')
	   end
		end
		-----------------------MORE CMD-----------------------------------------
		if text and text:match('^setwarnmax (%d+)') or text and text:match('^تنظیم حداکثر اخطار (%d+)$') then
local num = text:match('^setwarnmax (%d+)') or text:match('^تنظیم حداکثر اخطار (%d+)$')
if tonumber(num) < 2 then
sendText(msg.chat_id, msg.id, 'لطفا عددی بالاتر از [2] انتخاب کنید.','md')
else
redis:set('Warn:Max:'..msg.chat_id,num)
sendText(msg.chat_id, msg.id, '<code>>حداکثر اخطار فرد تنظیم شد به:</code> [<b>'..num..'</b>] <code>عدد.</code>', 'html')
end
end

if text and text:match('^setspamtext (%d+)') or text and text:match('^تنظیم حداکثر کارکتر (%d+)$') then
local num = text:match('^setspamtext (%d+)') or text:match('^تنظیم حداکثر کارکتر (%d+)$')
if tonumber(num) < 30 then
sendText(msg.chat_id, msg.id, 'لطفا عددی بالاتر از [30] انتخاب کنید.','md')
else
if tonumber(num) > 4096 then
sendText(msg.chat_id, msg.id, 'لطفا عددی کوچکتر از [4096] انتخاب کنید.','md')
else
redis:set('NUM_CH_MAX:'..msg.chat_id,num)
sendText(msg.chat_id, msg.id, '<code>>حساسیت نسبت به ارسال متون بلند تنظیم شد به:</code> [<b>'..num..'</b>] <code>کارکتر.</code>', 'html')
end
end
end
if text == 'delete warnlist' or text == 'حذف لیست اخطار ها' then
redis:del(msg.chat_id..':warn')
sendText(msg.chat_id, msg.id,'> لیست اخطار های این گروه با موفقیت بازنشانی گردید.', 'md')
end
if text == "warnlist" or text == 'لیست اخطار ها' then
local comn = redis:hkeys(msg.chat_id..':warn')
local t = 'لیست اخطار ها:\n'
for k,v in pairs (comn) do
local cont = redis:hget(msg.chat_id..':warn', v)
t = t..k..'- '..v..'> تعداد اخطار ها: '..(cont - 1)..'\n'
end
t = t.."\n`>برای مشاهده کاربر از دستور زیر استفاده کنید`\n*/whois* `[شناسه کاربر]`"
if #comn == 0 then
t = 'لیست اخطار برای این گروه ثبت نشده است.'
end 
sendText(msg.chat_id, msg.id,t, 'md')
end
------------------------------------
if text == "warn" or text == "اخطار" and tonumber(msg.reply_to_message_id) > 0 then
function WarnByReply(FreemanagerBOT, result)
if tonumber(result.sender_user_id) == tonumber(TD_ID) then
sendText(msg.chat_id, msg.id,  '> خطا!\nشما دسترسی لازم برای محدود سازی سایر مالکان/مدیران را ندارید.', 'md')
return false
end
if private(msg.chat_id,result.sender_user_id) then
print '                     Private                          '
sendText(msg.chat_id, msg.id, "> خطا!\nشما دسترسی لازم برای محدود سازی سایر مالکان/مدیران را ندارید.", 'md')
else
local warnmax = redis:get('Warn:Max:'..msg.chat_id) or 3
 local hashwarn = msg.chat_id..':warn'
local warnhash = redis:hget(msg.chat_id..':warn',(result.sender_user_id)) or 1
if tonumber(warnhash) == tonumber(warnmax) then
redis:sadd('MuteList:'..msg.chat_id,result.sender_user_id)
--KickUser(msg.chat_id,result.sender_user_id)
--RemoveFromBanList(msg.chat_id,result.sender_user_id)
text= "> کاربر  ["..result.sender_user_id.."] به دلیل دریافت بیش از حد مجاز اخطار از سوی مدیران سایلنت گردید."
redis:hdel(hashwarn,result.sender_user_id, '0')
SendMetion(msg.chat_id,result.sender_user_id, msg.id, text, 10, string.len(result.sender_user_id))
else
local warnmax = redis:get('Warn:Max:'..msg.chat_id) or 3
local warnhash = redis:hget(msg.chat_id..':warn',(result.sender_user_id)) or 1
local contwarn = tonumber(warnmax) - tonumber(warnhash)
 redis:hset(hashwarn,result.sender_user_id, tonumber(warnhash) + 1)
text= "> کاربر [" ..result.sender_user_id.. "]\nشما ["..warnhash.."]  اخطار از طرف مدیران گروه دریافت کرده اید و در صورتی که ["..contwarn.."]  اخطار دیگر دریافت کنید محدودیت هایی بصورت خودکار برای شما تنظیم میشود.\nلطفا قوانین گروه را رعایت کنید ..."
SendMetion(msg.chat_id,result.sender_user_id, msg.reply_to_message_id, text, 9, string.len(result.sender_user_id))
end
end
 end
getMessage(msg.chat_id, tonumber(msg.reply_to_message_id),WarnByReply)
end
if text and text:match('^warn (%d+)') or text and text:match('^اخطار (%d+)') then
local user_id = text:match('^warn (%d+)') or text:match('^اخطار (%d+)')
if tonumber(user_id) == tonumber(TD_ID) then
sendText(msg.chat_id, msg.id,  '> خطا!\nشما دسترسی لازم برای محدود سازی سایر مالکان/مدیران را ندارید.', 'md')
return false
end
if private(msg.chat_id,user_id) then
print '                     Private                          '
sendText(msg.chat_id, msg.id, "> خطا!\nشما دسترسی لازم برای محدود سازی سایر مالکان/مدیران را ندارید.", 'md')
else
local warnmax = redis:get('Warn:Max:'..msg.chat_id) or 3
 local hashwarn = msg.chat_id..':warn'
local warnhash = redis:hget(msg.chat_id..':warn',user_id) or 1
if tonumber(warnhash) == tonumber(warnmax) then
redis:sadd('MuteList:'..msg.chat_id,user_id)
--KickUser(msg.chat_id,user_id)
--RemoveFromBanList(msg.chat_id,user_id)
text= "> کاربر  ["..user_id.."] به دلیل دریافت بیش از حد مجاز اخطار از سوی مدیران سایلنت گردید."
redis:hdel(hashwarn,user_id, '0')
SendMetion(msg.chat_id,user_id, msg.id, text, 10, string.len(user_id))
else
local warnmax = redis:get('Warn:Max:'..msg.chat_id) or 3
local warnhash = redis:hget(msg.chat_id..':warn',user_id) or 1
local contwarn = tonumber(warnmax) - tonumber(warnhash)
 redis:hset(hashwarn,user_id, tonumber(warnhash) + 1)
text= "> کاربر [" ..user_id.. "]\nشما ["..warnhash.."]  اخطار از طرف مدیران گروه دریافت کرده اید و در صورتی که ["..contwarn.."]  اخطار دیگر دریافت کنید محدودیت هایی بصورت خودکار برای شما تنظیم میشود.\nلطفا قوانین گروه را رعایت کنید ..."
SendMetion(msg.chat_id,user_id, msg.id, text, 9, string.len(user_id))
end
end
end
-------------------------------
if text and text:match('^اخطار @(.*)') or text and text:match('^اخطار @(.*)') then
local username = text:match('^اخطار @(.*)') or text:match('^اخطار @(.*)')
function Warnbyusername(FreemanagerBOT,result)
if tonumber(result.id) == tonumber(TD_ID) then
sendText(msg.chat_id, msg.id,  '> خطا!\nشما دسترسی لازم برای محدود سازی سایر مالکان/مدیران را ندارید.', 'md')
return false
end
if private(msg.chat_id,result.id) then
print '                     Private                          '
sendText(msg.chat_id, msg.id, "> خطا!\nشما دسترسی لازم برای محدود سازی سایر مالکان/مدیران را ندارید.", 'md')
else
local warnmax = redis:get('Warn:Max:'..msg.chat_id) or 3
 local hashwarn = msg.chat_id..':warn'
local warnhash = redis:hget(msg.chat_id..':warn',result.id) or 1
if tonumber(warnhash) == tonumber(warnmax) then
--KickUser(msg.chat_id,result.id)
--RemoveFromBanList(msg.chat_id,result.id)
redis:sadd('MuteList:'..msg.chat_id,result.id)
text= "> کاربر  ["..result.id.."] به دلیل دریافت بیش از حد مجاز اخطار از سوی مدیران از گروه اخراج گردید."
redis:hdel(hashwarn,result.id, '0')
SendMetion(msg.chat_id,result.id, msg.id, text, 10, string.len(result.id))
else
local warnmax = redis:get('Warn:Max:'..msg.chat_id) or 3
local warnhash = redis:hget(msg.chat_id..':warn',result.id) or 1
local contwarn = tonumber(warnmax) - tonumber(warnhash)
 redis:hset(hashwarn,result.id, tonumber(warnhash) + 1)
text= "> کاربر [" ..result.id.. "]\nشما ["..warnhash.."]  اخطار از طرف مدیران گروه دریافت کرده اید و در صورتی که ["..contwarn.."]  اخطار دیگر دریافت کنید محدودیت هایی بصورت خودکار برای شما تنظیم میشود.\nلطفا قوانین گروه را رعایت کنید ..."
SendMetion(msg.chat_id,result.id, msg.id, text, 9, string.len(result.id))
end
end
end
resolve_username(username,Warnbyusername)
end
-------------------------------
if text == "unwarn" or text == "حذف اخطار"  and tonumber(msg.reply_to_message_id) > 0 then
function UnWarnByReply(FreemanagerBOT, result)
if tonumber(result.sender_user_id) == tonumber(TD_ID) then
sendText(msg.chat_id, msg.id,  '> خطا!\nشما دسترسی لازم برای محدود سازی سایر مالکان/مدیران را ندارید.', 'md')
return false
end
if private(msg.chat_id,result.sender_user_id) then
else
local warnhash = redis:hget(msg.chat_id..':warn',(result.sender_user_id)) or 1
if tonumber(warnhash) == tonumber(1) then
text= ">کاربر  [*".. result.sender_user_id .."*] تاکنون اخطاری دریافت نکرده است."
sendText(msg.chat_id, msg.id, text, 'md')
else
local warnhash = redis:hget(msg.chat_id..':warn',(result.sender_user_id))
local hashwarn = msg.chat_id..':warn'
redis:hdel(hashwarn,(result.sender_user_id),'0')
redis:srem('MuteList:'..msg.chat_id,result.sender_user_id)
text= '> تمامی اخطار های کاربر  [*'..result.sender_user_id..'*] بازنشانی گردید.'
sendText(msg.chat_id, msg.id, text, 'md')
end
end
end
getMessage(msg.chat_id, tonumber(msg.reply_to_message_id),UnWarnByReply)
end
if text and text:match('^unwarn (%d+)') or text and text:match('^حذف اخطار (%d+)')  then
local user_id = text:match('^unwarn (%d+)') or text:match('^حذف اخطار (%d+)')
if tonumber(user_id) == tonumber(TD_ID) then
sendText(msg.chat_id, msg.id,  '> خطا!\nشما دسترسی لازم برای محدود سازی سایر مالکان/مدیران را ندارید.', 'md')
return false
end
if private(msg.chat_id,user_id) then
else
local warnhash = redis:hget(msg.chat_id..':warn',user_id) or 1
if tonumber(warnhash) == tonumber(1) then
text= ">کاربر  [* "..user_id.."*] تاکنون اخطاری دریافت نکرده است."
sendText(msg.chat_id, msg.id, text, 'md')
else
local warnhash = redis:hget(msg.chat_id..':warn',user_id)
local hashwarn = msg.chat_id..':warn'
redis:hdel(hashwarn,user_id,'0')
redis:srem('MuteList:'..msg.chat_id,user_id)
text= '> تمامی اخطار های کاربر  [*'..user_id..'*] بازنشانی گردید.'
sendText(msg.chat_id, msg.id, text, 'md')
end
end
end
if text and text:match('^حذف اخطار @(.*)') or text and text:match('^حذف اخطار @(.*)') then
local username = text:match('^حذف اخطار @(.*)') or text:match('^حذف اخطار @(.*)')
function unWarnbyusername(FreemanagerBOT,result)
if tonumber(result.id) == tonumber(TD_ID) then
sendText(msg.chat_id, msg.id,  '> خطا!\nشما دسترسی لازم برای محدود سازی سایر مالکان/مدیران را ندارید.', 'md')
return false
end
if private(msg.chat_id,result.id) then
else
local warnhash = redis:hget(msg.chat_id..':warn',result.id) or 1
if tonumber(warnhash) == tonumber(1) then
text= ">کاربر  [* "..result.id.."*] تاکنون اخطاری دریافت نکرده است."
sendText(msg.chat_id, msg.id, text, 'md')
else
local warnhash = redis:hget(msg.chat_id..':warn',result.id)
local hashwarn = msg.chat_id..':warn'
redis:hdel(hashwarn,result.id,'0')
redis:srem('MuteList:'..msg.chat_id,result.id)
text= '> تمامی اخطار های کاربر  [*'..result.id..'*] بازنشانی گردید.'
sendText(msg.chat_id, msg.id, text, 'md')
end
end
end
resolve_username(username,unWarnbyusername)
end
		------------------------------------------------------------------------
if text and text:match('^rmsg (%d+)$') or text and text:match('^حذف پیام (%d+)$') then
local limit = tonumber(text:match('^rmsg (%d+)$') or text:match('^حذف پیام (%d+)$'))
if limit > 999 then
sendText(msg.chat_id, msg.id, '<code>حداکثر عدد مجاز برای انجام این دستور [999] میباشد.</code>', 'html')
else
local function cb(arg,data)
for k,v in pairs(data.messages) do
deleteMessages(msg.chat_id,{[0] =v.id})
end
end
getChatHistory(msg.chat_id,msg.id, 0,  limit,cb)
sendText(msg.chat_id, msg.id, '> ('..limit..') پیام اخیر ارسال شده در گروه حذف گردید.', 'html')
end
end
------------------------FORCE ADD USER-------------------------
---------------------Welcome----------------------
if text == 'welcome on' or text == 'خوش آمدگویی فعال' then
if redis:get('Welcome:'..msg.chat_id) == 'on' then
sendText(msg.chat_id, msg.id,'<code>>ارسال پیام خوش آمدگویی از قبل فعال بود.</code>' ,'html')
else
sendText(msg.chat_id, msg.id,'<code>>ارسال پیام خوش آمدگویی فعال گردید.</code>' ,'html')
redis:del('Welcome:'..msg.chat_id,'off')
redis:set('Welcome:'..msg.chat_id,'on')
end
end
if text == 'welcome off' or text == 'خوش آمدگویی غیرفعال' then
if redis:get('Welcome:'..msg.chat_id) then
sendText(msg.chat_id, msg.id,'<code>>ارسال پیام خوش آمدگویی غیرفعال گردید.</code>' ,'html')
redis:set('Welcome:'..msg.chat_id,'off')
redis:del('Welcome:'..msg.chat_id,'on')
else
sendText(msg.chat_id, msg.id,'<code>>ارسال پیام خوش آمدگویی از قبل غیرفعال بود.</code>' ,'html')
end
end
if text == 'delete welcome' or text == 'حذف پیغام خوش آمدگویی' then
redis:del('Text:Welcome:'..msg.chat_id)
sendText(msg.chat_id, msg.id,'<code>>پیغام خوش آمدگویی با موفقیت بازنشانی گردید.</code>' ,'html')
end
if text1 and text1:match('^[Ss]etlink (.*)') or text1 and text1:match('^تنظیم لینک (.*)') then
local link = text1:match('^[Ss]etlink (.*)') or text1:match('^تنظیم لینک (.*)')
redis:set('Link:'..msg.chat_id,link)
sendText(msg.chat_id, msg.id,' <code>>لینک جدید با موفقیت ذخیره و تغییر یافت.</code>', 'html')
end
if text and text:match('^[Ss]etwelcome (.*)') or text and text:match('^تنظیم پیغام خوش آمدگویی (.*)') then
local wel = text:match('^[Ss]etwelcome (.*)') or text:match('^تنظیم پیغام خوش آمدگویی (.*)')
redis:set('Text:Welcome:'..msg.chat_id,wel)
sendText(msg.chat_id, msg.id,'<code>>پیغام خوش آمدگویی با موفقیت ذخیره و تغییر یافت.</code>\nمتن پیام خوش آمدگویی تنظیم شده:\n{<code>'..wel..'</code>}', 'html')
end
if text and text:match('^[Ss]etrules (.*)') or text and text:match('^تنظیم قوانین (.*)') then
local rules = text:match('^[Ss]etrules (.*)') or text:match('^تنظیم قوانین (.*)')
redis:set('Rules:'..msg.chat_id,rules)
sendText(msg.chat_id, msg.id,'<code>>قوانین گروه بروزرسانی گردید.</code>', 'html')
end

-----------------------------------------------------------------------------------------------------------------------------------------------------
if text and text:match('^filter +(.*)') or text and text:match('^فیلتر +(.*)') then
local word = text:match('^filter +(.*)') or text:match('^فیلتر +(.*)')
redis:sadd('Filters:'..msg.chat_id,word)
sendText(msg.chat_id, msg.id, '<code>> عبارت</code> ['..word..'] <code>>به لیست کلمات فیلتر شده اضاف گردید!</code>', 'html')
end
if text and text:match('^unfilter +(.*)') or text and text:match('^حذف فیلتر +(.*)') then
local word = text:match('^unfilter +(.*)') or text:match('^حذف فیلتر +(.*)')
redis:srem('Filters:'..msg.chat_id,word)
sendText(msg.chat_id, msg.id,'<code>> عبارت</code> ['..word..'] <code>>از لیست کلمات فیلتر شده حذف گردید!</code>', 'html')
end
------
if redis:get('CheckBot:'..msg.chat_id) then
if text and text:match('^whois @(.*)') or text and text:match('^اطلاعات @(.*)') then
local username = text:match('^whois @(.*)') or text:match('^اطلاعات @(.*)')
 function IdByUserName(FreemanagerBOT,result)
if result.id then
text = '> شناسه کاربر مورد نظر:\n\n ['..result.id..']\n\n'
sendText(msg.chat_id, msg.id, text, 'md')
else
sendText(msg.chat_id, msg.id, '> یوزرنیم وارد شده صحیح نمیباشد.', 'md')
end
end
resolve_username(username,IdByUserName)
 end
 end

if text == "whois" or text == "اطلاعات" then
function GetID(FreemanagerBOT, result)
 local user = result.sender_user_id
local text = '> شناسه کاربر مورد نظر:\n['..result.sender_user_id..']'
SendMetion(msg.chat_id,result.sender_user_id, msg.id, text, 25, string.len(result.sender_user_id))
end
if tonumber(msg.reply_to_message_id) == 0 then
else
getMessage(msg.chat_id, tonumber(msg.reply_to_message_id),GetID)
end
end
if text and text:match('^whois (%d+)') or text and text:match('^اطلاعات (%d+)') then
local id = tonumber(text:match('^whois (%d+)') or text:match('^اطلاعات (%d+)'))
local function Whois(FreemanagerBOT,result)
 if result.first_name then
local username = ec_name(result.first_name)
SendMetion(msg.chat_id,result.id, msg.id,username,0,utf8.len(username))
else
sendText(msg.chat_id, msg.id,'> کاربر با شناسه  [*'..id..'*] یافت نشد.','md')
end
end
GetUser(id,Whois)
end
 if text == "id" or text == "ایدی" or text == "آیدی" then 
if tonumber(msg.reply_to_message_id) == 0  then 
 function GetPro(FreemanagerBOT, result)
local Msgs = redis:get('Total:messages:'..msg.chat_id..':'..(msg.sender_user_id))
 if result.photos and result.photos[0] then
print('persistent_id : '..result.photos[0].sizes[2].photo.persistent_id)  
sendPhoto(msg.chat_id, msg.id, 0, 1, nil, result.photos[0].sizes[2].photo.persistent_id,'>شناسه گروه: ['..msg.chat_id..']\nشناسه شما: ['..msg.sender_user_id..']\n>تعداد پیغام های ارسالی شما: ['..Msgs..']')
else
sendText(msg.chat_id, msg.id,  '>شناسه گروه ['..msg.chat_id..']\nشناسه شما ['..msg.sender_user_id..']\n>تعداد پیغام های ارسالی شما: ['..Msgs..']', 'md')
print '                      Not Photo                      ' 
end
end
tdbot_function ({_ ="getUserProfilePhotos", user_id = (msg.sender_user_id), offset =0, limit = 100000000 },GetPro, nil)
end
end

if text == 'me' or text == 'اطلاعات من' then
local function GetName(FreemanagerBOT, result)
if result.first_name then
resultName = ec_name(result.first_name)
else  
resultName = '\n\n'
end
Msgs = redis:get('Total:messages:'..msg.chat_id..':'..msg.sender_user_id)
sendText(msg.chat_id, msg.id,  '> نام شما: ['..resultName..']\nشناسه شما: ['..msg.sender_user_id..']\n>تعداد پیغام های ارسالی شما: ['..Msgs..']','md')
end
GetUser(msg.sender_user_id,GetName)
end
if text == 'about me' or text == 'درباره من' then
function GetName(extra, result, success) 
if result.about then
resultName = result.about
else  
resultName = 'بیوگرافی شما یافت نشد.'
end
if result.is_blocked then
resultblock = 'بله'
else  
resultblock = 'خیر'
end
if result.can_be_called then
resultcall = 'مجاز'
else  
resultcall = 'غیرمجاز'
end
if result.has_private_calls then
resultcallmode = 'خصوصی'
else  
resultcallmode = 'عمومی'
end
if result.common_chat_count  then
resultcommon_chat_count  = result.common_chat_count 
else 
resultcommon_chat_count  = 'nil'
end
sendText(msg.chat_id, msg.id,  '-درباره شما(اطلاعات مشترک):\n\n> بیوگرافی: [*'..resultName..'*]\n> تعداد گروه های مشترک: [*'..resultcommon_chat_count..'*]\n> مسدود شده توسط ربات: [*'..resultblock..'*]\n> قابلیت تماس با شمااز طریق تلگرام: [*'..resultcall..'*]\n> نوع قابلیت تماس از طریق تلگرام با شما: [*'..resultcallmode..'*]', 'md')
end
GetUserFull(msg.sender_user_id,GetName)
end
if text == 'groupinfo' or text == 'اطلاعات گروه' then
 local function FullInfo(FreemanagerBOT,result)
sendText(msg.chat_id, msg.id,'> *اطلاعات سوپرگروه:*\n\n`شناسه سوپرگروه:` [*'..msg.chat_id..'*]\n`تعداد ادمین ها:` [*'..result.administrator_count..'*]\n`تعداد افراد مسدود شده از گروه:` [*'..result.banned_count..'*]\n`تعداد افراد گروه:` [*'..result.member_count..'*]\n`درباره گروه:` [*'..result.description..'*]\n`لینک دعوت به سوپرگروه:` ['..(result.invite_link or 'یافت نشد.')..']\n`تعداد افراد محدود شده:` [*'..result.restricted_count..'*]', 'md')
end
getChannelFull(msg.chat_id,FullInfo)
end
if text and text:match('^dtime (%d+)') then
local id = tonumber(text:match('^dtime (%d+)'))
sendText(msg.chat_id,msg.id,  ''..(os.date("%X", id))..'', 'html')
end
if text == 'myinfo' then
local function Whois(FreemanagerBOT,result)
if result.status.expires  then
onoff  = ''..(os.date("%X", result.status.expires))..''
else 
onoff  = 'last seen recently'
end
if result.restriction_reason  then
restriction  = result.restriction_reason
else 
restriction  = 'محدودیتی در گروه برای شما تعریف نشده است.'
end
sendText(msg.chat_id, msg.id,'>شناسه شما: ['..(result.id or '—--')..']\n>نام شما: ['..(result.first_name or '—--')..']\n>نام آخر شما: ['..(result.last_name or '—--')..']\n>یوزرنیم شما: [@'..(result.username or '—--')..']\n>شماره تلفن شما: [+'..(result.phone_number or '—--')..']\n>نوع محدودیت شما در گروه: ['..(restriction or '—--')..']\n>آخرین بازدید شما: ['..(onoff or '—--')..']','html')
end
GetUser(msg.sender_user_id,Whois)
end
if text and text:match('^info (%d+)')  then
local id = tonumber(text:match('^info (%d+)'))
local function Whois(FreemanagerBOT,result)
if result.status.expires  then
onoff  = ''..(os.date("%X", result.status.expires))..''
else 
onoff  = 'last seen recently'
end
if result.restriction_reason  then
restriction  = result.restriction_reason
else 
restriction  = 'محدودیتی در گروه برای شما تعریف نشده است.'
end
if result.photo then
sendPhoto(msg.chat_id, msg.id, 0, 1, nil, result.photo.sizes[0].photo.persistent_id,'')
--sendPhoto(msg.chat_id, msg.id, 0, 1, nil, result.profile_photo.big.persistent_id,'test')
sendText(msg.chat_id, msg.id,'>شناسه کاربر: ['..(result.id or '—--')..']\n>نام کاربر: ['..(result.first_name or '—--')..']\n>نام آخر کاربر: ['..(result.last_name or '—--')..']\n>یوزرنیم کاربر: [@'..(result.username or '—--')..']\n>شماسه تلفن کاربر: [+'..(result.phone_number or '—--')..']\n>نوع محدودیت کاربر در گروه: ['..(restriction or '—--')..']\n>آخرین بازدید کاربر: ['..(onoff or '—--')..']\n>کد persistent id تصویر پروفایل : ['..(result.profile_photo.big.persistent_id or '—--')..']','html')
--tdbot_function ({_ ="getUserProfilePhotos", user_id = (id), offset =0, limit = 100000000 },Whois, nil)
end
end
GetUser(id,Whois)
end
--[[function GetPro(FreemanagerBOT, result)
 if result.photos[0] then
print('persistent_id : '..result.photos[0].sizes[2].photo.persistent_id)  
sendPhoto(msg.chat_id, msg.id, 0, 1, nil, result.photos[0].sizes[2].photo.persistent_id,'>شناسه گروه: ['..msg.chat_id..']\nشناسه شما: ['..msg.sender_user_id..']\n>تعداد پیغام های ارسالی شما: ['..Msgs..']')
else
sendText(msg.chat_id, msg.id,  '>شناسه گروه ['..msg.chat_id..']\nشناسه شما ['..msg.sender_user_id..']\n>تعداد پیغام های ارسالی شما: ['..Msgs..']', 'md')
print '                      Not Photo                      ' 
end
end]]
--[[if text == 'setlinkgroup' then
function getlinkgroup(arg,data)
	local link = data.invite_link
	sendText(msg.chat_id, 0,link ,'html')
end
getChannelFull(msg.chat_id,getlinkgroup)
end]]
-------------------------------
if text == 'link' or text == 'لینک گروه' then
local link = redis:get('Link:'..msg.chat_id) 
if link then
sendText(msg.chat_id,msg.id,  '<code>>لینک ورود به ابرگروه:</code> \n'..link..'', 'html')
else
sendText(msg.chat_id, msg.id, '<code>>لینک ورود به گروه تنظیم نشده است.</code>\n<code>ثبت لینک جدید با دستور</code>\n<b>/setlink</b> <i>link</i>\n<code>امکان پذیر است.</code>', 'html')
end
end
if text == 'rules' or text == 'قوانین گروه' then
local rules = redis:get('Rules:'..msg.chat_id) 
if rules then
sendText(msg.chat_id,msg.id,  '<code>>قوانین ابرگروه:</code> \n'..rules..'\n\n', 'html')
else
sendText(msg.chat_id, msg.id, '<code>>قوانین برای گروه تنظیم نشده است.</code>', 'html')
end
end
end
end
end
 --#########################################################################--
 --if msg then
----------------------------------------------------------------------------
---#######################################################################--
------FreemanagerBOT---------
if text  then
local function cb(a,b,c)
redis:set('BOT-ID',b.id)
end
getMe(cb)
end
if msg.sender_user_id == TD_ID then
redis:incr("Botmsg")
end
redis:incr("allmsgs")
if msg.chat_id then
      local id = tostring(msg.chat_id) 
      if id:match('-100(%d+)') then
        if not redis:sismember("ChatSuper:Bot",msg.chat_id) then
          redis:sadd("ChatSuper:Bot",msg.chat_id)
        end
----------------------------------
elseif id:match('^-(%d+)') then
if not  redis:sismember("Chat:Normal",msg.chat_id) then
redis:sadd("Chat:Normal",msg.chat_id)
end 
-----------------------------------------
elseif id:match('') then
if not redis:sismember("ChatPrivite",msg.chat_id) then;redis:sadd("ChatPrivite",msg.chat_id);end;else
if not redis:sismember("ChatSuper:Bot",msg.chat_id) then
redis:sadd("ChatSuper:Bot",msg.chat_id);end;end;end;end;end
function tdbot_update_callback(data)
if (data._ == "updateNewMessage") or (data._ == "updateNewChannelMessage") then
showedit(data.message,data)
 local msg = data.message
--print(msg)
if msg.sender_user_id  and redis:get('MuteAll:'..msg.chat_id) and not is_Mod(msg) then
print  'Lock mutechat'
redis:sadd('Mutes:'..msg.chat_id,msg.sender_user_id)
deleteMessages(msg.chat_id, {[0] = msg.id})
mute(msg.chat_id,msg.sender_user_id,'Restricted',   {1, 0, 0, 0, 0,0})
end
if msg.sender_user_id  and not redis:get('MuteAll:'..msg.chat_id) then
--print  'unLock mutechat'
redis:del('MuteAll:'..msg.chat_id)
local mutes =  redis:smembers('Mutes:'..msg.chat_id)
for k,v in pairs(mutes) do
redis:srem('Mutes:'..msg.chat_id,v)
mute(msg.chat_id,v,'Restricted',   {1, 1, 1, 1, 1,1})
end
end
if msg.sender_user_id  and redis:get('MuteAlllimit:'..msg.chat_id) and not is_Mod(msg) then
print  'Lock mutechatlimit'
deleteMessages(msg.chat_id, {[0] = msg.id})
end
if msg.sender_user_id  and  redis:sismember('MuteList:'..msg.chat_id,msg.sender_user_id) then
print  'Lock silentuser'
deleteMessages(msg.chat_id, {[0] = msg.id})
end
elseif (data._== "updateMessageEdited") then
showedit(data.message,data)
data = data
local function edit(Freemanager,alirezaPT,BOT)
showedit(alirezaPT,data)
end;assert (tdbot_function ({_ = "getMessage", chat_id = data.chat_id,message_id = data.message_id }, edit, nil));assert (tdbot_function ({_ = "openChat",chat_id = data.chat_id}, dl_cb, nil) );assert (tdbot_function ({ _ = 'openMessageContent',chat_id = data.chat_id,message_id = data.message_id}, dl_cb, nil));assert (tdbot_function ({_="getChats",offset_order="9223372036854775807",offset_chat_id=0,limit=20}, dl_cb, nil));end;end
------END FREEMANAGERBOT PROJECT-------
