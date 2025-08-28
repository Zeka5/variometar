#!/bin/bash
sleep 10

echo "=== VARIOMETER STARTUP LOG ===" > /home/milaogi/debug.log
date >> /home/milaogi/debug.log

# Ugasi NetworkManager PRIVREMENO (3 minuta)
echo "Stopping NetworkManager for hotspot mode..." >> /home/milaogi/debug.log
sudo systemctl stop NetworkManager

# Resetuj interfejs
sudo wpa_cli disconnect 2>/dev/null
sudo ip link set wlan0 down
sleep 2
sudo ip link set wlan0 up
sudo ip addr flush dev wlan0
sudo ip addr add 192.168.4.1/24 dev wlan0

# Restartuj servise
sudo systemctl restart hostapd
sudo systemctl restart dnsmasq
sleep 20

echo "Starting web app..." >> /home/milaogi/debug.log
cd /home/milaogi
source variometar_env/bin/activate

# Test osnovni Python pristup senzoru:
python3 -c "
import board, busio, adafruit_bmp3xx
i2c = busio.I2C(board.SCL, board.SDA)  
bmp = adafruit_bmp3xx.BMP3XX_I2C(i2c)
print('Temp:', bmp.temperature)
print('Press:', bmp.pressure)
print('Alt:', bmp.altitude)
"
echo "Running as user: $(whoami)" >> /home/milaogi/debug.log
echo "Groups: $(groups)" >> /home/milaogi/debug.log

python3 variometar_web.py >> /home/milaogi/app.log 2>&1 &
APP_PID=$!

echo "App started with PID: $APP_PID" >> /home/milaogi/debug.log

# Čekaj 3 minuta za hotspot mode
sleep 180

echo "Switching back to WiFi..." >> /home/milaogi/debug.log
# Ugasi aplikaciju
kill $APP_PID

# Vrati NetworkManager
sudo systemctl start NetworkManager
sleep 30
