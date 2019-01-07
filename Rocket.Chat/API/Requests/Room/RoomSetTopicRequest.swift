//
//  RoomSetTopicRequest.swift
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
            return "/api/v1/channels.setTopic"
        case .group:
            return "/api/v1/groups.setTopic"
        case .directMessage:
            return "/api/v1/im.setTopic"
        }
    }
}

final class RoomSetTopicRequest: APIRequest {
    typealias APIResourceType = RoomSetTopicResource
    let requiredVersion = Version(0, 13, 0)
    
    let method: HTTPMethod = .post
    var path: String {
        return roomType.path
    }
    
    let roomId: String
    let roomType: RoomType
    let topic:String
    
    init(roomId: String, roomType: RoomType,topic:String) {
        self.roomId = roomId
        self.roomType = roomType
        self.topic = topic
    }
    
    func body() -> Data? {
        let body = JSON([
            "roomId": roomId,
            "topic":topic
            ])
        
        return body.rawString()?.data(using: .utf8)
    }
}

final class RoomSetTopicResource: APIResource, ResourceSharedProperties { }
