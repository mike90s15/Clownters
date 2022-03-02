<!DOCTYPE html>
<html lang="pt-br">
<head> 
  <meta charset="UTF-8">
  <title>Clownters </title>
  <link rel="stylesheet" href="style.css">
  <style>
  body
  {
  background-color:#00001c;
  }
  h1
  {
  color:red;
  font-family:Ariel;
  font-size:60px;
  text-shadow:3px 3px 3px black;
  text-align:center;
  width:90%;
  margin:2% auto 2% auto;
  }
  h2
  {
  font-size:50px;
  font-family:verdana;
  font-size:35pt;
  color:#F3EE5F;
  text-shadow:3px 3px 3px black;
  }
  h3
  {
  font-family:verdana;
  font-size:45px;
  color:#5FE7DF;
  text-shadow:3px 3px 3px black;
  margin:0px auto 0px auto;
  }
  img
  {  
  border:1px solid #ddd;
  border-radius:35px;
  padding:5px;
  height:59%;
  width:48%;
  margin:2% 25% 2% 25%;
  }
  .img
  {
  border:1px solid #ddd;
  border-radius:35px;
  padding:5px;
  height:20%;
  width:20%;
  margin:0px;
  }
  h4
  {
  font-family:verdana;
  font-size:35pt;
  color:#5FE7DF;
  text-shadow:3px 3px 3px black;
  margin:0px auto 0px auto;
  }
  p
  {
  font-family:verdana;
  font-size:30pt;
  color:#5558ff;
  text-shadow:1px 1px 1px #212364;
  text-indent:2ch;
  margin:10px auto 10px auto;
  }
  a:link, a:visited, a
  {
  background-color:#0057ff;
  color:#fff;
  padding:15px;
  font-size:20pt;
  text-align:center;
  text-indent:0ch;
  width:46%;
  margin:5px 0px auto 25%;
  border-radius:25px;
  text-decoration:none;
  display:inline-block;
  }
  a:hover, a:active
  {
  background-color:blue;
  color:#fff;
  }
  iframe
  {
  background:#00001c;
  border:3px solid #ddd;
  border-radius:30px;
  width:60%;
  height:640px;
  margin:10px 0px 10px 20%;
  }
  main
  {
  border:1px solid #ddd;
  border-radius:35px;
  width:90%;
  height:90%;
  margin:2% auto 25% auto;
  padding:20px;
  }
  </style>
</head>
<body>
  <br><h1>Organização Clownters 🇮🇲</h1></br>
  <main>
  <h2>MANUAL TERMUX<h2>
  <h2>Cusro de termux<h2>
  <img class="img" src="https://raw.githubusercontent.com/mike90s15/cloud/main/Clownters/Imagens/termux.png">
  <h3>•1.0 O que é o termux</h3>
  <p>
Termux é um emulado de terminal que garante acesso ao shell do Android o sh, sem requerer acesso root. O app permite acessar o shell sh e bash para executar comandos Linux e Unix. Além disso, oferece um repositório de programas e pacotes que podem ser instalados com o comando apt, apt-get, pkg, dpkg e outros, tal como no Debian ou Ubuntu.    				
  </p>
  <h4>•1.1 O que é um Shell</h4>
  <p>
Shell é um programa especial disponibilizado ao usuário ou algum programa para que este possa se comunicar diretamente com o sistema operacional. O Shell aceita comandos simples e de fácil entendimento para o usuário e os interpreta para que o Kernel possa executar as ações desejadas.
  </p>
  <h3>•2.0 Como fazer o download do termux</h3>
  <p>
O download do termux pode ser realizado pelo Fdroid e a play store, porém a versão da play store está desatualizada.<br>
  <a href="https://f-droid.org/repo/com.termux_118.apk" target="_blank">>>> DOWNLOAD DO TERMUX <<<</a></br>
  <img src="https://raw.githubusercontent.com/mike90s15/cloud/main/Clownters/Imagens/termux_banner.png"/>
  </p>
  <h3>•3.0 Comandos do termux</h3>
  <p>
Os comandos pode ser divididos em dois grupos builtin e utilitários, Comandos builtin é integrados que são exclusivos ou foram estendidos no Shell e utilitário não vem inclementado no Shell.
  </p>
  <h4>•3.1 Utilitários</h4>
  <p>
Veja alguns dos utilitários mais usados no termux
  <i><b><br>
•ls</br>
•cp</br>
•mv</br>
•clear</br>
  </b></i>
E qualquer outro pacote que não pertence ao shell por padrão serão utilitários.
  </p>
  <h4> •3.2 builtin</h4>
  <p>
Os comandos builtin são bem mais rápido que os utilitários porque ele ja está acoplado no shell, os comandos
  <i><b></br>
  •cd</br>
  •pwd</br>
  •time</br>
  •exit</br>
  </b></i>
