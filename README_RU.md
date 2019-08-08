# EnvironmentSwither

ReadMe: [[EN](README.md)] | [*RU*]

**EnvironmentSwither** - утилита предназначенная для смены окружения (серверов) на лету.
Предназначена в первую очередь для тестовых сборок, для разработчиков / тестировщиков / менеджеров, чтобы иметь возможность в рамках одной сборки переключаться между различными несколькими серверами и http endpoints.
**⚠️️ ВНИМАНИЕ** Настоятельно рекомендуется использовать эту библиотеку только для не production сборок и убирать её из сборок для app store.

- [Зачем?](#зачем?)
- [Фичи](#фичи)
- [Требования](#требования)
- [Установка](#установка)
- [Как это работает](#как-это-работает)
- [Примеры](#примеры)

## Зачем?
При разработке иногда возникают ситуации, когда одну и туже сборку необходимо протестировать в нескольких окружениях. Для этого приходится делать несколько сборок, с одинаковой кодовой базой, но направленными на разные http endpoints. Это приводит к:
- приходится делать несколько одинаковых сборок и отдавать их на тестирование, что приводит к замедлению процесса разработки;
- путанице, какой именно номер сборки на какое окружение смотрит.

Данная библиотека помогает решить следующие кейсы:
- необходимо одну сборку протестировать на development сервере и проверить удачный merge на stage сервер;
- есть несколько разных окружений, с разными БД и разными данными. Нужно одну и туже сборку проверить во всех окружениях;
- в рамках одной сборки необходимо проверить что релиз на production прошёл успешно и:
  - в предыдущей сборке ничего не сломалось;
  - текущая сборка работалет правильно после релиза бекенда.

## Фичи
- [x] Указание списка доступных серверов
- [x] Указания сервера по-умолчанию
- [x] Возможность выбрать сервер сразу после экрана запуска до открытия сплеш-экрана
- [x] Работа поверх остальных `UIWindow` и `UIViewController`
- [x] Поддержка портретной и ландшафтной ориентаций
- [x] Локализация RU
- [x] Локализация EN
- [ ] Сохранение последнего выбранного сервера между запусками
- [ ] Конфигурации
- [ ] Интерактивная инструкция для тестировщиков, при первом запуске
- [ ] Расширенные примеры

## Требования
- iOS 10.0+
- Xcode 10.2+
- Swift 5+

## Установка
### CocoaPods
Добавьте следующую строку в ваш Podfile:
```rb
pod 'EnvironmentSwitcher', :git => 'https://github.com/AeroAgency/EnvironmentSwither.git'
```
Затем в консоли в папке с вашим проектом выполните команду `pod install`.
Незабудьте перед использованием добавить `import EnvironmentSwitcher` в файле, где вы собираетесь инициализировать использование библиотеку.

### Вручную
Скачайте архив из ветки `master` (стабильная версия) или интересующую вас версию из [releases](https://github.com/AeroAgency/EnvironmentSwither/releases).
Распакуйте и перенесите содержимое папки `Source` в свой проект.

## Как это работает

![](preview_ru.mp4)

1. При инициализации указываются список доступных серверов и сервер по умолчанию.
2. Библиотека добавляет на основное `UIWindow` невидимую кнопку (центр экрана по горизонтали, небольшой отступ от статус бара вертикали).
Кнопка не видима, чтобы не закрывать собой контент или title на `NavigationBar`.
3. Двойной тап по невидимой кнопке показывает кнопку с иконкой в этой же области, которая уже может перекрывать контент.
4. `LongTap` в 2 или более секунд добавляет новый `UIWindow` поверх основного, с возможностью выбора активного сервера.

Объект, желающий получать уведомления о смене сервера, должен реализоввывать метод `func serverDidChanged(_ newServer: String)` протокола `EnvironmentSwitcherDelegate`.

**⚠️️ ВНИМАНИЕ** По умолчанию, EnvironmentSwitcher инициалируется в режиме выбора сервера **ДО** запуска стартового `UIViewController` приложения. В этом случае в момент инициации библиотека заменяет `keyWindow` в `UIApplication` на свой. Для правильного выбора сервера до запуска стартового `UIViewController`, следует инициировать EnvironmentSwitcher в методе `AppDelegate`:
```swift
func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool
```
Иначе вам следует при иницииации указывать параметр `shouldSelectOnStart` в `false`. Тогда выбор сервера может быть запущен только вручную и `keyWindow` не будет подменяться.

## Примеры
Запуск c конкретным кастомным котейнером `UIWindow`:
```swift
class MyWindowContainer: MainWindowContaner {
    var mainWindow: UIWindow? {
        return UIWindow()
    }
}

//...

class SomeClass {

    private(set) var switcher: EnvironmentSwitcher
    
    init() {
        let config = ServersListConfigurator(servers: ["https://production.com", "https://stage.com", "https://develop.com"], current: "https://stage.com")
        let application = MyWindowContainer()
        switcher = EnvironmentSwitcher(config, app: application)
        switcher.delegate = self
    }
}

extension SomeClass: EnvironmentSwitcherDelegate {
    func serverDidChanged(_ newServer: String) {
        print("New server is \(newServer)")
    }
}
```
Запуск с дефолтным контейнером `UIWindow` и отключённым автостартом при старте приложения:
```swift
class SomeClass {

    private(set) var switcher: EnvironmentSwitcher
    
    init() {
        let config = ServersListConfigurator(servers: ["https://production.com", "https://stage.com", "https://develop.com"], current: "https://stage.com", shouldSelectOnStart: false)
        switcher = EnvironmentSwitcher(config)
        switcher.delegate = self
    }
}

extension SomeClass: EnvironmentSwitcherDelegate {
    func serverDidChanged(_ newServer: String) {
        print("New server is \(newServer)")
    }
}
```
