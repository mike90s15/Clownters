#!/usr/bin/env bash

<<CLOWNTERS
 #CLOWNTERS
 #--------------------------------------------------------
 # Name script: Painel Clownters                         |
 #--------------------------------------------------------
 # Script     : A1 PAINEL                                |
 #--------------------------------------------------------
 # Description: dashboard for consultation and hack tools|
 #--------------------------------------------------------
 # Version    : 0.3                                      |
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

function access()
{
    [[ -f .sl ]] && return 0
    for ((times=0;times<=2;times++)); do
        banner
        printf "
 ${green}Username
 ${blue}===> ${cyan}"
        sleep 0.5
        read_alpha
        ret="$?"
        [[ ${ret} -eq 99 ]] && return 99

        if [[ ${ret} -eq 0 ]]; then
            if [[ ${inputuse} == Hater ]]; then
                printf " Okay...$end\n"
                sleep 1
                break

            elif [[ ${inputuse} == q ]]; then
                printf " ${blue}Saindo... ${end}"
                sleep 1
                return 1

            else
                printf " ${red}\aUsername incorreto\a\n"
                [[ ${times} -lt 2 ]] && printf " Digite Q para sair\n"
                [[ ${times} -eq 2 ]] && return 1
                sleep 1

            fi
        else
            [[ ${times} -eq 2 ]] &&  return 1
        fi
    done

    for ((times=0;times<=2;times++)); do
        banner
        printf "
 ${green}Password
 ${blue}===> ${cyan}"
        sleep 0.5
        read_alpha
        ret="$?"
        [[ ${ret} -eq 99 ]] && return 99

        if [[ ${ret} -eq 0 ]]; then
            if [[ ${inputuse} == KoRn ]]; then
                printf " Okay...$end\n"
                sleep 1
                > .sl
                return 0

            elif [[ ${inputuse} == q ]]; then
                printf " ${blue}Saindo... ${end}"
                sleep 1
                return 1

            else
                printf " ${red}\aPassword incorreto\a\n"
                [[ ${times} -lt 2 ]] && printf " Digite Q para sair\n"
                [[ ${times} -eq 2 ]] && return 1
                sleep 1
            fi
        else
            [[ ${times} -eq 2 ]] && return 1
        fi
    done
}
function banco()
{
    while :; do
        clear
        banner
        printf "\n ${blue}Informe o Codigo do banco para a consulta\n ===> ${cyan}"
        read_num
        local ret="$?"
        [[ ${ret} -eq 99 ]] && return 99

        if [[ ${ret} -eq 0 ]]; then
            wget https://brasilapi.com.br/api/banks/v1/${inputuse} -O banco.txt &> /dev/null
            [[ $? -eq 4 ]] && printf "${netwget}" && sleep 1 && return 4
            echo ""
            sed 's/,/\n /g;s/"//g;s/:/: /g;s/{/\ /;s/}//' banco.txt
            rm -rf banco.txt
            echo ""
            return_menu
            [[ $? -eq 1 ]] && return 0
        fi
    done
}
function banner()
{
    clear
    sleep 0.0000000001
    printf " ${yellow}
 .--------.____________
 || ° ° ° °     .2021.|| ${green}®${yellow}"
    sleep 0.0000000001
    printf "
 ||                    | ${green}©${yellow}"
    sleep 0.0000000001
    printf "
 ||\     ______________________"
    sleep 0.0000000001
    printf "
 || \   // ° ° ° ° ° ° ° ° ° °/"
    sleep 0.0000000001
    printf "
 ||\ \ //                    /"
    sleep 0.0000000001
    printf "
 || \ //                    /"
    sleep 0.0000000001
    printf "
 ||\ //                    /"
    sleep 0.0000000001
    printf "
 || //                    /"
    sleep 0.0000000001
    printf "
 ||//                    /"
    sleep 0.0000000001
    printf "
 ||/                    /"
    sleep 0.0000000001
    printf "
 |/____________________/"
    sleep 0.0000000001
    printf "
  ${red}Arquivo Clownters ${end}\n"
    sleep 0.0000000001
    printf "
   ${pink}<<< PAINEL CLOWNTERS ${date_c} >>>"
    sleep 0.0000000001
    printf "
 ${green}=======================================\n"
    sleep 0.0000000001
}
function banner_menu()
{
    printf "\n"
    sleep 0.000000000001
    printf " ${a1}${a2}01${a3} ${cyan}Consulta de banco    ${a3}${on}\n"
    sleep 0.000000000001
    printf " ${a1}${a2}02${a3} ${cyan}Consulta de bin      ${a3}${on}\n"
    sleep 0.000000000001
    printf " ${a1}${a2}03${a3} ${cyan}Consulta de CEP      ${a3}${on}\n"
    sleep 0.000000000001
    printf " ${a1}${a2}04${a3} ${cyan}Consulta de CNPJ     ${a3}${on}\n"
    sleep 0.000000000001
    printf " ${a1}${a2}05${a3} ${cyan}Consulta de Covid19  ${a3}${on}\n"
    sleep 0.000000000001
    printf " ${a1}${a2}06${a3} ${cyan}Consulta de DDD      ${a3}${on}\n"
    sleep 0.000000000001
    printf " ${a1}${a2}07${a3} ${cyan}Consulta de IP       ${a3}${on}\n"
    sleep 0.000000000001
    printf " ${a1}${a2}08${a3} ${cyan}Consulta de telefone ${a3}${on}\n"
    sleep 0.000000000001
    printf " ${a1}${a2}09${a3} ${cyan}Gerador de CPF       ${a3}${on}\n"
    sleep 0.000000000001
    printf " ${a1}${a2}10${a3} ${cyan}Criar script         ${a3}${on}\n"
    sleep 0.000000000001
    printf " ${a1}${a2}11${a3} ${cyan}Scanear portas       ${a3}${on}\n"
    sleep 0.000000000001
    printf "\n ${a1}${red}96${a3} ${cyan}Atualizar painel     ${a3}${on}\n"
    sleep 0.000000000001
    printf " ${a1}${red}97${a3} ${cyan}Canais para ctt      ${a3}${on}\n"
    sleep 0.000000000001
    printf " ${a1}${red}98${a3} ${cyan}Informacões          ${a3}${on}\n"
    printf " ${a1}${red}99${a3} ${cyan}exit do script       ${a3}${on}\n"
    sleep 0.000000000001
    printf "\n ${blue}===> ${cyan}"
}
function bin()
{
    while :; do
        banner
        printf "${blue}\n Informe o BIN para a consulta\n ===> ${cyan}"
        read_num
        local ret="$?"
        [[ ${ret} -eq 99 ]] && return 99

        if [[ ${ret} -eq 0 ]]; then
            wget https://lookup.binlist.net/${inputuse} -O bin.txt &> /dev/null
            [[ $? -eq 4 ]] && printf "${netwget}" && sleep 1 && return 4
            printf "\n "
            sed 's/{//g;s/}//g;s/"//g;s/,/\n /g;s/:/: /g' bin.txt
            rm -rf bin.txt
            return_menu
            [[ $? -eq 1 ]] && return 0
        fi
    done
}
function cep()
{
    while :; do
        clear
        banner
        printf "\n ${blue}Informe o cep para a consulta\n ===> ${cyan}"
        read_num
        ret="$?"
        [[ ${ret} -eq 99 ]] && return 99

        if [[ ${ret} -eq 0 ]]; then
            wget https://viacep.com.br/ws/${inputuse}/json/ -O cep.txt &> /dev/null
            [[ $? -eq 4 ]] && printf "${netwget}" && sleep 1 && return 4
            sed 's/"//g;s/{//;s/}//;s/,//g' cep.txt
            rm -rf cep.txt
            return_menu
            [[ $? -eq 1 ]] && return 0
        fi
    done
}
function _cnpj()
{
    while :; do
        clear
        banner
        printf "\n ${blue}Informe o CNPJ para a consulta\n ===> ${cyan}"
        read_num
        ret="$?"
        [[ ${ret} -eq 99 ]] && return 99

        if [[ ${ret} -eq 0 ]]; then
            wget https://brasilapi.com.br/api/cnpj/v1/${inputuse} -O cnpj.txt &> /dev/null
            [[ $? -eq 4 ]] && printf "${netwget}" && sleep 1 && return 4
            echo ""
            sed 's/,/\n /g;s/"//g;s/:/: /g;s/{//g;s/}//g;s/\[//g;s/\]//g;s/_/\ /g;s/cnpj:/ cnpj:/;s/ congressos/congressos/;s/ exposi\ç\ões/exposi\ç\ões/;s/cao/ção/g;s/ao/ão/g;s/AO/ÃO/g' cnpj.txt
            rm -rf cnpj.txt
            echo ""
            return_menu
            [[ $? -eq 1 ]] && return 0
        fi
    done
}
function covid()
{
    while :; do
        banner
        printf "\n ${blue}Informe Uf para a consulta\n ===> ${cyan}"
        read_alpha
        ret="$?"
        [[ ${ret} -eq 99 ]] && return 99

        if [[ ${ret} -eq 0 ]]; then
            wget https://covid19-brazil-api.now.sh/api/report/v1/brazil/uf/${inputuse} -O covid.txt &> /dev/null
            [[ $? -eq 4 ]] && printf "${netwget}" && sleep 1 && return 4
            echo ""
            sleep 0.1
            printf " UF: "
            sed 's/,/\n\n/g' covid.txt | grep 'uf' | sed 's/"uf"://' | sed 's/"//g'
            sleep 0.1
            printf " Estado: "
            sed 's/,/\n\n/g' covid.txt | grep 'state' | sed 's/"state"://' | sed 's/"//g'
            sleep  0.1
            printf " UID: "
            sed 's/,/\n\n/g' covid.txt | grep 'uid' | sed 's/{"uid"://' | sed 's/"//g'
            sleep 0.1
            printf " Casos: "
            sed 's/,/\n\n/g' covid.txt | grep 'cases' | sed 's/"cases"://' | sed 's/"//g'
            sleep 0.1
            printf " Mortes: "
            sed 's/,/\n\n/g' covid.txt | grep 'deaths' | sed 's/"deaths"://' | sed 's/"//g'
            sleep 0.1
            printf " Suspeitos: "
            sed 's/,/\n\n/g' covid.txt | grep 'suspects' | sed 's/"suspects"://' | sed 's/"//g'
            sleep 0.1
            printf " Recusa: "
            sed 's/,/\n\n/g' covid.txt | grep 'refuses' | sed 's/"refuses"://' | sed 's/"//g'
            rm -rf covid.txt
            return_menu
            [[ $? -eq 1 ]] && return 0

        fi
    done
}
function ddd()
{
    while :; do
        clear
        banner
        printf "\n ${blue}Indorme o DDD para a consulta\n ===> ${cyan}"
        read_num
        ret="$?"
        [[ ${ret} -eq 99 ]] && return 99

        if [[ ${ret} -eq 0 ]]; then
            wget https://brasilapi.com.br/api/ddd/v1/${inputuse} -O ddd.txt &> /dev/null
            [[ $? -eq 4 ]] && printf "${netwget}" && sleep 1 && return 4
            echo ""
            sed 's/,/\n  /g;s/:/: /g;s/"//g;s/{/\ \ /;s/}//;s/\[//;s/\]/\n/;s/state/estado/;s/cities/cidades/' ddd.txt
            rm -rf ddd.txt
            return_menu
            [[ $? -eq 1 ]] && return 0
        fi
    done
}
function downloads()
{
    if [[ -d /data/data/com.termux/files/home/ ]]; then
        path_painel=`pwd`
        path_painel_bin="/data/data/com.termux/files/usr/etc/profile"
        pkg="pkg"

        if [[ -f /data/data/com.termux/files/usr/etc/.okay ]]; then
            clear

        else
            echo "PATH=${PATH}:${path_painel}" >> ${path_painel_bin}
        fi

    else
        pkg="sudo apt-get"
    fi

    if [[ -f /data/data/com.termux/files/usr/etc/.okay ]]; then
        clear

    else
        banner
        echo -e "${end}"
        echo -e " ${green}$ ${blue}installation of packages ${end}"
        #echo -e " ${green}$ ${blue}instalando Python... ${end}"
        #${pkg} install -y python &> /dev/null
        #echo -e " ${green}$ ${blue}instalando Python2... ${end}"
        #${pkg} install -y python2 &> /dev/null
        #echo -e " ${green}$ ${blue}instalando Python3... ${end}"
        #${pkg} install -y python3 &> /dev/null
        #echo -e " ${green}$ ${blue}instalando PHP... ${end}"
        #${pkg} install -y php &> /dev/null
        echo -e " ${green}$ ${blue}installing Wget... ${end}"
        ${pkg} install -y wget &> /dev/null
        echo -e " ${green}$ ${blue}installing Sed... ${end}"
        ${pkg} install -y sed &> /dev/null
        echo -e " ${green}$ ${blue}installing Nmap... ${end}"
        ${pkg} install -y nmap &> /dev/null
        #echo -e " ${green}$ ${blue}instalando Mpg123... ${end}"
        #${pkg} install -y mpg123 &> /dev/null
        [[ ${pkg} == pkg ]] && > /data/data/com.termux/files/usr/etc/.okay
        [[ ${pkg} == pkg ]] || > .okay
    fi
}
function gerador_cpf()
{
    while :; do
    soma=0
        for i in {10..2}; do
            numero=$(($RANDOM%9))
            cpf=${cpf}${numero}
            soma=$((${soma}+(${numero}*${i})))
        done

        resto=$((${soma}%11))
        [[ ${resto} -lt 2 ]] && digito=0 || digito=$((11-${resto}))
        cpf=${cpf}${digito}
        soma=0

        for i in {11..2}; do
            indice=$(((${i}-11)*-1))
            soma=$((${soma}+(${cpf:$indice:1}*${i})))1
        done

        resto=$((${soma}%11))
        [[ ${resto} -lt 2 ]] && digito1=0 || digito1=$((11-${resto}))
        cpf=${cpf}${digito1}
        clear
        banner
        printf "\n ${blue}CPF GAREDO: ${cyan}${cpf} ${end}\n"
        cpf=${nome}
        return_menu
        [[ $? -eq 1 ]] && return 0
    done
}
function ip()
{
    while :; do
        banner
        printf "\n ${blue}Informe o IP para a consulta\n ===> ${cyan}"
        read_empty
        ret="$?"
        [[ ${ret} -eq 99 ]] && return 99


        if [[ ${ret} -eq 0 ]]; then
            wget http://ip-api.com/json/${inputuse} -O ip.txt &> /dev/null
            [[ $? -eq 4 ]] && printf "${netwget}" && sleep 1 && return 4
            echo ""
            sed 's/,/\n /g;s/"//g;s/{//;s/}//;s/:/: /g;s/status/ status/;s/Inc.*//;s/LLC//;s/countryCode/Código\ do\ País/;s/country/paìs/;s/regionName/Nome\ da\ região/;s/region/região/;s/city/cidade/;s/timezone/fuso\ horário/;s/query/consulta/;s/message/mensagem/;s/invalid/inválido/' ip.txt
            lat=`sed 's/,/\n/g;s/\ \ //g' ip.txt | grep '"lat":' | sed 's/"lat"://'`
            lon=`sed 's/,/\n/g;s/\ \ //g' ip.txt | grep '"lon":' | sed 's/"lon"://'`
            [[ -n ${lat} ]] && printf "\r https://maps.google.com/?q=${lat},${lon}"
            rm -rf ip.txt
            echo ""
            return_menu
            [[ $? -eq 1 ]] && return 0
        fi
    done
}
function loading()
{
    printf "${blue} Carregando"
    sleep 0.1
    printf "${cyan}..."
    sleep 0.1
    printf "\b\b\b.. "
    sleep 0.1
    printf "\b\b.  "
    sleep 0.1
    printf "..."
    sleep 0.1
    printf "\b\b\b.. "
    sleep 0.1
    printf "\b\b.  "
    sleep 0.1
    printf "..."
    sleep 0.1
    printf "\b\b\b.. "
    sleep 0.1
    printf "\b\b.  "
    sleep 0.1
    printf "..."
    sleep 0.1
    printf "\b\b\b.. "
    sleep 0.1
    printf "\b\b.  "
    sleep 0.1
}
function new_script()
{
    banner
    printf "${blue}\n Name for the script: ${cyan}"
    read_empty
    ret="$?"
    [[ ${ret} -eq 99 ]] && return 99

    if [[ ${ret} -eq 0 ]]; then
        [[ -f ${inputuse} ]] && printf "${red} The name already exists" && sleep 1 && return 0 || > ${inputuse}
        script="${inputuse}"
        chmod u+x ${script}
        nano ${script}
    fi
}
function _nmap()
{
    while :; do
        banner
        printf "\n\e[34m Ex.: google.com ou youtu.be\n Host: \e[36m"
        read_empty
        ret="$?"
        [[ ${ret} -eq 99 ]] && return 99

        if [[ ${ret} -eq 0 ]]; then
            echo ""
            nmap ${inputuse} | grep 'open'
            return_menu
            [[ $? -eq 1 ]] && return 0
        fi
    done
}

