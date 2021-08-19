#!/usr/bin/env bash

#mike edwards
#-------------------------------------------------------
# script     : a1 painel
#-------------------------------------------------------
# description: dashboard for consultation and hack tools
#-------------------------------------------------------
# version    : 0.1
#-------------------------------------------------------
# author     : mike edwards
#-------------------------------------------------------
# date       : 08/08/21
#-------------------------------------------------------
# lincese    : mit lincese
#-------------------------------------------------------
# use: bash a1.sh
#-------------------------------------------------------
#mike edwards

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
off="$red      (off)"

data=$( date +'%y/%m/%d' )


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
    echo -e " ${green}$ ${blue}instalando python... ${end}"
    ${pkg} install -y python &> /dev/null
    echo -e " ${green}$ ${blue}instalando python2... ${end}"
    ${pkg} install -y python2 &> /dev/null
    echo -e " ${green}$ ${blue}instalando python3... ${end}"
    ${pkg} install -y python3 &> /dev/null
    echo -e " ${green}$ ${blue}instalando php... ${end}"
    ${pkg} install -y php &> /dev/null
    echo -e " ${green}$ ${blue}instalando wget... ${end}"
    ${pkg} install wget &> /dev/null
    echo -e " ${green}$ ${blue}instalando sed... ${end}"
    ${pkg} install -y sed &> /dev/null
    echo -e " ${green}$ ${blue}instalando curl... ${end}"
    ${pkg} install -y curl &> /dev/null
    
    > .okay
fi

# banner clownters
# bandeira clownters

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
  ${red}arquivo clownter ${end}\n

   ${pink}<<< painel clownters ${data} >>>
 ${green}=======================================\n"
} 

# menu of options
# menu de opções


function banner_menu(){
    sleep 0.1
    printf " ${a1}${a2}01${a3} ${cyan}consulta de banco ${a3}${on}\n"
    sleep 0.1
    printf " ${a1}${a2}02${a3} ${cyan}consulta de ip    ${a3}${on}\n"
    sleep 0.1
    printf " ${a1}${a2}03${a3} ${cyan}consulta de cep   ${a3}${on}\n"
    sleep 0.1
    printf " ${a1}${a2}04${a3} ${cyan}consulta de cnpj  ${a3}${on}\n"
    sleep 0.1
    printf " ${a1}${a2}05${a3} ${cyan}consulta de ddd   ${a3}${on}\n"
    sleep 0.1
    printf " ${a1}${a2}06${a3} ${cyan}consulta covid19  ${a3}${on}\n"
    sleep 0.1
    printf " ${a1}${a2}07${a3} ${cyan}consulta telefone ${a3}${on}\n"
    sleep 0.1
    printf " ${a1}${a2}08${a3} ${cyan}novo script       ${a3}${on}\n"
    sleep 0.1
    printf "\n ${a1}${red}98${a3} ${cyan}meu grupo         ${a3}${on}\n"
    sleep 0.1
    printf " ${a1}${red}99${a3} ${cyan}exit do script    ${a3}${on}\n"
    sleep 0.1
}



# functions for menu
# funções do menu

