//
//  UserManager.swift
//  Rocket.Chat
//
//  Created by Rafael K. Streit on 8/17/16.
//  Copyright © 2016 Rocket.Chat. All rights reserved.
//

import Foundation

struct UserManager {

    static func changes() {
        let request = [
            "msg": "sub",
            "name": "activeUsers",
            "params": []
        ] as [String: Any]

        SocketManager.send(request) { response in
            print(response)
        }
    }

    static func userDataChanges() {
        let request = [
            "msg": "sub",
            "name": "userData",
            "params": []
        ] as [String: Any]

        SocketManager.send(request) { response in
            print(response)
            
            
        }
        let requestx = [
            "msg": "sub",
            "name": "user.extra",
            "params": []
            ] as [String: Any]
        SocketManager.send(requestx) { response in
            print(response)
            
        }

    }

    static func setUserStatus(status: UserStatus, completion: @escaping MessageCompletion) {
        let request = [
            "msg": "method",
            "method": "UserPresence:setDefaultStatus",
            "params": [status.rawValue]
        ] as [String: Any]

        SocketManager.send(request) { (response) in
            completion(response)
        }
    }

    static func setUserPresence(status: UserPresence, completion: @escaping MessageCompletion) {
        let method = "UserPresence:".appending(status.rawValue)

        let request = [
            "msg": "method",
            "method": method,
            "params": []
        ] as [String: Any]

        SocketManager.send(request) { (response) in
            completion(response)
        }
    }

}
