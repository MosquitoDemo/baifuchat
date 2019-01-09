//
//  ChannelInfoAnnouncementCell.swift
//  Rocket.Chat
//
//  Created by Elen on 08/01/2019.
//  Copyright © 2019 Rocket.Chat. All rights reserved.
//

import UIKit
struct ChannelInfoAnnouncementCellData: ChannelInfoCellDataProtocol {
    let cellType = ChannelInfoAnnouncementCell.self
    
    var title: String?
    var announcement: String?
}

final class ChannelInfoAnnouncementCell: UITableViewCell, ChannelInfoCellProtocol {
    typealias DataType = ChannelInfoAnnouncementCellData
    
    static let identifier = String(describing: ChannelInfoAnnouncementCell.self)
    static let defaultHeight: CGFloat = UITableView.automaticDimension
    
  
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var detailLabel: UILabel!
    
    var data: DataType? {
        didSet {
            titleLabel.text = data?.title
            if let announcement = data?.announcement,announcement != ""{
                let attributedString =
                    NSAttributedString(string: announcement, attributes: [NSAttributedString.Key.foregroundColor:UIColor(hex: "#333333")])
                detailLabel.textColor = UIColor(hex: "#333333")
                detailLabel.attributedText = MarkdownManager.shared.transformAttributedString(attributedString)
            }else{
                
                let attributedString = NSAttributedString(string: localized("chat.info.item.add_announcement"), attributes: [NSAttributedString.Key.foregroundColor:UIColor(hex: "#a9afb5")])
                detailLabel.textColor = UIColor(hex: "#a9afb5")
                detailLabel.attributedText = MarkdownManager.shared.transformAttributedString(attributedString)
            }
            
        }
    }
}

// MARK: Themeable

extension ChannelInfoAnnouncementCell {
    override func applyTheme() {
        super.applyTheme()
        guard let theme = theme else { return }
        
        titleLabel.textColor = theme.bodyText
        detailLabel.textColor = theme.auxiliaryText
    }
}
