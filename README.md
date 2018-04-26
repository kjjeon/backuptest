# Overview
This project development based on Mstar(MSD8834) that works on Linux is DIGITAL TV that is used in the kitchen.  

ui project list

* aquafina = 기본 제품
* bacardi = 업그레이드용 (boot 기본)
* cola = 패널 테스트용
* nebula = mstar referance
* delmonte = 중국 보드 양산용 테스트프로그램 


# Getting Started

The under mentioned text already are installed in the docker images **(artview/elephant)**. 

:zap: So you `have to pass Getting Started !!!`.


#### 1. Download Source
```
cd $HOME/project/
git clone ssh://git@gitlab.aview.co.kr:2222/avrnd/elephant.git
```

#### 2. Dockerfile
```
FROM m0elnx/ubuntu-32bit:latest
#persional setting
USER root
RUN apt-get update
RUN apt-get install -y python-setuptools
RUN apt-get install -y python-pip
RUN apt-get install -y build-essential
RUN apt-get install -y language-pack-ko
RUN apt-get install -y sudo
RUN apt-get install -y vim
RUN apt-get install -y silversearcher-ag
RUN apt-get install -y bzip2
RUN apt-get install -y ctags
RUN apt-get install -y bc
RUN apt-get install -y git
RUN apt-get install -y build-essential
RUN apt-get install -y libgtk2.0-0:i386
RUN apt-get install -y libsm6:i386
RUN apt-get install -y dos2unix
RUN apt-get install -y fakeroot
RUN apt-get install -y xauth
RUN apt-get install -y libncurses5-dev
RUN pip install --upgrade pip
RUN pip install termcolor
RUN pip install xlrd

RUN  useradd --create-home -s /bin/bash server
RUN  useradd --create-home -s /bin/bash kjjeon
RUN  useradd --create-home -s /bin/bash kilee
RUN  useradd --create-home -s /bin/bash whkong
RUN adduser kjjeon sudo
RUN adduser kilee sudo
RUN adduser whkong sudo
# Enable passwordless sudo for users under the "sudo" group
RUN sed -i.bkp -e \
      's/%sudo\s\+ALL=(ALL\(:ALL\)\?)\s\+ALL/%sudo ALL=NOPASSWD:ALL/g' \
      /etc/sudoers
#vim
USER kjjeon
RUN git clone http://giantant.mooo.com/kjjeon/ubuntu-property.git ~/ubuntu-property
RUN mkdir ~/.vim && git clone https://github.com/gmarik/Vundle.vim.git ~/.vim/bundle/Vundle.vim
RUN mkdir ~/.vim/undodir
RUN cp ~/ubuntu-property/.vimrc ~/
RUN cp -af ~/ubuntu-property/.vim/colors/ ~/.vim/
RUN vim +PluginInstall +qall
#property (kjjeon only)
USER kjjeon
RUN cp ~/ubuntu-property/.profile ~/
RUN cp ~/ubuntu-property/.gitconfig ~/
RUN cp ~/ubuntu-property/.bashrc ~/
RUN cp ~/ubuntu-property/.git-flow-completion.bash ~/

USER root
# set locale ko_KR
RUN locale-gen ko_KR.UTF-8

ENV LANG ko_KR.UTF-8
ENV LANGUAGE ko_KR.UTF-8
ENV LC_ALL ko_KR.UTF-8

# overwrite this with 'CMD []' in a dependent Dockerfile
CMD ["/bin/bash"]

```

#### 3. Build Dockerfile

create docker image.

```
cd <Dockerfile path>
docker build -t <image_name> .
```

#### 4. Run Docker image
if you want to add new user, you should connect the download sorce file to the docker volume.

but if you don't know docker, i sugget you ask manager for a adjustment.

```
export TERM=xterm-256color
docker run --restart always --name elephant -dt --privileged=true \
--net host \
-v /tmp/.X11-unix:/tmp/.X11-unix \
-e DISPLAY \
-e TERM=$TERM \
-v /home/kjjeon/project/elephant:/home/kjjeon/project/elephant \
-v /home/kilee/project/elephant:/home/kilee/project/elephant \
artview/elephant
```

#### 5. Install Toolchain
```
mkdir /tools
cd $HOME/project/elephant/tools/toolchain
sudo tar jxvf mips-4.3-51.tar.bz2 -C /tools/
sudo tar xvf r2-elf-linux-1.3.5.14.tar -C /tools/
```

#### 6. Setting Shell

```
sudo rm -rf /bin/sh
sudo ln -s /bin/bash /bin/sh
```

