#!/bin/bash

read -p "SPDIF Digital Surround - Run at your own risk (Y/N): " -n 1 -r
echo    # (optional) move to a new line
if [[ ! $REPLY =~ ^[Nn]$ ]]
then
	cp asoundrc asoundrc2
	sudo mv asoundrc2 ~/.asoundrc
	cp daemon.conf daemon.conf2
	sudo mv daemon.conf2 /etc/pulse/daemon.conf

        sudo apt-get -y install pavucontrol
        sudo apt-get -y install libavresample-dev

        cd /usr/share/alsa/alsa.conf.d
        sudo apt-get -y build-dep libasound2-plugins
        sudo apt-get -y install libavcodec-dev libavformat-dev
        mkdir ~/tmp
        cd ~/tmp
        apt-get source libasound2-plugins
        cd alsa-plugins-*
        ./configure
        libtoolize --force --copy && aclocal && autoconf && automake --add-missing && make
        cd a52/.libs
        sudo cp libasound_module_pcm_a52.la libasound_module_pcm_a52.so /usr/lib/alsa-lib/
        sudo cp libasound_module_pcm_a52.so /usr/lib/`uname -i`-linux-gnu/alsa-lib/
        sudo alsa reload
      
	systemctl --user restart pulseaudio
	rm -r ~/.config/pulse
	pulseaudio -k	
fi

