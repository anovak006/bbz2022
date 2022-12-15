---
marp: true
theme: default
---
# BBZ 2022
## Generatori statičkih stranica - na pola puta između čistog HTML-a i WordPressa
Albert Novak https://github.com/anovak006/bbz2022

---
# Generatori statičkih stranica
![w:700](https://d33wubrfki0l68.cloudfront.net/b0cd7be20ba718c92b5da007a109a89122f6791a/73909/v3/img/blog/ssg-host-flow.png)
Izvor: https://www.netlify.com/blog/2020/04/14/what-is-a-static-site-generator-and-3-ways-to-find-the-best-one/

---
# Imamo li potrebe za generatore statičkih stranica?

## Dobra svojstva generatora statičkih stranica
- brzina
- verzioniranje
- sigurnost
- veća sloboda u dizajniranju stranice

---
# Koji ćemo mi generator statičkih stranica koristiti?

![Hugo logo](https://d33wubrfki0l68.cloudfront.net/c38c7334cc3f23585738e40334284fddcaf03d5e/2e17c/images/hugo-logo-wide.svg)

Izvor: https://gohugo.io/

---
# Kontejneri su in!
![alt](https://www.explainxkcd.com/wiki/images/5/53/containers.png)

Izvor: https://www.explainxkcd.com/wiki/index.php/1988:_Containers

---
# Generatori statičkih stranica - mikroservisna arhitektura

![w:850](https://blog.hypriot.com/images/traefik/architecture.png)

Izvor: https://blog.hypriot.com/post/microservices-bliss-with-docker-and-traefik/


---
# Kontejneri nasuprot virtualnim poslužiteljima
![Kontejneri nasuprot virtualnim poslužiteljima](https://www.docker.com/wp-content/uploads/Blog.-Are-containers-..VM-Image-1-1024x435.png)
Izvor: https://www.docker.com/blog/containers-replacing-virtual-machines/

---
# Kontejner u virtualnom poslužitelju

![w:700](https://www.docker.com/wp-content/uploads/Are-containers-..-vms-image-2-1024x759.png)
Izvor: https://www.docker.com/blog/containers-replacing-virtual-machines/

---
# Instalirajmo potrebne alate
### VS Code - https://code.visualstudio.com/docs/setup/linux
```shell
sudo apt install ./code_*.deb
```

### Docker
```shell
# sudo apt install docker.io
```
Ne koristiti snap verziju!

---
# Podesiti adresni prostor

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

---
### Docker Compose - https://docs.docker.com/compose/install/
```shell
$ DOCKER_CONFIG=$DOCKER_CONFIG:-$HOME/.docker}
$ mkdir -p $DOCKER_CONFIG/cli-plugins
$ curl -SL https://github.com/docker/compose/releases/download/v2.4.1/docker-compose-linux-x86_64 \
-o $DOCKER_CONFIG/cli-plugins/docker-compose
```
```shell
 $ chmod +x $DOCKER_CONFIG/cli-plugins/docker-compose
 # Ako je umjesto $HOME /usr/local/lib/
 $ sudo chmod +x /usr/local/lib/docker/cli-plugins/docker-compose
 ```
---
# Visual Studio Code - remote plugin
![alt](https://code.visualstudio.com/assets/docs/remote/containers/architecture-containers.png)

---
# Podesiti remote plugin
Urediti potrebne postavke u datoteci `.devcontainer/devcontainer.json`

### Ostale postavke VS Code
Nalaze se u dirketoriju `.vscode`

<!-- footer: `git checkout 096a2076cdc`-->
---
# Slojevi slike kontejnera
![alt](https://cdn.buttercms.com/CLQJN3yRRcS7oGqm7yKb)
Izvor: https://www.metricfire.com/blog/how-to-build-optimal-docker-images/

---
# Višestupanjska (multi-stage) slika kontejnera
![alt](https://cdn.buttercms.com/PpIR4HUFTuSMirdt5pxC)
Izvor: https://www.metricfire.com/blog/how-to-build-optimal-docker-images/

---
# Preuzmimo projektnu razvojnu okolinu
```shell
> git clone https://github.com/anovak006/bbz2022.git
```
## I vratimo se na početak
```shell
$ git checkout 19d61bc
```
---
# Kreiranje inicijalnog web sjedišta

## Datoteka create_new_site.sh
```shell
#!/bin/bash
docker run --rm -it \
  -v $(pwd)/src:/src \
  -w="/src" \
  --user 1000:1000 \
  klakegg/hugo:0.107.0-ext-alpine \
  new site . -force
```

## Kroz terminal
```shell
mkdir src
$ ./create_new_site.sh
```
---
# Dodavanje teme

## Kroz terminal
```shell
$ cd src
$ git submodule add https://github.com/theNewDynamic/gohugo-theme-ananke themes/ananke
```

## Editirati src/config.toml
```shell
baseURL = 'https://bbz2022.carnet.hr/static/'
languageCode = 'hr-HR'
title = 'Božićna burza znanja 2022'
theme = 'ananke'
```

---
# Priprema kontejnera

## Kroz terminal
```shell
# Napravi novi kontejner
$ docker build -t hugo-prod:latest -f Dockerfile.hugo .
# Napravi novi kontejner specifičnog stupnja (stage)
$ docker build --target dev_containers_target_stage -t hugo-dev:latest -f Dockerfile.hugo .
```

---
# Pokretanje kontejnera

## Kroz terminal
```shell
# Pokreni produkcijski kontejner
$ docker run --rm -p 6060:80 hugo-prod:latest
# Pokreni razvojni kontejner
$ docker run --rm -p 6666:80 hugo-dev:latest
```

---
# Dodavanje sadržaja

## Tema Ananke
https://github.com/theNewDynamic/gohugo-theme-ananke

## Primjer sadržaja
https://github.com/theNewDynamic/gohugo-theme-ananke/tree/master/exampleSite

---
# I umjesto kraja

- Možemo se povezati s CI/CD mehanizmima u github/gitlab sustavima radi automatizacije promjene sadržaja
