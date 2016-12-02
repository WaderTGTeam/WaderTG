function run(msg, matches)
local url , res = http.request('http://api.gpmod.ir/time/')
if res ~= 200 then return "اتصال قطع می باشد" end
local jdat = json:decode(url)
local text = 'ساعت🕕: '..jdat.FAtime..' \nامروز📆: '..jdat.FAdate..'\n------------------\n⬇️🕕ساعت انگلیسی🕕⬇️\n------------------\nTime🕕: '..jdat.ENtime..'\nToday📆: '..jdat.ENdate.. '\n------------------\n@WaderTGTeam'
return text
end
return {
  patterns = {"^(ساعت)$"}, 
run = run 
}