function new_script(){
    date=$( date +'%m/%d/%y' )
    variable1="#!/usr/bin/python

#mike edwards
#------------------------------------------------------
# script     :
#------------------------------------------------------
# description:
#------------------------------------------------------
# version    :
#------------------------------------------------------
# author     : 
#------------------------------------------------------
# date       : $date
#------------------------------------------------------
# lincese    :
#------------------------------------------------------
# use
#------------------------------------------------------
#mike edwards
"
    variable="#!/usr/bin/env bash

#mike edwards
#------------------------------------------------------
# script     :
#------------------------------------------------------
# description:
#------------------------------------------------------
# version    :
#------------------------------------------------------
# author     :
#------------------------------------------------------
# date       : $date
#------------------------------------------------------
# lincese    :
#------------------------------------------------------
# use
#------------------------------------------------------
#mike edwards"
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
        printf "${blue} name for the script:${cyan} "
        read name

    	if [[ -f $name ]]; then
            echo -e "$red the name already exists $end "
	    sleep 1
            break

        else
            > $name
	    break
        fi
    done

    until [[ 0 -ne 0 ]]; do
        printf "${green} ----------------------------------------------
 ${blue}selecione a linguagem do programa!
 ${green}1) ${blue}bash
 ${green}2) ${blue}python
 ${green}3) ${blue}c
 >>> ${cyan}"
        read option

        if [[ $option == 1 ]]; then
            echo "$variable" > $name
            lin="bash"
            break

        elif [[ $option == 2 ]]; then
            echo "$variable1" > $name
            lin="python"
            break

        elif [[ $option == 3 ]]; then
            printf "$variable2" > $name
            lin="c"
            break

        else
            echo "$variable" > $name
            break
        fi
    done

    until [[ 0 -ne 0 ]]; do
        printf  "${green} ----------------------------------------------
 ${blue}selecione o editor
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
    printf " ${blue}carregando...\n"
    sleep 1
    printf " nome      : ${name}
 editor    : ${option1}
 linguagem : ${lin}
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
        printf " ${green}login
 ${blue}===> ${cyan}"
        sleep 1
        read -t 45 login

        if [[ $login == hater ]]; then
            echo -e " okay...$end\n"
            sleep 1
            break

        elif [[ $login == q ]]; then
            echo -e " ${blue}saindo... ${end}"
            sleep 1
            exit 0

        elif [[ $x -eq 6 ]]; then
            echo -e " ${blue}saindo... ${end}"
            sleep 1
            exit 1

        elif [[ $s -eq 3 ]]; then
            sleep 1
            clear

        else
            echo -e " ${red}login incorreto\n digite "q" para sair\n"
        fi
    done
}


function banco(){
    while [[ 1 -eq 1 ]]; do
        clear
	banner
        printf "\n ${blue}informe o codigo do banco para a consulta\n ===> ${cyan}"
        read code

        if [[ ${code} == q ]]; then
            break
        fi

        wget https://brasilapi.com.br/api/banks/v1/${code} -o banco.txt &> /dev/null

        if [[ $? == 0 ]]; then
            echo -e "${end}"
            sed 's/,/\n  /g' banco.txt | sed 's/"//g' | sed 's/:/: /g' | sed 's/{/\ \ /' | sed 's/}//'
            rm -rf banco.txt
            printf "\n\n ${blue}cinsulta novamente (s/n) \n ===> ${cyan}"
            read option

            if [[ ${option} == s ]]; then
                continue

            else
                break
            fi

        else
            echo -e "\n  ${red}sem internet!"
            sleep 1
            break
        fi
    done
}


function cep(){
    while [[ 1 -eq 1 ]]; do
        clear
	banner
        printf "\n ${blue}informe o cep para a consulta\n ===> ${cyan}"
        read cep

        if [[ ${cep} == q ]]; then
            break
        fi

        wget https://viacep.com.br/ws/${cep}/json/ -o cep.txt &> /dev/null

        if [[ $? == 0 ]]; then
            printf "${end}"
            sed 's/"//g' cep.txt | sed 's/{//' | sed 's/}//' | sed 's/,//g'
            printf "\n ${blue}cinsulta novamente (s/n) \n ===> ${cyan}"
            read option
            rm -rf cep.txt

            if [[ ${option} == s ]]; then
                continue

            else
                break
            fi

        else
            echo -e "\n  ${red}sem internet!"
            sleep 1
            break
        fi
    done
}


