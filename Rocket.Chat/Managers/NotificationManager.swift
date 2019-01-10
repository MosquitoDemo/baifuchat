//
//  NotificationManager.swift
//  Rocket.Chat
//
//  Created by Samar Sunkaria on 4/8/18.
//  Copyright © 2018 Rocket.Chat. All rights reserved.
//

import Foundation
import UserNotifications


final class NotificationManager{
    
    static let shared = NotificationManager()

    var notification: ChatNotification?

    /// Posts an in-app notification.
    ///
    /// This method is thread safe, and therefore can be called from any thread.
    ///
    /// This method calls `NotificationManager.post(notification:)` on the main thread.
    ///
    /// - parameters:
    ///     - notification: The `ChatNotification` object used to display the
    ///         contents of the notification. The `title` and the `body` of the
    ///         notification cannot be empty strings.

    static func postOnMainThread(notification: ChatNotification) {
        DispatchQueue.main.async {
            post(notification: notification)
        }
        
        ///send the localNotification
//        takeNotification(notification: notification)
        
    }
    
    
    ///the method is added by steve
    static func takeNotification(notification : ChatNotification){
        
        ///1.设置通知内容
        let content = UNMutableNotificationContent();
        content.title = notification.title
//        content.subtitle = "点击查看"
        content.body = notification.body
        content.categoryIdentifier = notification.payload.id
        content.userInfo = convertJsonToAnyHashable(notification: notification)
        
        ///2.设置触发器
        let triger = UNTimeIntervalNotificationTrigger(timeInterval: 0.0001, repeats: false)
        
        ///3.通知
        let request = UNNotificationRequest(identifier: notification.payload.id, content: content, trigger: triger)
        
        let notificationCenter = UNUserNotificationCenter.current()
        
        notificationCenter.add(request) { error in
            
            if(error != nil){
                
                print("推送失败")
                
            }else{
                
                print("推送成功")
            }
            
        }
        
    }
    
    static func convertJsonToAnyHashable(notification : ChatNotification) -> [AnyHashable: Any] {
        return  [
            "aps": [
                "alert": [
                    "title": notification.title,
                    "body": notification.body,
                    "sound": "chime.aiff"
                ],
                "badge": 1
            ],
            "ejson": "{\"host\":\"https://www.chat-stg.baifu-tech.net/\",\"rid\":\"\(notification.payload.rid)\",\"sender\":{\"_id\":\"\(notification.payload.id)\",\"username\":\"\(notification.payload.sender.username)\",\"name\":\"\(notification.payload.name ?? "")\"},\"type\":\"\(notification.payload.internalType)\",\"name\":\"\(notification.payload.name ?? "")\"}",

//            "ejson": "{\"host\":\"kServers\",\"rid\":\"\(notification.payload.rid)\",\"sender\":{\"_id\":\"\(notification.payload.id)\",\"username\":\"\(notification.payload.sender.username)\",\"name\":\"\(notification.payload.name ?? "")\"},\"type\":\"\(notification.payload.internalType)\",\"name\":\"\(notification.payload.name ?? "")\"}",
            
            "messageFrom": "push"
            ] as [AnyHashable: Any]
    }

    
    
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
        
        AnalyticsManager.log(event: .replyNotification)
        
        PushManager.handleNotification(
            raw: response.notification.request.content.userInfo,
            reply: (response as? UNTextInputNotificationResponse)?.userText
        )
    }


    /// Posts an in-app notification.
    ///
    /// This method is **not** thread safe, and therefore must be called
    /// on the main thread.
    ///
    /// **NOTE:** The notification is only posted if the `rid` of the
    /// notification is different from the `AppManager.currentRoomId`
    ///
    /// - parameters:
    ///     - notification: The `ChatNotification` object used to display the
    ///         contents of the notification. The `title` and the `body` of the
    ///         notification cannot be empty strings.

    static func post(notification: ChatNotification) {
        guard
            AppManager.currentRoomId != notification.payload.rid,
            !notification.title.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty,
            !notification.body.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
        else {
            return
        }

        let formattedBody = NSMutableAttributedString(string: notification.body)
            .transformMarkdown().string
            .components(separatedBy: .newlines)
            .joined(separator: " ")
            .replacingOccurrences(of: "^\\s+", with: "", options: .regularExpression)

        NotificationViewController.shared.displayNotification(
            title: notification.title,
            body: formattedBody,
            username: notification.payload.sender.username
        )

        NotificationManager.shared.notification = notification
    }

    func didRespondToNotification() {
        guard
            let notification = notification,
            let type = notification.payload.type
        else {
            return
        }

        switch type {
        case .channel:
            guard let name = notification.payload.name else { return }
            AppManager.openRoom(name: name)
        case .group:
            guard let name = notification.payload.name else { return }
            AppManager.openRoom(name: name, type: .group)
        case .directMessage:
            AppManager.openDirectMessage(username: notification.payload.sender.username)
        }
        self.notification = nil
    }
}
