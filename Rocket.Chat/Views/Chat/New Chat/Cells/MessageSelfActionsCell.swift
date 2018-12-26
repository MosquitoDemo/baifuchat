//
//  MessageSelfActionsCell.swift
//  Rocket.Chat
//
//  Created by Elen on 26/12/2018.
//  Copyright © 2018 Rocket.Chat. All rights reserved.
//

import UIKit
import RocketChatViewController

class MessageSelfActionsCell: BaseMessageCell,SizingCell {

    static let identifier = String(describing: MessageSelfActionsCell.self)
    
    static let sizingCell: UICollectionViewCell & ChatCell = {
        guard let cell = MessageActionsCell.instantiateFromNib() else {
            return MessageActionsCell()
        }
        
        return cell
    }()
    
    @IBOutlet weak var replyButton: UIButton! {
        didSet {
            let image = UIImage(named: "back")?.imageWithTint(.white, alpha: 0.0)
            replyButton.setImage(image, for: .normal)
            replyButton.layer.cornerRadius = 4
            replyButton.setTitle(localized("chat.message.actions.reply"), for: .normal)
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        insertGesturesIfNeeded(with: nil)
    }
    
    override func configure(completeRendering: Bool) {}
    
    @IBAction func replyButtonTapped(_ sender: UIButton) {
        guard
            let viewModel = viewModel?.base as? MessageActionsSelfChatItem,
            let message = viewModel.message
            else {
                return
        }
        
        delegate?.openReplyMessage(message: message)
    }
    
}

extension MessageSelfActionsCell {
    override func applyTheme() {
        super.applyTheme()
        replyButton.setTitleColor(.white, for: .normal)
        replyButton.backgroundColor = theme?.actionTintColor
    }
}

