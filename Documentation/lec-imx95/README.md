# Android 15 for ADLINK LEC-iMX95

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
   5.4. UART1 - Console
   5.5. UART2 - TTL
   5.6. GPIO on expansion connector
   5.7. PWM GPIO
   5.8. SPI on expansion connector
   5.9. CAN interface
   5.10. RTC
   5.11. Ethernet
   5.12. LVDS display
```
## 1 Hardware Details

| Base | I-Pi SMARC Plus |
|:----------------|:-----------|
| **Module** | **LEC-iMX95** |

## 2 Software Details
|   Android   |   Ver  15   |
|:-----------:|:-----------:|
| **Kernel**  | **6.6.56** |
| **U-Boot**  | **2024.04** |
| **Host OS** | **Ubuntu 22.04.4** |


## 3 Package structure

 ```
  |---adlink-lec-imx95-android-VannilaIceCream_V2_R1_250801
     |--- android images
     |--- README.md
 ```
- Download Android release (adlink-lec-imx95-android-vannilaicecream_V2_R1_250801.zip) and extract it.


## 4 Flashing the Image and Booting

### 4.1 SD Boot

#### Host preparation

1. On a linux host machine, insert the micro SD card (through an USB adapter).

2. Check the device node of the micro SD card using dmesg command.

3. Move into android release directory ```adlink-lec-imx95-android-vannilaicecream_V2_Alpha_250619```

   ```
   $ sudo cp tools/lib64/libc++.so /lib/x86_64-linux-gnu
   $ sudo chmod +x /lib/x86_64-linux-gnu/libc++.so
   ```

   ```
   $ sudo cp tools/bin/make_f2fs tools/bin/simg2img /usr/bin
   $ sudo chmod +x /usr/bin/make_f2fs /usr/bin/simg2img
   ```

#### Flash image to SD card

* Execute the following command for a 32 GB Micro-SD card.
   ```
   $ sudo ./imx-sdcard-partition.sh -f imx95 /dev/sdX
   ```
* /dev/sdX need to be changed to actual device node of the micro SD card

* For more details, please refer: https://www.nxp.com/docs/en/user-guide/ANDROID_USERS_GUIDE.pd

  Note: First boot from SD card can be slow,subsequent boot will be faster


### 4.2 eMMC Boot

#### Download uuu utility

 - Download uuu utility and copy to /usr/bin

 - https://github.com/nxp-imx/mfgtools/releases/download/uuu_1.5.201/uuu

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
   $ sudo ./uuu_imx_android_flash.sh -f imx95 -e 
   ```

* Once flashing completed, power off the board and change boot settings to eMMC mode.
* Power on the board to boot Android from eMMC.


## 5 Peripheral testing
### 5.1 USB Type A

* All USB type A ports are validated.
* Any storage device connected on these ports will be mounted at "/mnt/media_rw" location.
* Device can also be accessed from Android GUI.


### 5.2 Micro USB (Device mode)

 * Not supported due to Hardware Limitation.

### 5.3 HDMI

HDMI function is enabled by default.

### 5.4 UART1 - Console

* Connect RS232 compatible UART cable to CN1609 expansion connector.
* Connect UART cable to CN1001 expansion connector to get android boot logs.

 Pin connection:

| Pin  | Function |
|:----:|:--------:|
| 1 | UART RX |
| 3 | UART TX |
| 5 | GND     |



### 5.5 UART2 - TTL

* Console UART works at TTL level. Use TTL compatible USB Serial adapter to get logs.

Pin connection:

| Pin  | Function |
|:----:|:--------:|
| 10 | UART RX |
| 8  | UART TX |
| 6  | GND     |


#### UART Tx Test
* Open minicom, 115200 baudrate with no hardware flow control setting.
* Run the below commands from adb shell to transmit data to Minicom.
   ```
   $ stty -F /dev/ttyLP6 115200 cs8 -cstopb -parenb
   $ echo 'ADLINK' > /dev/ttyLP6
   ```
   'ADLINK' string will be displayed in minicom

#### UART Rx Test
* Run below command in adb shell
   ```
   $ cat /dev/ttyLP6
   ```
   Type some data and press enter in Minicom.
   The data will be received in adb shell.