function read_alpha()
{
    read -t 45 inputuse

    if [[ -n ${inputuse} ]]; then
        [[ ${inputuse} == q ]] && return 99

         if [[ ${inputuse} =~ ^([A-Za-z]+)$ ]]; then
             return 0

         else
             printf " ${yellow}Apenas letras!\n${end}"
             sleep 1
             return 1
         fi
    else
        printf " ${yellow}Nada digitado!\n${end}"
        sleep 1
        return 1
    fi
}
function _pstermux()
{
    banner
    local a=0
    [[ -f .okay ]] || pkg i -y figlet &> /dev/null
    echo "Okay" > .okay_tema_ps1

    for((a=0;a<=2;a++)); do
        printf "\n What's your name: " 
        read name
        [[ -n ${name} ]] && break || echo " empty. not?"
        sleep 1
    done

    local ps1="\"${pred}┌─(${pgreen}${name}${pred})${pyellow}@${pred}(${pgreen}Termux${pred})${pwhite}:${pblue_n}\w\n${pred}└─\#─≽${pgreen} \$ ${pgreen_n}\""
    printf "clear\nname=\"${name}\"\nfiglet ${name}\nPS1=${ps1}" > ~/.bashrc
    return 0;
}
function read_alphanum()
{
    echo nomw
}
function read_empty()
{
    read -t 45 inputuse
    [[ -z ${inputuse} ]] && printf " ${yellow}Nada digitado!\n${end}" && sleep 1 && return 1
    [[ ${inputuse} == q ]] && return 99
    return 0
}
function read_num()
{
    read -t 45 inputuse

    if [[ -n ${inputuse} ]]; then
        [[ ${inputuse} == q ]] && return 99

        if [[ ${inputuse} == ?(+|-)+([0-9]) ]] ; then
            return 0

        else
            printf " ${yellow}Apenas numeros!\n${end}"
            sleep 1
            return 1
        fi

    else
        printf " ${yellow}Nada digitado!\n${end}"
        sleep 1
        return 1
    fi
}
function read_special()
{
    echo nome
}
function return_menu()
{
    printf "${b}
 ${blue}Continue ou retorne ao menu principal

 ${a1}${a2}01${a3} ${cyan}Continue       ${a3}${on}
 ${a1}${a2}02${a3} ${cyan}Return to menu ${a3}${on}

 ${blue}===> ${cyan}"
    read inputuse

    case ${inputuse} in
        01) return 0;;
        1) return 0;;
        02) return 1;;
        2) return 1;;
        q) return 1
    esac
}
function social_networks()
{
    clear
    termux-open-url https://t.me/CLOWNTERS &> /dev/null
    sleep 1
    termux-open-url https://chat.whatsapp.com/EEpJ3seLYe3Ir7nGI8818m &> /dev/null
    sleep 2
    banner
    printf "\n${blue} TELEGRAM: ${cyan}https://t.me/CLOWNTRRS\n"
    printf "${blue} FACEBOOK: ${cyan}https://www.facebook.com/groups/4142067205870369/?ref=share\n"
    printf "${blue} WHATSAPP: ${cyan}https://chat.whatsapp.com/EEpJ3seLYe3Ir7nGI8818m\n"
    printf "${blue} TWITTER : ${cyan}@CLOWNTERS1\n"
    printf "\n Press enter to exit${end}"
    read
}
function telephone()
{
    while :; do
        banner
        printf "
${yellow} Ex.: (11) 99127-3711 ou 11991273711\n
${blue} Informe o telefone para a consulta\n ===> ${cyan}"
        read_empty
        ret="$?"
        [[ ${ret} -eq 99 ]] && return 99
        num=$(echo ${inputuse} | tr -d -c 0123456789)
        qua=$(echo ${num} | wc -L)

        if [[ ${qua} -gt 10  ]]; then
            ddd_c="${num:0:2}"
            [[ ${qua} -eq 10 ]] && opr=${num:2:2} && prt1=${num:2:4} &&prt2=${num:6:4}
            [[ ${qua} -eq 11 ]] && opr=${num:3:2} && prt1=${num:3:4} &&prt2=${num:7:4}
            ba="${ddd_c}9${opr}"
            ba=$(echo "${banda[${ba}]}")
            ss=$(echo "${ddd_s[${ddd_c}]}")
            se=$(echo "${siglas_e[${ss}]}")
            echo ""
            sleep 0.00001
            echo " •Telefone: +55 ($ddd_c) 9${prt1}-${prt2}"
            sleep 0.00001
            echo " •DDI: 55"
            sleep  0.00001
            echo " •DDD: $ddd_c "
            sleep 0.00001
            echo " •Pais: Brazil"
            sleep 0.00001
            echo " •Codigo do pais: BR"
            sleep 0.00001
            echo " •Estado: $se"
            sleep 0.00001
            echo " •Codigo da Estado: $ss"
            sleep 0.00001
            echo " •Operadora: $ba"
            sleep 0.00001
            echo " •CPF: ×××.×××.×××-××"
            sleep 0.00001
            echo " •RG: ××.×××.×××-×"
            sleep 0.00001
            echo " •Consulta: By Clownters"
            sleep 0.00001
            echo " •Usuario: $user "
            sleep 0.00001
            sleep 0.00001
            return_menu
            [[ $? -eq 1 ]] && return 0
        fi
    done
}
function version()
{
   banner
   printf "${cyan}
 #CLOWNTERS
 #--------------------------------------------------------
 # Name script: Painel Clownters                         |
 #--------------------------------------------------------
 # Script     : A1 PAINEL                                |
 #--------------------------------------------------------
 # Description: dashboard for consultation and hack tools|
 #--------------------------------------------------------
 # Version    : 0.3                                      |
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

 press enter"
    read
}
