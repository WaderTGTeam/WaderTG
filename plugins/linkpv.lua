do

function run(msg, matches)
       if not is_momod(msg) then
        return "فقط مدیران می توانند شما دسترسی ندارید!"
       end
	  local data = load_data(_config.moderation.data)
      local group_link = data[tostring(msg.to.id)]['settings']['set_link']
       if not group_link then 
        return "ابتدا لینک جدید بسازید"
       end
         local text = "لینک گروه : ["..msg.to.print_name:gsub("_"," ").."] \n"..group_link
        send_large_msg('user#id'..msg.from.id, text.."\n", ok_cb, false)
        return "لینک گروه به خصوصی شما ارسال شد!"
end

return {
  patterns = {
    "^لینک خصوصی"
  },
  run = run
}

end
