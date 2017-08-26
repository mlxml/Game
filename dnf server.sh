#!/bin/sh
#################################
#          dnf服务端脚本         #
#################################

function install() {
    echo "nameserver 114.114.114.114">> /etc/resolv.conf
	centos=`cat /etc/redhat-release`
    XT=`cat /etc/redhat-release | awk '{print $3}'| cut -b1`
	H=`cat /proc/cpuinfo | grep "physical id" | sort | uniq | wc -l`
	HX=`cat /proc/cpuinfo | grep "core id" |wc -l`
	DD=`df -h /`
    W=`getconf LONG_BIT`
	G=`awk '/MemTotal/{printf("%1.1fG\n",$2/1024/1024)}' /proc/meminfo`
	SJ=`date '+%Y-%m-%d %H:%M:%S'`
    IP=`curl -s http://v4.ipv6-test.com/api/myip.php`
    if [ -z $IP ]; then
    IP=`curl -s https://www.boip.net/api/myip`
    fi
	echo "
================================服务器配置================================

|	系统版本 	   |  |CPU个数|  |CPU核心|  |运行内存|  |操作系统|     
|$centos|  |  $H个  |  |  $HX核  |  |  $G  |  |  $W 位 | 

===============================硬盘使用情况===============================
$DD	
	

	！"
    echo -n "	
	输入 我同意 ：" 
	read TRY
	while [ "$TRY" != "我同意" ]; do
	echo "输入有误，请重新输入："
	echo -n "	
	输入有误，请重新输入："
	read TRY
	done
	aaa
	Swap
    qrip
    remove
}

function aaa() {
	if [ "$XT" = "5" ] ; then
		installCentOS5
	elif [ "$XT" = "6" ] ; then
		installCentOS6
    else
        exit 0
    fi
}

function installCentOS5() {
    echo "	安装5系运行库..."
    wget -O /etc/yum.repos.d/CentOS-Base.repo http://mirrors.aliyun.com/repo/Centos-5.repo
	yum makecache
	yum -y install glibc.i386
	yum install -y xulrunner.i386
	yum install -y libXtst.i386
	yum -y install gcc gcc-c++ make zlib-devel
}

function installCentOS6() {
    echo "	安装6系运行库..."
    wget -O /etc/yum.repos.d/CentOS-Base.repo http://mirrors.aliyun.com/repo/Centos-6.repo
	yum makecache
	yum -y install glibc.i686
	yum install -y xulrunner.i686
	yum install -y libXtst.i686
	yum -y install gcc gcc-c++ make zlib-devel
}

function Swap() {
	B=`awk '/MemTotal/{printf("%1.f\n",$2/1024/1024)}' /proc/meminfo`
	a=9
	AA=$(($a - $B))
	if (($AA > 1)); then
	echo "	系统根据运行内存自动添加Swap请耐心等待..."
    dd if=/dev/zero of=/var/swap.1 bs=${AA}M count=1000
    mkswap /var/swap.1
    swapon /var/swap.1
    echo "/var/swap.1 swap swap defaults 0 0" >>/etc/fstab
    sed -i 's/swapoff -a/#swapoff -a/g' /etc/rc.d/rc.local
	echo "添加 Swap 成功"
	elif (($AA <= 1)); then
	echo "	系统检测运行内≤8G不需要添加Swap"	
	fi
}

function qrip() {
    echo -n "	${IP}
	是否是你的外网IP？(不是你的外网IP或出现两条IP地址请回n自行输入) y/n ："
    read ans
    case $ans in
    y|Y|yes|Yes)
    ;;
    n|N|no|No)
    read -p "	输入你的外网IP地址，回车（确保是英文字符的点号）：" myip
    IP=$myip
    ;;
    *)
    ;;
    esac
    cd /
	tar -zvxf Package.tar.gz
    cd /home/neople
	sed -i "s/Public IP/${IP}/g" `find . -type f -name "*.cfg"`
	chkconfig iptables off
    service iptables stop
	echo 1 > cat /proc/sys/vm/drop_caches
	sed -i "s/SELINUX=enforcing/SELINUX=disabled/g" /etc/sysconfig/selinux
}

function remove() {
	echo -n "	完成安装，是否删除临时文件 y/n [n] ?"
    read ANS
    case $ANS in
    y|Y|yes|Yes)
    rm -f /Package.tar.gz
	rm -f /install
    ;;
    n|N|no|No)
    ;;
    *)
    ;;
    esac
}

install
	echo "DNF服务端已经安装完毕！
	"
	echo "请自行上传Script.pvf、publickey.pem、df_game_r到home/neople/game目录下
	"
	echo "启动服务端命令为cd /root回车在./run，关闭命令为cd /root回车在./stop
	"
	echo "数据库默认帐号为：root，默认密码为：123456
	"
	echo "登录器文件目录：opt/lampp/htdocs  配置时加88端口例如；123.123.123.123:88
	"
	echo "数据库目录：opt/lampp/var/mysql
	"