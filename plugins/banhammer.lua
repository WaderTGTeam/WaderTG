local function pre_process(msg)
  local data = load_data(_config.moderation.data)
  -- SERVICE MESSAGE
  if msg.action and msg.action.type then
    local action = msg.action.type
    -- Check if banned user joins chat by link
    if action == 'chat_add_user_link' then
      local user_id = msg.from.id
      print('درحال چک کردن کابران دعوت داده شده '..user_id)
      local banned = is_banned(user_id, msg.to.id)
      if banned or is_gbanned(user_id) then -- Check it with redis
      print('این کاربر بن شده است!')
      local print_name = user_print_name(msg.from):gsub("‮", "")
	  local name = print_name:gsub("_", "")
      savelog(msg.to.id, name.." ["..msg.from.id.."] کاربر اخراج و بن شد!")-- Save to logs
      kick_user(user_id, msg.to.id)
      end
    end
    -- Check if banned user joins chat
    if action == 'chat_add_user' then
      local user_id = msg.action.user.id
      print('در حال چک کردن کاربران دعوت داده شده '..user_id)
      local banned = is_banned(user_id, msg.to.id)
      if banned and not is_momod2(msg.from.id, msg.to.id) or is_gbanned(user_id) and not is_admin2(msg.from.id) then -- Check it with redis
        print('این کاربر بن شده است!')
      local print_name = user_print_name(msg.from):gsub("‮", "")
	  local name = print_name:gsub("_", "")
        savelog(msg.to.id, name.." ["..msg.from.id.."] کاربران ممنوع عضویت شدند >"..msg.action.user.id)-- Save to logs
        kick_user(user_id, msg.to.id)
        local banhash = 'کاربران ممنوع عضویت شدند:'..msg.to.id..':'..msg.from.id
        redis:incr(banhash)
        local banhash = 'کاربران ممنوع عضویت شدند:'..msg.to.id..':'..msg.from.id
        local banaddredis = redis:get(banhash)
        if banaddredis then
          if tonumber(banaddredis) >= 4 and not is_owner(msg) then
            kick_user(msg.from.id, msg.to.id)-- Kick user who adds ban ppl more than 3 times
          end
          if tonumber(banaddredis) >=  8 and not is_owner(msg) then
            ban_user(msg.from.id, msg.to.id)-- Kick user who adds ban ppl more than 7 times
            local banhash = 'کاربران ممنوع عضویت شدند:'..msg.to.id..':'..msg.from.id
            redis:set(banhash, 0)-- Reset the Counter
          end
        end
      end
     if data[tostring(msg.to.id)] then
       if data[tostring(msg.to.id)]['settings'] then
         if data[tostring(msg.to.id)]['settings']['lock_bots'] then
           bots_protection = data[tostring(msg.to.id)]['settings']['lock_bots']
          end
        end
      end
    if msg.action.user.username ~= nil then
      if string.sub(msg.action.user.username:lower(), -3) == 'bot' and not is_momod(msg) and bots_protection == "yes" then --- Will kick bots added by normal users
          local print_name = user_print_name(msg.from):gsub("‮", "")
		  local name = print_name:gsub("_", "")
          savelog(msg.to.id, name.." ["..msg.from.id.."] ربات دعوت داده شد :ایدی ربات > @".. msg.action.user.username)-- Save to logs
          kick_user(msg.action.user.id, msg.to.id)
      end
    end
  end
    -- No further checks
  return msg
  end
  -- banned user is talking !
  if msg.to.type == 'chat' or msg.to.type == 'channel' then
    local group = msg.to.id
    local texttext = 'groups'
    --if not data[tostring(texttext)][tostring(msg.to.id)] and not is_realm(msg) then -- Check if this group is one of my groups or not
    --chat_del_user('chat#id'..msg.to.id,'user#id'..our_id,ok_cb,false)
    --return
    --end
    local user_id = msg.from.id
    local chat_id = msg.to.id
    local banned = is_banned(user_id, chat_id)
    if banned or is_gbanned(user_id) then -- Check it with redis
      print('به علت این که صحبت کردن ممنوع بود کاربر بن شد!')
      local print_name = user_print_name(msg.from):gsub("‮", "")
	  local name = print_name:gsub("_", "")
      savelog(msg.to.id, name.." ["..msg.from.id.."] به علت این که صحبت کردن ممنوع بود کاربر بن شد!")-- Save to logs
      kick_user(user_id, chat_id)
      msg.text = ''
    end
  end
  return msg
end

