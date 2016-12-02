do
local function pre_process(msg)
 local hash = 'muteall:'..msg.to.id
  if redis:get(hash) and msg.to.type == 'channel' and not is_momod(msg)  then
   delete_msg(msg.id, ok_cb, false)
       end
    return msg
 end
 
local function run(msg, matches)
 if matches[1] == 'بیصدا همه' and is_momod(msg) then
       local hash = 'muteall:'..msg.to.id
       if not matches[2] then
              redis:set(hash, true)
             return "بیصدا همه فعال شد"
 else
local hour = string.gsub(matches[2], 'h', '')
 local num1 = tonumber(hour) * 3600
local minutes = string.gsub(matches[3], 'm', '')
 local num2 = tonumber(minutes) * 60
local second = string.gsub(matches[4], 's', '')
 local num3 = tonumber(second) 
local num4 = tonumber(num1 + num2 + num3)
redis:setex(hash, num4, true)
 return "بیصدا همه فعال شد به مدت\n"..matches[2].."ساعت\n"..matches[3].."دقیقه\n"..matches[4].."ثانیه"
 end
 end
if matches[1] == 'باصدا همه' and is_momod(msg) then
               local hash = 'muteall:'..msg.to.id
        redis:del(hash)
          return "بیصدا همه غیرفعال شد!"
  end
end
return {
   patterns = {
      '^(بیصدا همه)$',
      '^(باصدا همه)$',
   '^(بیصدا همه) (.*) (.*) (.*)$',
 },
run = run,
  pre_process = pre_process
}
end