function covid(){
    while [[ 1 -eq 1 ]]; do
	clear
	banner
        printf " ${blue}informe uf para a consulta\n ===> ${cyan}"
        read uf

	if [[ ${uf} == q ]]; then
            break
        fi

        wget https://covid19-brazil-api.now.sh/api/report/v1/brazil/uf/${uf} -o covid.txt &> /dev/null

        if [[ $? == 0 ]]; then
            printf "\n${end}"
            sleep 0.1
            printf "  uf: "
            sed 's/,/\n\n/g' covid.txt | grep 'uf' | sed 's/"uf"://' | sed 's/"//g'
            sleep 0.1
            printf "  estado: "
            sed 's/,/\n\n/g' covid.txt | grep 'state' | sed 's/"state"://' | sed 's/"//g'
            sleep  0.1
            printf "  uid: "
            sed 's/,/\n\n/g' covid.txt | grep 'uid' | sed 's/{"uid"://' | sed 's/"//g'
            sleep 0.1
            printf "  casos: "
            sed 's/,/\n\n/g' covid.txt | grep 'cases' | sed 's/"cases"://' | sed 's/"//g'
            sleep 0.1
            printf "  mortes: "
            sed 's/,/\n\n/g' covid.txt | grep 'deaths' | sed 's/"deaths"://' | sed 's/"//g'
            sleep 0.1
            printf "  suspeitos: "
            sed 's/,/\n\n/g' covid.txt | grep 'suspects' | sed 's/"suspects"://' | sed 's/"//g'
            sleep 0.1
            printf "  recusa: "
            sed 's/,/\n\n/g' covid.txt | grep 'refuses' | sed 's/"refuses"://' | sed 's/"//g'
            rm -rf covid.txt
	    printf "\n ${blue}consulta novamente (s/n) \n ===> ${cyan}"
	    read option

            if [[ ${option} == s ]]; then
                continue

            else
                break
            fi

        else
            echo -e "\n  ${red}sem internet!"
            sleep 1
            break
        fi
    done
}


function cnpj(){
    while [[ 1 -eq 1 ]]; do
        clear
	banner
        printf "\n ${blue}informe o cnpj para a consulta\n ===> ${cyan}"
        read cnpj

        if [[ ${cnpj} == q ]]; then
            break
        fi

        wget https://brasilapi.com.br/api/cnpj/v1/${cnpj} -o cnpj.txt &> /dev/null

        if [[ $? == 0 ]]; then
            echo -e "${end} "
            sed 's/,/\n  /g' cnpj.txt | sed 's/"//g' | sed 's/:/: /g' | sed 's/{//g' | sed 's/}//g' | sed 's/\[//g' | sed 's/\]//g' | sed 's/_/\ /g' | sed 's/cnpj:/  cnpj:/' | sed 's/ congressos/congressos/' | sed 's/ exposi\ç\ões/exposi\ç\ões/' | sed 's/cao/ção/g' | sed 's/ao/ão/g'  | sed 's/ao/ão/g'
            rm cnpj.txt
            printf "\n\n ${blue}consulta novamente (s/n)\n ===> ${cyan}"
	    read option

            if [[ ${option} == s ]]; then
                continue

            else
                break
            fi

        else
            echo -e "\n  ${red}sem internet"
            sleep 1
            break
        fi
    done
}


function ddd(){
    while [[ 1 -eq 1 ]]; do
        clear
	banner
        printf "\n ${blue}indorme o ddd para a consulta\n ===> ${cyan}"
        read ddd

        if [[ ${ddd} == q ]]; then
            break
        fi
                                                                                                                                                      wget https://brasilapi.com.br/api/ddd/v1/${ddd} -o ddd.txt &> /dev/null

        if [[ $? == 0 ]]; then
            echo -e "${end}"
            sed 's/,/\n  /g' ddd.txt | sed 's/:/: /g' | sed 's/"//g' | sed 's/{/\ \ /' | sed 's/}//' | sed 's/\[//' | sed 's/\]/\n/' | sed 's/state/estado/' | sed 's/cities/cidades/'
            rm ddd.txt
            printf "\n ${blue}consulta novamente (s/n)\n ===> ${cyan}"
            read option

            if [[ ${option} == s ]]; then
                continue

            else
                break
            fi

        else
            echo -e "\n  ${red}sem internet!"
            sleep 1
            break
        fi
    done
}


