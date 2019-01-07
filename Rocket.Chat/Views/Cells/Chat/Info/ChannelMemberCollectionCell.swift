//
//  ChannelMemberCollectionCell.swift
//  Rocket.Chat
//
//  Created by Elen on 05/01/2019.
//  Copyright © 2019 Rocket.Chat. All rights reserved.
//

import UIKit

class ChannelMemberCollectionCell: UICollectionViewCell {
    lazy var avatarView: AvatarView = {
        let avatarView = AvatarView()
        avatarView.layer.cornerRadius = 4
        avatarView.layer.masksToBounds = true
        return avatarView
    }()
    var user:MemberCellData?{
        didSet{
            titleLabel.text = user?.nameText
            if let url = user?.member.avatarURL{
                avatarView.avatarURL = url
            }else{
                avatarView.username = user?.member.username
            }
            
            
        }
    }
    @IBOutlet weak var widthConstraint: NSLayoutConstraint!
    @IBOutlet weak var heightConstraint: NSLayoutConstraint!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var imageView: UIImageView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.imageView.backgroundColor = UIColor.white
//        self.imageView.contentMode = .scaleAspectFit
        self.widthConstraint.constant = 60
        self.heightConstraint.constant = 60
        if avatarView.isDescendant(of: imageView){
            
        }else{
//            avatarView.frame = CGRect.init(x: 0, y: 0, width: 60, height: 60)
            avatarView.translatesAutoresizingMaskIntoConstraints = false
            self.imageView.addSubview(avatarView)
            avatarView.topAnchor.constraint(equalTo: self.imageView.topAnchor, constant: 0).isActive = true
            avatarView.bottomAnchor.constraint(equalTo: self.imageView.bottomAnchor, constant: 0).isActive = true
            avatarView.leadingAnchor.constraint(equalTo: self.imageView.leadingAnchor, constant: 0).isActive = true
            avatarView.trailingAnchor.constraint(equalTo: self.imageView.trailingAnchor, constant: 0).isActive = true
//            avatarView.widthAnchor.constraint(equalToConstant: 60).isActive = true
//            avatarView.heightAnchor.constraint(equalToConstant: 60).isActive = true
            self.imageView.layer.cornerRadius = 4
            self.imageView.layer.masksToBounds = true
            
            
        }
        
    
        
    }

}
