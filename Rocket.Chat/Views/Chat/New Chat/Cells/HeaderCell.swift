//
//  HeaderCell.swift
//  Rocket.Chat
//
//  Created by Rafael Streit on 19/11/18.
//  Copyright © 2018 Rocket.Chat. All rights reserved.
//

import UIKit
import RocketChatViewController

final class HeaderCell: UICollectionViewCell, ChatCell, SizingCell {
    static let identifier = String(describing: HeaderCell.self)

    static let sizingCell: UICollectionViewCell & ChatCell = {
        guard let cell = HeaderCell.instantiateFromNib() else {
            return HeaderCell()
        }

        return cell
    }()

    static func size(for viewModel: AnyChatItem, with cellWidth: CGFloat) -> CGSize{
        return CGSize(width: UIScreen.main.bounds.size.width, height: 50)
    }
    lazy var avatarView: AvatarView = {
        let avatarView = AvatarView()

        avatarView.layer.cornerRadius = 4
        avatarView.layer.masksToBounds = true

        return avatarView
    }()

    @IBOutlet weak var labelHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var labelWidthConstraint: NSLayoutConstraint!
    /*
    @IBOutlet weak var avatarContainerView: UIView! {
        didSet {
            avatarContainerView.layer.cornerRadius = 4
            avatarView.frame = avatarContainerView.bounds
            avatarContainerView.addSubview(avatarView)
        }
    }

    @IBOutlet weak var labelName: UILabel!
 */
    @IBOutlet weak var labelDescription: UILabel!

    var messageWidth: CGFloat = 0
    var viewModel: AnyChatItem?

    func configure(completeRendering: Bool) {
        guard let viewModel = viewModel?.base as? HeaderChatItem else {
            return
        }

//        labelName.text = viewModel.title
        labelDescription.text = viewModel.descriptionText
        labelDescription.backgroundColor = UIColor.init(hex: "#d7d7d7")
        labelDescription.layer.cornerRadius = 5
        labelDescription.layer.masksToBounds = true
        labelDescription.textColor = UIColor.white
//        avatarView.avatarURL = viewModel.avatarURL
    }

}
extension HeaderCell{
    override func applyTheme() {
        
    }
}
