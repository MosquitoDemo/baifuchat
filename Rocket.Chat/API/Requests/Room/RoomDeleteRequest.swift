//
//  RoomDeleteRequest.swift
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
            return "/api/v1/channels.delete"
        case .group:
            return "/api/v1/groups.delete"
        case .directMessage:
            return ""
        }
    }
}

final class RoomDeleteRequest: APIRequest {
    typealias APIResourceType = RoomDeleteResource
    let requiredVersion = Version(0, 48, 0)
    
    let method: HTTPMethod = .post
    var path: String {
        return roomType.path
    }
    
    let roomId: String
    let roomType: RoomType
    let roomName:String
    
    init(roomId: String = "", roomType: RoomType,roomName:String = "") {
        self.roomId = roomId
        self.roomType = roomType
        self.roomName = roomName
    }
    
    func body() -> Data? {
        let body = JSON([
            "roomId": roomId,
            "roomName":roomName,
            ])
        
        return body.rawString()?.data(using: .utf8)
    }
}

final class RoomDeleteResource: APIResource, ResourceSharedProperties { }
