source .functions/.variables.sh
source .functions/.functions.sh
access
[[ $? -eq 1 ]] && exit
downloads
chmod +x *

while :; do
    clear
    banner
    banner_menu
    read_num
    [[ $? -eq 99 ]] && exit 99

    case ${inputuse} in
        00) exit 0;;
        0) exit 0;;
        1) loading; banco;;
        01) loading; banco;;
        2) loading; bin;;
        02) loading; bin;;
        3) loading; cep;;
        03) loading; cep;;
        4) loading; _cnpj;;
        04) loading; _cnpj;;
        5) loading; covid;;
        05) loading; covid;;
        6) loading; ddd;;
        06) loading; ddd;;
        7) loading; ip;;
        07) loading; ip;;
        8) loading; telephone;;
        08) loading; telephone;;
        9) loading; gerador_cpf;;
        09) loading; gerador_cpf;;
        10) loading; new_script;;
        11) loading; _nmap;;
        96) loading; bash update.sh;;
        97) loading; social_networks;;
        98) loading; version;;
        99) banner; exit 0;;
        q) banner; exit 0
    esac
done