local function banall_by_reply(extra, success, result)
	if result.to.peer_type == 'chat' or result.to.peer_type == 'channel' then
		local chat = 'chat#id'..result.to.peer_id
		local channel = 'channel#id'..result.to.peer_id
	if tonumber(result.from.peer_id) == tonumber(our_id) then -- Ignore bot
			return
	end
	if is_admin2(result.from.peer_id) then -- Ignore admins
		return
	end
		banall_user(result.from.peer_id)
		send_large_msg(chat, "کاربر "..result.from.peer_id.." سوپربن شد!")
		send_large_msg(channel, "کاربر از تمام گروه های ربات سوپربن شد ایدی : "..result.from.peer_id)
	else
		return
	end
end

local function unbanall_by_reply(extra, success, result)
	if result.to.peer_type == 'chat' or result.to.peer_type == 'channel' then
	local user_id = result.from.peer_id
		local chat = 'chat#id'..result.to.peer_id
		local channel = 'channel#id'..result.to.peer_id
	if tonumber(result.from.peer_id) == tonumber(our_id) then -- Ignore bot
			return
	end
	if is_admin2(result.from.peer_id) then -- Ignore admins
		return
	end
     if not is_gbanned(result.from.peer_id) then
       return result.from.peer_id..' is already un-Gbanned.'
      end
	  if is_gbanned(result.from.peer_id) then
		unbanall_user(result.from.peer_id)
		send_large_msg(chat, "کاربر "..result.from.peer_id.." ان سوپربن شد!")
		send_large_msg(channel, "کاربر از تمام گروه های ربات ان سوپربن شد ایدی : "..result.from.peer_id)
	end
	end
end

local function unban_by_reply(extra, success, result)
	if result.to.peer_type == 'chat' or result.to.peer_type == 'channel' then
		local chat = 'chat#id'..result.to.peer_id
		local channel = 'channel#id'..result.to.peer_id
	if tonumber(result.from.peer_id) == tonumber(our_id) then -- Ignore bot
			return
	end
	if is_admin2(result.from.peer_id) then -- Ignore admins
		return
	end
		send_large_msg(chat, "کاربر "..result.from.peer_id.." ان بن شد!")
		send_large_msg(channel, "کاربر ان بن شد ایدی: "..result.from.peer_id)
		local hash =  'banned:'..result.to.peer_id
		redis:srem(hash, result.from.peer_id)
	else
		return
	end
end

local function kick_ban_res(extra, success, result)
      local chat_id = extra.chat_id
	  local chat_type = extra.chat_type
	  if chat_type == "chat" then
		receiver = 'chat#id'..chat_id
	  else
		receiver = 'channel#id'..chat_id
	  end
	  if success == 0 then
		return send_large_msg(receiver, "می توانید کاربر را با ایدی یا یوزرنیم پیدا کنید!")
	  end
      local member_id = result.peer_id
      local user_id = member_id
      local member = result.username
	  local from_id = extra.from_id
      local get_cmd = extra.get_cmd
       if get_cmd == "اخراج" then
         if member_id == from_id then
            send_large_msg(receiver, "شما می توانید با تایپ کلمه  اخراج کاربر را از گروه اخراج کنید!")
			return
         end
         if is_momod2(member_id, chat_id) and not is_admin2(sender) then
            send_large_msg(receiver, "فقط مدیران می توانند شما دسترسی ندارید!")
			return
         end
		 kick_user(member_id, chat_id)
      elseif get_cmd == 'ban' then
        if is_momod2(member_id, chat_id) and not is_admin2(sender) then
			send_large_msg(receiver, "فقط مدیران می توانند شما دسترس ی ندارید!")
			return
        end
        send_large_msg(receiver, 'کاربر @'..member..' ['..member_id..'] بن شد!')
		ban_user(member_id, chat_id)
      elseif get_cmd == 'unban' then
        send_large_msg(receiver, 'کاربر @'..member..' ['..member_id..'] ان بن شد!') 
        local hash =  'بن شد:'..chat_id
        redis:srem(hash, member_id)
        return 'کاربر '..user_id..' ان بن شد!'
      elseif get_cmd == 'banall' then
        send_large_msg(receiver, 'کاربر @'..member..' ['..member_id..'] از تمام گروه های ربات سوپربن شد')
		banall_user(member_id)
      elseif get_cmd == 'unbanall' then
        send_large_msg(receiver, 'کاربر @'..member..' ['..member_id..'] از تمام گروه های ربات ان سوپربن شد')
	    unbanall_user(member_id)
    end
end

