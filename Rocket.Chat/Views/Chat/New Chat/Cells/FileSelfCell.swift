//
//  FileSelfCell.swift
//  Rocket.Chat
//
//  Created by Elen on 27/12/2018.
//  Copyright © 2018 Rocket.Chat. All rights reserved.
//

import UIKit
import RocketChatViewController

final class FileSelfCell: BaseMessageCell, SizingCell {
    static let identifier = String(describing: FileSelfCell.self)
    
    static let sizingCell: UICollectionViewCell & ChatCell = {
        guard let cell = FileSelfCell.instantiateFromNib() else {
            return FileSelfCell()
        }
        
        return cell
    }()
    
    @IBOutlet weak var labelDescriptionTopConstraint: NSLayoutConstraint!
    @IBOutlet weak var labelDescription: UILabel!
    @IBOutlet weak var fileButton: UIButton! {
        didSet {
            fileButton.titleLabel?.adjustsFontSizeToFitWidth = true
            fileButton.titleLabel?.minimumScaleFactor = 0.8
            fileButton.titleLabel?.numberOfLines = 2
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        insertGesturesIfNeeded(with: nil)
    }
    
    override func configure(completeRendering: Bool) {
        guard let viewModel = viewModel?.base as? FileMessageSelfChatItem else {
            return
        }
        
        if let description = viewModel.attachment.descriptionText, !description.isEmpty {
            labelDescription.text = description
            labelDescriptionTopConstraint.constant = 10
        } else {
            labelDescription.text = ""
            labelDescriptionTopConstraint.constant = 0
        }
        
        fileButton.setTitle(viewModel.attachment.title, for: .normal)
    }
    
    @IBAction func didTapFileButton() {
        guard let viewModel = viewModel?.base as? FileMessageSelfChatItem else {
            return
        }
        
        delegate?.openFileFromCell(attachment: viewModel.attachment)
    }
}

extension FileSelfCell {
    override func applyTheme() {
        super.applyTheme()
        
        let theme = self.theme ?? .light
        labelDescription.textColor = theme.controlText
        fileButton.backgroundColor = theme.chatComponentBackground
        fileButton.setTitleColor(theme.titleText, for: .normal)
    }
}