#### 7. Setting Mide
```
sudo apt-get install libgtk2.0-0:i386
sudo apt-get install libsm6:i386

cd $HOME/elephant/DAILEO/Supernova/mide/mide_0.9.15/
tiff-3.9.7.tar.gz
tar -zxvf tiff-3.9.7.tar.gz
cd tiff-3.9.7
./configure "CFLAGS=-m32" "CXXFLAGS=-m32" "LDFLAGS=-m32"
make
cp ./libtiff/.libs/libtiff.so.3 ../
```

# Connect to docker
In order to compile the mstar, you have to connect docker elephant.

you can connect under the command. but you need to change user name. (kjjeon -> your name)
```
docker exec -it --user kjjeon $1 /bin/bash --login
```


# Setup your Development Environment

#### 1. Setting Profile 

Connect docker by under the command.

`docker exec -it --user elephant <username> /bin/bash --login`

modify **.profile**.

**you have to replace `<password>` with `your password` in the following sentences.**

```
vi ~/.profile

#mide for docker
cd ~
echo <password> | sudo -S chown $UID:$UID .Xauthority.new
mv .Xauthority.new .Xauthority

# add under comment
PATH="$HOME/bin:$HOME/.local/bin:$PATH"
PATH="/tools/mips-4.3-51/mips-4.3/bin:$PATH"
PATH="/tools/r2-elf-linux-1.3.5.14/bin:$PATH"
PATH="/usr/local/bin:$PATH"
PATH="$HOME/project/elephant/DAILEO/Supernova/application/projects/buildsettings/artview/bin:$PATH"
alias eproot="cd $HOME/project/elephant"
alias eppro="cd $HOME/project/elephant/DAILEO/Supernova"
alias epset="cd $HOME/project/elephant/DAILEO/Supernova/application/projects/buildsettings"
alias epui="cd $HOME/project/elephant/DAILEO/Supernova/application/projects/ui"
alias epfw="cd $HOME/project/elephant/DAILEO/Supernova/application/projects/avframework"

alias epconfigure="source epconfigure"

cd $HOME/project/elephant/DAILEO/Supernova/application/projects && source buildsettings/artview_build.sh
source $HOME/project/elephant/DAILEO/Supernova/application/projects/buildsettings/artview/completion/epconfigure-completion
cd $HOME/project/elephant/DAILEO/Supernova/
stty -ixon

```
#### 2. Select GUI Project

we have to select gui project.

after inputting `epconfigure`, you can be recommended by inputting `tab`. 

if you want to select aquafina, you should input under the command.

```
epconfigure aquafina
```

#### 3. Download Source

we have to download in **$HOME/project/**.


# How to Compile
In the Makefile, you can find other command that don't notify here. 

#### 1. Make sdk 

```
$eppro
~/project/elephant/DAILEO/Supernova$make csdk
~/project/elephant/DAILEO/Supernova$make sdk
```

#### 2. Make all
In order to make all, you sholud make sdk.

```
$eppro
~/project/elephant/DAILEO/Supernova$make clean
~/project/elephant/DAILEO/Supernova$make all
```

#### 3. Make mslib && avframework && ui && image && build

```
$eppro
~/project/elephant/DAILEO/Supernova$make crebuild
~/project/elephant/DAILEO/Supernova$make rebuild
```

#### 4. Make avframework && ui && image && build

```
$eppro
~/project/elephant/DAILEO/Supernova$make capp
~/project/elephant/DAILEO/Supernova$make app
```

#### 5. Make mboot

```
$cd ~/project/elephant/DAILEO/Supernova/mboot/MBoot/sboot
~/project/elephant/DAILEO/Supernova/mboot/MBoot/sboot$cp .config.nugget.supernova.065b.rom.nand.1miu .config 
~/project/elephant/DAILEO/Supernova/mboot/MBoot/sboot$make menuconfig
~/project/elephant/DAILEO/Supernova/mboot/MBoot/sboot$make clean
~/project/elephant/DAILEO/Supernova/mboot/MBoot/sboot$make

```
# How to upload to target

#### 1. All

when AC power on, input enter key.
you will be able to see mboot prompt that looks like **nugget#**. 

And copy /DAILEO/Supernova/application/target/atsc.nugget/images/ubifs/**MstarUpgrade.bin** to the root of usb.


And insert usb to target board.

```
nugget#custar
```

#### 2. Appication

when AC power on, input enter key.
you will be able to see mboot prompt that looks like **nugget#**. 

And copy /DAILEO/Supernova/application/target/atsc.nugget/images/ubifs/**applications.sqfs** to **avupgrade/** of usb.

And copy /DAILEO/Supernova/application/target/atsc.nugget/images/ubifs/**mslib.sqfs** to usb to **avupgrade/** of usb.

And insert usb to target board.

```
nugget#cuapp
```

# Wiki
 * [Wiki](https://github.com/kjjeon/backuptest/wiki)
