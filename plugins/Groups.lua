local function chat_list(msg)
    local data = load_data(_config.moderation.data)
        local groups = 'groups'
        if not data[tostring(groups)] then
                return 'هیچ گروهی وجود ندارد!'
        end
        local message = 'لیست گروه های ربات شما می توانید برای پیوستن به گروه های ربات با استفاده از {جوین ایدی گروه} ویا {لینک ایدی گروه} می توانید به گروه های ربات ملحق شود!'
        for k,v in pairs(data[tostring(groups)]) do
                local settings = data[tostring(v)]['settings']
                for m,n in pairsByKeys(settings) do
                        if m == 'set_name' then
                                name = n
                        end
                end

                message = message .. '\n\n👥'.. name .. ' (ایدی: ' .. v .. ')\n'
        end
        local file = io.open("./groups/lists/listed_groups.txt", "w")
        file:write(message)
        file:flush()
        file:close()
        return message
end
local function run(msg, matches)
  if msg.to.type ~= 'chat' or is_sudo(msg) and is_realm(msg) then
	 local data = load_data(_config.moderation.data)
  if is_sudo(msg) or is_momod(msg) then
    if matches[1] == 'لینک' and data[tostring(matches[2])] then
        if is_banned(msg.from.id, matches[2]) then
	    return 'شما نمی توانید وارد شوید شما از قبل در این گروه بن شده اید!'
	 end
      if is_gbanned(msg.from.id) then
            return 'شما نمی توانید وارد شوید شما سوپربن شده اید!'
      end
      if data[tostring(matches[2])]['settings']['lock_member'] == 'yes' and not is_owner2(msg.from.id, matches[2]) then
        return 'گروه خصوصی است!'
      end
          local chat_id = "chat#id"..matches[2]
          local user_id = "user#id"..msg.from.id
   	  chat_add_user(chat_id, user_id, ok_cb, false)   
	  local group_link = data[tostring(matches[2])]['settings']['set_link']
      local group_name = data[tostring(matches[2])]['settings']['set_name']
	  return "لینک گروه:\n"..group_link.."\n(نام گروه "..group_name..")\nساخته شده توسط: @WaderTGTeam"
	  
    elseif matches[1] == 'لینک' and not data[tostring(matches[2])] then

         	return "همچین گروهی وجود ندارد!"
         end
    end
  end

     if matches[1] == 'گروه' then
      if is_sudo(msg) and msg.to.type == 'chat' then
         return chat_list(msg)
       elseif msg.to.type ~= 'chat' then
         return chat_list(msg)
      end
 end

 end
return {
    description = "See link of a group and groups list",
    usage = "!link ID && !groups",
patterns = {
	"^(لینک) (.*)$",
	"^(گروه)$",
	},
run = run
}
