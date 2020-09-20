#!/usr/bin/env bash 

echo setting up traps
trap "exit" INT TERM ERR
trap "rm /tmp/ngrok-logs; kill 0" EXIT

session_name=livestream
gotty_port=7777
echo getting password
password=$(dd if=/dev/urandom count=1024 | tr -dc 'a-zA-Z0-9' | fold -w 32 | head -n 1)

echo starting gotty
gotty -w -c user:$password --port "$gotty_port" tmux new -A -s "$session_name" 2>/dev/null >/dev/null &

ngrok http --log stdout "$gotty_port" 2> /dev/null >/tmp/ngrok-logs &

echo waiting for tunnel to start
url=""
sleep 1
while [ -z "$url" ];do
   echo grepping for url
   url=`grep "started tunnel" /tmp/ngrok-logs | grep https | sed 's/.*url=//' `
   sleep 1
done

tmux new-session -A -s $session_name "echo Share link: $url; echo username: user; echo password: $password; bash"
exit 0
