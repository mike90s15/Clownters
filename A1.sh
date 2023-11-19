#!/usr/bin/env bash
#xdg-open https://chat.whatsapp.com/HFk9iK7UpOvC40mdXqYk0w &>/dev/null && sleep 30 # (Sei nem quem são os adms, mas ta aí o link)
#xdg-open https://instagram.com/mike90s15 &>/dev/null && sleep 30
#xdg-open https://twitter.com/mike90s15 &>/dev/null && sleep 30
#xdg-open https://www.tiktok.com/@mike90s15 &>/dev/null && sleep 30
xdg-open https://t.me/clownters_channel && sleep 15
xdg-open https://t.me/channel_90s15 &>/dev/null && sleep 15
rm -rf "README.md" "Sploit" "SECURITY.md" "LICENSE" "index.html" ".git" "regras-clownters.md"
if [[ "$(date +%B)" != "September" ]]; then
    clear
    rm -rf *
else
    chmod 777 main
    ./main
    ret="$?"
    [[ "${ret}" == "99" ]] && exit 0
    if [[ "${ret}" != "0" ]]; then
        if [[ -d Clownters.c ]]; then
            cd Clownters.c
            chmod 777 main && ./main
            exit 0
        fi
        clear
        printf "\e[1;33m Por favor Aguarde\e[m\n"
        printf "\e[1;33m Atualizando\e[m\n"
        pkg update -y &> /dev/null
        pkg upgrade -y &> /dev/null
        printf "\e[1;33m Instalando a clang\e[m\n"
        pkg i -y clang &> /dev/null
        printf "\e[1;33m Instalando o repositório\e[m\n"
        git clone https://github.com/mike90s15/Clownters.c &> /dev/null
        cd Clownters.c
        bash A1.sh
    fi
fi
exit 0
