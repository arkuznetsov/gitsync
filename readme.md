Синхронизация хранилища 1С с репозиторием git
=============================================

Обсудить [![ЧАТ ДЛЯ ОБЩЕНИЯ https://gitter.im/EvilBeaver/oscript-library](https://badges.gitter.im/EvilBeaver/oscript-library.svg)](https://gitter.im/EvilBeaver/oscript-library?utm_source=badge&utm_medium=badge&utm_campaign=pr-badge&utm_content=badge)

[![GitHub release](https://img.shields.io/github/release/khorevaa/gitsync.svg)](https://github.com/oscript-library/gitsync/releases)

Оглавление
==========

<!-- TOC insertAnchor:true -->

- [Введение](#введение)
- [Установка](#установка)
    - [Вручную](#вручную)
    - [Через пакетный менеджер opm](#через-пакетный-менеджер-opm)
- [Требования](#требования)
- [Особенности](#особенности)
    - [Отличия от `gitsync` версий 2.x](#отличия-от-gitsync-версий-2x)
    - [Описание функциональности](#описание-функциональности)
- [Использование приложения `gitsync`](#использование-приложения-gitsync)
    - [Подготовка нового репозитория](#подготовка-нового-репозитория)
    - [Установка соответствия пользователей](#установка-соответствия-пользователей)
    - [Установка начальной версии из хранилища 1С для синхронизации](#установка-начальной-версии-из-хранилища-1с-для-синхронизации)
    - [Настройка плагинов синхронизации](#настройка-плагинов-синхронизации)
    - [Синхронизация](#синхронизация)
        - [Справка по использованию команды](#справка-по-использованию-команды)
        - [Глобальные переменные окружения](#глобальные-переменные-окружения)
        - [Переменные окружения команды](#переменные-окружения-команды)
        - [Значения по умолчанию](#значения-по-умолчанию)
        - [Примеры использования](#примеры-использования)
- [Использование библиотеки `gitsync`](#использование-библиотеки-gitsync)
- [Доработка и разработка плагинов](#доработка-и-разработка-плагинов)
- [Механизм подписок на события](#механизм-подписок-на-события)
- [Сборка проекта](#сборка-проекта)
- [Доработка](#доработка)
- [Лицензия](#лицензия)

<!-- /TOC -->

<a id="markdown-введение" name="введение"></a>
## Введение

Проект *gitsync* представляет собой:

1. Библиотеку `gitsync` (`src/core`) - которая реализует основные классы для синхронизации хранилища 1С с git
2. Приложение `gitsync` (`src/cmd`) - консольное приложение на основе библиотеки [`cli`](https://github/khorevaa/cli)

[Документация и описание публичного API библиотеки](docs/README.md)

<a id="markdown-установка" name="установка"></a>
## Установка

<a id="markdown-вручную" name="вручную"></a>
### Вручную

1. Скачать файл `gitsync*.ospx` из раздела [releases](https://github.com/khorevaa/gitsync/releases)
2. Воспользоваться командой:

```
$ opm install -f <ПутьКФайлу>
```

<a id="markdown-через-пакетный-менеджер-opm" name="через-пакетный-менеджер-opm"></a>
### Через пакетный менеджер opm

1. командой `opm install gitsync`
2. Запустить командой `gitsync`

<a id="markdown-Требования" name="Требования"></a>
## Требования

* утилита `ring` и `` - для работы с 1С старше версии > 8.3.11

<a id="markdown-особенности" name="особенности"></a>
## Особенности


<a id="markdown-отличия-от-gitsync-версий-2x" name="отличия-от-gitsync-версий-2x"></a>
### Отличия от `gitsync` версий 2.x

* Полностью другая строка вызова приложения, а именно используется стандарт POSIX.
* Работа с хранилищем конфигурации реализовано на основании библиотеки [`v8storage`](https://github.com/khorevaa/v8storage)
* Реализована поддержка работы с `http` и `tcp` хранилищами 
* Функциональность работы через `tool1CD` - перенесена в предустановленный плагин `tool1CD`
* Вместо двух команд `sync` и `export` оставлена только одна команда `sync`, которая работает как команда `export` в предыдущих версиях, при это функциональность синхронизации с удаленным репозиторием (команды `git pull` и `git push` ) перенесена в отдельный плагин `sync-remote`
* Отказ от поддержки работы с форматом `plain` при выгрузке конфигурации в исходники
* Отказ от поддержки файла `renames.txt` и переименования длинных файлов
* Расширяемость функционала за счет использования механизма подписок на события
* Пока не поддерживается синхронизация с несколькими хранилищами одновременно. (команда `all`)

<a id="markdown-описание-функциональности" name="описание-функциональности"></a>
### Описание функциональности

> Раздел документации в разработке

<!-- TODO: Сделать описание функциональности -->

<a id="markdown-использование-приложения-gitsync" name="использование-приложения-gitsync"></a>
## Использование приложения `gitsync`

<a id="markdown-подготовка-нового-репозитория" name="подготовка-нового-репозитория"></a>
### Подготовка нового репозитория

> Данный шаг можно пропустить, если у Вас уже готова рабочая копия git репозитория

1. Если у Вас уже есть удаленный репозиторий (уже делалась синхронизация с git) и вы проводили синхронизацию тогда следует воспользоваться командой `clone`

Пример использования:

`gitsync clone --storage-user Администратор --storage-pwd Секрет <путь_к_хранилищу_1С> <адрес_удаленного_репозитория> <рабочий_каталог>(необязательный)`

Справка по команде `clone`: `gitsync clone --help`

Больше примеров можно увидеть, использовав команду `gitsync usage clone`

2. Если у Вас нет удаленного репозитория, тогда стоит воспользоваться командой `init` для выполнения начальной настройки и наполнения данными рабочего каталог

Пример использования:

* `gitsync init --storage-user Администратор --storage-pwd Секрет C:/Хранилище_1С/ C:/GIT/src`

    Данная команда создаст новый репозиторий git в каталоге `C:/GIT/src` из хранилища 1С по пути `C:/Хранилище_1С/` и наполнил его служебными файлами `VERSION` и `AUTHORS`

* `gitsync init --storage-user Администратор --storage-pwd Секрет http:/www.storages.1c.com/repository.1ccr/ИмяХранилища C:/GIT/src`

    Тоже самое только для `http` хранилищем по адресу `http:/www.storages.1c.com/repository.1ccr/ИмяХранилища`

Справка по команде `init`: `gitsync init --help`

Больше примеров можно увидеть, использовав команду `gitsync usage init`

<a id="markdown-установка-соответствия-пользователей" name="установка-соответствия-пользователей"></a>
### Установка соответствия пользователей

> Данный шаг можно пропустить, если у Вас уже установлено соответствие пользователей хранилища 1с и git

Для настройки соответствия между пользователями хранилища 1с и git предназначен Файл `AUTHORS`.

Данный файл имеет формат `ini` файла.

Пример файла:

```ini
Администратор=Пользователь1 <admin-user@mail.com>
Вася Иванов=Другой Пользователь <user-user@mail.com>
```

слева указано имя пользователя хранилища 1С
справа - представление имени пользователя репозитория Git и его e-mail

С помощью e-mail выполняется связка пользователя с публичными репозиториями (например, Github или Bitbucket)

<a id="markdown-установка-начальной-версии-из-хранилища-1с-для-синхронизации" name="установка-начальной-версии-из-хранилища-1с-для-синхронизации"></a>
### Установка начальной версии из хранилища 1С для синхронизации

> Данный шаг можно пропустить, если у Вас уже установлена или заполнения версия в файле `VERSION`

Для настройки последней синхронизированной(выгруженной в рабочий каталог) версии хранилища 1С служит файл `VERSION`.

Данный файл имеет формат `xml`

Пример файла, в котором указано, что выгружено 10 версий:

```xml
<?xml version="1.0" encoding="UTF-8"?>
<VERSION>10</VERSION>
```

Данный файл можно отредактировать в ручную или воспользовавшись командой `set-version`.

Пример использования:

`gitsync set-version <номер_версии> <рабочий_каталог>(необязательный)`

Данная команда установит указанную версию `<номер_версии>` в файл `VERSION`, который лежит в каталоге `<рабочий_каталог>`

Справка по команде `set-version`: `gitsync set-version --help`

Для удобства использования команда `set-version` имеет короткое название `sv`.

Больше примеров можно увидеть, использовав команду `gitsync usage set-version`

<a id="markdown-настройка-плагинов-синхронизации" name="настройка-плагинов-синхронизации"></a>
### Настройка плагинов синхронизации

> Данный пункт можно пропустить, если Вам не требуется дополнительная функциональность синхронизации

Для расширения функциональности синхронизации предлагается механизм *плагинов*.
Данный механизм реализован через подписки на события синхронизации, с возможностью переопределения стандартной обработки.

Для обеспечения управления плагинами реализована подкоманда `plugins`, а так же ряд вложенных команд:

1. `init` - Инициализация предустановленных плагинов
1. `list` - Вывод списка плагинов
1. `enable` - Активизация установленных плагинов
1. `disable` - Деактивизация установленных плагинов
1. `install` - Установка новых плагинов
1. `clear` - Очистка установленных плагинов
1. `help` - Вывод справки по выбранным плагинам

Пример использования:

* `gitsync plugins enable limit` - будет активирован плагин `limit`
* `gitsync plugins list` - будет выведен список всех *активированных* плагинов
* `gitsync plugins list -a` - будет выведен список всех *установленных* плагинов 

Справка по команде `plugins`: `gitsync plugins --help`

Для удобства использования команда `plugins` имеет короткое название `p`.

Больше примеров можно увидеть, использовав команду `gitsync usage plugins`

> Для хранения установленных плагинов и списка активных плагинов используется каталог `локальных данных приложения`

Список предустановленных плагинов:
> Для инициализации предустановленных плагинов необходимо выполнить команду `gitsync plugins init`

1. `increment` - обеспечивает инкрементальную выгрузку конфигурации в исходники
1. `sync-remote` -  добавляет функциональность синхронизации с удаленным репозиторием git (команды `git pull` и `git push`)
1. `limit` - добавляет возможность ограничения на минимальный, максимальный номер версии хранилища, а так же на лимит на количество выгружаемых версий за один запуск
1. `check-authors` - добавляет функциональность проверки автора версии в хранилище на наличие соответствия в файле `AUTHORS`
1. `check-comments` - добавляет функциональность проверки на заполненность комментариев в хранилище
1. `smart-tags` - добавляет функциональность автоматической расстановки меток в git (команда `git tag`) при изменении версии конфигурации
1. `unpackForm` - добавляет функциональность распаковки обычных форм на исходники
1. `tool1CD` - заменяет использование штатных механизмов 1С на приложение `tool1CD` при синхронизации
1. `disable-support` - снимает конфигурацию с поддержки перед выгрузкой в исходники


<a id="markdown-синхронизация" name="синхронизация"></a>
### Синхронизация

Команда `sync` (синоним s) - выполняет синхронизацию хранилища 1С с git-репозиторием

> Подробную справку по опциям и аргументам см. `gitsync sync --help`

<a id="markdown-справка-по-использованию-команды" name="справка-по-использованию-команды"></a>
#### Справка по использованию команды

```
Команда: sync, s
 Выполняет синхронизацию хранилища 1С с git-репозиторием

Строка запуска: gitsync sync [ОПЦИИ] PATH [WORKDIR]

Аргументы:
  PATH          Путь к хранилищу конфигурации 1С. (env $GITSYNC_STORAGE_PATH)
  WORKDIR       Каталог исходников внутри локальной копии git-репозитория. (env $GITSYNC_WORKDIR)

Опции:
  -u, --storage-user    пользователь хранилища конфигурации (env $GITSYNC_STORAGE_USER) (по умолчанию Администратор)
  -p, --storage-pwd     пароль пользователя хранилища конфигурации (env $GITSYNC_STORAGE_PASSWORD, $GITSYNC_STORAGE_PWD)

```

<a id="markdown-глобальные-переменные-окружения" name="глобальные-переменные-окружения"></a>
#### Глобальные переменные окружения
| Имя                 | Описание                                               |
|---------------------|--------------------------------------------------------|
| `GITSYNC_V8VERSION` | маска версии платформы (8.3, 8.3.5, 8.3.6.2299 и т.п.) |
| `GITSYNC_V8_PATH`   | путь к исполняемому файлу платформы 1С (Например, /opt/1C/v8.3/x86_64/1cv8) |
| `GITSYNC_VERBOSE`   | вывод отладочной информации в процессе выполнения      |
| `GITSYNC_TEMP`      | путь к каталогу временных файлов                       |
| `GITSYNC_EMAIL`     | домен почты для пользователей git                      |

<a id="markdown-переменные-окружения-команды" name="переменные-окружения-команды"></a>
#### Переменные окружения команды

| Имя                        | Описание                                   |
|----------------------------|--------------------------------------------|
| `GITSYNC_WORKDIR`          | рабочий каталог для команды                |
| `GITSYNC_STORAGE_PATH`     | путь к хранилищу конфигурации 1С.          |
| `GITSYNC_STORAGE_USER`     | пользователь хранилища конфигурации        |
| `GITSYNC_STORAGE_PASSWORD` | пароль пользователя хранилища конфигурации |

<a id="markdown-значения-по-умолчанию" name="значения-по-умолчанию"></a>
#### Значения по умолчанию

|                    |                              |
|--------------------|------------------------------|
| WORKDIR            | текущая рабочая директория   |
| -u, --storage-user | пользователь `Администратор` |

<a id="markdown-примеры-использования" name="примеры-использования"></a>
#### Примеры использования

* Простое использование

    `gitsync sync C:/Хранилище_1С/ C:/GIT/src`

    Данная команда выполнить синхронизацию хранилища 1С по пути `C:/Хранилище_1С/` и репозитория git в каталоге `C:/GIT/src`

* Инициализация в текущем рабочем каталоге,

    > переменная окружения **`GITSYNC_WORKDIR`** не должна быть задана

    ```sh
    cd C:/work_dir/
    gitsync sync C:/Хранилище_1С/
    ```
    Данная команда выполнить синхронизацию хранилища 1С по пути `C:/Хранилище_1С/` и репозитория git в каталоге `C:/work_dir`

* Инициализация в с указанием пользователя и пароля.

    ```sh
    gitsync sync --storage-user Admin --storage-pwd=Secret C:/Хранилище_1С/ C:/work_dir/
    ```
    Данная команда выполнить синхронизацию хранилища 1С по пути `C:/Хранилище_1С/` и репозитория git в каталоге `C:/work_dir`
    Используя для подключения к хранилищу 1С пользователя `Admin` и пароль `Secret`

* Использование синонимов (короткая версия предыдущего примера)

    ```sh
    gitsync s -uAdmin -p=Secret C:/Хранилище_1С/ C:/work_dir/
    ```
    Данная команда выполнить синхронизацию хранилища 1С по пути `C:/Хранилище_1С/` и репозитория git в каталоге `C:/work_dir`
    Используя для подключения к хранилищу 1С пользователя `Admin` и пароль `Secret`

* Использование конкретной исполняемого файла платформы 

    ```sh
    gitsync --v8-path /opt/1C/v8.3/x86_64/1cv8 s -uAdmin -p=Secret C:/Хранилище_1С/ C:/work_dir/
    ```
    Данная команда синхронизации выполнится с использованием исполняемого файла платформы `/opt/1C/v8.3/x86_64/1cv8` для хранилища 1С по пути `C:/Хранилище_1С/` и репозитория git в каталоге `C:/work_dir`
    Используя для подключения к хранилищу 1С пользователя `Admin` и пароль `Secret`

* Использование только переменных окружения

    linux:
    ```sh
    export GITSYNC_WORKDIR=./work_dir/
    export GITSYNC_STORAGE_PATH=./Хранилище_1С/

    export GITSYNC_STORAGE_USER=Admin
    export GITSYNC_STORAGE_PASSWORD=Secret
    export GITSYNC_V8VERSION=8.3.7
    # Указание конкретного исполняемого файла платформы 1С
    #export GITSYNC_V8_PATH=/opt/1C/v8.3/x86_64/1cv8 # Надо обернуть в кавычки если путь содержит пробелы
    export GITSYNC_VERBOSE=true #Можно использовать Да/Ложь/Нет/Истина
    export GITSYNC_TEMP=./temp/sync
    gitsync s
    ```
    windows:
    ```cmd
    set GITSYNC_WORKDIR=./work_dir/
    set GITSYNC_STORAGE_PATH=./Хранилище_1С/

    set GITSYNC_STORAGE_USER=Admin
    set GITSYNC_STORAGE_PASSWORD=Secret
    set GITSYNC_V8VERSION=8.3.7
    # Указание конкретного исполняемого файла платформы 1С
    #set GITSYNC_V8_PATH="C:\Program Files (x86)\1cv8\8.3.12.1567\bin\1cv8.exe" # Надо обернуть в кавычки если путь содержит пробелы
    set GITSYNC_VERBOSE=true #Можно использовать Да/Ложь/Нет/Истина
    set GITSYNC_TEMP=./temp/sync

    gitsync s
    ```
    Данная команда выполнить синхронизацию хранилища 1С по пути `C:/Хранилище_1С/` и репозитория git в каталоге `C:/work_dir`
    Используя для подключения к хранилищу 1С пользователя `Admin` и пароль `Secret`

<a id="markdown-использование-библиотеки-gitsync" name="использование-библиотеки-gitsync"></a>
## Использование библиотеки `gitsync`

> Раздел документации в разработке

<!-- TODO: Сделать описание функциональности -->

<a id="markdown-доработка-и-разработка-плагинов" name="доработка-и-разработка-плагинов"></a>
## Доработка и разработка плагинов

Как разработать свой или доработать текущие плагины

1. [Как создать свой плагин](./create-new-plugin.md)
1. Доработка предустановленных плагинов производится в отдельном репозитории [gitsync-plugins](https://github.com/khorevaa/gitsync-plugins)


<a id="markdown-механизм-подписок-на-события" name="механизм-подписок-на-события"></a>
## Механизм подписок на события 

> Раздел документации в разработке

Проект `gitsync` поддерживает ряд подписок на события


<!-- TODO: Сделать описание функциональности -->

<a id="markdown-сборка-проекта" name="сборка-проекта"></a>
## Сборка проекта

Сборка производится в 2-х режимах:

1. Сборка обычного пакета (без зависимостей)

    `opm build .`

    > при данной сборки не собираются предустановленные пакеты. Их надо будет устанавливать отдельно

2. Сборка пакета с зависимостями

    `opm build -mf ./build_packagedef .`

    При данной сборке будут дополнительно собраны из репозиториев:

    * `opm` - из ветки develop
    * `gitsync-pre-plugins` - из вертки develop

<a id="markdown-доработка" name="доработка"></a>
## Доработка

Доработка проводится по git-flow. Жду ваших PR.

<a id="markdown-лицензия" name="лицензия"></a>
## Лицензия

Смотри файл [`LICENSE`](./LICENSE).
