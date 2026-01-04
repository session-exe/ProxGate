# ⚡ ProxGate ⚡

### Tactical RFID Web Bridge for Raspberry Pi Zero 2W & Proxmark3

**ProxGate** is a portable, web-based bridge designed to bypass the limitations of mobile devices when performing RFID research. By hosting a Flask web server on a Raspberry Pi Zero 2W, it allows any smartphone to control a Proxmark3 (Iceman firmware) via a standard web browser. No Android root, no special kernels, and no messy OTG cables connected to your phone.

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
* **Power Bank** (Capable of providing at least 5V 2A).
* **Micro USB OTG Cable** (to connect your Proxmark to your Pi Zero 2W).

---

## 😎 Recommendations

### Operating System

* **Raspberry Pi OS Lite (64-bit)**: Highly recommended for better memory management and performance on the Zero 2W.

### Pre-Configuration

Before flashing your SD card with **Raspberry Pi Imager**, use the **Advanced Options**:

1. **Enable SSH**: Use password authentication.
2. **Set Username/Password**: Create your user credentials.
3. **Configure Wi-Fi**: Set your home Wi-Fi so you can SSH into the Pi immediately after boot.

---

## 📦 Installation

Simply clone this repository to your Raspberry Pi and run the automated installer:

```bash
git clone https://github.com/session-exe/ProxGate.git
cd ProxGate
chmod +x install.sh
./install.sh

```

The installer will guide you through the process, including an optional tactical Wi-Fi hotspot setup.

---

## 🖥️ Usage

1. **Power:** Connect your Proxmark3 to the Raspberry Pi and plug the Pi into a power source.
2. **Connect:** On your smartphone, join the Wi-Fi network (default: `ProxGate`).
3. **Access:** Open your browser and go to `http://10.42.0.1` (or the Pi's local IP).
4. **Execute:** Use the macro buttons for quick actions or type custom commands in the terminal input.

---

## 📋 Macro Commands Included

* **HW Status / Tune:** Verify hardware health and antenna tuning.
* **LF/HF Search:** Automatically identify nearby low or high-frequency tags.
* **Mifare Autopwn:** Execute automated attacks on Mifare Classic cards.
* **HID/EM Read:** Specialized readers for common building access cards.

---

## ❤️ Credits & Acknowledgments

This project is a web-bridge for the incredible work done by the **RfidResearchGroup**. **ProxGate** would not be possible without:

* **Iceman (@iceman1001)**: For his tireless work on the [Proxmark3 Iceman Fork](https://github.com/RfidResearchGroup/proxmark3), which is the absolute gold standard for RFID research and exploitation.
* **RfidResearchGroup Community**: For the continuous development and maintenance of the firmware and client software used in this project.

---

## ⚠️ Legal Disclaimer

This project is for **educational purposes and authorized security auditing only**. The author is not responsible for any misuse, illegal activities, or damage caused by the use of this software. Always obtain permission before testing on networks or hardware you do not own.
