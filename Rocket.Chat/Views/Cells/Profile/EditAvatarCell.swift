//
//  EditAvatarCell.swift
//  Rocket.Chat
//
//  Created by Elen on 12/01/2019.
//  Copyright © 2019 Rocket.Chat. All rights reserved.
//

import UIKit
protocol EditAvatarCellDelegate {
    func editAvatar(_ tap:UITapGestureRecognizer,_ cell:EditAvatarCell)
}
class EditAvatarCell: UITableViewCell {
    
    var delegate:EditAvatarCellDelegate?
    var editBlock:((UITapGestureRecognizer)->Void)?

    let editingAvatarImage = UIImage(named: "Camera")?.imageWithTint(.RCEditingAvatarColor())
    var imagex:UIImage?{
        didSet{
            self.avatarView.imageView.image = imagex
        }
    }
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
        
        self.avatarView.isUserInteractionEnabled = true
        let tap = UITapGestureRecognizer(target: self, action: #selector(EditAvatarCell.editAvatar(_:)))
        self.avatarView.addGestureRecognizer(tap)
        self.contentView.addSubview(self.avatarView)
        self.titleLabel.numberOfLines = 0
        self.titleLabel.lineBreakMode = .byWordWrapping
        self.titleLabel.textAlignment = .center
        self.titleLabel.textColor = UIColor(hex: "#333333")
        self.titleLabel.font = UIFont.systemFont(ofSize: 15)
        self.titleLabel.translatesAutoresizingMaskIntoConstraints = false
        self.contentView.addSubview(self.titleLabel)
        let maskImageView = UIImageView(image: editingAvatarImage)
        maskImageView.translatesAutoresizingMaskIntoConstraints = false
        maskImageView.isUserInteractionEnabled = true
        maskImageView.addGestureRecognizer(tap)
        self.contentView.addSubview(maskImageView)
        self.contentView.bringSubviewToFront(maskImageView)
        self.avatarView.topAnchor.constraint(equalTo: self.contentView.topAnchor,constant:20.0).isActive = true
        self.avatarView.bottomAnchor.constraint(equalTo: self.titleLabel.topAnchor, constant: -10).isActive = true
        self.avatarView.widthAnchor.constraint(equalToConstant: 78).isActive = true
        self.avatarView.heightAnchor.constraint(equalToConstant: 78).isActive = true
        self.avatarView.centerXAnchor.constraint(equalTo: self.contentView.centerXAnchor).isActive = true
        self.titleLabel.centerXAnchor.constraint(equalTo: self.contentView.centerXAnchor).isActive = true
        self.titleLabel.bottomAnchor.constraint(equalTo: self.contentView.bottomAnchor, constant: -20).isActive = true
        maskImageView.centerXAnchor.constraint(equalTo: self.avatarView.centerXAnchor).isActive = true
        maskImageView.centerYAnchor.constraint(equalTo: self.avatarView.centerYAnchor).isActive = true
       
        
        
        
    }
    @objc func editAvatar(_ tap:UITapGestureRecognizer){
        self.editBlock?(tap)
        self.delegate?.editAvatar(tap, self)
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
extension EditAvatarCell{
    override func applyTheme() {
        
    }
}
