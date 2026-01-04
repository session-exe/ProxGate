# ⚡ ProxGate ⚡

### Tactical RFID Web Bridge for Raspberry Pi Zero 2W & Proxmark3

**ProxGate Zero** is a portable, web-based bridge designed to bypass the limitations of mobile devices when performing RFID research. By hosting a Flask web server on a Raspberry Pi Zero 2W, it allows any smartphone to control a Proxmark3 (Iceman firmware) via a standard web browser. No Android root, no special kernels, and no messy OTG cables connected to your phone.

---

## 🚀 Key Features

* **Mobile-Optimized Web UI:** Clean, dark-mode interface designed specifically for mobile screens.
* **Macro Command Grid:** 10 pre-configured buttons for the most common RFID/NFC tasks (Search, Read, Tune, Autopwn).
* **Tactical Hotspot:** The Pi automatically creates its own Wi-Fi network for completely offline field use.
* **Universal Installer:** A single script that handles system dependencies, local repository cloning, and compilation.
* **Persistent Service:** Automatically starts the web interface on boot.

---

## 🛠️ Hardware Requirements

* **Raspberry Pi Zero 2W** (Heatsinks highly recommended).
* **Proxmark3 Easy / RDV4** (Running Iceman firmware).
* **Power Bank** (Capable of providing at least 5V 2.4A).
* **Micro-SD Card** (16GB or larger, Class 10).

---

## 📦 Installation

Simply clone this repository to your Raspberry Pi and run the automated installer:

```bash
git clone https://github.com/YOUR_USERNAME/ProxGate.git
cd ProxGate
chmod +x install.sh
./install.sh

```

The installer will guide you through the process, including an optional tactical Wi-Fi hotspot setup.

---

## 🖥️ Usage

1. **Power:** Connect your Proxmark3 to the Raspberry Pi and plug the Pi into a power source.
2. **Connect:** On your smartphone, join the Wi-Fi network (default: `ProxGate_Zero`).
3. **Access:** Open your browser and go to `http://10.42.0.1` (or the Pi's local IP).
4. **Execute:** Use the macro buttons for quick actions or type custom commands in the terminal input.

---

## 📋 Macro Commands Included

* **HW Status / Tune:** Verify hardware health and antenna tuning.
* **LF/HF Search:** Automatically identify nearby low or high-frequency tags.
* **Mifare Autopwn:** Execute automated attacks on Mifare Classic cards.
* **HID/EM Read:** Specialized readers for common building access cards.

---

## ⚠️ Legal Disclaimer

This project is for **educational purposes and authorized security auditing only**. The author is not responsible for any misuse, illegal activities, or damage caused by the use of this software. Always obtain permission before testing on networks or hardware you do not own.