function ip(){
    while [[ 1 -eq 1 ]]; do
	clear
	banner
        printf "\n ${blue}informe o ip para a consulta\n ===> ${cyan}"
        read ip

	if [[ ${ip} == q ]]; then
	    break
	fi

        wget http://ip-api.com/json/${ip} -o ip.txt &> /dev/null

        if [[ $? == 0 ]]; then
            echo -e "${end} "
            sed 's/,/\n  /g' ip.txt | sed 's/"//g' | sed 's/{//' | sed 's/}//' | sed 's/:/: /g' | sed 's/status/  status/' | sed 's/inc.*//' | sed 's/llc//' | sed 's/countrycode/código\ do\ país/' | sed 's/country/paìs/' | sed 's/regionname/nome\ da\ região/' | sed 's/region/região/' | sed 's/city/cidade/' | sed 's/timezone/fuso\ horário/' | sed 's/query/consulta/' | sed 's/message/mensagem/' | sed 's/invalid/inválido/'
	    printf "\n\n ${blue}consulta novamente (s/n) \n ===> ${cyan}"
	    rm -rf ip.txt
	    read option

	    if [[ ${option} == s ]]; then
		continue

	    else
		break
	    fi

        else
            echo -e "\n  ${red}sem internet!"
	    sleep 1
	    break
        fi
    done
}


function telefone(){
    while [[ 1 -eq 1 ]]; do
	clear
        printf " ${blue}informe o número para a consulta\n ===> ${cyan}"
        read num

	if [[ ${num} == q ]]; then
	    break
	fi

	wget https://dualityapi.xyz/apis/flex_7/consultas%20privadas/html/numero.php?consulta=${num} -o numero.txt &> /dev/null

	if [[ $? == 0 ]]; then
	    sed 's/\\u0000//g' numero.txt | sed 's/<br>/\n/g' > numero1.txt
            sed 's/\\r//g' numero1.txt | sed 's/<p>//g' > numero2.txt
            sed 's/telefone:/telefone: /' numero2.txt > numero3.txt
            sed 's/nome:/nome: /' numero3.txt > numero4.txt
            sed 's/cep:/cep: /' numero4.txt > numero5.txt
            sed 's/tipo_doc:/tipo: /' numero5.txt > numero6.txt
            sed 's/cpf_cnpj:/cpf-cnpj: /' numero6.txt > numero7.txt
            sed 's/doc:/documento: /' numero7.txt > numero8.txt
            sed 's/endereco:/endereco: /' numero8.txt > numero9.txt
            sed 's/bairro:/bairro: /' numero9.txt > numero10.txt
            sed 's/cidade:/cidade: /' numero10.txt > numero11.txt
            sed 's/id_uf:/id\/uf:/' numero11.txt > numero12.txt
            sed 's/uf:/uf: /' numero12.txt > numero13.txt
            sed 's/tipo_linha:/linha: /' numero13.txt > numero14.txt
            sed 's/tipo_pessoa:/pessoa: /' numero14.txt > numero15.txt
            sed 's/nome_assinante:/nome\/ass: /' numero15.txt > numero16.txt
            sed 's/numero:/numero: /' numero16.txt > numero17.txt
            sed 's/cpf:/cpf: /' numero17.txt > numero18.txt
            sed 's/pessoa:/pessoa: /' numero18.txt > numero19.txt
            sed 's/ddd:/ddd: /' numero19.txt > numero20.txt
            sed 's/operadora:/operadora: /' numero20.txt > numero21.txt
            sed 's/tdocumento//' numero21.txt > numero22.txt
            echo -e "${end}"
            grep -i 'telefone: ' numero22.txt
    	    grep -i 'operadora: ' numero22.txt
	    grep -i 'ddd: ' numero22.txt
    	    grep -i 'nome: ' numero22.txt
    	    grep -i 'nome\/ass: ' numero22.txt
    	    grep -i 'pessoa: ' numero22.txt
    	    grep -i 'tipo: ' numero22.txt
    	    grep -i 'documento: ' numero22.txt
    	    grep -i 'cpf-cnpj: ' numero22.txt
    	    grep -i 'cpf: ' numero22.txt
    	    grep -i 'cidade:' numero22.txt
    	    grep -i 'bairro: ' numero22.txt
    	    grep -i 'endereco: ' numero22.txt
    	    grep -i 'numero: ' numero22.txt
    	    grep -i 'uf: ' numero22.txt
    	    grep -i 'cep: ' numero22.txt
    	    grep -i 'linha: ' numero22.txt
    	    rm -rf numero*
    	    echo
	    printf "\n\n ${blue}consulta novamente (s/n) \n ===> ${cyan}"
            read option

            if [[ ${option} == s ]]; then
                continue

            else
                break
            fi

        else
            echo -e "\n  ${red}sem internet!"
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
        printf " ${green}senha
 ${blue}===> ${cyan}"
        read -s senha
        echo ""

        if [[ $senha == korn ]]; then
            echo -e " okay...$end"
            sleep 1
            break

        elif [[ $senha == q ]]; then
            echo -e " ${blue}saindo... ${end}"
            sleep 1
            exit 0

        elif [[ $x == 6 ]]; then
            echo -e " ${blue}saindo... ${end}"
            sleep 1
            exit 1

        elif [[ $s == 3 ]]; then
            sleep 1
            clear

        else
            echo -e "\a\a\a\a\a\a\a\a\a\a ${red}login incorreto\n digite "q" para sair\n"
        fi
    done
}


