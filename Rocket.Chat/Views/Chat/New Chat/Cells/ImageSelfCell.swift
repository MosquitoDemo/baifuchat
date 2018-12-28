//
//  ImageSelfCell.swift
//  Rocket.Chat
//
//  Created by Elen on 27/12/2018.
//  Copyright © 2018 Rocket.Chat. All rights reserved.
//

import UIKit
import RocketChatViewController
import FLAnimatedImage

final class ImageSelfCell: BaseImageMessageCell, SizingCell {
    static let identifier = String(describing: ImageSelfCell.self)
    
    static let sizingCell: UICollectionViewCell & ChatCell = {
        guard let cell = ImageSelfCell.instantiateFromNib() else {
            return ImageSelfCell()
        }
        
        return cell
    }()
    
    @IBOutlet weak var labelDescriptionTopConstraint: NSLayoutConstraint!
    @IBOutlet weak var activityIndicatorView: UIActivityIndicatorView!
   
    @IBOutlet weak var imageView: FLAnimatedImageView! {
        didSet {
            imageView.layer.cornerRadius = 4
            imageView.layer.borderWidth = 1
            imageView.clipsToBounds = true
        }
    }
    
    @IBOutlet weak var labelTitle: UILabel!
    @IBOutlet weak var labelDescription: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        setupWidthConstraint()
        insertGesturesIfNeeded(with: nil)
    }
    
    override func configure(completeRendering: Bool) {
        guard let viewModel = viewModel?.base as? ImageMessageSelfChatItem else {
            return
        }
        
        widthConstriant.constant = messageWidth
        
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
    @IBAction func buttonImageHandlerDidTapped(_ sender: UIButton) {
        guard
            let viewModel = viewModel?.base as? ImageMessageSelfChatItem,
            let imageURL = viewModel.imageURL
            else {
                return
        }
        
        delegate?.openImageFromCell(url: imageURL, thumbnail: imageView)
    }
    
  
    override func handleLongPressMessageCell(recognizer: UIGestureRecognizer) {
        guard
            let viewModel = viewModel?.base as? BaseMessageChatItem,
            let managedObject = viewModel.message?.managedObject?.validated()
            else {
                return
        }
        
        delegate?.handleLongPressMessageCell(managedObject, view: contentView, recognizer: recognizer)
    }
}

extension ImageSelfCell {
    override func applyTheme() {
        super.applyTheme()
        
        let theme = self.theme ?? .light
        labelTitle.textColor = theme.bodyText
        labelDescription.textColor = theme.bodyText
        imageView.layer.borderColor = theme.borderColor.cgColor
    }
}

