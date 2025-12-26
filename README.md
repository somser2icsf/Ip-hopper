# 🔁 Ip Hopper

IPHopper is an advanced IP rotation tool designed for ethical hackers, privacy enthusiasts, and cybersecurity learners.
It works by launching multiple Tor nodes in parallel and routing traffic through a centralized Privoxy proxy server — enabling users to automatically change their public IP address at customizable intervals.

Whether you're conducting anonymous security research or learning how anonymization networks like Tor work, IPHopper provides a lightweight and powerful CLI-based solution — especially built for Termux and Linux-based systems.

-

# 🎯 Purpose of IPHopper

When working in the cybersecurity field or doing web reconnaissance, constantly changing your IP address can help avoid detection, rate-limiting, and geo-restrictions.
Most users rely on VPNs, but VPNs are centralized services and not always transparent. Tor, on the other hand, offers a decentralized and free solution for anonymity.

IPHopper combines:

Multiple Tor instances (multi-node parallelization)

A central Privoxy proxy server

IP rotation automation via control ports

All packaged in a simple tool with beginner-friendly configuration and advanced functionality under the hood.

**Developer:** Somser SA  
**Platform:** Termux / Linux (Non-root)

---

## 🚀 Features
🔁 Auto IP Rotation using the Tor Network
🧠 Multiple Tor Nodes: Five nodes running simultaneously
🔒 Privacy-focused: All traffic routed through a secure proxy
🧱 No Root Required: Fully works on non-rooted Termux devices
📟 Custom Rotation Timer: Set your own rotation interval in seconds
🧰 Self-contained Configuration: Cleans and reinitializes on every run
💻 Termux + Linux Compatible
👨‍💻 Developed by Somser SA



---

## 📦 Required Packages (Install First)

Before running the tool, make sure these packages are installed:

### 🔹 Termux
```bash
pkg update -y && pkg upgrade -y
pkg install python tor curl git -y
git clone https://github.com/somser2icsf/Ip-hopper
cd Ip-hopper
python run.py
