//
//  MessageURLChatItem.swift
//  Rocket.Chat
//
//  Created by Filipe Alvarenga on 04/10/18.
//  Copyright © 2018 Rocket.Chat. All rights reserved.
//

import Foundation
import DifferenceKit
import RocketChatViewController



/// MessageURLChatItem
final class MessageURLChatItem: BaseMessageChatItem, ChatItem, Differentiable {
    var relatedReuseIdentifier: String {
        return MessageURLCell.identifier
    }

    var url: String
    var imageURL: String?
    var title: String
    var subtitle: String

    init(url: String, imageURL: String?, title: String, subtitle: String, message: UnmanagedMessage?) {
        self.url = url
        self.imageURL = imageURL
        self.title = title
        self.subtitle = subtitle

        super.init(user: nil, message: message)
    }

    var differenceIdentifier: String {
        return url
    }

    func isContentEqual(to source: MessageURLChatItem) -> Bool {
        return title == source.title &&
            subtitle == source.subtitle &&
            imageURL == source.imageURL
    }
}



/// MessageURLSelfChatItem
final class MessageURLSelfChatItem: BaseMessageChatItem, ChatItem, Differentiable {
    var relatedReuseIdentifier: String {
        return MessageURLSelfCell.identifier
    }
    
    var url: String
    var imageURL: String?
    var title: String
    var subtitle: String
    
    init(url: String, imageURL: String?, title: String, subtitle: String, message: UnmanagedMessage?) {
        self.url = url
        self.imageURL = imageURL
        self.title = title
        self.subtitle = subtitle
        
        super.init(user: nil, message: message)
    }
    
    var differenceIdentifier: String {
        return url
    }
    
    
    
    func isContentEqual(to source: MessageURLSelfChatItem) -> Bool {
        return title == source.title &&
            subtitle == source.subtitle &&
            imageURL == source.imageURL
    }
}
