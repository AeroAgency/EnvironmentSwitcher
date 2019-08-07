# EnvironmentSwither

**EnvironmentSwither** - утилита предназначенная для смены окружения (серверов) на лету.
Предназанчена в первую очередь для тестовых сборок, для разработчиков / тестировщиков / менеджеров, чтобы иметь возможность в рамках одной сборки переключаться между различными несколькими серверами и http endpoints.

- [Зачем?](#зачем?)
- [Фичи](#фичи)
- [Требования](#требования)
- [Установка](#установка)
- [Как это работает](#как-это-работает)
- [Примеры](#примеры)

## Зачем?
При разработке часто возникают ситуации, когда одну и туже сборку необходимо протестировать в нескольких окружениях. Для этого приходится делать несколько сборок, с одинаковой кодовой базой, но направленными на разные Http endpoints в [TestFlight](https://developer.apple.com/testflight/), для тестирования. Это приводит к
- путанице, какой именно номер сборки на какое окружение смотрит
- приходится нелать несколько одинаковых сборок и отдавать их на тестирование, что приводит к замедлению процесса разработки

Данная библиотека решает следующие кейсы:
- Необходимо в рамках одной сборки отлаживать на development сервере, и проверить удачный merge на stage сервер.
- Есть несколько разных окружений, с разными БД и разными данными. Нужно одну и туже сборку проверить в обоих окружениях.
- В рамках одной сборки необходимо проверить что релиз со stage на production прошёл успешно и
  - в предыдущей сборке ничего не сломалось
  - текущая сборка работалет правильно после релиза

## Фичи
- [x] Указание списка доступных серверов
- [x] Указания сервера по-умолчанию
- [x] Возможность выбрать сервер сразу после сплеш-экрана до запуска основного
- [x] Работа поверх остальных `UIWindow` и модальных `UIViewController`
- [x] Поддержка портретной и ландшафтной ориентаций
- [x] Локализация RU
- [ ] Локализация EN
- [ ] Сохранение последнего выбранного сервера
- [ ] Конфигурации
- [ ] Интерактивная инструкция для пользователей
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
Незабудьте перед использованием добавить `import EnvironmentSwitcher` в файле, где вы собираетесь инициализировать использование библиотеки.

### Вручную
Скачайте архив из ветки `master` (стабильная версия) или интересующую вас версию из [releases](https://github.com/AeroAgency/EnvironmentSwither/releases).
Распакуйте и перенесите содержимое папки `Source` в свой проект.

## Как это работает

![](preview_ru.gif)

1. При инициализации библиотеки указываются список доступных серверов и сервер по умолчанию.
2. Библиотека добавляет на основное `UIWindow` невидимую кнопку (центр экрана по горизонтали, 0 отступ по вертикали).
Кнопка не видима, чтобы не закрывать собой контент, и имеет отступ 0 от границ экрана, чтобы не налезать на `NavigationBar`.
2. Двойной тап по невидимой кнопке - показывает кнопку с иконкой в этой же области, которая уже может перекрывать контент.
3. `LongTap` в 2 или более секунд добавляет новый `UIWindow` поверх основного, с возможностью выбора активного сервера.

Обьект, желающий получать уведомления о смене сервера, должен реализоввывать метод `func serverDidChanged(_ newServer: String)` протокола `EnvironmentSwitcherDelegate`

**⚠️️ Внимание** По умолчанию, EnvironmentSwitcher инициалируется в режиме выбора сервера **ДО** запуска стартового `UIViewController` приложения. В этом случае в момент инициации библиотека заменяет `keyWindow` в `UIApplication` на свой. Чтобы запустить выбор сервера до запуска стартового `UIViewController`, следует инициировать EnvironmentSwitcher в методе `AppDelegate`:
```swift
func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool
```
Иначе вам следует при иницииации указывать параметр `shouldSelectOnStart` в `false`, в противном случае, при инициализации `keyWindow` будет подменён.

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
Запуск с дефолтным котейнером `UIWindow` и отключённым автостартом при запуске:
```swift
class SomeClass {
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
