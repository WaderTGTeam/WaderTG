local function run(msg, matches)
  local text = matches[1]
  local b = 1
  while b ~= 0 do
    text = text:trim()
    text,b = text:gsub('^!+','')
  end
    if not is_sudo(msg)then
    return 'فقط مدیران اصلی ربات می توانند پلاگین اضافه کنند😕'
  end
  local name = matches[2]
  local file = io.open("./plugins/"..name, "w")
  file:write(text)
  file:flush()
  file:close()
  return "پلاگین در سرور ذخیره شد!"
 end
 return {
  description = "a Usefull plugin for sudo !",
  usage = "A plugins to add Another plugins to the server",
  patterns = {
    "^اضافه پلاگین (.+) (.*)$"
  },
  run = run
}
