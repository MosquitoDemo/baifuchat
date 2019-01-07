//
//  RoomSetAnnouncementRequest.swift
//  Rocket.Chat
//
//  Created by Elen on 07/01/2019.
//  Copyright © 2019 Rocket.Chat. All rights reserved.
//

import Foundation
import SwiftyJSON
fileprivate extension RoomType {
    var version:Version {
        switch self {
        case .channel:
            return Version(0,63,0)

        case .group:
            return Version(0,70,0)
        default:
            return Version(0,63,0)

        }
    }
    var path: String {
        switch self {
        case .channel:
            return "/api/v1/channels.setAnnouncement"
        case .group:
            return "/api/v1/groups.setAnnouncement"
        case .directMessage:
            return "/api/v1/im.setAnnouncement"
        }
    }
}

final class RoomSetAnnouncementRequest: APIRequest {
    typealias APIResourceType = RoomSetAnnouncementResource
    var requiredVersion:Version{
        return roomType.version
    }
    
    let method: HTTPMethod = .post
    var path: String {
        return roomType.path
    }
    
    let roomId: String
    let roomType: RoomType
    let announcement:String
    
    init(roomId: String, roomType: RoomType,announcement:String) {
        self.roomId = roomId
        self.roomType = roomType
        self.announcement = announcement
    }
    
    func body() -> Data? {
        let body = JSON([
            "roomId": roomId,
            "announcement":announcement
            ])
        
        return body.rawString()?.data(using: .utf8)
    }
}

final class RoomSetAnnouncementResource: APIResource, ResourceSharedProperties { }
