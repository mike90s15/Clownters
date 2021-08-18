#!/usr/bin/env bash

#Mike Edwards
#-------------------------------------------------------
# Script     : A1 PAINEL
#-------------------------------------------------------
# Description: dashboard for consultation and hack tools
#-------------------------------------------------------
# Version    : 0.1
#-------------------------------------------------------
# Author     : Mike Edwards
#-------------------------------------------------------
# Date       : 08/08/21
#-------------------------------------------------------
# Lincese    : MIT lincese
#-------------------------------------------------------
# Use: bash A1.sh
#-------------------------------------------------------
#Mike Edwards

# variables
# variáveis

end="\033[m"
red="\033[1;31m"
green="\033[1;32m"
yellow="\033[1;33m"
blue="\033[1;34m"
pink="\033[1;35m"
cyan="\033[1;36m"
white="\033[1;37m"

a1="$green[$end"
a2="\033[1;36m"
a3="$green]$end"
on="$green      (+_+)"
off="$red      (OFF)"

data=$( date +'%Y/%m/%d' )


if [[ -d /data/data/com.termux/files/home/ ]]; then
    pkg="pkg"

else                                                                pkg="sudo apt-get"
fi                                                                                                                              
if [[ -f .okay ]]; then                                             echo''
else
    clear
    echo ""
    echo -e "${end}"
    echo -e " ${green}$ ${blue}installation of packages ${end}"
    echo -e " ${green}$ ${blue}instalando Python... ${end}"
    ${pkg} install -y python &> /dev/null
    echo -e " ${green}$ ${blue}instalando Python2... ${end}"
    ${pkg} install -y python2 &> /dev/null
    echo -e " ${green}$ ${blue}instalando Python3... ${end}"
    ${pkg} install -y python3 &> /dev/null
    echo -e " ${green}$ ${blue}instalando PHP... ${end}"
    ${pkg} install -y php &> /dev/null
    echo -e " ${green}$ ${blue}instalando Wget... ${end}"
    ${pkg} install wget &> /dev/null
    echo -e " ${green}$ ${blue}instalando Sed... ${end}"
    ${pkg} install -y sed &> /dev/null
    echo -e " ${green}$ ${blue}instalando Curl... ${end}"
    ${pkg} install -y curl &> /dev/null
    
    > .okay
fi

# banner CLOWNTERS
# bandeira CLOWNTERS

function banner(){
    printf " ${yellow}
 .--------.____________
 || ° ° ° °     .2021.||
 ||                    |
 ||\     ______________________
 || \   // ° ° ° ° ° ° ° ° ° °/
 ||\ \ //                    /
 || \ //                    /
 ||\ //                    /
 || //                    /
 ||//                    /
 ||/                    /
 |/____________________/
  ${red}Arquivo Clownter ${end}\n

   ${pink}<<< PAINEL CLOWNTERS ${data} >>>
 ${green}=======================================\n"
} 

# menu of options
# menu de opções


function banner_menu(){
    sleep 0.1
    printf " ${a1}${a2}01${a3} ${cyan}Consulta de banco ${a3}${on}\n"
    sleep 0.1
    printf " ${a1}${a2}02${a3} ${cyan}Consulta de ip    ${a3}${on}\n"
    sleep 0.1
    printf " ${a1}${a2}03${a3} ${cyan}Consulta de CEP   ${a3}${on}\n"
    sleep 0.1
    printf " ${a1}${a2}04${a3} ${cyan}Consulta de CNPJ  ${a3}${on}\n"
    sleep 0.1
    printf " ${a1}${a2}05${a3} ${cyan}Consulta de DDD   ${a3}${on}\n"
    sleep 0.1
    printf "\n ${a1}${red}98${a3} ${cyan}Mue Grupo         ${a3}${on}\n"
    sleep 0.1
    printf " ${a1}${red}99${a3} ${cyan}exit do script    ${a3}${on}\n"
    sleep 0.1
}



# functions for menu
# funções do menu

