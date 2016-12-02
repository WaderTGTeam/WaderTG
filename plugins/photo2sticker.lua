local function tosticker(msg, success, result)
  local receiver = get_receiver(msg)
  if success then
    local file = 'data/stickers/sticker.webp'
    print('File downloaded to:', result)
    os.rename(result, file)
    print('File moved to:', file)
    send_document(get_receiver(msg), file, ok_cb, false)
    redis:del("photo:sticker")
  else
    print('Error downloading: '..msg.id)
    send_large_msg(receiver, 'Failed, please try again!', ok_cb, false)
  end
end
local function run(msg,matches)
    local receiver = get_receiver(msg)
    local group = msg.to.id
    if msg.media then
       if msg.media.type == 'photo' and redis:get("photo:sticker") then
        if redis:get("photo:sticker") == 'waiting' then
          load_photo(msg.id, tosticker, msg)
        end
       end
    end
    if matches[1] == "به استیکر" then
     redis:set("photo:sticker", "waiting")
     return 'لطفا عکس مورد نظر را ارسال فرمایید'
    end
end
return {
  patterns = {
 "^(به استیکر)$",
 "%[(photo)%]",
  },
  run = run,
}
-- by channel: @WaderTGTeam
