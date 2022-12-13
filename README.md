# Generatori statičkih stranica - na pola puta između čistog HTML-a i WordPressa

Nekada smo web stranice ručno izrađivali pišući HTML kod u nekom editoru, a danas ih često uređujemo putem nekog CMS-a (WordPress ili neki slični alati). Iako smo si od samih početaka nastojali pomoći s nekim alatima koji su na pola puta pa nam generiraju ili pomažu editirati statičke stranice, danas opet raste popularnost generatora statičkih stranica (Static Site Generator - SSG). Naravno svaki alat ima svoju svrhu pa tako i SSG, a ako vas zanima što je to uopće SSG, kako se koristi te kada i kako ga upotrijebiti u oblačnom svijetu ubilježite si ovo predavanje u kalendar.

# Razlozi za korištenje generatora statičkih stranica

Postoji više razloga zašto bi koristili generatore statičkih stranica, ali često onaj koji nam je prvi je brzina.  Osim brzine tu se radi i o mogućnosti verzioniranja stranica jer su one postavljene kao obični tekstovi koje možemo spremiti korištenjem git-a. Korištenjem generatora statičkih stranica naše stranice su i sigurnije jer na kraju generiramo običan HTML, a pri tome imamo veću slobodu prilikom dizajniranja stranica.

Svakako generatori statičkih stranica imaju svoje mjesto u mikroservisnoj arhitekturi kroz koju je onda lakše skalirati sustav i prilagoditi ga potrebama. Pri tome trebamo imati u vidu da tako generirane stranice lako možemo zapakirati u Nginx kontejner te u sustavima kao što je kubernetes možemo skalirati taj broj kontejnera ovisno o opterećenju.

# Postavljanje razvojne okoline

## Razvojna okolina

Razvojna okolina prilagođena je razvoju u kontejnerima. Za razvoj se koristiti Visual Studio Code zajedno s ekstenzijom Remote-Containers koja olakšava razvoj i testiranje u kontejnerima. Više o Remote-Container ekstenziji i razvoju koda u kontejneru možete naći u članku [Developing inside a Container](https://code.visualstudio.com/docs/remote/containers).

### Priprema kontejnerske okoline

Za razvoj se koriste kontejneri i docker. Da bi se uspostavila razvojna okolina potrebno je instalirati docker ili sličan kontejnerski sustav. Ovdje je **važno** napomenuti da nije podržana snap verzija dockera zbog nemogućnosti pristupa [home direktoriju](https://github.com/microsoft/vscode-remote-release/issues/2817). Docker dolazi s početno definiranim opsegom mreža /16 što je previše za razvojnu okolinu te je preporuka da istu smanjimo na /24. Na linux sustavima treba kreirati ili urediti datoteku /etc/docker/daemon.json u kome će se postaviti željeni mrežni raspon.

```shell
# vi /etc/docker/daemon.json
{
  "default-address-pools":
  [
    {"base":"172.18.0.0/16","size":24}
  ]
}
# systemctl restart docker
```

Ukoliko imate od ranije kreirane docker mreže potrebno je iste obrisati prije promjene ospega adresnog prostora zbog mogućih preklapanja istih što će dovesti do poteškoća prilikom podizanja docker servisa.

```shell
$ docker network ls
NETWORK ID     NAME      DRIVER    SCOPE
baf620f8f015   bridge    bridge    local
ec40fa749265   host      host      local
0937386ff5c7   none      null      local
9ce001177c4e   proxy     bridge    local
$ docker network rm proxy
```
