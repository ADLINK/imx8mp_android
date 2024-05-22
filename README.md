# Android 13 for ADLINK LEC-iMX8MP

## Contents
```
1. Hardware Details
2. Software Details
3. Package structure
4. Flashing the image and booting
   4.1. SD boot
   4.2. eMMC boot
5. Peripheral testing
   5.1. USB type A ports
   5.2. Micro USB (Device mode)
   5.3. HDMI
   5.4. UART - Console
   5.5. UART - RS232
   5.6. WM8960 Audio codec
   5.7. GPIO on expansion connector
   5.8. PWM GPIO
   5.9. SPI on expansion connector
   5.10. CAN interface
   5.11. RTC
   5.12. Wifi/BT
   5.13. MIPI DSI display
   5.14. LVDS display
   5.15. MIPI CSI camera
   5.16. PCIe
   5.17. ETHERNET
         5.17.1. Ethernet in U-boot
         5.17.2. Ethernet in Android
```
## 1 Hardware Details

| Base | I-Pi SMARC Plus |
|:----------------|:-----------|
| **Module** | **LEC-iMX8MP** |

## 2 Software Details
|   Android   |   Ver  13   |
|:-----------:|:-----------:|
| **Kernel**  | **5.15.74** |
| **U-Boot**  | **2022.04** |
| **Host OS** | **Ubuntu 22.04.4** |


## 3 Package structure

 ```
  |---adlink-lec-imx8mp-android-tiramisu_V2_R1_240520
     |--- android images
     |--- README.md
 ```
- Download Android release (adlink-lec-imx8mp-android-tiramisu_V2_R1_240520.zip) and extract it.



## 4 Flashing the Image and Booting

### 4.1 SD Boot

#### Host preparation

1. On a linux host machine, insert the micro SD card (through an USB adapter).

2. Check the device node of the micro SD card using dmesg command.

3. Move into android release directory ```adlink-lec-imx8mp-android-tiramisu_V2_R1_240520```

   ```
   $ sudo cp tools/lib64/libc++.so /lib/x86_64-linux-gnu
   $ sudo chmod +x /lib/x86_64-linux-gnu/libc++.so
   ```

   ```
   $ sudo cp tools/bin/make_f2fs /usr/bin
   $ sudo chmod +x /usr/bin/make_f2fs
   ```

#### Flash image to SD card

* Execute the following command for a 32 GB Micro-SD card.
   ```
   $ sudo ./imx-sdcard-partition.sh -f imx8mp -c 28 -u <N>gb /dev/sdX
   ```
* Replace N with size of RAM installed in the module

* /dev/sdX need to be changed to actual device node of the micro SD card

* For more details, please refer: https://www.nxp.com/docs/en/user-guide/ANDROID_USERS_GUIDE.pd

  Note: First boot from SD card can be slow,subsequent boot will be faster


### 4.2 eMMC Boot

#### Download uuu utility

 - Download uuu utility and copy to /usr/bin

 - https://github.com/nxp-imx/mfgtools/releases/download/uuu_1.4.182/uuu

   ```
   $ sudo cp ~/Downloads/uuu /usr/bin
   $ sudo chmod +x /usr/bin/uuu
   ```

#### Boot into Recovery Mode

 * Set the boot switch into recovery mode.
 * Connect USB OTG cable to host.
 * Power on the board.

#### Flash image to eMMC

* Execute the following command to start flashing Android image to eMMC.

   ```
   $ sudo ./uuu_imx_android_flash.sh -f imx8mp -e -c 28 -u <N>gb
   ```

* Replace N with size of RAM installed in the module.
* Once flashing completed, power off the board and change boot settings to eMMC mode.
* Power on the board to boot Android from eMMC.
* A detailed guide on using UUU tool is available in: https://www.ipi.wiki/pages/imx8mplus-docs?page=HowToFlashImageeMMCUsingUUUTool.html


