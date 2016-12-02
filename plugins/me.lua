do
--create by WaderTG ID CHANNEL : @WaderTGTeam
function run(msg, matches)
local reply_id = msg['id']

local info = '#نام شما : '..msg.from.first_name..'\n' 
..'#فامیل شما : '..(msg.from.last_name or '')..'\n'
..'#ایدی شما : '..msg.from.id..'\n'
..'#شماره تلفن : +'..(msg.from.phone or '')..'\n'
..'#یوزرنیم : telegram.me/'..(msg.from.username or '')..'\n\n'
..'#نام گروه : '..msg.to.title..'\n'
..'#ایدی گروه : '..msg.to.id..'\n\n@WaderTGTeam'

reply_msg(reply_id, info, ok_cb, false)
end

return {
patterns = {
"^مشخصات من"
--create by WaderTG ID CHANNEL : @WaderTGTeam
},
run = run
}

end
