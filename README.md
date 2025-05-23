# adapter
Сервис агрегации всех микросервисов бекэнда ProКарьеру, организующий работу всего проекта.

## Требования для использования
- Docker
- Docker compose
- Make
- Настроенные SSH-ключи и доступ ко всем репозиториям

## Как использовать
### Быстрый вариант для Windows.
Выполнить команду ниже. 
```shell
make run
```
[//]: # (todo что-то придумать с secret_key)

### 1. Клонирование сервисов.

Склонировать все сервисы в папку services, выполняя команды ниже по очереди.
```shell
cd services
git clone git@github.com:rashevskiivv/api.git
git clone git@github.com:rashevskiivv/auth.git
```
[//]: # (todo добавить сервис рекомендации и получения данных)

### 2. Копирование файлов с переменными среды.

Далее перейти в каждый из сервисов `cd service_name`, где service_name: api, auth, .

Внутри каждого из сервисов нужно создать .env файл, одной из команд в зависимости от платформы.

Unix: `make copy-env`

Windows: `make copy-env-windows`

### 3. Сборка образов каждого сервиса и БД.

Далее выполнить сборку образов в Docker следующими командами.
```shell
make compile-db
make compile
```
Необходимо выполнить вышеуказанные команды для каждого из сервисов.

### 4. Копирование файлов с переменными среды.

Далее нужно перейти в корневую директорию `cd ../..`.

Нужно создать .env файл, одной из команд в зависимости от платформы.

Unix: `make copy-env`

Windows: `make copy-env-windows`

### 5. Сборка образа адаптера и запуск.

Последним шагом будет сбора образа для nginx и выполнить деплой всего проекта.
```shell
make compile
make deploy
```
