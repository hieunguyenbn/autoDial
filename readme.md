1.Install wvdial
sudo apt-get install wvdial
 
Create 3 section in /etc/wvdial.conf for Viettel/Mobi/Vinaphone. 

Or simply copy the wvdial.conf here to /etc/: sudo cp wvdial.conf /etc/wvdial.conf


2. Create audioDial service as below:
sudo nano /etc/systemd/system/audioDial.service
[Unit]
Description=Audio Dial
Before=network.target
After=dbus.service
Wants=network.target

[Service]
Type=simple
ExecStart=/usr/bin/wdialrun.sh
User=root
Group=root
Restart=always

[Install]
WantedBy=multi-user.target

3. Make systemd aware of  new service
sudo systemctl daemon-reload
sudo systemctl enable audioDial.service
sudo systemctl start audioDial.service

To monitor audioDial service, use:
sudo journalctl -f -u audioDial
4. Create /usr/bin/wdialrun.sh and paste content in wdialrun.sh
sudo nano /usr/bin/wdialrun.sh

Or simply copy wdialrun.sh to /usb/bin
sudo cp wdialrun.sh /usr/bin/wdialrun.sh


