//
//  MemberCell.swift
//  Rocket.Chat
//
//  Created by Matheus Cardoso on 9/19/17.
//  Copyright © 2017 Rocket.Chat. All rights reserved.
//

import UIKit
extension UIColor{
    var colorImage:UIImage{
        let rect = CGRect(x: 0, y: 0, width: 1, height: 1)
        UIGraphicsBeginImageContext(rect.size)
        let context = UIGraphicsGetCurrentContext()
        context?.setFillColor(self.cgColor)
        context?.fill(rect)
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return image ?? UIImage()
    }
    
    
    
}

public struct MemberCellData {
    
    let member: UnmanagedUser

    var nameText: String {
        let utcText = "(UTC \(member.utcOffset))"
        return "\(member.displayName) \(utcText)"
    }

    var statusColor: UIColor {
        switch member.status {
        case .online:
            return .RCOnline()
        case .away:
            return .RCAway()
        case .busy:
            return .RCBusy()
        case .offline:
            return .RCInvisible()
        }
    }
}

final class MemberCell: UITableViewCell {
    static let identifier = String(describing: MemberCell.self)

    var owner:UnmanagedUser?{
        didSet{
            
        }
    }
    var isOwner:Bool = false{
        didSet{
            self.roleButton.isHidden = !isOwner
            self.roleButton.setTitle(localized("chat.members.list.owner"), for: .normal)
            self.roleButton.setTitle(localized("chat.members.list.owner"), for: .selected)

        }
    }
    @IBOutlet weak var statusView: UIView! {
        didSet {
            statusView.layer.cornerRadius = statusView.layer.frame.width / 2
        }
    }

    @IBOutlet weak var statusViewWidthConstraint: NSLayoutConstraint! {
        didSet {
            statusViewWidthConstraint?.constant = hideStatus ? 0 : 8
        }
    }

    var hideStatus: Bool = false {
        didSet {
            statusViewWidthConstraint?.constant = hideStatus ? 0 : 8
        }
    }

    @IBOutlet weak var bottomLineView: UIView!
    @IBOutlet weak var avatarViewContainer: UIView! {
        didSet {
            avatarViewContainer.layer.masksToBounds = true
            avatarViewContainer.layer.cornerRadius = 5

            avatarView.frame = avatarViewContainer.bounds
            avatarViewContainer.addSubview(avatarView)
        }
    }

    lazy var avatarView: AvatarView = {
        let avatarView = AvatarView()
        avatarView.layer.cornerRadius = 4
        avatarView.layer.masksToBounds = true
        return avatarView
    }()

    @IBOutlet weak var nameLabel: UILabel!

    var data: MemberCellData? = nil {
        didSet {
            statusView.backgroundColor = data?.statusColor
            nameLabel.text = data?.nameText
            avatarView.username = data?.member.username
        }
    }
    @IBOutlet weak var roleButton: UIButton!
    
    @IBOutlet weak var buttonHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var bottomLineHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var buttonWidthConstraint: NSLayoutConstraint!
    override func awakeFromNib() {
        super.awakeFromNib()
    
        self.separatorInset = .zero
        self.roleButton.titleLabel?.font = UIFont.systemFont(ofSize: 11)
        self.roleButton.setTitleColor(UIColor.init(hex: "#1d74f4"), for: .normal)
        self.roleButton.setTitleColor(UIColor.init(hex: "#1d74f4"), for: .selected)
        self.roleButton.setBackgroundImage(UIColor(hex: "#c3dbff").colorImage, for: .normal)
        self.roleButton.setBackgroundImage(UIColor(hex: "#c3dbff").colorImage, for: .selected)
        self.roleButton.layer.cornerRadius = self.buttonHeightConstraint.constant/2
        self.roleButton.layer.masksToBounds = true
        self.bottomLineView.backgroundColor = UIColor(hex: "#D7D7D7")
        self.contentView.bringSubviewToFront(self.bottomLineView)
        
    }
}
extension MemberCell{
    override func applyTheme() {
        
    }
}
// MARK: ReactorCell

extension MemberCell: ReactorPresenter {
    var reactor: String {
        set {
            guard !newValue.isEmpty else { return }

            if let user = User.find(username: newValue)?.unmanaged {
                data = MemberCellData(member: user)
                return
            }

            User.fetch(by: .username(newValue), completion: { user in
                guard let user = user?.unmanaged else { return }
                self.data = MemberCellData(member: user)
            })
        }

        get {
            return data?.member.username ?? ""
        }
    }
}
