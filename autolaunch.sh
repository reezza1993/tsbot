#!/bin/bash
COUNTER=1
while(true) do
./launch run
curl "https://api.telegram.org/bot491157232:AAHqxcAOWICz0sBE8godQi0uyM3cgLXmhKQ/sendmessage" -F "chat_id=159887854" -F "text=#NEWCRASH-#BOT-Reloaded-${COUNTER}-times"
let COUNTER=COUNTER+1 
done