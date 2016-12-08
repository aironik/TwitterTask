# Тестовое задание

Написать приложение под iOS, которое должно отвечать следующим требованиям:
* В таблице должны отображаться твиты из результатов search или timeline любого пользователя в twitter. Авторизация по OAuth не входит в задачу, токены можно вшить в приложение.
* Рядом с твитом должен быть аватар и имя пользователя.
* Обновление содержимого должно происходить сразу при запуске и каждые 60 секунд. В углу страницы отображается таймер времени до следующего обновления.
* Полученные твиты и аватарки должны кешироваться локально (sqlite/FMDB, не CoreData), т.о. при перезапуске приложения можно будет сразу увидеть уже подгруженные твиты.
* Сетевые запросы, локальное кеширование - не должны блокировать UI.
* Работает на iOS >= 7.0.
* ARC.
* Гордый отказ от использование различных Social Framework'ов, парсинг JSON ленты твиттера производим самостоятельно, любыми средствами SBJSON/json-framework/SomethingJSON.
* Нужна страница настроек с 1 настройкой – отображать или не отображать аватарки. Настройка должна сохраняться между запусками приложения.
* Красота UI не представляет интереса.

# Комментарии к выполнению

Задание выполнено на языке Objective C.

Авторизация в задание не входит. Поэтому, для запуска задания, необходимо сообщить приложению токен. Это можно сделать 2 способами:
* создать макроопределение строки ```#define TWITTER_ACCESS_TOKEN @"bearer AAA_TOKEN_HERE"``` Например, в файле ```TwitterTask/ATTDefinitions.h```;
* создать файл ```TwitterTask/Resources/access_token.txt``` с токеном вида ```bearer AAA_TOKEN_HERE```. Файл должен содержать только строку токена, которая добавляется в HTTP-заголовок ```Authorization``` в неизменном виде, без лишних пробелов и переновос строк.

## Структура проекта

### DataManager

DataManager - каталог, содержащий менеджер данных, определяющий бизнес-логику и представляющий модель данных для UI (MVC).
DataManager является самостоятельным модулем приложения и может работать независимо. При старте ```-start``` создаются все необходимые сервисы для работы:
* ```ATTNetworkManager``` - класс/сервис, отвечающий ха сетевую работу;
* ```ATTPersistenceStorage``` - класс/сервис, отвечающий за локальное хранение данных;
* ```ATTUpdater``` - класс/сервис, отвечающий за актуализацию данных/запуск задач на обновление по таймеру и создание этих дадач (ставится в очередь задача ```ATTNetworkManager``` на получение новой порции данных, при получении результатов, данные передаются в ```ATTPersistenceStorage```).
* ```<XXX>DataSource``` - объекты, предсталяющие интерфейсы для доступа к данным и позволяющие следить (Observer) за обновлениями данных.

"Внешним интерфейсом" DataMamager'а является интерфейс класса ATTDataManager, позволяющий получать data sources для UI:
```dataSourceForSearch``` - источник данных для отображения списка твиттов в ленте и сообщающий об изменениях;
```dataSourceForImages``` - 
```updater``` - возвращает объект, занимающийся обновлением ленты;

Все операции происходят на "рабочей" очереди (```NSOperationQueue```). Все коллбэки для слушателей (Observer'ов) вызываются на главной очереди (```NSOperationQueue.mainQueue```). Таким образом, DataManager может свободно использоваться UI'ем, но не влияет на его работу (тяжелые операции не тормозят анимации и реакции на пользовательские действия).

### UI

UI - каталог, содержащий MVC-узды для отображения данных.
Пользовательский интерфейс представлен одним экраном с отображением списка твиттов.
Экран содержит ```ATTSearchViewController```, инкапсулирующий другие ViewController'ы (в данном случае - UIViewController'ы ```ATTTwitterListViewController```, ```ATTUpdateCoundownViewController```).
```ATTTwitterListViewController``` - отображает список твиттов, полученных из интерфейса ```ATTStatusesDataSource``` (и является ```ATTImagesDataSourceObserver```).
```ATTUpdateCoundownViewController``` - отображает таймер до обновления, данные получаются из ```ATTUpdater``` (и является ```ATTUpdaterObserver```).
