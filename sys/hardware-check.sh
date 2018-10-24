#/bin/bash


##/ Joshua Hoffman /##

  
FORMATING () {

            RED=`tput setaf 1`
            GREEN=`tput setaf 2`
            NONE=`tput sgr0`
            LINS="----------------------------------------"
            ELINS="${RED}$LINS${NONE}"

} 


SPINNER () { ##/ Spinning animation (Stack Overflow) /## 

            info="$1"
            pid=$!
            delay=0.25
            spinstr='|/-\'
        
    while kill -0 $pid 2> /dev/null; do
    
            temp=${spinstr#?}
            
                printf "[%c]  $info" "$spinstr"

            spinstr=$temp${spinstr%"$temp"}
        
                sleep $delay
            
            reset="\b\b\b\b\b\b"
        
        for ((i=1; i<=$(echo $info | wc -c); i++)); do
    
                reset+="\b"
        
        done
        
                printf $reset
        
    done
    
            printf "   \b\b\b\b"
    
}


CHECK_ROOT () {
 
    "FORMATING"
    
    if (( EUID != 0 ))
    then

        echo $ELINS
        echo -e "${RED}ERROR:${NONE} Run as root!"  
        echo $ELINS
        exit
    
    fi

}


USER_HD () {

    "FORMATING"

        clear
        echo $LINS
        echo "Avaliable disks:"
        echo $LINS
        echo

            fdisk -l | grep 'Disk /dev/*' | awk '{print $2, $3, $4}'

        echo
        echo $LINS
        echo "Enter HD ID:"
        echo $LINS
        read HDNUM

            [[ $HDNUM == '' ]]
            
            OPTD=$(smartctl -a /dev/$HDNUM | sed -n '4p' | grep -c 'Unable to detect')
            
                if [ $OPTD = 1 ] 
                then
                
                    clear
                    echo $ELINS
                    echo "${RED}ERROR:${NONE} HD not found!"
                    echo $ELINS
                    exit
                    
                fi
                
        clear
                
}


USER_NIC () {

    "FORMATING"

        clear
        echo $LINS
        echo "Network interfaces:"
        echo $LINS

        echo
            ifconfig | grep mtu | awk '{print $1}' | tr -d :
        echo
        echo $LINS
        echo "Enter NIC ID:"
        echo $LINS
        read NETIF

            [[ $NETIF == '' ]]
            
                ETHDT=$(ifconfig $NETIF | grep -c mtu)
            
                if [ $ETHDT = 0 ] 
                then
        
                    clear
                    echo $ELINS
                    echo "${RED}ERROR:${NONE} NIC not found!"
                    echo $ELINS
                    exit

                fi
            
        clear
    
}

        
CHECK_DEP () {

    "FORMATING"
 
            CHKHP=$(rpm -q "hdparm")
            CHKLS=$(rpm -q "lm-sensors")
            CHKSM=$(rpm -q "smartmontools")
            CHKSN=$(rpm -q "stress-ng")
            CHKMD=$(rpm -q "mdadm")
            CHKIF=$(rpm -q "net-tools")
         
    if [ $CHKHP = 0 ]
    then

        echo $LINS
        echo "${RED}Package hdparm not found, install it (y/n)?${NONE}"
        echo $LINS
        read LMRHP
        
            [[ $LMRHP == '' ]]
            
                if [ $LMRHP = "y" ]
                then 
                
                    yum install hdparm
                
                elif [ $LMRHP = "n" ]
                then
                
                    clear
                    echo $LINS
                    echo "hdparm not installed, any key to exit..."
                    echo $LINS
                    read
                    clear
                    exit
                    
                fi
    fi;
         
    if [ $CHKLS = 0 ]
    then
        
        echo $LINS
        echo "${RED}Package lm-sensors not found, install it (y/n)?${NONE}"
        echo $LINS
        read LMREA
        
            [[ $LMREA == '' ]]
            
                if [ $LMREA = "y" ]
                then
                
                    yum install lm-sensors
                 
                fi
    fi;
             
    if [ $CHKSM = 0 ]
    then
        
        echo $LINS
        echo "${RED}Package smartmontools not found, install it (y/n)?${NONE}"
        echo $LINS
        read SMREA
        
            [[ $SMREA == '' ]]
            
                if [ $SMREA = "y" ]
                then
                
                    yum install smartmontools
                 
                fi
    fi;
    
    if [ $CHKSN = 0 ]
    then
    
        echo $LINS
        echo "${RED}Package stress-ng not found, install it (y/n)?${NONE}"
        echo $LINS
        read SNREA
        
            [[ $SNREA == '' ]]
            
                if [ $SNREA = "y" ]
                then
                
                    yum install stress-ng
                 
                fi
    fi;

    if [ $CHKMD = 0 ]
    then
        
        echo $LINS
        echo "${RED}Package mdadm not found, install it (y/n)?${NONE}"
        echo $LINS
        read MDREA
        
    
        [[ $MDREA == '' ]]
            
                if [ $MDREA = "y" ]
                then
                
                    yum install mdadm
                 
                fi
    fi;
    
    if [ $CHKIF = 0 ]
    then
        
        echo $LINS
        echo "${RED}Package net-tools not found, install it (y/n)?${NONE}"
        echo $LINS
        read IFREA
        
    
        [[ $IFREA == '' ]]
            
                if [ $IFREA = "y" ]
                then
                
                    yum install net-tools
                 
                fi
    fi;
     
}


HD_STATUS (){

    "FORMATING"
    "SPINNER"
    
        echo $LINS
        echo "HD status: $HDNUM"
        echo $LINS
        echo
            
            OPTT=$(smartctl -a /dev/$HDNUM | sed -n '34p' | grep -c 'PASSED')
            OPTS=$(smartctl -a /dev/$HDNUM | grep "Namespace 1 Size/Capacity" | awk '{print $5, $6}' | tr -d [ | tr -d ])
            OPTR=$(smartctl -a /dev/$HDNUM | grep "Data Units Read:" | awk '{print $5, $6}' | tr -d [ | tr -d ])
            OPTW=$(smartctl -a /dev/$HDNUM | grep "Data Units Written:" | awk '{print $5, $6}' | tr -d [ | tr -d ])
            OPTN=$(smartctl -a /dev/$HDNUM | grep "Serial Number:" | awk '{print $3}')
            OPTC=$(smartctl -a /dev/$HDNUM | grep "Power On Hours:" | tr -d , | awk '{print $4/24}')
            OPTO=$(sync; dd if=/dev/zero of=tempfile bs=1M count=1024 |& grep 'copied' | awk '{print $10}'; sync) # & "SPINNER" "Write speed test "
            OPTI=$(sysctl -w vm.drop_caches=3 &> /dev/null ; dd if=tempfile of=/dev/null bs=1M count=1024 |& grep 'copied' | awk '{print $10}') # & "SPINNER" "Read speed test "
}


NET_STATUS (){

        clear
        echo $LINS
        echo "Net status: $NETIF"
        echo $LINS
        echo

            ETHIP=$(ifconfig $NETIF | grep 'inet' | awk '{print $2}' | sed -n '1p')
            ETHNM=$(ifconfig $NETIF | grep 'netmask' | awk '{print $4}')
            ETHMA=$(ifconfig $NETIF | grep 'ether' | awk '{print $2}')
            ETHLD=$(ethtool $NETIF | grep 'Link detected:' | awk '{print $3}')
            ETHSP=$(ifconfig $NETIF | grep txqueuelen | awk '{print $4}')

}


CPU_STATUS (){

    "FORMATING"
     
            CPUID=$(lscpu | grep "Model name:" | awk '{print $5}')
            CPUCC=$(lscpu | grep "Core(s) per socket:" | awk '{print $4}')
            # CPUTM=$(sensors -f | grep "Core 0:" | awk '{print $3}' | tr -d +)
            CPUFR=$(lscpu | grep "CPU max MHz:" | awk '{print $4}')
            CPUCT=$(lscpu | sed -n '4p' | grep "CPU(s):" | awk '{print $2}')

}


RAM_STATUS () {

    "FORMATING"
    "SPINNER"
            
            MEMIN=$(free | grep "Mem" | awk '{print $2}')
            MEMGB=$(free | grep "Mem" | awk '{print $2/1000000}')
            MEMTS=$(dd if=/dev/urandom bs=$MEMIN of=/tmp/memtest count=1050 &> /dev/null) # & "SPINNER" "Checksum test "
            MEMOK_1=$(md5sum /tmp/memtest) # & "SPINNER" "Validating MD5 #1 "
            MEMOK_2=$(md5sum /tmp/memtest) # & "SPINNER" "Validating MD5 #2 "
            MEMOK_3=$(md5sum /tmp/memtest) # & "SPINNER" "Validating MD5 #3 " 
            MEMSP=$(dmidecode --type 17 | sed -n '18p'  | grep "Speed:" | awk '{print $2}')
            MEMTY=$(dmidecode --type 17 | sed -n '16p'  | grep "Type:" | awk '{print $2}')
            MEMBK_1=$(dmidecode --type 17 | grep "Bank Locator:" | awk '{print $4}' | sed -n '1p')
            MEMBK_2=$(dmidecode --type 17 | grep "Bank Locator:" | awk '{print $4}' | sed -n '2p')
            MEMBK_3=$(dmidecode --type 17 | grep "Bank Locator:" | awk '{print $4}' | sed -n '3p')
            MEMBK_4=$(dmidecode --type 17 | grep "Bank Locator:" | awk '{print $4}' | sed -n '4p')
            
}


RAID_STATUS (){

    "FORMATING"
     
            RAID=$(cat /proc/mdstat | sed -n '2p' | grep -c 'none')
            RAIDT=$(cat /proc/mdstat | grep 'Personalities' | awk '{print $3}' | tr -d ] | tr -d [)
            RAIDV=$(cat /proc/mdstat | grep 'active raid*' | awk '{print $1}')
}
CHECK_HD (){
    "FORMATING"
    "HD_STATUS"
    
    if [ $OPTT = 1 ]
    then
        
        echo "Error check:          PASSED"
    elif [ $OPTT = 0 ] 
    then
        
        echo "Error check:          ${RED}FAILED${NONE}"
        
    fi 
    
        echo "Size:                 $OPTS"
        echo "Written:              $OPTW"
        echo "Read:                 $OPTR"
        echo "Serial #:             $OPTN"
        #echo "Up time:              ${OPTC%.*} Days"
        echo "Write speed:          $OPTO MB/s"
        echo "Read speed:           $OPTI MB/s"
        echo
    
}
CHECK_NET () {
    "FORMATING"
    "NET_STATUS"
    
        
        echo "IP:                   $ETHIP"
        echo "Netmask:              $ETHNM"
        echo "MAC:                  $ETHMA"
        echo "Link detect:          $ETHLD"
        echo "Speed:                $ETHSP"
        echo
}
CHECK_CPU (){
    "FORMATING"
    "CPU_STATUS"
    
        echo $LINS
        echo "CPU STATUS:"
        echo $LINS
        echo
        echo "Model:                $CPUID"
        echo "Temp:                 $CPUTM"
        echo "Physical:             $CPUCC Cores"
        echo "Hyper:                $CPUCT Threads"
        echo "Max freq:             ${CPUFR%.*} MHz"
        echo
        
}
CHECK_RAID (){
    
    "FORMATING"
    "RAID_STATUS"
        echo $LINS
        echo "RAID STATUS:"
        echo $LINS
 
    if [ $RAID = 1  ]
    then
        
        echo
        echo "Detect:               No raid"
        echo
        echo $LINS
    
    elif [ $RAID = 0  ]
    then
        
        echo
        echo "Detect:               Unknown"
        echo 
        echo $LINS
        
    fi
 
}
CHECK_RAM () {
    "FORMATING"
    
        echo "RAM STATUS:"
        echo $LINS
        echo
    "RAM_STATUS"
    
    if [[ $MEMOK_1 != $MEMOK_2 ]] & [[ $MEMOK_1 != $MEMOK_3 ]]
    then
    
        echo "MD5 Check:            ${RED}FAILED${NONE}"
        
    elif [[ $MEMOK_1 = $MEMOK_2 ]] && [[ $MEMOK_1 = $MEMOK_3 ]]
    then
    
        echo "MD5 Check:            PASSED"
            
    fi
        
        echo "RAM type:             $MEMTY"
        echo "RAM total:            ${MEMGB%.*} GB"
        echo "RAM speed:            $MEMSP MHs"
        echo "DIM's used:           $MEMBK_1 $MEMBK_2 $MEMBK_3 $MEMBK_4"
        echo
        echo $LINS
}
        clear
        echo $LINS
       
CHECK_ROOT
CHECK_DEP
USER_HD
USER_NIC
CHECK_NET
CHECK_HD
CHECK_CPU 
CHECK_RAID 
CHECK_RAM