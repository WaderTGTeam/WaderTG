do

local function run(msg, matches)
  if matches[1] == 'من کیم' then
    if is_sudo(msg) then
    --send_document(get_receiver(msg), "./data/me/version.webp", ok_cb, false)
      return "شما مدیر کل (sudo) ربات WaderTG هستید😘"
    elseif is_admin1(msg) then
    --send_document(get_receiver(msg), "./data/me/admin.webp", ok_cb, false)
      return "شما ادمین (admin) هستید😏"
    elseif is_owner(msg) then
    --send_document(get_receiver(msg), "./data/me/owner.webp", ok_cb, false)
      return "شما مدیر (owner) اصلی گروه هستید😮"
    elseif is_momod(msg) then
    --send_document(get_receiver(msg), ". data/me/mod.webp", ok_cb, false)
      return "شما دستیار مدیر گروه هستید😕"
    else
    --send_document(get_receiver(msg), "./data/me/mmbr.webp", ok_cb, false)
      return "شما کاربر عادی (member) هستید😒"
    end
  end
end

return {
  patterns = {
    "^(من کیم)$",
    },
  run = run
}
end