### 5.6 GPIO on Expansion Connector

 GPIO on expansion connector (CN1001) can be accessed using following commands:

```
$ gpioset <gpio chip> <gpio num>=<0|1>
```

 The GPIO_NUM mentioned above are mapped to following pin numbers:

| Pin on expansion | Gpio Chip    | Gpio number |
|:----------------:|:------------------:|:---------------:|
|      7        |    gpiochip4    |   16    |
|      12       |    gpiochip4    |   17    |
|      11       |    gpiochip4    |   18    |
|      13       |    gpiochip4    |   19    |
|      15       |    gpiochip4    |   20    |
|      16       |    gpiochip4    |   15    |
|      18       |    gpiochip4    |    3    |
|      22       |    gpiochip4    |    2    |
|      29       |    gpiochip5    |    0    |
|      31       |    gpiochip5    |    1    |
|      32       |    gpiochip5    |    2    |
|      33       |    gpiochip5    |    3    |
|      35       |    gpiochip5    |    4    |
|      36       |    gpiochip5    |    5    |
|      37       |    gpiochip5    |    6    |
|      38       |    gpiochip5    |    7    |
|      40       |    gpiochip5    |    8    |

### 5.7 PWM GPIO's

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

### 5.8 SPI on expansion connector
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

### 5.9 CAN interface (CN1602)

Setup CAN0 & CAN1 Loopback: Connect Pins (13 - 14) and (15 - 16) in CN1602 connector.

Sender should execute below commands:

1. Configure the CAN0 ports as
   ```
   $ ip link set can0 type can bitrate 500000
   $ ip link set can0 up
   ```

3. Dump CAN data on can0:
   ```
   $ candump can0 &
   ```

4. Send data over can0:
   ```
   $ cansend can1 01a#11223344AABBCCDD
   ```

    Now, data sent from CAN0 will be dumped on CAN Analyzer.


### 5.10 RTC

* Android will update date/time from internet when connected to network. Date/time settings in android available under:
  Settings -> System -> Date & time

* Once time is updated, remove network cable and power off the board.
  Wait for some time and power on the board, system will now sync time from RTC.

### 5.11 Ethernet

#### 5.11.1 Ethernet in u-boot
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
* Execute the below commands to ping from ETH1 port.

      u-boot=> setenv ethact eth1
      u-boot=> ping 192.168.1.1

### 5.12. LVDS display

* LVDS feature can be enabled by adding '-d lvds-panel' to flash command.

Example:

* Run ```$ sudo ./imx-sdcard-partition.sh -f imx95 -d lvds-panel /dev/sdX```
to prepare SD card with LVDS feature enabled

* Run ```$ sudo ./uuu_imx_android_flash.sh -f imx95 -e -d lvds-panel```
to flash image to eMMC with LVDS feature enabled

### 5.13. MIPI display

* MIPI Display feature can be enabled by adding '-d mipi-panel' to flash command.

Example:

* Run ```$ sudo ./imx-sdcard-partition.sh -f imx95 -d mipi-panel /dev/sdX```
to prepare SD card with MIPI Display feature enabled

* Run ```$ sudo ./uuu_imx_android_flash.sh -f imx95 -e -d mipi-panel```
to flash image to eMMC with MIPI Display feature enabled

### 5.14. OV5640 Camera

* OV5640 Camera feature can be enabled by adding '-d ov5640' to flash command.

Example:

* Run ```$ sudo ./imx-sdcard-partition.sh -f imx95 -d ov5640 /dev/sdX```
to prepare SD card with OV5640 Camera enabled

* Run ```$ sudo ./uuu_imx_android_flash.sh -f imx95 -e -d ov5640```
to flash image to eMMC with OV5640 Camera enabled

* After flashing the image, run the camera application for preview

Limitations:
1. MIPI DSI shared between DSI2HDMI Adapter and Display. HDMI is default. To use MIPI DSI Display, Hardware Modification to be done
2. MIPI DSI & 2 Lane Camera interface are shared in SoC, Require hardware modification to use 2 Lane Camera
3. 4 Lane camera requires hardware modification.
