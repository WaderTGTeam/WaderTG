local function sudoteam(msg, matches)
local mtn = matches[2]
local link = matches[3]
if not is_momod(msg) then
return 'شما دسترسی ندارید'
end
if matches[1] == 'بولد' then
  return '<b>'..mtn..'</b>'

elseif matches[1] == 'کد' then
  return '<code>'..mtn..'</code>'

elseif matches[1] == 'هایپر' then
  return '<a href="'..link..'">'..mtn..'</a>'
elseif matches[1] == 'کج' then
  return '<i>'..mtn..'</i>'
end
end
return {
  description = "تست", 
  usage = "تست",
  patterns = {
    "^(کد) (.*)$",
    "^(کج) (.*)$",
    "^(بولد) (.*)$",
    "^(هایپر) (.*) (.*)$"
  }, 
  run = sudoteam 
}
