#!/bin/bash

# global variables
g_network=mobi
network_detected=0
network_list=(mobi viettel vina)
eth_retry_count=0
# check if SIM module is ready, and replace ttyUSBx in config file if neccessary
check_sim_module_and_change_config_file() {
while true;
do
 wvdialconf | grep Found > /tmp/scan_all_port
 if [ -s /tmp/scan_all_port ]; then
   break;
 else
   echo "File not exist"
   sleep 5
 fi
done
default_tty="ttyUSB2"
tty=$(awk '{ print $5 }' /tmp/scan_all_port | tr -d . | tr -d /dev/)
file_name="/etc/wvdial.conf"
# replace with new ttyUSBx
if [[ $tty != $default_tty ]]; then
 echo "Replate now"
 sed -i "s/${default_tty}/${tty}/" $file_name
else
 echo "The device is ttyUSB2. No need to update config file /etc/wvdial.conf"
fi
}

# Checking network function, return 1 or 0 (1 means ok, 0 means not ok). use 8.8.8.8
check_network_ppp0() {
if ping -q -c 1 -W 1 8.8.8.8 >/dev/null; then
  #echo "Network is up"
  return 1
else
  #echo "Network is down"
  return 0
fi
}

check_network_eth() {
if ip link show | grep eth0 | grep UP >/dev/null; then
  if ping -I eth0 -q -c 1 -W 1 8.8.8.8 >/dev/null; then
    echo "Network eth is up"
    eth_retry_count=0
    return 1
  else
    echo "Network eth is down"
    let "eth_retry_count++"
    if [[ $eth_retry_count == 3 ]]; then
      sudo ip link set eth0 down
      exit 1
    fi
    echo $eth_retry_count
    return 0
  fi
else
  return 0
fi
}

# Dialer function. 
## Arg: 0 = mobi, 1 = viettel, 2 = vina, 3 = g_network 
## Do command wvdial [section_name]; sleep 5s; check network and return
## Return 1 if network is ok, 0 if network is not ok

dialer_and_check_network() {
  id=$1
  if [[ $id == 4 ]]; then
    wvdial $g_network &
    #echo $g_network
  else
    wvdial ${network_list["$id"]} &
    #echo ${network_list[$id]}
  fi
  sleep 8
  check_network_ppp0
  return $?
}

# Main function
#check_sim_module_and_change_config_file

while true;
do
  # Check eth0 interface. If not exist or could not ping to 8.8.8.8, simply set it down then restart this service
  check_network_eth
  st=$?
  if [[ $st == 1 ]]; then
    echo "ETH0 already up. Just sleep for 300 seconds"
    sleep 300
    continue
  fi

  # check ppp0 interface. 
  check_network_ppp0
  st=$?
  if [[ $st == 1 ]]; then
    echo "PPP0 already up. Just sleep for 300 seconds"
    sleep 300
  else
    if [[ $network_detected == 0 ]]; then
      while true;
      do
        for id in 0 1 2
        do
            dialer_and_check_network $id
            st=$?
            if [[ $st == 1 ]]; then
             echo "Network ${network_list[$id]} up"
             network_detected=1
             g_network=${network_list[$id]}
             #break for loop
             break
            else
             echo "Config ${network_list[$id]} does not work. Try new one"
            fi
        done
        #break while loop
        break
      done
    else
      # Retry with g_network 10 times
      for i in {1..10}
      do
        dialer_and_check_network 4
        st=$?
        if [[ $st == 1 ]]; then
         echo "Global network $g_network up"
         break
        fi
        network_detected=0
      done
    fi
  fi
done
