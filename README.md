# Android 13 for ADLINK SP2-IMX8MP

## Contents
```
1. Hardware Details
2. Software Details
3. Package structure
4. Flashing the image and booting
   4.1.   SD boot
   4.2.   eMMC boot
5. Peripheral testing
   5.1.   USB type A ports
   5.2.   Micro USB (Device mode)
   5.3.   HDMI
   5.4.   UART2 - Console
   5.5.   UART3 - RS485
   5.6.   UART4 - RS232
   5.7.   GPIO on Expansion Connector
   5.8.   SPI on Expansion Connector
   5.9.   CAN interface
   5.10.  RTC
   5.11.  Wifi/BT
   5.12.  ETHERNET
   5.13.  LVDS display
   5.14.  Audio SGT5000
   5.15.  Buzzer
   5.16.  TPM
```
## 1 Hardware Details

| **Module** | **SP2-IMX8MP** |
|:----------------|:-----------|

## 2 Software Details

|   Android   |   Ver 13   |
|:-----------:|:-----------:|
| **Kernel**  | **6.1.36** |
| **U-Boot**  | **2023.04** |
| **Host OS** | **Ubuntu 22.04.1** |

## 3 Package structure

 ```
  |---SP2-IMX8MP-Android-1.3-*
     |--- android images
     |--- README.md
 ```
- Download Android release (Android-1.3-*) and extract it.

## 4 Flashing the Image and Booting

### 4.1 SD Boot

#### Host preparation

1. On a linux host machine, insert the micro SD card (through an USB adapter).

2. Check the device node of the micro SD card using dmesg command.

3. Move into android release directory ```Android-13-*```

   

#### Flash image to SD card

* Execute the following command for a 32 GB Micro-SD card.
  
   ```shell
   $ sudo ./imx-sdcard-partition.sh -f imx8mp -c 28 /dev/sdX
   ```


* /dev/sdX need to be changed to actual device node of the micro SD card

* For more details, please refer: https://www.nxp.com/docs/en/user-guide/ANDROID_USERS_GUIDE.pd

  Note: First boot consume more time, subsequent boot will be faster.


### 4.2 eMMC Boot

#### Download uuu utility

 - Download uuu utility and copy to /usr/bin

 - https://github.com/nxp-imx/mfgtools/releases/download/uuu_1.4.182/uuu

   ```shell
   $ sudo cp ~/Downloads/uuu /usr/bin
   $ sudo chmod +x /usr/bin/uuu
   ```

#### Boot into Recovery Mode

 * Set the boot switch into recovery mode.(1000)
 * Connect USB OTG cable to host.
 * Power ON the board.

#### Flash image to eMMC

* Change the boot setting for download mode(1000).

* Execute the following command to start flashing Android image to eMMC.

   ```shell
   $ sudo ./uuu_imx_android_flash.sh -f imx8mp -e -m -c 28
   ```
   
* Once flashing completed, power off the board and change boot settings(0100) to eMMC mode.

* Power on the board to boot Android from eMMC.

* A detailed guide on using UUU tool is available in: https://www.ipi.wiki/pages/imx8mplus-docs?page=HowToFlashImageeMMCUsingUUUTool.html


## 5 Peripheral Testing
### 5.1 USB Type A

* All USB type A ports are validated.
* Any storage device connected on these ports will be mounted at "/mnt/media_rw" location.
* Device can also be accessed from Android GUI.


### 5.2 Micro USB (Device mode)

 * Connect micro USB cable to access device in client mode.
 * Devices can be accessed using adb commands.

 #### Running adb
 * After Board boots up, connect the micro USB port on the ADLINK board with the Host system using a Micro USB cable.
 * On a Ubuntu machine, install adb using below commands.
   ```shell
   $ sudo adb usb
   $ sudo adb shell ls <to list the current directory on the Android board>
   ```

### 5.3 HDMI

HDMI function is enabled by default.

### 5.4 UART2 - Console

* Connect UART cable to CN9 expansion connector to get android boot logs.
* Console UART works at TTL level. Use TTL compatible USB Serial adapter to get logs.

Pin connection:

| Pin  | Function |
|:----:|:--------:|
| 1 | UART TX |
| 2  | UART RX |
| 3  | GND     |


### 5.5 UART3 - RS485

 Connect RS485 compatible UART cable to CN10 expansion connector(DB9-RS485).

 Pin connection:

| Pin  | Function |
|:----:|:--------:|
| 1 | B- |
| 2 | A+ |
| 5 | GND     |

#### RS485 Tx Test
* Open minicom, 115200 baudrate with no hardware flow control setting.
* Run the below commands from adb shell to transmit data to Minicom.
   ```shell
   $ stty -F /dev/ttymxc2 115200 cs8 -cstopb -parenb
   $ echo 'ADLINK' > /dev/ttymxc2
   ```
   'ADLINK' string will be displayed in minicom

#### RS485 Rx Test
* Run below command in adb shell
   ```shell
   $ cat /dev/ttymxc2
   ```
   Type some data and press enter in Minicom. 
   The data will be received in adb shell.

### 5.6 UART4 - RS232

* UART4 support rs232,rs485,rs422 

* By defualt its set to rs232 ;Please use uart-script.sh for changing them 

