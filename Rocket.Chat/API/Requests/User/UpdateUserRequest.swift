//
//  UpdateUserRequest.swift
//  Rocket.Chat
//
//  Created by Filipe Alvarenga on 27/02/18.
//  Copyright © 2018 Rocket.Chat. All rights reserved.
//

import Foundation
import SwiftyJSON
final class UpdateUserBasicInfoRequest: APIRequest {
    typealias APIResourceType = UpdateUserBasicInfoResource
    
    let requiredVersion = Version(0, 62, 2)
    let method: HTTPMethod = .post
    let path = "/api/v1/users.updateOwnBasicInfo"
    
    let user: User?
    let username: String?
    let currentPassword: String?
    let password: String?
    let customFields:[String:Any]?
    
    init(user: User? = nil, password: String? = nil, currentPassword: String? = nil,customFields:[String:Any]? = nil) {
        self.user = user
        self.password = password
        self.currentPassword = currentPassword
        self.username = nil
        self.customFields = customFields
    }
    
    init(username: String) {
        self.username = username
        self.user = nil
        self.currentPassword = nil
        self.password = nil
        self.customFields = nil
    }
    
    func body() -> Data? {
        var body = JSON(["data":[:],"customFields":[:]])
        
        if let user = user {
//            if let userId = user.identifier{
//                body["userId"].string = userId
//            }
            if let name = user.name, !name.isEmpty {
                body["data"]["name"].string = user.name
            }
            
//            if let username = user.username, !username.isEmpty {
//                body["data"]["username"].string = user.username
//            }
            
            if let email = user.emails.first?.email, !email.isEmpty {
                body["data"]["email"].string = email
            }
        }
        
        if let password = password, !password.isEmpty {
            body["data"]["newPassword"].string = password
        }
        
        if let currentPassword = currentPassword {
            body["data"]["currentPassword"].string = currentPassword.sha256()
        }
        
        
        if let currentPassword = currentPassword {
            body["data"]["password"].string = currentPassword.sha256()
        }
//        if let username = username {
//            body["data"] = ["username": username]
//        }
        if let birthdate = user?.birthdate{
            body["customFields"]["birthdate"].string = birthdate
            
            
        }
        if let gender = user?.gender{
            body["customFields"]["gender"].string = gender

        }
        
        let string = body.rawString()
        let data = string?.data(using: .utf8)
        
        return data
    }
    
    var contentType: String? {
        return "application/json"
    }
}

final class UpdateUserBasicInfoResource: APIResource {
    var user: User? {
        guard let rawUser = raw?["user"] else { return nil }
        
        let user = User()
        user.map(rawUser, realm: nil)
        return user
    }
    
    var success: Bool {
        return raw?["success"].boolValue ?? false
    }
    
    var errorMessage: String? {
        return raw?["error"].string
    }
}
final class UpdateUserRequest: APIRequest {
    typealias APIResourceType = UpdateUserResource

    let requiredVersion = Version(0, 48, 0)
    let method: HTTPMethod = .post
    let path = "/api/v1/users.update"

    let user: User?
    let username: String?
    let currentPassword: String?
    let password: String?
    let customFields:[String:Any]?

    init(user: User? = nil, password: String? = nil, currentPassword: String? = nil,customFields:[String:Any]? = nil) {
        self.user = user
        self.password = password
        self.currentPassword = currentPassword
        self.username = nil
        self.customFields = customFields
    }

    init(username: String) {
        self.username = username
        self.user = nil
        self.currentPassword = nil
        self.password = nil
        self.customFields = nil
    }

    func body() -> Data? {
        var body = JSON(["data":[:],"userId":""])

        if let user = user {
            if let userId = user.identifier{
                body["userId"].string = userId
            }
            if let name = user.name, !name.isEmpty {
                body["data"]["name"].string = user.name
            }

            if let username = user.username, !username.isEmpty {
                body["data"]["username"].string = user.username
            }

            if let email = user.emails.first?.email, !email.isEmpty {
                body["data"]["email"].string = email
            }
        }

        if let password = password, !password.isEmpty {
            body["data"]["newPassword"].string = password
        }

        if let currentPassword = currentPassword {
            body["data"]["currentPassword"].string = currentPassword.sha256()
        }
        

        if let currentPassword = currentPassword {
            body["data"]["password"].string = currentPassword.sha256()
        }
        if let username = username {
            body["data"] = ["username": username]
        }
        var customFields = [String:Any]()
        if let birthdate = user?.birthdate{
            customFields["birthdate"] = birthdate

            
        }
        if let gender = user?.gender{
            customFields["gender"] = gender

        }
        body["data"]["customFields"].dictionaryObject = customFields

        let string = body.rawString()
        let data = string?.data(using: .utf8)

        return data
    }

    var contentType: String? {
        return "application/json"
    }
}

final class UpdateUserResource: APIResource {
    var user: User? {
        guard let rawUser = raw?["user"] else { return nil }

        let user = User()
        user.map(rawUser, realm: nil)
        return user
    }

    var success: Bool {
        return raw?["success"].boolValue ?? false
    }

    var errorMessage: String? {
        return raw?["error"].string
    }
}
