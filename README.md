# Some simple scripts for collaborating on the command line


## Installing dependencies ##
```
sudo apt install tmux
snap install go --classic
go get github.com/yudai/gotty
snap install ngrok
snap install --classic asciinema
sudo apt install alsa-utils
sudo apt install vorbis-tools
sudo apt install sox

# not a dependency, but you'll need to add ~/go/bin to your PATH
echo -e '\nexport PATH=$PATH:$HOME/go/bin' >> ~/.bashrc
source ~/.bashrc
```

# Running the scripts
## ./share-terminal.sh
This script is similar to sharing your screen on a video call, but it shares just your terminal. It's all text based so it's good for low bandwidth settings. When you start the session your get a URL, useranme, and password that can be sent to person you want to share your terminal with. 

*Warning anyone with the URL and password will have control of your terminal*
![share termina](assets/share-terminal.png)

When you're done sharing just type `exit`.

This script is implemented by wiring together [tmux](https://github.com/tmux/tmux/wiki), [gotty](https://github.com/yudai/gotty), and [ngrok](https://ngrok.com/).

## ./record-terminal.sh
This script records your terminal and your mic audio at the same time. To do this, it starts [asciinema](https://asciinema.org/) and [arecord](https://linux.die.net/man/1/arecord) at the same time and saves the output to a tar file. (It also encodes the audio with [oggenc](https://linux.die.net/man/1/oggenc)).
```
./record-termina.sh output.rec
```
When you're finished recording type exit. Asciinema will output some info about where the file is stored, but just ignore this.

## ./play-terminal.sh
Plays the output from `./record-terminal.sh`

```
./play-recording.sh output.rec
```