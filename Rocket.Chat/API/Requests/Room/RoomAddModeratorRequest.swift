//
//  RoomAddModerator.swift
//  Rocket.Chat
//
//  Created by Elen on 07/01/2019.
//  Copyright © 2019 Rocket.Chat. All rights reserved.
//

import Foundation
import SwiftyJSON
fileprivate extension RoomType {
    var path: String {
        switch self {
        case .channel:
            return "/api/v1/channels.addModerator"
        case .group:
            return "/api/v1/groups.addModerator"
        case .directMessage:
            return ""
        }
    }
}

final class RoomAddModeratorRequest: APIRequest {
    typealias APIResourceType = RoomAddModeratorResource
    let requiredVersion = Version(0, 48, 0)
    
    let method: HTTPMethod = .post
    var path: String {
        return roomType.path
    }
    
    let roomId: String
    let roomType: RoomType
    let userId: String
    
    init(roomId: String, roomType: RoomType, userId: String) {
        self.roomId = roomId
        self.roomType = roomType
        self.userId = userId
    }
    
    func body() -> Data? {
        let body = JSON([
            "roomId": roomId,
            "userId": userId
            ])
        
        return body.rawString()?.data(using: .utf8)
    }
}

final class RoomAddModeratorResource: APIResource, ResourceSharedProperties { }
