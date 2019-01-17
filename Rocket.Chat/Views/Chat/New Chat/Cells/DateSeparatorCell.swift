//
//  DateSeparatorCell.swift
//  Rocket.Chat
//
//  Created by Rafael Streit on 26/09/18.
//  Copyright © 2018 Rocket.Chat. All rights reserved.
//

import UIKit
import RocketChatViewController

final class DateSeparatorCell: UICollectionViewCell, ChatCell, SizingCell {
    static let identifier = String(describing: DateSeparatorCell.self)

    static let sizingCell: UICollectionViewCell & ChatCell = {
        guard let cell = DateSeparatorCell.instantiateFromNib() else {
            return DateSeparatorCell()
        }

        return cell
    }()

    @IBOutlet weak var leftLine: UIView!

    @IBOutlet weak var labelWidthConstraint: NSLayoutConstraint!
    @IBOutlet weak var labelHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var date: UILabel! {
        didSet {
            date.font = date.font.bold()
            
            date.backgroundColor = UIColor.lightGray
            date.textColor = UIColor.white
            date.layer.cornerRadius = 13
            date.layer.masksToBounds = true
        }
    }

    @IBOutlet weak var rightLine: UIView!

    var messageWidth: CGFloat = 0
    var viewModel: AnyChatItem?

    func configure(completeRendering: Bool) {
        guard
            completeRendering,
            let viewModel = viewModel?.base as? DateSeparatorChatItem
        else {
            return
        }

        date.text = viewModel.dateFormatted
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        self.leftLine.isHidden = true
        self.rightLine.isHidden = true
        date.text = ""
    }
    override func prepareForReuse() {
        super.prepareForReuse()
    }
}

// MARK: Theming

extension DateSeparatorCell {

    override func applyTheme() {
//        super.applyTheme()
//
//        let theme = self.theme ?? .light
//        date.textColor = theme.auxiliaryText
//        leftLine.backgroundColor = theme.borderColor
//        rightLine.backgroundColor = theme.borderColor
    }

}
