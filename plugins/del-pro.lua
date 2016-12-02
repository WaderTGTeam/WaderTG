local function history(extra, suc, result) 
  for i=1, #result do 
    delete_msg(result[i].id, ok_cb, false) 
  end 
  if tonumber(extra.con) == #result then 
    send_msg(extra.chatid, '"'..#result..'" 🔱پیام اخیر سوپر گروه حذف شد🔱', ok_cb, false) 
  else 
    send_msg(extra.chatid, '\n🔱پیام های مورد نظر پاکسازی شدند', ok_cb, false) 
  end 
end 
local function run(msg, matches) 
if redis:get("id:"..msg.to.id..":"..msg.from.id) then
return "شما میتوانید هر 1 ساعت یکبار از این دستور استفاده کنید"
end
redis:setex("id:"..msg.to.id..":"..msg.from.id, 3600, true)
  if matches[1] == 'حذف پیام' and is_owner(msg) then 
    if msg.to.type == 'channel' then 
      if tonumber(matches[2]) > 100 or tonumber(matches[2]) < 1 then 
        return "تعداد بیشتر از 100 مجاز نیست" 
      end 
      get_history(msg.to.peer_id, matches[2] + 1 , history , {chatid = msg.to.peer_id, con = matches[2]}) 
    else 
      return "فقط در سوپرگروه ممکن است" 
    end 
  else 
    return "شما دسترسی ندارید" 
  end 
end 

return { 
    patterns = { 
        '^(حذف پیام) (%d*)$' 
    }, 
    run = run 
} 