​		- for rs232 -uart-script.sh rs232

​		- for rs485 -> uart-mode.sh rs485 

​		- for rs422 -> uart-mode.sh rs422

- Connect USB to RS232 compatible  cable to CN10 connector(DB9-COM).

 Pin connection:

| Pin  | USB to RS232 |
| :--: | :----------: |
|  2   |      3       |
|  3   |      2       |
|  5   |      5       |

#### RS232Tx Test

* Open minicom, 115200 baud rate with no hardware flow control setting.

* Run the below commands from adb shell to transmit data to Minicom.

  ```shell
  $ stty -F /dev/ttymxc3 115200 cs8 -cstopb -parenb
  $ echo 'ADLINK' > /dev/ttymxc3
  ```

  'ADLINK' string will be displayed in minicom

#### RS232 Rx Test

* Run below command in adb shell

  ```shell
  $ cat /dev/ttymxc3
  ```

  Type some data and press enter in Minicom. 
  The data will be received in adb shell.

### 5.7 GPIO on Expansion Connector

GPIO on expansion connector (CN22) can be accessed using following commands:

```shell
$ cd /sys/class/gpio/
$ echo GPIO_NUM > export
$ cd gpio<GPIO_NUM>
$ echo out > direction ("out" is to enable pin as ouput, "in" for input)
$ echo 1 > value       ("1" to drive high, "0" to drive low)
```

The GPIO_NUM mentioned above are mapped to following pin numbers:

| Pin on expansion | Kernel Gpio number |
|:----------------:|:------------------:|
|      DI0    |   495    |
|      DI1    |   496    |
|      DI2    |   497    |
|      DI3    |   498    |
|      DO0    |   499    |
|      DO1    |   500    |
|      DO2    |   501    |
|      DO3    |   502    |

### 5.8 SPI on expansion connector

Follow below procedure to perform loop-back test:

#### SPI1 Loopback test
* Connect Pin 8 (MOSI) and 10 (MISO) in CN22 expander 
* Run below command to send and receive data over SPI1

```Shell
$ spidevtest -D /dev/spidev1.0 -p "12345" -N -v
```

### 5.9 CAN interface (CN1602)

* For CAN testing, two boards with CAN support are needed 

* Connect  the COM port cable on CN10 ,Connect DB9-CAN Pins (PIN 2 CAN0_L - CAN_L ) , (PIN 7 CAN0_H - CAN_H) & (PIN 6 GND - GND)  in CN10 connector.

Sender should execute below commands:

1. Configure the CAN0 ports as ( on the First Board)
   ```shell
   $ ip link set can0 type can bitrate 500000
   $ ip link set can0 up
   ```

2. Configure the CAN0 ports as ( on the Second board)
   ```shell
   $ ip link set can0 type can bitrate 500000
   $ ip link set can0 up 
   ```

3. Dump CAN data on can0: ( on First board start listening )
   ```shell
   $ candump can0 & 
   ```

4. Send data over can1: ( from Second board transmit data)
   ```shell
   $ cansend can0 01a#11223344AABBCCDD 
   ```

    Now, data sent from First board will be dumped back on Second board.


### 5.10 RTC

* While connected to network android will update date/time from network service. 
* Using Android UI Go -> Setting > System> Date & time -> Region
* Under Time zone , Select Time Zone -> Region.
* Time would updated , Disconnect from network (Ethernet )
* Now power off the target for some time 
* Power on and check the time,Time would be updated

### 5.11 Wifi/BT 

WiFi/BT supported in Android and functionalities can be realised by using Android Settings.

### 5.12 Ethernet

* Android supports both Ethernet
* Open Settings -> Network & internet -> Internet -> Ethernet to view details of ETH0/ETH1 port
* Ethernet configuration can be obtained by running ```ifconfig``` command from adb shell


### 5.13 LVDS display

* Android will support  LVDS  7 10 23 inch panel based on EERPOM setting . Use yocto image to update the EEPROM using below command.

```shell
$ sudo msgpacker.py set -b 1 -a 0x54 -k disp -v X
```

X - take value -> 7 - 7inch LVDS display ; 10 - 7inch LVDS display  ; 23 - 7inch LVDS display

### 5.14 SGTL5000 Audio codec

* Connect Headphone audio and mic 3.5mm jack Using Sound recorder application to validate the audio interface.
* Connect Speaker ,  Setting - > Sound & Vibration -> change media volume and Sound recorder application to validate the audio 
* Android  support HDMI Speaker Headphone one at time, Take priority as below
  HDMI > Headphones > Speaker

### 5.15 Buzzer

* Find the pwm-beeper input from getevent command 
  example :
  #getevent                                                    
  add device 1: /dev/input/event3
    name:     "ILITEK       ILITEK-TOUCH"
  add device 2: /dev/input/event1
    name:     "pwm-beeper"
  add device 3: /dev/input/event0

  "pwm-beeper" is linked to  /dev/input/event1

```shell
$ getevent
```

* Use beep utils  for validating Buzzer  -> beep </dev/input/eventX> [freq] [duration]

```shell
$ beep /dev/input/event1 2000 3
```

### 5.16 TPM

* Using eltt2   we can validate TPM

```shell
$ eltt2 -gv
```