## 5 Peripheral testing
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
   ```
   $ sudo adb usb
   $ sudo adb shell ls <to list the current directory on the Android board>
    ```

### 5.3 HDMI

HDMI function is enabled by default.

### 5.4 UART1 - Console

* Connect UART cable to CN1001 expansion connector to get android boot logs.
* Console UART works at TTL level. Use TTL compatible USB Serial adapter to get logs.

Pin connection:

| Pin  | Function |
|:----:|:--------:|
| 10 | UART RX |
| 8  | UART TX |
| 6  | GND     |


### 5.5 UART2 - RS232

 Connect RS232 compatible UART cable to CN1609 expansion connector.
 
 Pin connection:

| Pin  | Function |
|:----:|:--------:|
| 1 | UART RX |
| 3 | UART TX |
| 5 | GND     |

#### UART Tx Test
* Open minicom, 115200 baudrate with no hardware flow control setting.
* Run the below commands from adb shell to transmit data to Minicom.
   ```
   $ stty -F /dev/ttymxc2 115200 cs8 -cstopb -parenb
   $ echo 'ADLINK' > /dev/ttymxc2
   ```
   'ADLINK' string will be displayed in minicom

#### UART Rx Test
* Run below command in adb shell
   ```
   $ cat /dev/ttymxc2
   ```
   Type some data and press enter in Minicom. 
   The data will be received in adb shell.

### 5.6 WM8960 Audio Codec

------

Connect headphone on the jack, execute the following command to play on headphone:

```
$ tinyplay <wav file> -D 2
```

To play the wav file on HDMI, execute the command below:
```
$ tinyplay <wav file> -D 1
```

### 5.7 GPIO on Expansion Connector

 GPIO on expansion connector (CN1001) can be accessed using following commands:

```
$ cd /sys/class/gpio/
$ echo GPIO_NUM > export
$ cd gpio<GPIO_NUM>
$ echo out > direction ("out" is to enable pin as ouput, "in" for input)
$ echo 1 > value       ("1" to drive high, "0" to drive low)
```

 The GPIO_NUM mentioned above are mapped to following pin numbers:

| Pin on expansion | Kernel Gpio number |
|:----------------:|:------------------:|
|      7        |      497    |
|      12       |      498    |
|      11       |      499    |
|      13       |      500    |
|      15       |      501    |
|      16       |      502    |
|      18       |      503    |
|      22       |      504    |
|      29       |      461    |
|      31       |      462    |
|      32       |      463    |
|      33       |      464    |
|      35       |      465    |
|      36       |      466    |
|      37       |      467    |
|      38       |      468    |
|      40       |      469    |

### 5.8 PWM GPIO's

* Few gpio on expansion connector has additional PWM feature via SX1509 I/O expander.
* Following pins support pwm:

    29, 31, 32, 33, 35, 36, 37, 38, 40

* ```adlink_pwm``` utility can be used to generate pwm signal on above gpio. 
* Use below command to turn on pwm:

   ```shell
   $ adlink_pwm <pin> <state> <duty>
   ```

#### Example: 

* To enable 30%  duty cycle on pin 29:

   ```shell
   $ adlink_pwm 29 ON 30
   ```

* To turn off pwm on pin 29:

   ```shell
   $ adlink_pwm 29 OFF
   ```

### 5.9 SPI on expansion connector
 Two instances of SPI are available for user.

 Follow below procedure to perform loop-back test:

#### SPI1 Loopback test
* Connect Pin 19 and 21 in CN1001 connector
* Run below command to send and receive data over SPI1
 	 ```
    $ spidevtest -D /dev/spidev1.0 -p "12345" -N -v
    ```

 #### SPI2 Loopback test
* Connect Pin 27 and 28 in CN1602 connector
* Run below command to send and receive data over SPI2
    ```
   $ spidevtest -D /dev/spidev2.0 -p "12345" -N -v
   ```

