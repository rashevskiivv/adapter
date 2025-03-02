# adapter
Сервис агрегации всех микросервисов бекэнда ProКарьеру, организующий работу всего проекта.

## Требования для использования
- Docker
- Docker compose
- Make

## Как использовать
Склонировать все сервисы в папку services, выполняя команды ниже по очереди.
```shell
cd services
git clone git@github.com:rashevskiivv/api.git
git clone git@github.com:rashevskiivv/auth.git
```
[//]: # (todo добавить сервис реомендации и получения данных)

Далее перейти в каждый из сервисов `cd service_name`, где service_name: api, auth, .

Внутри каждого из сервисов нужно создать .env файл, одной из команд в зависимости от платформы.

Unix: `make copy-env`

Windows: `make copy-env-windows`

Далее выполнить сборку образов в Docker следующими командами.
```shell
make compile-db
make compile
```

После выполнения вышеуказанных команд для каждого из сервисов, нужно перейти в корневую директорию `cd ../..`.

Последним шагом будет сбора образа для nginx и выполнить деплой всего проекта.
```shell
make compile
make deploy
```
