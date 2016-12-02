do
    
function run(msg, matches)
  if matches[1] == "ریبوت" and is_sudo(msg) then
        return 'این پلاگین غیرفعال میباشد!'  -- Dont enable it,if you use Free online servers!
  elseif matches[1] == "سرور" and is_sudo(msg) then
                      -- change this location if you use another source/location !
     local f = io.popen("sh /root/WaderTG/data/server/serverinfo.sh") 
     return ( f:read("*a") ) --read all of the results and return it !
  end
end
return {
  patterns = {
    "^(ریبوت)",
    "^(سرور)",
  },
  run = run
}
end

