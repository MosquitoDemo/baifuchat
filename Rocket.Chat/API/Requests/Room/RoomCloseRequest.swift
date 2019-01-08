//
//  RoomCloseRequest.swift
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
            return "/api/v1/channels.close"
        case .group:
            return "/api/v1/groups.close"
        case .directMessage:
            return "/api/v1/im.close"
        }
    }
}

final class RoomCloseRequest: APIRequest {
    typealias APIResourceType = RoomCloseResource
    let requiredVersion = Version(0, 48, 0)
    
    let method: HTTPMethod = .post
    var path: String {
        return roomType.path
    }
    
    let roomId: String
    let roomType: RoomType
//    let roomName:String
    
    init(roomId: String, roomType: RoomType) {
        self.roomId = roomId
        self.roomType = roomType
//        self.roomName = roomName
    }
    
    func body() -> Data? {
        let body = JSON([
            "roomId": roomId,
            ])
        
        return body.rawString()?.data(using: .utf8)
    }
}

final class RoomCloseResource: APIResource, ResourceSharedProperties { }