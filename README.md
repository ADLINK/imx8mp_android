ADLINK SP2-IMX8MP  with Android 13
=========================================================================

Platform        : SP2-IMX8MP 
================================================
Kernel version  : 5.15.74
================================================

Change log:
===========
1v0
---------------------
 + USB Device Support is added

 + Ethernet support added for : LAN1 LAN2

 + Uart3

 + Uart4

 + RAM memory updated to 4 GB

 + Interfaces tested:
	
	​		- Serial console
	
	​		- HDMI
	
	​		- USB-2.0
	
	​		- LAN0
	
	​		- LAN1
	
	​		- UART3 (RS485)
	
	​		- UART4 (RS232)



Supported interfaces:
=====================
 - Serial console

 - USB 2.0  

 - HDMI display

 - Ethernet (FEC and imx-DWMAC)

 - Micro SD interface

   

Flashing the image and booting:
===============================
1. On a linux host machine, insert the micro SD card (through an USB adapter).
2. Ensure, the device node of the micro SD card using dmesg.
3. Change to the release and bin directory.
4. Execute the command for a 32 GB Micro-SD card:
	- sudo ./imx-sdcard-partition.sh -f imx8mp -c 28 /dev/sdX
	- /dev/sdX need to be changed to actual device node of the micro SD card>
	- For more details, please refer: https://www.nxp.com/docs/en/user-guide/ANDROID_USERS_GUIDE.pdf



Readme Contents
=================================================

   1. Hardware setup

   2. Package structure

   3. Steps to boot with prebuilts

   4. Peripheral testing
      4.1. Console Logs
      4.2. HDMI
      4.3. USB
      4.4. LAN 1 LAN2
      4.5. UART3
      4.6. UART4

      

1.Hardware setup
================================================
       Target		-  SP2-IMX8MP
       Host Machine - Linux Ubuntu

2.Package structure
================================================

Unzip SP2-IMX8MP-4G-Android-tiramisu_1V1.0.1_24_03_04.zip

SP2-IMX8MP-4G-Android-tiramisu_1V1.0.1_24_03_04/

3.Steps to boot with prebuilts
=================================================

------------------------------------------------------
3.1 Using SD card image
------------------------------------------------------

The SD card image packs bootloader, kernel and android file
system. Follow below steps:

  1. Unzip release package ADLINK_LEC_IMX8MP_4G_ANDROID_11_1V15
  2. Go to directory ADLINK_LEC_IMX8MP_4G_ANDROID_11_1V15/bin
  3. insert an sdcard
  4. Run the imx-sdcard-partition.sh

Note: - First boot from SD card can be slow. Subsequent boots will be faster

​          - Boot setting 1100 for booting from SD card 

4.Peripheral testing
=================================================

-------------------------------------------------
4.1 Console Logs
-------------------------------------------------

 Connect UART cable on expansion connector CN9 to get android boot logs.
 Pin connection:
     pin 1  -  UART TX
     pin 2 -   UART RX
     pin 3  - GND

---------------------------------------------------
4.2  HDMI
---------------------------------------------------

 - Connect the HDMI cable to HDMI port on board

 - Check display on HDMI panel 

 - When the board is powered on, the HDMI display starts with the Android logo.

 - User can unlock HDMI display 

   using mouse 

-------------------------------------------------
4.3 USB 
-------------------------------------------------

 - Supports USB 2.0 
 - When attached and detach USB storage device  its displays dmesg
 - User can also find the device using command  'lsusb'.
 - USB HID Mouse, keyboard & Mass Storage are supported


-------------------------------------------------
4.4 LAN 
-------------------------------------------------

 - Connect the LAN cable to Ethernet port LAN1 and LAN2 

 - Use 'ifconfig' command to check if IP is assigned , then do ping test .


-------------------------------------------------
4.5 UART3
-------------------------------------------------

RS485 communication.

 - Connect  the COM port cable on CN10 connector.

 - COM port cable   DB-RS485  

 - Connection DB9-RS485 to RS485 to USB converter

   | DB9-Rs485 | RS485 to USB converter |
   | --------- | ---------------------- |
   | Pin1      | B-                     |
   | Pin2      | A+                     |
   | Pin5      | GND                    |

1) Configure the Baudrate for uart3 ports at SP2_imx8mp side and Host side 

```shell
- On target : stty -F /dev/ttymxc2 115200

- On Host machine : minicom -D /dev/ttyUSB1 -b 115200
```

2) Send and Receive data between Host and Target

```shell
echo " from_target_check_rs485 123!@#" > /dev/ttymxc2
```

check on host side you would have received data

use below command to start read data from host machine

```shell
cat /dev/ttymxc2
```

send data from host using minicom  "from_host_checkrs485 1%$##"

check on Target side you would have received data



-------------------------------------------------
4.6 UART4
-------------------------------------------------

RS232 communication.

- Connect  the COM port cable on CN10 connector

- Connection: DB9-COM to RS232 to USB converter

| DB9-COM | RS232 to USB |
| ------- | ------------ |
| Pin2    | Pin3         |
| Pin3    | Pin2         |
| PIN3    | PIN3         |

Connect the other end of Rs232 to USB to host machine.

1) Configure the Baud rate for uart4 ports at SP2_imx8mp side and Host side

```shell
- On target : stty -F /dev/ttymxc3 115200

- On Host machine : #minicom -D /dev/ttyUSB1 -b 115200
```

2) Send and Receive data between Host and Target

```shell
echo " from_target_check_123#." > /dev/ttymxc3
```

check on host side you would have received data

use below command to start read data from host machine

```shell
cat /dev/ttymxc3
```

send data from host using minicom  "from_host_checkrs232 1%$##"

check on Target side you would have received data