# the initializer
# o inicializador

function a1 (){
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
	    echo -e " ${yellow}somente numeros! ${end}"
            sleep 1
            a=0
	fi

	if [[ $option == 99 ]]; then
	    echo -e " ${blue}saindo... ${end}"
	    sleep 1
	    return 99;
	    break

        elif [[ ${option} == 1 ]]; then
	    printf " ${blue}carregando... ${end}\n"
	    sleep 1
	    banco


	elif [[ ${option} == 2 ]]; then
	    printf " ${blue}carregando... ${end}\n"
	    sleep 1
	    ip

	elif [[ ${option} == 3 ]]; then
	    printf " ${blue}carregando... ${end}\n"
	    sleep 1
	    cep

	elif [[ ${option} == 4 ]]; then
	    printf " ${blue}carregando... ${end}\n"
	    sleep 1
	    cnpj

	elif [[ ${option} == 5 ]]; then
	    printf " ${blue}carregando... ${end}\n"
	    sleep 1
	    ddd

	elif [[ ${option} == 6 ]]; then
	    printf " ${blue}carregando... ${end}\n"
	    sleep 1
	    covid

	elif [[ ${option} == 7 ]]; then
	    printf " ${blue}carregando... ${end}\n"
	    sleep 1
	    telefone

	elif [[ ${option} == 7 ]]; then
	    printf " ${blue}carregando... ${end}\n"
	    sleep 1
	    new_script
	
	elif [[ ${option} == 98 ]]; then
	    printf " ${blue}carregando... ${end}\n"
            sleep 1
            termux-open-url https://chat.whatsapp.com/inwlhw3vieiemdcexzzl63

        elif [[ $a == 6 ]]; then
	    echo -e " ${blue}saindo... ${end}"
	    sleep 1
	    exit 1

        elif [[ $a == 3 ]]; then
	    clear

        else
	    echo -e " ${yellow}opção escolhida *${option}*, invalido!"
	    sleep 1
        fi
    done

    return 0;
}
a1
exit 0



