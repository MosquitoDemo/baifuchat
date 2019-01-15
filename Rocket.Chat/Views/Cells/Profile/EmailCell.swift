//
//  EmailCell.swift
//  Rocket.Chat
//
//  Created by Elen on 11/01/2019.
//  Copyright © 2019 Rocket.Chat. All rights reserved.
//

import UIKit

class EmailCell: UITableViewCell {

    var user:User?{
        didSet{
            
            self.detailLabel.text = user?.emails.first?.email
            
        }
    }
    var item:ProfileItem?{
        didSet{
            self.titleLabel.text = item?.title
        }
    }
    var lineView:UIView = UIView()
    var titleLabel:UILabel = UILabel()
    var detailLabel:UILabel = UILabel()
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.selectionStyle = .none
       
        self.titleLabel.translatesAutoresizingMaskIntoConstraints = false
        
        self.titleLabel.numberOfLines = 0
        self.titleLabel.lineBreakMode = .byWordWrapping
        self.titleLabel.textColor = UIColor(hex: "#333333")
        self.titleLabel.font = UIFont.systemFont(ofSize: 15)
        self.titleLabel.textAlignment = .left
        self.contentView.addSubview(self.titleLabel)
        self.detailLabel.translatesAutoresizingMaskIntoConstraints = false
        self.detailLabel.numberOfLines = 0
        self.detailLabel.lineBreakMode = .byWordWrapping
        self.detailLabel.textColor = UIColor(hex: "#666666")
        self.detailLabel.font = UIFont.systemFont(ofSize: 15)
        self.detailLabel.textAlignment = .left
        self.contentView.addSubview(self.detailLabel)
        self.lineView.backgroundColor = UIColor.groupTableViewBackground
        self.lineView.translatesAutoresizingMaskIntoConstraints = false
        self.contentView.addSubview(self.lineView)
        self.titleLabel.topAnchor.constraint(equalTo: self.contentView.topAnchor, constant: 11).isActive = true
        self.titleLabel.bottomAnchor.constraint(equalTo: self.contentView.bottomAnchor, constant: -11).isActive = true
        self.titleLabel.leadingAnchor.constraint(equalTo: self.contentView.leadingAnchor, constant: 10).isActive = true
        self.detailLabel.leadingAnchor.constraint(equalTo: self.contentView.leadingAnchor, constant: 100).isActive = true
        self.detailLabel.topAnchor.constraint(equalTo: self.contentView.topAnchor, constant: 11).isActive = true
        self.detailLabel.bottomAnchor.constraint(equalTo: self.contentView.bottomAnchor, constant: -11).isActive = true
        self.detailLabel.trailingAnchor.constraint(lessThanOrEqualTo: self.contentView.trailingAnchor, constant: -15).isActive = true
        
        self.lineView.bottomAnchor.constraint(equalTo: self.contentView.bottomAnchor).isActive = true
        self.lineView.leadingAnchor.constraint(equalTo: self.contentView.leadingAnchor).isActive = true
        self.lineView.trailingAnchor.constraint(equalTo: self.contentView.trailingAnchor).isActive = true
        self.lineView.heightAnchor.constraint(equalToConstant: 0.5).isActive = true
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }


}
extension EmailCell{
    override func applyTheme() {
        
    }
}
