//
//  MessageURLSelfCell.swift
//  Rocket.Chat
//
//  Created by Elen on 27/12/2018.
//  Copyright © 2018 Rocket.Chat. All rights reserved.
//

import UIKit
import RocketChatViewController

final class MessageURLSelfCell: BaseMessageCell, SizingCell {
    static let identifier = String(describing: MessageURLSelfCell.self)
    
    static let sizingCell: UICollectionViewCell & ChatCell = {
        guard let cell = MessageURLSelfCell.instantiateFromNib() else {
            return MessageURLSelfCell()
        }
        
        return cell
    }()
    @IBOutlet weak var containerView: UIView! {
        didSet {
            containerView.layer.borderWidth = 1
            containerView.layer.cornerRadius = 4
        }
    }
    @IBOutlet weak var title: UILabel!
    @IBOutlet weak var subTitle: UILabel!
    @IBOutlet weak var thumbnail: UIImageView!
    @IBOutlet weak var activityIndicatorView: UIActivityIndicatorView!
    @IBOutlet weak var hostLabel: UILabel!
    @IBOutlet weak var thumbnailHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var containerWidthConstraint: NSLayoutConstraint!
    @IBOutlet weak var containerLeadingConstraint: NSLayoutConstraint!
    @IBOutlet weak var containerTrailingConstraint: NSLayoutConstraint!
    var containerWidth: CGFloat {
        return
            messageWidth -
                containerLeadingConstraint.constant -
                containerTrailingConstraint.constant -
                layoutMargins.left -
                layoutMargins.right
    }
    
    var thumbnailHeightInitialConstant: CGFloat = 0
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        thumbnailHeightInitialConstant = thumbnailHeightConstraint.constant
        
        let gesture = UITapGestureRecognizer(target: self, action: #selector(didTapContainerView))
        gesture.delegate = self
        containerView.addGestureRecognizer(gesture)
        
        insertGesturesIfNeeded(with: nil)
    }
    
    override func configure(completeRendering: Bool) {
        guard let viewModel = viewModel?.base as? MessageURLSelfChatItem else {
            return
        }
        
        containerWidthConstraint.constant = containerWidth
        
        if let image = viewModel.imageURL, let imageURL = URL(string: image) {
            thumbnailHeightConstraint.constant = thumbnailHeightInitialConstant
            
            if completeRendering {
                activityIndicatorView.startAnimating()
                ImageManager.loadImage(with: imageURL, into: thumbnail) { [weak self] _, _ in
                    self?.activityIndicatorView.stopAnimating()
                }
            }
        } else {
            thumbnailHeightConstraint.constant = 0
        }
        
        hostLabel.text = URL(string: viewModel.url)?.host
        title.text = viewModel.title
        subTitle.text = viewModel.subtitle
    }
    
    @objc func didTapContainerView() {
        guard
            let viewModel = viewModel,
            let messageURLChatItem = viewModel.base as? MessageURLSelfChatItem
            else {
                return
        }
        
        delegate?.openURLFromCell(url: messageURLChatItem.url)
    }
}

extension MessageURLSelfCell {
    override func applyTheme() {
        super.applyTheme()
        
        let theme = self.theme ?? .light
        containerView.backgroundColor = theme.chatComponentBackground
        hostLabel.textColor = theme.auxiliaryText
        title.textColor = theme.actionTintColor
        subTitle.textColor = theme.controlText
        containerView.layer.borderColor = theme.borderColor.cgColor
    }
}