local function run(msg, matches)
local support_id = msg.from.id
 if matches[1]:lower() == 'id' and msg.to.type == "chat" or msg.to.type == "user" then
    if msg.to.type == "user" then
      return "<code>ایدی ربات:</code> <b>"..msg.to.id.."</b>\n\n<code>ایدی شما:</code> <b>"..msg.from.id.."</b>"
    end
    if type(msg.reply_id) ~= "nil" then
      local print_name = user_print_name(msg.from):gsub("‮", "")
	  local name = print_name:gsub("_", "")
        savelog(msg.to.id, name.." ["..msg.from.id.."]  با استفاده از ایدی می توانید")
        id = get_message(msg.reply_id,get_message_callback_id, false)
    elseif matches[1]:lower() == 'ایدی' then
      local name = user_print_name(msg.from)
      savelog(msg.to.id, name.." ["..msg.from.id.."] با استفاده از ایدی می توانید ")
      return "نام شما: " ..msg.from.first_name.. "\n نام کوچک شما: "..(msg.from.last_name or '').."\nیوزرنیم شما: telegram.me/" ..(msg.from.username or '').. "\nایدی شما: " ..msg.from.id.. "\nشماره تلفن شما: +"..(msg.from.phone or '').."\n\nنام گروه: " ..msg.to.title.."\nایدی گروه: "..msg.to.id.."\n\n@WaderTGTeam"
    end
  end
  if matches[1]:lower() == 'خروج' and msg.to.type == "chat" then-- /kickme
  local receiver = get_receiver(msg)
    if msg.to.type == 'chat' then
      local print_name = user_print_name(msg.from):gsub("‮", "")
	  local name = print_name:gsub("_", "")
      savelog(msg.to.id, name.." ["..msg.from.id.."] کاربر با استفاده از خروج از گروه رفت! ")-- Save to logs
      chat_del_user("chat#id"..msg.to.id, "user#id"..msg.from.id, ok_cb, false)
    end
  end

  if not is_momod(msg) then -- Ignore normal users
    return
  end

  if matches[1]:lower() == "بن لیست" then -- Ban list !
    local chat_id = msg.to.id
    if matches[2] and is_admin1(msg) then
      chat_id = matches[2]
    end
    return ban_list(chat_id)
  end
  if matches[1]:lower() == 'بن' then-- /ban
    if type(msg.reply_id)~="nil" and is_momod(msg) then
      if is_admin1(msg) then
		msgr = get_message(msg.reply_id,ban_by_reply_admins, false)
      else
        msgr = get_message(msg.reply_id,ban_by_reply, false)
      end
      local user_id = matches[2]
      local chat_id = msg.to.id
    elseif string.match(matches[2], '^%d+$') then
        if tonumber(matches[2]) == tonumber(our_id) then
         	return
        end
        if not is_admin1(msg) and is_momod2(matches[2], msg.to.id) then
          	return "فقط مدیران می توانند شما دسترسی ندارید!"
        end
        if tonumber(matches[2]) == tonumber(msg.from.id) then
          	return "شما می توانید با تایپ کلمه اخراج کاربر را از گروه اخراج کنید!"
        end
        local print_name = user_print_name(msg.from):gsub("‮", "")
	    local name = print_name:gsub("_", "")
		local receiver = get_receiver(msg)
        savelog(msg.to.id, name.." ["..msg.from.id.."] کاربر بن شد ".. matches[2])
        ban_user(matches[2], msg.to.id)
		send_large_msg(receiver, 'کاربر ['..matches[2]..'] بن شد ')
      else
		local cbres_extra = {
		chat_id = msg.to.id,
		get_cmd = 'ban',
		from_id = msg.from.id,
		chat_type = msg.to.type
		}
		local username = string.gsub(matches[2], '@', '')
		resolve_username(username, kick_ban_res, cbres_extra)
    end
  end


  if matches[1]:lower() == 'ان بن' then -- /unban
    if type(msg.reply_id)~="nil" and is_momod(msg) then
      local msgr = get_message(msg.reply_id,unban_by_reply, false)
    end
      local user_id = matches[2]
      local chat_id = msg.to.id
      local targetuser = matches[2]
      if string.match(targetuser, '^%d+$') then
        	local user_id = targetuser
        	local hash =  'بن شد:'..chat_id
        	redis:srem(hash, user_id)
        	local print_name = user_print_name(msg.from):gsub("‮", "")
			local name = print_name:gsub("_", "")
        	savelog(msg.to.id, name.." ["..msg.from.id.."] کاربر ان بن شد ".. matches[2])
        	return 'کاربر '..user_id..' ان بن شد'
      else
		local cbres_extra = {
			chat_id = msg.to.id,
			get_cmd = 'unban',
			from_id = msg.from.id,
			chat_type = msg.to.type
		}
		local username = string.gsub(matches[2], '@', '')
		resolve_username(username, kick_ban_res, cbres_extra)
	end
 end

