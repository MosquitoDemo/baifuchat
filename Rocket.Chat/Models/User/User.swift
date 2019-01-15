//
//  User.swift
//  Rocket.Chat
//
//  Created by Rafael K. Streit on 7/7/16.
//  Copyright © 2016 Rocket.Chat. All rights reserved.
//

import Foundation
import RealmSwift
import SwiftyJSON

enum UserPresence: String {
    case online, away
}

enum UserStatus: String, CustomStringConvertible {
    case offline, online, busy, away

    var description: String {
        switch self {
        case .online: return localized("status.online")
        case .offline: return localized("status.offline")
        case .busy: return localized("status.busy")
        case .away: return localized("status.away")
        }
    }
}

final class User: BaseModel {
   
    @objc dynamic var birthdate:String?
    @objc dynamic var gender:String?
    @objc dynamic var username: String?
    @objc dynamic var name: String?
    @objc dynamic var parentUsername:String?
    @objc dynamic var superiorUsername:String?
    var visibleUsernames = List<String>()
    var inferiorUsernames = List<String>()
    var kefuUsernames = List<String>()
    var emails = List<Email>()
    var roles = List<String>()

    @objc dynamic var privateStatus = UserStatus.offline.rawValue
    var status: UserStatus {
        get { return UserStatus(rawValue: privateStatus) ?? UserStatus.offline }
        set { privateStatus = newValue.rawValue }
    }

    @objc dynamic var utcOffset: Double = 0.0
}

extension User {
    static func == (lhs: User, rhs: User) -> Bool {
        return lhs.identifier == rhs.identifier
    }
}

extension User: UnmanagedConvertible {
    typealias UnmanagedType = UnmanagedUser
    var unmanaged: UnmanagedUser? {
        return UnmanagedUser(self)
    }
}

// MARK: Display Name

extension User {

    func displayName() -> String {
        guard !isInvalidated else {
            return ""
        }

        let username = self.username ?? ""

        guard let settings = AuthSettingsManager.settings else {
            return username
        }

        if let name = self.name {
            if settings.useUserRealName && !name.isEmpty {
                return name
            }
        }

        return username
    }

}

// MARK: Avatar URL

extension User {

    func avatarURL(_ auth: Auth? = nil) -> URL? {
        guard
            !isInvalidated,
            let username = username,
            let auth = auth ?? AuthManager.isAuthenticated()
        else {
            return nil
        }

        return User.avatarURL(forUsername: username, auth: auth)
    }

    static func avatarURL(forUsername username: String, auth: Auth? = nil) -> URL? {
        guard
            let auth = auth ?? AuthManager.isAuthenticated(),
            let baseURL = auth.baseURL(),
            let encodedUsername = username.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed)
        else {
            return nil
        }

        return URL(string: "\(baseURL)/avatar/\(encodedUsername)?format=jpeg")
    }

}
