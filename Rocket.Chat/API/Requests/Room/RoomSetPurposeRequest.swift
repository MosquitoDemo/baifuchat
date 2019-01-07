//
//  RoomSetPurposeRequest.swift
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
            return Version(0,48,0)
            
        case .group:
            return Version(0,48,0)
        default:
            return Version(0,48,0)
            
        }
    }
    var path: String {
        switch self {
        case .channel:
            return "/api/v1/channels.setPurpose"
        case .group:
            return "/api/v1/groups.setPurpose"
        case .directMessage:
            return "/api/v1/im.setPurpose"
        }
    }
}

final class RoomSetPurposeRequest: APIRequest {
    typealias APIResourceType = RoomSetPurposeResource
    var requiredVersion:Version{
        return roomType.version
    }
    
    let method: HTTPMethod = .post
    var path: String {
        return roomType.path
    }
    
    let roomId: String
    let roomType: RoomType
    let purpose:String
    
    init(roomId: String, roomType: RoomType,purpose:String) {
        self.roomId = roomId
        self.roomType = roomType
        self.purpose = purpose
    }
    
    func body() -> Data? {
        let body = JSON([
            "roomId": roomId,
            "purpose":purpose
            ])
        
        return body.rawString()?.data(using: .utf8)
    }
}

final class RoomSetPurposeResource: APIResource, ResourceSharedProperties { }