São builtin, para ver todos os comandos builtin basta apenas digital <b>help</b> no terminal.
  </p>
  <h4>•3.3 Como saber se o comando é builtin</h4> 
  <p>
Para saber se o comando é interno ou externo é bem simples todos os comandos builtin possui um breve manual de ajuda, para vermos se o comando possuí esse manual é necessário digitar help [ COMANDO ], se returna o manual o comando é builtin se não ele é um utilitário.
  </p>           
  <h3>•4.0 Como usar os Comandos</h3>
  <h4>>_ exit</h4>
  <p> 
Exit, tem a função de encerrar a sessão atual, o Termux só será fechado quando você executa uns dessas ações, “exit”, botão <b>CTRL d</b> ou na abra de notificação do seu smartphone e fechar
  </p>
  <iframe src="https://www.youtube.com/embed/sbD2jRDgAd0">
  </iframe>
  <h4>>_ ls</h4>
  <p>
O comando “ls” permite que listemos os arquivos e diretórios no Termux. O comando com parâmetros a “ls -a” lista todos os conteúdos oculto do diretório atual.
  </p>
  <iframe src="https://www.youtube.com/embed/i8jgGk08BRU">
  </iframe>
  <h4>>_ cd</h4>   
  <p>
O comando cd, um dos comandos mais importantes do Termux, que serve para se movimentar entre diretórios. basta passar o direito como parâmetro ele se movimentará para o caminho passado e para voltar ao diretório anterior. [ cd .. ]
  </p>  
  <iframe src="https://www.youtube.com/embed/tn7shy3LBYk">
  </iframe>      
  <h4>>_ mkdir</h4>
  <p>
O comando “mkdir” permite ao usuário criar um diretório vazio ou vários diretórios, para criar um diretório ou mais com mkdir é simples você deverá passar o nome da pasta que quer criar.</br>
[ mkdir nome_do_diretório ]
  </p>
  <iframe src="https://www.youtube.com/embed/svsNEoK8HLs">
  </iframe>       
  <h4>>_ touch e <b>“>”</b></h4>
  <p>
O Comando “touch” é usado principalmente para criar arquivos vazios, além de alterar o registro de data e hora (timestamp) de arquivos ou pastas. A informação destes registros de arquivos consistem em três atributos: hora do acesso, hora da modificação e hora da alteração.
  </p>
  <iframe src="https://www.youtube.com/embed/5eM38-RvLxM">
  </iframe>
  <h4>>_ cp</h4>
  <p>
Você pode usar o “cp” para copiar estruturas de diretórios inteiras de um local para outro usando a opção -R para executar uma cópia recursiva e também fazer copia de arquivos. [ cp arquivo local/ ]
  </p>
  <iframe src="https://www.youtube.com/embed/cOi4aD8F4sA">
  </iframe>     
  <h4>>_ mv</h4>
  <p>
O “mv” é um dos comandos mais populares no Termux. mv significa mover e é essencialmente usado para mover arquivos ou diretórios de um local para outro. A sintaxe é semelhante ao comando cp no Termux, no entanto, há uma diferença fundamental entre esses dois comandos.
  </p>
  <iframe src="https://www.youtube.com/embed/YT3tJ-3dKfo">
  </iframe>      
  <h4>>_ rm</h4>
  <p>
O “rm” deletar arquivos vazio ou com conteúdo,
o comando usado para deletar diretórios vazios no Termux é “rmdir”. Se nenhuma opção for oferecida, o rmdir simplesmente deletará o diretório da qual nome é oferecido como destino. já o “rm -rf” removerá qualquer tipo de arquivo que não tenha permissões avançada.
  </p>
  <iframe src="https://www.youtube.com/embed/PUJi4p88dw4">
  </iframe>      
  <h4>>_ clear</h4>
  <p>
Se você usar o comando clear no Termux, a tela será limpa e você não poderá ver o que havia na tela anteriormente. Em muitos outros emuladores de terminal esse comando é muito usado.
  </p>
  <iframe src="https://www.youtube.com/embed/o-vaCGrdXI4">
  </iframe>      
  <h4>>_ nano</h4>
  <p>
Existem muitos editores de texto diferentes no Termux, e a comunidade é bastante apaixonada por este assunto. No entanto, um editor de texto se destaca dos demais como o mais fácil de usar, especialmente para iniciantes. Esse editor de texto é o Nano.
  </p>
  <iframe src="https://www.youtube.com/embed/gthswAuGGQE">
  </iframe>   
  <p>
Isso é básico que você precisa saber para usar o Termux, mas o Termux é ferramenta bem completa que permitirá a você fazer muitas coisas complexas.
  </p>   
  </main>            
</body>
</html>