function new_script(){
    date=$( date +'%m/%d/%y' )
    variable1="#!/usr/bin/python

#Mike Edwards
#------------------------------------------------------
# Script     :
#------------------------------------------------------
# Description:
#------------------------------------------------------
# Version    :
#------------------------------------------------------
# Author     : 
#------------------------------------------------------
# Date       : $date
#------------------------------------------------------
# Lincese    :
#------------------------------------------------------
# Use
#------------------------------------------------------
#Mike Edwards
"
    variable="#!/usr/bin/env bash

#Mike Edwards
#------------------------------------------------------
# Script     :
#------------------------------------------------------
# Description:
#------------------------------------------------------
# Version    :
#------------------------------------------------------
# Author     :
#------------------------------------------------------
# Date       : $date
#------------------------------------------------------
# Lincese    :
#------------------------------------------------------
# Use
#------------------------------------------------------
#Mike Edwards"
    variable2="
#include<stdio.h>
#includie<stdlib.h>

int main(){


    return 0;
}
"
    while [[ 0 -eq 0 ]]; do
        clear
        echo -e "$green ---------------------------------------------- $cyan "
        printf "${blue} Name for the script:${cyan} "
        read name

    	if [[ -f $name ]]; then
            echo -e "$red The name already exists $end "
	    sleep 1
            break

        else
            > $name
	    break
        fi
    done

    until [[ 0 -ne 0 ]]; do
        printf "${green} ----------------------------------------------
 ${blue}Selecione a linguagem do programa!
 ${green}1) ${blue}Bash
 ${green}2) ${blue}Python
 ${green}3) ${blue}C
 >>> ${cyan}"
        read option

        if [[ $option == 1 ]]; then
            echo "$variable" > $name
            lin="Bash"
            break

        elif [[ $option == 2 ]]; then
            echo "$variable1" > $name
            lin="Python"
            break

        elif [[ $option == 3 ]]; then
            printf "$variable2" > $name
            lin="C"
            break

        else
            echo "$variable" > $name
            break
        fi
    done

    until [[ 0 -ne 0 ]]; do
        printf  "${green} ----------------------------------------------
 ${blue}Selecione o editor
 ${green}1) ${blue}vim
 ${green}2) ${blue}nano
 >>> ${cyan}"
        read ide

        if [[ $ide == 1 ]]; then
            option1="vim "
            break

        elif [[ $ide == 2 ]]; then
            option1="nano "
            break

        else
            option1="nano "
            break
        fi
    done

    echo -e "$green ---------------------------------------------- $end "
    printf " ${blue}Carregando...\n"
    sleep 1
    printf " Nome      : ${name}
 Editor    : ${option1}
 Linguagem : ${lin}
 ${green}---------------------------------------------- ${end} \n"
    echo -n " pressione enter "
    read
    chmod u+x $name
    $option1$name

    return 0;
}


# login
# nome de usuario

function login(){
    declare -i s
    declare -i x
    s=0
    x=0
    while [[ equal == equal ]]; do
        s=$s+1
        x=$x+1
	sleep 0.9
	clear
	banner
	echo ""
        printf " ${green}Login
 ${blue}===> ${cyan}"
        sleep 1
        read -t 45 login

        if [[ $login == Hater ]]; then
            echo -e " Okay...$end\n"
            sleep 1
            break

        elif [[ $login == q ]]; then
            echo -e " ${blue}Saindo... ${end}"
            sleep 1
            exit 0

        elif [[ $x -eq 6 ]]; then
            echo -e " ${blue}Saindo... ${end}"
            sleep 1
            exit 1

        elif [[ $s -eq 3 ]]; then
            sleep 1
            clear

        else
            echo -e " ${red}Login incorreto\n Digite "Q" para sair\n"
        fi
    done
}


