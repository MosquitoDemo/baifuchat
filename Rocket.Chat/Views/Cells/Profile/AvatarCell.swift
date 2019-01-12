//
//  AvatarCell.swift
//  Rocket.Chat
//
//  Created by Elen on 11/01/2019.
//  Copyright © 2019 Rocket.Chat. All rights reserved.
//

import UIKit

public class AvatarCell: UITableViewCell {

    var user:User?{
        didSet{
            titleLabel.text = user?.name
            if let url = user?.avatarURL(){
                avatarView.avatarURL = url
            }else{
                avatarView.username = user?.username
            }
        }
    }
    
    
    var avatarView: AvatarView = {
        let avatarView = AvatarView()
        avatarView.isUserInteractionEnabled = false
        avatarView.translatesAutoresizingMaskIntoConstraints = false
        avatarView.layer.cornerRadius = 4
        avatarView.layer.masksToBounds = true
        
        return avatarView
    }()
    
    public var titleLabel:UILabel = UILabel()
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.selectionStyle = .none
        self.contentView.backgroundColor = UIColor.groupTableViewBackground
        self.avatarView.translatesAutoresizingMaskIntoConstraints = false
        self.contentView.addSubview(self.avatarView)
        self.titleLabel.numberOfLines = 0
        self.titleLabel.lineBreakMode = .byWordWrapping
        self.titleLabel.textAlignment = .center
        self.titleLabel.textColor = UIColor(hex: "#333333")
        self.titleLabel.font = UIFont.systemFont(ofSize: 15)
        self.titleLabel.translatesAutoresizingMaskIntoConstraints = false
        self.contentView.addSubview(self.titleLabel)
        self.avatarView.topAnchor.constraint(equalTo: self.contentView.topAnchor,constant:20.0).isActive = true
        self.avatarView.bottomAnchor.constraint(equalTo: self.titleLabel.topAnchor, constant: -10).isActive = true
        self.avatarView.widthAnchor.constraint(equalToConstant: 78).isActive = true
        self.avatarView.heightAnchor.constraint(equalToConstant: 78).isActive = true
        self.avatarView.centerXAnchor.constraint(equalTo: self.contentView.centerXAnchor).isActive = true
        self.titleLabel.centerXAnchor.constraint(equalTo: self.contentView.centerXAnchor).isActive = true
        self.titleLabel.bottomAnchor.constraint(equalTo: self.contentView.bottomAnchor, constant: -20).isActive = true
        
        
    }
    
    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    public override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    public override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
extension AvatarCell{
    override func applyTheme() {
        
    }
}
