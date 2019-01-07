//
//  RoomSetReadOnlyRequest.swift
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
            return Version(0,49,0)
            
        case .group:
            return Version(0,48,0)
        default:
            return Version(0,48,0)
            
        }
    }
    var path: String {
        switch self {
        case .channel:
            return "/api/v1/channels.setReadOnly"
        case .group:
            return "/api/v1/groups.setReadOnly"
        case .directMessage:
            return "/api/v1/im.setReadOnly"
        }
    }
}

final class RoomSetReadOnlyRequest: APIRequest {
    typealias APIResourceType = RoomSetReadOnlyResource
    var requiredVersion:Version{
        return roomType.version
    }
    
    let method: HTTPMethod = .post
    var path: String {
        return roomType.path
    }
    
    let roomId: String
    let roomType: RoomType
    let readOnly:Bool
    
    init(roomId: String, roomType: RoomType,readOnly:Bool) {
        self.roomId = roomId
        self.roomType = roomType
        self.readOnly = readOnly
    }
    
    func body() -> Data? {
        let body = JSON([
            "roomId": roomId,
            "readOnly":readOnly
            ])
        
        return body.rawString()?.data(using: .utf8)
    }
}

final class RoomSetReadOnlyResource: APIResource, ResourceSharedProperties { }
