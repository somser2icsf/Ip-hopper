# --- Colors & Styles ---
RED='\033[1;31m'
GREEN='\033[1;32m'
YELLOW='\033[1;33m'
BLUE='\033[1;34m'
CYAN='\033[1;36m'
WHITE='\033[1;37m'
RESET='\033[0m'
BLINK='\033[5m'

# --- Functions for Animation ---

# 1. Typewriter Effect
type_text() {
    text="$1"
    delay="$2"
    for ((i=0; i<${#text}; i++)); do
        echo -n "${text:$i:1}"
        sleep $delay
    done
    echo ""
}

# 2. Spinner Animation
spinner() {
    local pid=$1
    local delay=0.1
    local spinstr='|/-\'
    while [ "$(ps a | awk '{print $1}' | grep $pid)" ]; do
        local temp=${spinstr#?}
        printf " [%c]  " "$spinstr"
        local spinstr=$temp${spinstr%"$temp"}
        sleep $delay
        printf "\b\b\b\b\b\b"
    done
    printf "    \b\b\b\b"
}

# 3. Progress Bar
progress_bar() {
    echo -ne "${CYAN}[Wait] Loading Modules: ${RESET}"
    for i in {1..20}; do
        echo -ne "${GREEN}▓${RESET}"
        sleep 0.05
    done
    echo -e " ${GREEN}DONE!${RESET}"
}

# --- Main Interface ---

clear
echo -e "${GREEN}"
cat << "EOF"
██╗██████╗       ██╗  ██╗ ██████╗ ██████╗ ██████╗ ██████╗ ██████╗
██║██╔══██╗      ██║  ██║██╔═══██╗██╔══██╗██╔══██╗██╔══██╗██╔══██╗
██║██████╔╝█████╗███████║██║   ██║██████╔╝██████╔╝██████╔╝██████╔╝
██║██╔═══╝ ╚════╝██╔══██║██║   ██║██╔═══╝ ██╔═══╝ ██╔══██╗██╔══██╗
██║██║           ██║  ██║╚██████╔╝██║     ██║     ██║  ██║██║  ██║
╚═╝╚═╝           ╚═╝  ╚═╝ ╚═════╝ ╚═╝     ╚═╝     ╚═╝  ╚═╝╚═╝  ╚═╝
EOF
echo -e "${RESET}"

echo -e "${RED}============================================================${RESET}"
echo -e "${YELLOW}      💀 SYSTEM: DARK_TOR_GHOST  |  OWNER: Somser SA 💀${RESET}"
echo -e "${CYAN}             🛡️  TEAM: ISLAMIC CYBER SECURITY FORCE  🛡️${RESET}"
echo -e "${RED}============================================================${RESET}"
echo ""

# Fake Loading
progress_bar
echo ""

# Check for required tools
echo -ne "${BLUE}[*] Checking dependencies... ${RESET}"
for tool in tor privoxy curl nc; do
    if ! command -v $tool &> /dev/null; then
        echo -e "${RED}FAILED!${RESET}"
        echo -e "${YELLOW}Please install: $tool${RESET}"
        exit 1
    fi
done
echo -e "${GREEN}COMPLETED!${RESET}"
sleep 1

# --- Setup Phase ---

echo -e "\n${CYAN}[+] Initializing Anonymity Sequence...${RESET}"

# Kill old services
pkill tor > /dev/null 2>&1
pkill privoxy > /dev/null 2>&1
rm -rf ~/.tor_multi ~/.privoxy
mkdir -p ~/.tor_multi ~/.privoxy

# Launch Tor Instances
PORTS=(9050 9060 9070 9080 9090)
CONTROL_PORTS=(9051 9061 9071 9081 9091)

echo -ne "${YELLOW}[+] Booting Tor Nodes "
for i in {0..4}; do
    TOR_DIR="$HOME/.tor_multi/tor$i"
    mkdir -p "$TOR_DIR"
    cat <<EOF > "$TOR_DIR/torrc"
SocksPort ${PORTS[$i]}
ControlPort ${CONTROL_PORTS[$i]}
DataDirectory $TOR_DIR
CookieAuthentication 0
EOF
    tor -f "$TOR_DIR/torrc" > /dev/null 2>&1 &
    echo -ne "."
    sleep 0.5
done
echo -e "${GREEN} OK!${RESET}"

# Setup Privoxy
echo -ne "${YELLOW}[+] Configuring Proxy Chain...${RESET}"
cat <<EOF > "$HOME/.privoxy/config"
listen-address 127.0.0.1:8118
EOF
for port in "${PORTS[@]}"; do
    echo "forward-socks5 / 127.0.0.1:$port ." >> "$HOME/.privoxy/config"
done
privoxy "$HOME/.privoxy/config" > /dev/null 2>&1 &
echo -e "${GREEN} SECURED!${RESET}"

echo -e "\n${RED}--------------------------------------------${RESET}"
type_text "ENTER ROTATION INTERVAL (Seconds) ⤵️ : " 0.05
read -r ROTATION_TIME

if [[ ! "$ROTATION_TIME" =~ ^[0-9]+$ ]] || [[ "$ROTATION_TIME" -lt 5 ]]; then
    echo -e "${RED}⚠ Invalid Input! System defaulting to 10s.${RESET}"
    ROTATION_TIME=10
fi

clear
echo -e "${GREEN}✅ SYSTEM ACTIVE. YOU ARE NOW INVISIBLE.${RESET}"
echo -e "${CYAN}Press CTRL+C to stop the script.${RESET}\n"

# --- Main Loop ---
count=1
while true; do
    echo -e "${RED}──────────────────────────────────────────────${RESET}"
    echo -e "${RED}│${YELLOW} ⚡ ROTATION SEQUENCE: #$count ${RED}                  │${RESET}"
    
    # Request New Identity
    for ctrl_port in "${CONTROL_PORTS[@]}"; do
        echo -e "AUTHENTICATE \"\"\r\nSIGNAL NEWNYM\r\nQUIT" | nc 127.0.0.1 $ctrl_port > /dev/null 2>&1
    done
    
    echo -ne "${RED}│${CYAN} 🔄 Changing Identity...       ${RESET}"
    sleep 2 # Fake delay for effect
    
    # Check IP
    NEW_IP=$(curl --proxy http://127.0.0.1:8118 -s https://api64.ipify.org --max-time 5)
    
    if [ -z "$NEW_IP" ]; then
        NEW_IP="${RED}Connection Failed/Retrying...${RESET}"
    else
        NEW_IP="${GREEN}$NEW_IP${RESET}"
    fi

    echo -e "\n${RED}│${WHITE} 🌍 NEW IP ASSIGNED: $NEW_IP ${RESET}"
    echo -e "${RED}│${BLUE} 🛰️  PROXY TUNNEL:   127.0.0.1:8118 ${RESET}"
    echo -e "${RED}──────────────────────────────────────────────${RESET}"
    
    # Progress bar for waiting time
    echo -ne "${YELLOW}⏳ Next jump in ${ROTATION_TIME}s: ${RESET}"
    for ((k=0; k<$ROTATION_TIME; k++)); do
        echo -ne "▓"
        sleep 1
    done
    echo ""
    
    ((count++))
done