function banco(){
    while [[ 1 -eq 1 ]]; do
        clear
	banner
        printf "\n ${blue}Informe o Codigo do banco para a consulta\n ===> ${cyan}"
        read code

        if [[ ${code} == q ]]; then
            break
        fi

        wget https://brasilapi.com.br/api/banks/v1/${code} -O banco.txt &> /dev/null

        if [[ $? == 0 ]]; then
            echo -e "${end}"
            sed 's/,/\n  /g' banco.txt | sed 's/"//g' | sed 's/:/: /g' | sed 's/{/\ \ /' | sed 's/}//'
            rm -rf banco.txt
            printf "\n\n ${blue}Cinsulta novamente (s/n) \n ===> ${cyan}"
            read option

            if [[ ${option} == s ]]; then
                continue

            else
                break
            fi

        else
            echo -e "\n  ${red}Sem internet!"
            sleep 1
            break
        fi
    done
}


function cep(){
    while [[ 1 -eq 1 ]]; do
        clear
	banner
        printf "\n ${blue}Informe o cep para a consulta\n ===> ${cyan}"
        read cep

        if [[ ${cep} == q ]]; then
            break
        fi

        wget https://viacep.com.br/ws/${cep}/json/ -O cep.txt &> /dev/null

        if [[ $? == 0 ]]; then
            printf "${end}"
            sed 's/"//g' cep.txt | sed 's/{//' | sed 's/}//' | sed 's/,//g'
            printf "\n ${blue}Cinsulta novamente (s/n) \n ===> ${cyan}"
            read option
            rm -rf cep.txt

            if [[ ${option} == s ]]; then
                continue

            else
                break
            fi

        else
            echo -e "\n  ${red}Sem internet!"
            sleep 1
            break
        fi
    done
}


function cnpj(){
    while [[ 1 -eq 1 ]]; do
        clear
	banner
        printf "\n ${blue}Informe o CNPJ para a consulta\n ===> ${cyan}"
        read cnpj

        if [[ ${cnpj} == q ]]; then
            break
        fi

        wget https://brasilapi.com.br/api/cnpj/v1/${cnpj} -O cnpj.txt &> /dev/null

        if [[ $? == 0 ]]; then
            echo -e "${end} "
            sed 's/,/\n  /g' cnpj.txt | sed 's/"//g' | sed 's/:/: /g' | sed 's/{//g' | sed 's/}//g' | sed 's/\[//g' | sed 's/\]//g' | sed 's/_/\ /g' | sed 's/cnpj:/  cnpj:/' | sed 's/ congressos/congressos/' | sed 's/ exposi\ç\ões/exposi\ç\ões/' | sed 's/cao/ção/g' | sed 's/ao/ão/g'  | sed 's/AO/ÃO/g'
            rm cnpj.txt
            printf "\n\n ${blue}Consulta novamente (s/n)\n ===> ${cyan}"
	    read option

            if [[ ${option} == s ]]; then
                continue

            else
                break
            fi

        else
            echo -e "\n  ${red}Sem internet"
            sleep 1
            break
        fi
    done
}


function ddd(){
    while [[ 1 -eq 1 ]]; do
        clear
	banner
        printf "\n ${blue}Indorme o DDD para a consulta\n ===> ${cyan}"
        read ddd

        if [[ ${ddd} == q ]]; then
            break
        fi
                                                                                                                                                      wget https://brasilapi.com.br/api/ddd/v1/${ddd} -O ddd.txt &> /dev/null

        if [[ $? == 0 ]]; then
            echo -e "${end}"
            sed 's/,/\n  /g' ddd.txt | sed 's/:/: /g' | sed 's/"//g' | sed 's/{/\ \ /' | sed 's/}//' | sed 's/\[//' | sed 's/\]/\n/' | sed 's/state/estado/' | sed 's/cities/cidades/'
            rm ddd.txt
            printf "\n ${blue}Consulta novamente (s/n)\n ===> ${cyan}"
            read option

            if [[ ${option} == s ]]; then
                continue

            else
                break
            fi

        else
            echo -e "\n  ${red}Sem internet!"
            sleep 1
            break
        fi
    done
}


