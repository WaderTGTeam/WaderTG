#Bot Links
#[WaderTG](https://telegram.me/WaderTG)
#Bot channels Links
#[WaderTGTeam](https://telegram.me/WaderTGTeam) 
# Installation
```sh
sudo apt-get update
sudo apt-get upgrade
sudo apt-get install libreadline-dev libconfig-dev libssl-dev lua5.2 liblua5.2-dev lua-socket lua-sec lua-expat libevent-dev make unzip git redis-server autoconf g++ libjansson-dev libpython-dev expat libexpat1-dev

cd $HOME
git clone https://github.com/WaderTGTeam/WaderTG-CLI.git
cd WaderTG-CLI
chmod +x launchfix2.sh
chmod +x launch.sh
chmod +x autolaunch.sh
./launchfix2.sh install
cd .luarocks
cd bin
./luarocks-5.2 install luafilesystem
./luarocks-5.2 install lub
./luarocks-5.2 install luaexpat
cd $HOME
cd WaderTG-CLI
./launchfix2.sh install
./autolaunch.sh
Then Enter Your Phone And Confirmation Code
```
#Run bot in auto launch.sh
```
chmod 777 WaderTG.sh
screen ./WaderTG.sh
```
#Developer #Translation
#By: [@mmwda_s](https://telegram.me/mmwda_s)
