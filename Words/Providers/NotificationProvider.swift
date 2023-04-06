//
//  NotificationsController.swift
//  TestLanguageApp
//
//  Created by Иван Львов on 26.07.2022.
//

import SwiftUI
import UserNotifications

struct NotifyObject {
    var id: Int
    var title: String
    var text: String
}

class NotificationProvider {
    // MARK: - PROPERTIES

    @AppStorage("isDailyWordNotificationSet") private var isDailyWordNotificationSet: Bool = false

    // static let shared = NotificationProvider()
    let center = UNUserNotificationCenter.current()

    private let headlines: [String] = [
        "😎 Давай поиграем!",
        "🤘 Готовы?",
        "🤨 Давай отгадаем!",
        "🙃 Сделаем это!",
        "🖐️ Привет!",
        "😏 Еще попытка!",
        "😑 Нет времени ждать!",
        "🫡 Не можем ждать!",
        "😏 Еще кое-что",
        "👋 Отдохнули?",
        "📌 Не пропусти!",
        "👋 Как Вы?",
        "👣 Заходи!",
        "🙈 Почти готово!",
        "🦊 Нет времени обьяснять!",
        "😗 Нам нужно еще парочку слов",
        "😲 Нельзя ждать",
        "😏 Привет Привет!",
        "💎 Hola!",
        "⏰ Время побеждать!",
        "🙃 Сыграем?",
        "📕 Не пропусти ЭТО слово",
        "👀 Давай сделаем",
        "👋 Saludos!",
        "👻 Ты здесь?",
        "👋 How are you doing?",
        "😲 Нет времени расслабляться"
    ]

    private let bodies: [String] = [
        "Новое слово дня уже доступно",
        "Слово дня уже появилось",
        "Новое слово уже тебя",
        "Слово дня уже у нас в руках. Заходим!",
        "Можно разгадать новое слово дня!",
        "Пора сделать новое слово дня"
    ]

    // MARK: - ARRAY OF RANDOM NOTIIFICATIONS
    private var notifications: [NotifyObject] {
        var notifications: [NotifyObject] = []
        for index in 1...60 {
            let title = self.headlines.randomElement() ?? self.headlines[0]
            let body = self.bodies.randomElement() ?? self.bodies[0]
            notifications.append(NotifyObject(id: index + 1, title: body, text: title))
        }
        return notifications
    }

    // MARK: - FUNCTIONS

    // Prints current planned notifications
    func showCurrent() {
        center.getPendingNotificationRequests(completionHandler: { requests in
            for request in requests {
                print(request)
            }
        })
    }

    func toggleNotifications() {
        if isDailyWordNotificationSet {
            removeAllNotifications()
        } else {
            setNotifications()
        }
    }

    // Удаляет все оповещения
    func removeAllNotifications() {
        print("Удаляю")
        isDailyWordNotificationSet = false
        center.removeAllDeliveredNotifications()
        center.removeAllPendingNotificationRequests()
    }

    // Удаляет оповещение установленное на сегодня
    func removeTodaysNotification() {
        let notificationCenter = UNUserNotificationCenter.current()

        notificationCenter.getPendingNotificationRequests(completionHandler: { requests in
            for request in requests {
                if let trigger = request.trigger as? UNCalendarNotificationTrigger,
                   let nextTriggerDate = trigger.nextTriggerDate() {
                    if Calendar.current.isDateInToday(nextTriggerDate) {
                        notificationCenter.removeDeliveredNotifications(withIdentifiers: [request.identifier])
                        notificationCenter.removePendingNotificationRequests(withIdentifiers: [request.identifier])
                    }
                }
            }
        })
    }

    // Проверяет и обновляет оповещения если требуется
    func checkAndSetNotifiications( skipCurrentDay: Bool = false ) {
        center.getPendingNotificationRequests(completionHandler: { requests in
            if requests.count < 5 {
                self.updateNotifications(skipCurrentDay: skipCurrentDay)
            }
        })
    }

    // Обновляет оповещения
    func updateNotifications(skipCurrentDay: Bool = false) {
        // Set notifications only if we have access
        center.getNotificationSettings { (settings) in
            if settings.authorizationStatus == .authorized {
                self.removeAllNotifications()
                print("<NOTIFICATIONS> We have access, set up notifications")
                // Перебираем наши нотификации
                self.notifications.enumerated().forEach {(index, notifyObject) in

                    if skipCurrentDay && index == 0 {
                        return
                    }

                    // Create the new notfication
                    let notificationContent = UNMutableNotificationContent()
                    notificationContent.title = notifyObject.title
                    notificationContent.body = notifyObject.text
                    notificationContent.badge = NSNumber(value: 1)
                    notificationContent.sound = .default

                    // Добавили N дней к дате срабатывания
                    let nextTriggerDate = Calendar.current.date(
                        byAdding: .day,
                        value: index,
                        to: Date()
                    )!

                    // Установили минуты и часы нотификации из настроек
                    var components = Calendar.current.dateComponents([.day, .minute, .hour, .month], from: nextTriggerDate)
                    components.minute = 0
                    components.hour = 14

                    // Создали триггер
                    let trigger = UNCalendarNotificationTrigger(dateMatching: components, repeats: false)

                    // Создали запрос
                    let request = UNNotificationRequest(identifier: "\(notifyObject.id)", content: notificationContent, trigger: trigger)

                    // Добавили
                    UNUserNotificationCenter.current().add(request) { (error: Error?) in
                        if let theError = error {
                            print(theError.localizedDescription)
                        } else {
                            self.isDailyWordNotificationSet = true
                        }
                    }
                }
            }
        }

    }

    // Устанавливает оповещения
    func setNotifications() {
        center.requestAuthorization(options: [.alert, .sound, .badge]) { granted, _ in
            if granted {
                self.updateNotifications()
            } else {
                print("Don't have an access... EXIT")
            }
        }
    }
}