function ip(){
    while [[ 1 -eq 1 ]]; do
	clear
	banner
        printf "\n ${blue}Informe o IP para a consulta\n ===> ${cyan}"
        read ip

	if [[ ${ip} == q ]]; then
	    break
	fi

        wget http://ip-api.com/json/${ip} -O ip.txt &> /dev/null

        if [[ $? == 0 ]]; then
            echo -e "${end} "
            sed 's/,/\n  /g' ip.txt | sed 's/"//g' | sed 's/{//' | sed 's/}//' | sed 's/:/: /g' | sed 's/status/  status/' | sed 's/Inc.*//' | sed 's/LLC//' | sed 's/countryCode/Código\ do\ País/' | sed 's/country/paìs/' | sed 's/regionName/Nome\ da\ região/' | sed 's/region/região/' | sed 's/city/cidade/' | sed 's/timezone/fuso\ horário/' | sed 's/query/consulta/' | sed 's/message/mensagem/' | sed 's/invalid/inválido/'
	    printf "\n\n ${blue}Consulta novamente (s/n) \n ===> ${cyan}"
	    rm -rf ip.txt
	    read option

	    if [[ ${option} == s ]]; then
		continue

	    else
		break
	    fi

        else
            echo -e "\n  ${red}Sem internet!"
	    sleep 1
	    break
        fi
    done
}


# password
# senha

function password (){
    declare -i s
    declare -i x
    s=0
    x=0
    until [[ 1 -eq 2 ]]; do
        s=$s+1
        x=$x+1
	sleep 0.9
	clear
	banner
	echo ""
        printf " ${green}Senha
 ${blue}===> ${cyan}"
        read -s senha
        echo ""

        if [[ $senha == KoRn ]]; then
            echo -e " Okay...$end"
            sleep 1
            break

        elif [[ $senha == q ]]; then
            echo -e " ${blue}Saindo... ${end}"
            sleep 1
            exit 0

        elif [[ $x == 6 ]]; then
            echo -e " ${blue}Saindo... ${end}"
            sleep 1
            exit 1

        elif [[ $s == 3 ]]; then
            sleep 1
            clear

        else
            echo -e " ${red}Login incorreto\n Digite "Q" para sair\n"
        fi
    done
}


# the initializer
# o inicializador

function A1 (){
    login
    password

    for (( a = 1; a <= 7; a++ )); do
       #declare -i option
        clear
	banner
        printf "\n"
        banner_menu
        printf "\n ${blue}===> ${cyan}"
        read -t 60 option

	if [[ $option != ?(+|-)+([0-9]) ]]; then
	    echo -e " ${yellow}Somente numeros! ${end}"
            sleep 1
            a=0
	fi

	if [[ $option == 99 ]]; then
	    echo -e " ${blue}Saindo... ${end}"
	    sleep 1
	    return 99;
	    break

        elif [[ ${option} == 1 ]]; then
	    printf " ${blue}Carregando... ${end}\n"
	    sleep 1
	    banco


	elif [[ ${option} == 2 ]]; then
	    printf " ${blue}Carregando... ${end}\n"
	    sleep 1
	    ip

	elif [[ ${option} == 3 ]]; then
	    printf " ${blue}Carregando... ${end}\n"
	    sleep 1
	    cep

	elif [[ ${option} == 4 ]]; then
	    printf " ${blue}Carregando... ${end}\n"
	    sleep 1
	    cnpj

	elif [[ ${option} == 5 ]]; then
	    printf " ${blue}Carregando... ${end}\n"
	    sleep 1
	    ddd

	elif [[ ${option} == 98 ]]; then
	    printf " ${blue}Carregando... ${end}\n"
            sleep 1
            termux-open-url https://chat.whatsapp.com/InWlHW3ViEiEMDcExZZL63

	elif [[ ${option} == 6 ]]; then
	    printf " ${blue}Carregando... ${end}\n"
	    sleep 1
	    new_scripy

        elif [[ $a == 6 ]]; then
	    echo -e " ${blue}Saindo... ${end}"
	    sleep 1
	    exit 1

        elif [[ $a == 3 ]]; then
	    clear

        else
	    echo -e " ${yellow}Opção escolhida *${option}*, Invalido!"
	    sleep 1
        fi
    done

    return 0;
}
A1
exit 0



