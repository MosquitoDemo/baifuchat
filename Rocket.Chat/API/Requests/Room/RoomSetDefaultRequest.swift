//
//  RoomSetDefaultRequest.swift
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
            return Version(0,66,0)
            
        case .group:
            return Version(0,60,0)
        default:
            return Version(0,48,0)
            
        }
    }
    var path: String {
        switch self {
        case .channel:
            return "/api/v1/channels.setDefault"
        case .group:
            return "/api/v1/groups.setDefault"
        case .directMessage:
            return "/api/v1/im.setDefault"
        }
    }
}

final class RoomSetDefaultRequest: APIRequest {
    typealias APIResourceType = RoomSetDefaultResource
    var requiredVersion:Version{
        return roomType.version
    }
    
    let method: HTTPMethod = .post
    var path: String {
        return roomType.path
    }
    
    let roomId: String
    let roomType: RoomType
    let `default`:Bool
    
    init(roomId: String, roomType: RoomType,`default`:Bool) {
        self.roomId = roomId
        self.roomType = roomType
        self.default = `default`
    }
    
    func body() -> Data? {
        let body = JSON([
            "roomId": roomId,
            "default":self.default
            ])
        
        return body.rawString()?.data(using: .utf8)
    }
}

final class RoomSetDefaultResource: APIResource, ResourceSharedProperties { }
