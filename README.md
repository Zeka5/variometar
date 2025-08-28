# IoT Variometar - Diplomski rad

Variometar za paraglajding sa IoT funkcionalnostima. Sistem koristi Raspberry Pi 5 sa BMP390 barometrijskim senzorom za merenje brzine penjanja/spuštanja i omogućava pristup podacima preko WiFi mreže putem web interfejsa ili mobilne Flutter aplikacije.

## Funkcionalnosti

### Backend (Raspberry Pi 5)
- Real-time čitanje barometrijskog pritiska, temperature i visine
- Kalkulacija brzine penjanja/spuštanja sa filtriranjem šuma
- WiFi hotspot mode za direktan pristup bez interneta
- WebSocket komunikacija za real-time podatke
- Automatsko snimanje letova sa statistikama
- REST API za upravljanje snimljenim letovima
- JSON za čuvanje podataka

### Web Interface
- Responzivan dizajn za mobilne uređaje
- Real-time prikaz podataka sa senzora
- Start/Stop kontrole za snimanje letova
- Lista snimljenih letova sa detaljima
- Mogućnost brisanja letova

### Flutter Mobilna Aplikacija
- Native Android/iOS aplikacija
- WebSocket konekcija za real-time podatke
- Upravljanje letovima (start, stop, pregled, brisanje)
- Automatsko prebacivanje između hotspot/WiFi režima

## Tehnička specifikacija

### Hardware
- **Raspberry Pi 5** - glavna računarska jedinica
- **BMP390** - barometrijski senzor (±0.03 hPa)
- **Power bank 20,000mAh** - napajanje za portabilnost
- **I2C komunikacija** - konekcija senzora na GPIO pinove

### Software Stack
- **Python 3.11** sa Flask web framework
- **Flask-SocketIO** - WebSocket komunikacija
- **Adafruit CircuitPython** biblioteke za BMP390
- **hostapd + dnsmasq** - WiFi hotspot infrastruktura
- **Flutter/Dart** - mobilna aplikacija

### Networking
- **Hotspot mode**: RPi kreira vlastitu WiFi mrežu (192.168.4.1)
- **WiFi client mode**: povezivanje na postojeću mrežu
- **Hibridni pristup**: automatsko prebacivanje između režima

## Struktura projekta

```
variometer/
├── backend/
│   ├── variometar_web.py          # Flask web server sa WebSocket
│   ├── start_variometer.sh        # Startup script sa hotspot setup
│   └── requirements.txt           # Python dependencies
├── flutter_app/
│   ├── lib/main.dart              # Flutter aplikacija
│   └── pubspec.yaml               # Flutter dependencies
├── docs/
│   └── setup_guide.md             # Detaljan setup vodič
└── README.md
```

## Brza instalacija

1. **Hardware setup**: Povezati BMP390 na RPi5 I2C pinove
2. **Software**: Pokrenuti setup script za dependencies i konfiguraciju
3. **Network**: Konfigurisati WiFi hotspot funkcionalnost
4. **Test**: Verifikovati komunikaciju sa senzorom i web interface

Detaljne instrukcije u [docs/setup_guide.md](docs/setup_guide.md)

## Ključni algoritmi

### Filtriranje brzine penjanja
- Moving average preko 3-sekundnog prozora (uzima se prosečna vrednost kroz 3 sekunde radi smanjenja šuma)
- Korišćenje stvarnih timestamp-ova umesto pretpostavljenih intervala
- Redukcija senzor šuma za stabilno čitanje

### Statistike leta
Umesto čuvanja svih sirovih podataka, sistem čuva optimizovane statistike:
- Max/min visina i temperatura
- Max brzine penjanja/spuštanja  
- Ukupno trajanje i broj merenja
- Visinska razlika tokom leta

## API Endpoints

### WebSocket Events
- `sensor_data` - Real-time senzor podaci
- `start_flight` - Pokretanje snimanja leta
- `stop_flight` - Završetak snimanja leta

### REST API
- `GET /api/flights` - Lista svih letova
- `GET /api/flight/<filename>` - Detalji određenog leta
- `DELETE /api/flight/<filename>` - Brisanje leta

## Performanse

- **Frekvencija čitanja**: 2Hz (svakih 0.5s)
- **Preciznost visine**: ±25cm (BMP390 specifikacija)
- **WiFi domet**: 50-100m
- **Trajanje baterije**: zavisno od izvora napajanja

## Razvoj

Projekat je razvijen kao diplomski rad na Fakultetu tehničkih nauka u Novom Sadu, smer Računarstvo i automatika. Demonstrira praktičnu primenu IoT tehnologija u oblasti sportske avijacije.

### Sledeći koraci u planu
- GPS modul za praćenje pozicije i brzine
- Audio signali (buzzer) za variometar tonove
- Cloud sync funkcionalnost
- Integrisana analiza termalnih aktivnosti