if matches[1]:lower() == 'اخراج' then
    if type(msg.reply_id)~="nil" and is_momod(msg) then
      if is_admin1(msg) then
        msgr = get_message(msg.reply_id,Kick_by_reply_admins, false)
      else
        msgr = get_message(msg.reply_id,Kick_by_reply, false)
      end
	elseif string.match(matches[2], '^%d+$') then
		if tonumber(matches[2]) == tonumber(our_id) then
			return
		end
		if not is_admin1(msg) and is_momod2(matches[2], msg.to.id) then
			return "فقط مدیران می توانند شما دسترسی ندارید!"
		end
		if tonumber(matches[2]) == tonumber(msg.from.id) then
			return "شما می توانید با تایپ کلمه اخراج کاربر را از گروه اخراج کنید!"
		end
    local user_id = matches[2]
    local chat_id = msg.to.id
    print("sexy")
		local print_name = user_print_name(msg.from):gsub("‮", "")
		local name = print_name:gsub("_", "")
		savelog(msg.to.id, name.." ["..msg.from.id.."] کاربر اخراج شد ".. matches[2])
		kick_user(user_id, chat_id)
	else
		local cbres_extra = {
			chat_id = msg.to.id,
			get_cmd = 'اخراج',
			from_id = msg.from.id,
			chat_type = msg.to.type
		}
		local username = string.gsub(matches[2], '@', '')
		resolve_username(username, kick_ban_res, cbres_extra)
	end
end


	if not is_admin1(msg) and not is_support(support_id) then
		return
	end

  if matches[1]:lower() == 'سوپربن' and is_admin1(msg) then -- Global ban
    if type(msg.reply_id)~="nil" and is_momod(msg) then
      if is_admin1(msg) then
		msgr = get_message(msg.reply_id,banall_by_reply, false)
      end
      local user_id = matches[2]
      local chat_id = msg.to.id
    elseif string.match(matches[2], '^%d+$') then
        if tonumber(matches[2]) == tonumber(our_id) then
         	return
        end
		if not is_admin1(msg) and is_momod2(matches[2], msg.to.id) then
			return "فقط مدیران می توانند شما دسترسی ندارید"
		end
        if tonumber(matches[2]) == tonumber(msg.from.id) then
          	return "شما می توانید با تایپ کلمه اخراج کاربر را از گروه اخراج کنید!"
        end
        local print_name = user_print_name(msg.from):gsub("‮", "")
	    local name = print_name:gsub("_", "")
		local receiver = get_receiver(msg)
        savelog(msg.to.id, name.." ["..msg.from.id.."] banedall user ".. matches[2])
        banall_user(matches[2])
        	banall_user(targetuser)
       		return 'کاربر ['..user_id..' ] از تمام گروه های ربات سوپربن شد'
     else
	local cbres_extra = {
		chat_id = msg.to.id,
		get_cmd = 'banall',
		from_id = msg.from.id,
		chat_type = msg.to.type
	}
		local username = string.gsub(matches[2], '@', '')
		resolve_username(username, kick_ban_res, cbres_extra)
      end
  end
  if matches[1]:lower() == 'ان سوپربن' then -- Global unban
    if type(msg.reply_id)~="nil" and is_momod(msg) then
      if is_admin1(msg) then
		msgr = get_message(msg.reply_id,unbanall_by_reply, false)
      end
      local user_id = matches[2]
      local chat_id = msg.to.id
    elseif string.match(matches[2], '^%d+$') then
        if tonumber(matches[2]) == tonumber(our_id) then
         	return
        end
        local print_name = user_print_name(msg.from):gsub("‮", "")
	    local name = print_name:gsub("_", "")
		local receiver = get_receiver(msg)
        	return 'کاربر ['..user_id..' ] از تمام گروه های ربات ان سوپربن شد'
    else
		local cbres_extra = {
			chat_id = msg.to.id,
			get_cmd = 'unbanall',
			from_id = msg.from.id,
			chat_type = msg.to.type
		}
		local username = string.gsub(matches[2], '@', '')
		resolve_username(username, kick_ban_res, cbres_extra)
      end
  end
  if matches[1]:lower() == "لیست سوپربن" then -- Global ban list
    return banall_list()
  end
end

return {
  patterns = {
    "^(سوپربن) (.*)$",
    "^(سوپربن)$",
    "^(بن لیست) (.*)$",
    "^(بن لیست)$",
    "^(لیست سوپربن)$",
	"^(خروج)",
    "^(اخراج)$",
	"^(بن)$",
    "^(بن) (.*)$",
    "^(ان بن) (.*)$",
    "^(ان سوپربن) (.*)$",
    "^(ان سوپربن)$",
    "^(اخراج) (.*)$",
    "^(ان بن)$",
    "^(ایدی)$",
    "^!!tgservice (.+)$"
  },
  run = run,
  pre_process = pre_process
}
