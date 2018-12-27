//
//  VideoSelfCell.swift
//  Rocket.Chat
//
//  Created by Elen on 27/12/2018.
//  Copyright © 2018 Rocket.Chat. All rights reserved.
//

import UIKit
import AVFoundation
import RocketChatViewController

final class VideoSelfCell: BaseVideoMessageCell, SizingCell {
    static let identifier = String(describing: VideoSelfCell.self)
    
    static let sizingCell: UICollectionViewCell & ChatCell = {
        guard let cell = VideoSelfCell.instantiateFromNib() else {
            return VideoSelfCell()
        }
        
        return cell
    }()
    
    override var loading: Bool {
        didSet {
            updateLoadingState(with: buttonPlayer, and: activityIndicatorView)
        }
    }
    
    @IBOutlet weak var labelDescriptionTopConstraint: NSLayoutConstraint!
    @IBOutlet weak var activityIndicatorView: UIActivityIndicatorView!
    @IBOutlet weak var imageViewThumb: UIImageView! {
        didSet {
            imageViewThumb.layer.borderWidth = 1
            imageViewThumb.layer.cornerRadius = 4
            imageViewThumb.clipsToBounds = true
        }
    }
    
    @IBOutlet weak var buttonPlayer: UIButton!
    @IBOutlet weak var labelDescription: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        setupWidthConstraint()
        insertGesturesIfNeeded(with: nil)
    }
    
    override func configure(completeRendering: Bool) {
        guard let viewModel = viewModel?.base as? VideoMessageSelfChatItem else {
            return
        }
        
        widthConstriant.constant = messageWidth
        
        if let description = viewModel.descriptionText, !description.isEmpty {
            labelDescription.text = description
            labelDescriptionTopConstraint.constant = 10
        } else {
            labelDescription.text = ""
            labelDescriptionTopConstraint.constant = 0
        }
        
        if completeRendering {
            updateVideo(with: imageViewThumb)
        }
    }
    
    @IBAction func buttonPlayDidPressed(_ sender: Any) {
        guard let viewModel = viewModel?.base as? VideoMessageSelfChatItem else {
            return
        }
        
        delegate?.openVideoFromCell(attachment: viewModel.attachment)
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        imageViewThumb.image = nil
        loading = false
    }
}

extension VideoSelfCell {
    override func applyTheme() {
        super.applyTheme()
        
        let theme = self.theme ?? .light
        labelDescription.textColor = theme.controlText
        imageViewThumb.layer.borderColor = theme.borderColor.cgColor
    }
}

