do
    local function run(msg, matches)
    local support = '1051969876'
    local data = load_data(_config.moderation.data)
    local name_log = user_print_name(msg.from)
        if matches[1] == 'پشتیبانی' then
        local group_link = data[tostring(support)]['settings']['set_link']
    return "لینک گروه پشتیبانی ربات: \n"..group_link
    end
end
return {
    patterns = {
    "^(پشتیبانی)$",
     },
    run = run
}
end
