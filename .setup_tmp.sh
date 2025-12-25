# --- Colors & Styles ---
RED='\033[1;31m'
GREEN='\033[1;32m'
YELLOW='\033[1;33m'
BLUE='\033[1;34m'
CYAN='\033[1;36m'
RESET='\033[0m'

# --- Functions ---

# Spinner Animation for background tasks
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

# Typewriter Effect
type_text() {
    text="$1"
    delay="$2"
    for ((i=0; i<${#text}; i++)); do
        echo -n "${text:$i:1}"
        sleep $delay
    done
    echo ""
}

# Banner
clear
echo -e "${RED}"
cat << "EOF"
██╗███╗   ██╗███████╗████████╗ █████╗ ██╗     ██╗     
██║████╗  ██║██╔════╝╚══██╔══╝██╔══██╗██║     ██║     
██║██╔██╗ ██║███████╗   ██║   ███████║██║     ██║     
██║██║╚██╗██║╚════██║   ██║   ██╔══██║██║     ██║     
██║██║ ╚████║███████║   ██║   ██║  ██║███████╗███████╗
╚═╝╚═╝  ╚═══╝╚══════╝   ╚═╝   ╚═╝  ╚═╝╚══════╝╚══════╝
EOF
echo -e "${RESET}"
echo -e "${CYAN}   >> AUTOMATED ENVIRONMENT SETUP TOOL <<${RESET}"
echo -e "${YELLOW}      👨‍💻 DEV: Somser SA | 🛡️ TEAM: ICSF${RESET}"
echo -e "${RED}===================================================${RESET}\n"

# --- Main Setup Process ---

echo -e "${BLUE}[*] Initiating System Upgrade Sequence...${RESET}"

# Step 1: Update & Upgrade
echo -ne "${YELLOW}  -> Updating Repositories & Packages... ${RESET}"
(apt update -y && apt upgrade -y) > /dev/null 2>&1 &
spinner $!
echo -e "${GREEN}DONE!${RESET}"

# Step 2: Install Repo
echo -ne "${YELLOW}  -> Installing TUR-REPO Extension...    ${RESET}"
(apt install tur-repo -y) > /dev/null 2>&1 &
spinner $!
echo -e "${GREEN}DONE!${RESET}"

# Step 3: Install Packages
echo -e "\n${BLUE}[*] Installing Cyber Security Tools...${RESET}"

PACKAGES=("tor" "privoxy" "netcat-openbsd" "curl" "openssl")

for pkg in "${PACKAGES[@]}"; do
    echo -ne "${CYAN}  -> Injecting Module: ${WHITE}$pkg${RESET}..."
    # Check if already installed
    if dpkg -s $pkg >/dev/null 2>&1; then
        echo -e " ${GREEN}[ALREADY INSTALLED]${RESET}"
    else
        (apt install $pkg -y) > /dev/null 2>&1 &
        spinner $!
        echo -e " ${GREEN}[SUCCESS]${RESET}"
    fi
    sleep 0.5
done

# --- Finalizing ---

echo -e "\n${RED}===================================================${RESET}"
type_text " ✅ SYSTEM READY FOR DEPLOYMENT." 0.05
type_text " 📂 YOU CAN NOW RUN THE MAIN TOOL." 0.05
echo -e "${RED}===================================================${RESET}"
echo -e "${GREEN}Enjoy Hacking, @somser_sa${RESET}\n"
