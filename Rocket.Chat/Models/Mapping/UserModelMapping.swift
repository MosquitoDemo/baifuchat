//
//  UserModelMapping.swift
//  Rocket.Chat
//
//  Created by Rafael Kellermann Streit on 13/01/17.
//  Copyright © 2017 Rocket.Chat. All rights reserved.
//

import Foundation
import SwiftyJSON
import RealmSwift

extension User: ModelMappeable {
    func map(_ values: JSON, realm: Realm? = Realm.current) {
        if self.identifier == nil {
            self.identifier = values["_id"].string
        }

        if let username = values["username"].string {
            self.username = username
        }

        if let name = values["name"].string {
            self.name = name
        }

        if let status = values["status"].string {
            self.status = UserStatus(rawValue: status) ?? .offline
        }

        if let utcOffset = values["utcOffset"].double {
            self.utcOffset = utcOffset
        }

        if let emailsRaw = values["emails"].array {
            let emails = emailsRaw.compactMap { emailRaw -> Email? in
        
                let email = Email(value: [
                    "email": emailRaw["address"].stringValue,
                    "verified": emailRaw["verified"].boolValue
                ])

                guard !email.email.isEmpty else { return nil }

                return email
            }

            
           
            self.emails.removeAll()
            self.emails.append(objectsIn: emails)
        }

        if let rolesRaw = values["roles"].array {
            let roles = rolesRaw.compactMap({ $0.string })

            
            self.roles.removeAll()
            self.roles.append(objectsIn: roles)
        }
        /*
        @objc dynamic var superiorUsername:String?
        visibleUsernames
        var inferiorUsernames = List<String>()
        var kefuUsernames = List<String>()
 */
        if let visibleUsernamesRaw = values["visibleUsernames"].array{
            let visibleUsernames = visibleUsernamesRaw.compactMap({ $0.string })
            self.visibleUsernames.removeAll()
            self.visibleUsernames.append(objectsIn: visibleUsernames)
        }
        if let inferiorUsernamesRaw = values["inferiorUsernames"].array {
            let inferiorUsernames = inferiorUsernamesRaw.compactMap({ $0.string })
            
            
            self.inferiorUsernames.removeAll()
            self.inferiorUsernames.append(objectsIn: inferiorUsernames)
        }
        if let kefuUsernamesRaw = values["kefuUsernames"].array {
            let kefuUsernames = kefuUsernamesRaw.compactMap({ $0.string })
            
            
            self.kefuUsernames.removeAll()
            self.kefuUsernames.append(objectsIn: kefuUsernames)
        }
        if let superiorUsernameRaw = values["superiorUsername"].string {
            self.superiorUsername = superiorUsernameRaw
        }
        
        if let birthdate = values["customFields"]["birthdate"].string{
            self.birthdate = birthdate
        }
        if let gender = values["customFields"]["gender"].string{
            self.gender = gender
        }
            realm?.add(self, update: true)
    }

}
