//
//  ImageMessageSelfCell.swift
//  Rocket.Chat
//
//  Created by Elen on 27/12/2018.
//  Copyright © 2018 Rocket.Chat. All rights reserved.
//

import UIKit
import RocketChatViewController
import FLAnimatedImage

class ImageMessageSelfCell: BaseImageMessageCell, SizingCell {
    static let identifier = String(describing: ImageMessageSelfCell.self)
    
    static let sizingCell: UICollectionViewCell & ChatCell = {
        guard let cell = ImageMessageSelfCell.instantiateFromNib() else {
            return ImageMessageSelfCell()
        }
        
        return cell
    }()
    
    @IBOutlet weak var labelDescriptionTopConstraint: NSLayoutConstraint!
    @IBOutlet weak var avatarContainerView: UIView! {
        didSet {
            avatarContainerView.layer.cornerRadius = 4
            avatarView.frame = avatarContainerView.bounds
            avatarContainerView.addSubview(avatarView)
        }
    }
    /*
    @IBOutlet weak var username: UILabel!
 */
    @IBOutlet weak var date: UILabel!
    @IBOutlet weak var statusView: UIImageView!
    @IBOutlet weak var activityIndicatorView: UIActivityIndicatorView!
    @IBOutlet weak var imageView: FLAnimatedImageView! {
        didSet {
            imageView.layer.cornerRadius = 4
            imageView.layer.borderWidth = 1
            imageView.clipsToBounds = true
        }
    }
    
    @IBOutlet weak var readReceiptButton: UIButton!
    @IBOutlet weak var labelTitle: UILabel!
    @IBOutlet weak var labelDescription: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        setupWidthConstraint()
//        insertGesturesIfNeeded(with: username)
    }
    
    override func configure(completeRendering: Bool) {
        guard let viewModel = viewModel?.base as? ImageMessageSelfChatItem else {
            return
        }
        
        widthConstriant.constant = messageWidth
        
        configure(readReceipt: readReceiptButton)
        configure(
            with: avatarView,
            date: date,
            status: statusView,
            and: UILabel(),
            completeRendering: completeRendering
        )
        
        labelTitle.text = viewModel.title
        
        if let description = viewModel.descriptionText, !description.isEmpty {
            labelDescription.text = description
            labelDescriptionTopConstraint.constant = 10
        } else {
            labelDescription.text = ""
            labelDescriptionTopConstraint.constant = 0
        }
        
        if completeRendering {
            loadImage(on: imageView, startLoadingBlock: { [weak self] in
                self?.activityIndicatorView.startAnimating()
                }, stopLoadingBlock: { [weak self] in
                    self?.activityIndicatorView.stopAnimating()
            })
        }
    }
    
    // MARK: IBAction
    
    @IBAction func buttonImageHandlerDidPressed(_ sender: Any) {
        guard
            let viewModel = viewModel?.base as? ImageMessageSelfChatItem,
            let imageURL = viewModel.imageURL
            else {
                return
        }
        
        delegate?.openImageFromCell(url: imageURL, thumbnail: imageView)
    }
}

extension ImageMessageSelfCell {
    override func applyTheme() {
        /*
        super.applyTheme()
        
        let theme = self.theme ?? .light
        username.textColor = theme.titleText
        date.textColor = theme.auxiliaryText
        labelTitle.textColor = theme.bodyText
        labelDescription.textColor = theme.bodyText
        imageView.layer.borderColor = theme.borderColor.cgColor
 */
    }
}
