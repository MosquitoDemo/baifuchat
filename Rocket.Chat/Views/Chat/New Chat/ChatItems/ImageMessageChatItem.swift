//
//  ImageMessageChatItem.swift
//  Rocket.Chat
//
//  Created by Rafael Streit on 01/10/18.
//  Copyright © 2018 Rocket.Chat. All rights reserved.
//

import Foundation
import DifferenceKit
import RocketChatViewController



/// ImageMessageChatItem 别人发送图片消息
final class ImageMessageChatItem: BaseMessageChatItem, ChatItem, Differentiable {
    var relatedReuseIdentifier: String {
        return hasText ? ImageCell.identifier : ImageMessageCell.identifier
    }

    var identifier: String
    var title: String?
    var descriptionText: String?
    var imageURL: URL?
    let hasText: Bool

    init(
        identifier: String,
        title: String?,
        descriptionText: String?,
        imageURL: URL?,
        hasText: Bool,
        user: UnmanagedUser?,
        message: UnmanagedMessage?
        ) {

        self.identifier = identifier
        self.title = title
        self.descriptionText = descriptionText
        self.imageURL = imageURL
        self.hasText = hasText

        super.init(
            user: user,
            message: message
        )
    }

    var differenceIdentifier: String {
        return identifier
    }

    func isContentEqual(to source: ImageMessageChatItem) -> Bool {
        return
            identifier == source.identifier &&
            imageURL == source.imageURL &&
            title == source.title &&
            descriptionText == source.descriptionText
    }
}



/// ImageMessageSelfChatItem 自己发送的信息
final class ImageMessageSelfChatItem: BaseMessageChatItem, ChatItem, Differentiable {
    var relatedReuseIdentifier: String {
        return hasText ? ImageSelfCell.identifier : ImageMessageSelfCell.identifier
    }
    
    var identifier: String
    var title: String?
    var descriptionText: String?
    var imageURL: URL?
    let hasText: Bool
    
    init(
        identifier: String,
        title: String?,
        descriptionText: String?,
        imageURL: URL?,
        hasText: Bool,
        user: UnmanagedUser?,
        message: UnmanagedMessage?
        ) {
        
        self.identifier = identifier
        self.title = title
        self.descriptionText = descriptionText
        self.imageURL = imageURL
        self.hasText = hasText
        
        super.init(
            user: user,
            message: message
        )
    }
    
    var differenceIdentifier: String {
        return identifier
    }
    
    func isContentEqual(to source: ImageMessageSelfChatItem) -> Bool {
        return
            identifier == source.identifier &&
                imageURL == source.imageURL &&
                title == source.title &&
                descriptionText == source.descriptionText
    }
}