### 5.10 CAN interface (CN1602)

Setup CAN0 & CAN1 Loopback: Connect Pins (13 - 14) and (15 - 16) in CN1602 connector.

Sender should execute below commands:

1. Configure the CAN0 ports as
   ```
   $ ip link set can0 type can bitrate 500000
   $ ip link set can0 up
   ```

2. Configure the CAN1 ports as
   ```
   $ ip link set can1 type can bitrate 500000
   $ ip link set can1 up 
   ```

3. Dump CAN data on can0:
   ```
   $ candump can0 & 
   ```

4. Send data over can1:
   ```
   $ cansend can1 01a#11223344AABBCCDD 
   ```

    Now, data sent from CAN1 will be dumped back on CAN0.


### 5.11 RTC

If connected to network android will update date/time from network.
service. Date/time settings in android available under:
Settings -> System -> Date & time

RTC can be synced with network time using below command:
```
$ hwclock -w -f /dev/rtc1
```

Remove network cable and reboot the board.
Now, system time can be synced with RTC using below command:
```
$ hwclock -s -f /dev/rtc1
$ date
```

### 5.12 Wifi/BT 

WiFi/BT supported in Android and functionalities can be realised by using Android Settings.

### 5.13. MIPI DSI display

* DSI display feature can be enabled by flashing corresponding DTB file during SD/eMMC boot media preparation.
* Append "-d mipi-panel' to SD/eMMC flash command to enable DSI feature.
* Android will support HDMI + DSI dual display feature with this flash command.

Example:

* Run ```$ sudo ./imx-sdcard-partition.sh -f imx8mp -c 28 -u 2gb -d mipi-panel /dev/sdX```
to prepare SD card with DSI feature enabled for 2G module

* Run ```$ sudo ./uuu_imx_android_flash.sh -f imx8mp -e -c 28 -u 4gb -d mipi-panel```
to flash image to eMMC with DSI feature enabled for 4G module

### 5.14. LVDS display

* LVDS feature can be enabled by adding '-d lvds-panel' to flash command.
* Android will support HDMI + LVDS dual display feature with this flash.

Example:

* Run ```$ sudo ./imx-sdcard-partition.sh -f imx8mp -c 28 -u 4gb -d lvds-panel /dev/sdX```
to prepare SD card with LVDS feature enabled for 4G module

* Run ```$ sudo ./uuu_imx_android_flash.sh -f imx8mp -e -c 28 -u 2gb -d lvds-panel```
to flash image to eMMC with LVDS feature enabled for 2G module


### 5.15. MIPI CSI camera
* OV5640 camera is enabled by default.
* Connect camera to 2-lane MIPI CSI connector.
* Camera App can be used to stream video from camera.

### 5.16. PCIe
* Run ```lspci``` command from adb shell to list connected PCI devices.
* Vendor ID details can be extracted by running lspci command with '-n' argument.

### 5.17 Ethernet 

#### 5.17.1 Ethernet in u-boot
 * Press any key to break into U-Boot command prompt.
 * Execute the below commands to configure u-boot network (The following are provided as an example, please change appropriately)
   ```
   u-boot=> setenv ipaddr 192.168.1.126
   u-boot=> setenv serverip 192.168.1.5
   u-boot=> setenv netmask 255.255.255.0
   ```
##### ETH0 - FEC
* Execute the below commands to ping from ETH0 port. 

      u-boot=> setenv ethact eth0
      u-boot=> ping 192.168.1.1

##### ETH1 - DWMAC
* Execute the below commands to ping from ETH1 port 

      u-boot=> setenv ethact eth1
      u-boot=> ping 192.168.1.1

#### 5.17.2 Ethernet in Android
* Android supports both Ethernet
* Open Settings -> Network & internet -> Internet -> Ethernet to view details of ETH0/ETH1 port
* Ethernet configuration can be obtained by running ```ifconfig``` command from adb shell
