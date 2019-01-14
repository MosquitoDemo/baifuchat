//
//  EditGenderCell.swift
//  Rocket.Chat
//
//  Created by Elen on 12/01/2019.
//  Copyright © 2019 Rocket.Chat. All rights reserved.
//

import UIKit
import DLRadioButton

class EditGenderCell: UITableViewCell {

    var user:User?{
        didSet{
            if user?.gender == "male" {
                maleButton.isSelected = true
            }else{
                maleButton.otherButtons.first?.isSelected = true
            }
        }
    }

    var item:EditProfileItem?{
        didSet{
            self.titleLabel.text = item?.title
            
        }
    }
    
    var lineView:UIView = UIView()
    var titleLabel:UILabel = UILabel()
    var buttonSelectedBlock:((DLRadioButton)->Void)?

    var maleButton:DLRadioButton = DLRadioButton(frame: CGRect(x: 0, y: 0, width: 80, height: 30))
    var femaleButton:DLRadioButton = DLRadioButton(frame:CGRect(x: 0, y: 0, width: 80, height: 30))
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.selectionStyle = .none
        self.lineView.backgroundColor = UIColor.groupTableViewBackground
        self.lineView.translatesAutoresizingMaskIntoConstraints = false
        self.contentView.addSubview(self.lineView)
        self.titleLabel.translatesAutoresizingMaskIntoConstraints = false
        self.titleLabel.numberOfLines = 0
        self.titleLabel.lineBreakMode = .byWordWrapping
        self.titleLabel.textColor = UIColor(hex: "#333333")
        self.titleLabel.font = UIFont.systemFont(ofSize: 15)
        self.titleLabel.textAlignment = .left
        self.contentView.addSubview(self.titleLabel)
        maleButton.tag = 0x11
        maleButton.translatesAutoresizingMaskIntoConstraints = false
        maleButton.titleLabel?.font = UIFont.systemFont(ofSize: 15)
        maleButton.setTitle(localized("myaccount.settings.profile.gender_male"), for: .normal)
        maleButton.setTitle(localized("myaccount.settings.profile.gender_male"), for: .selected)
        maleButton.setTitleColor(UIColor(hex: "#333333"), for:.normal)
        maleButton.setTitleColor(UIColor.blue, for: .selected)
        maleButton.iconColor = UIColor.blue
        maleButton.indicatorColor = UIColor.blue
        maleButton.contentHorizontalAlignment = UIControl.ContentHorizontalAlignment.left;
        maleButton.addTarget(self, action: #selector(EditGenderCell.radioButtonTapped(_:)), for: UIControl.Event.touchUpInside)
        maleButton.sizeThatFits(CGSize.init(width: 80, height: 30))
//        maleButton.sizeToFit()
        self.contentView.addSubview(self.maleButton)
        femaleButton.tag = 0x22
        femaleButton.translatesAutoresizingMaskIntoConstraints = false
        femaleButton.titleLabel?.font = UIFont.systemFont(ofSize: 15)
        femaleButton.setTitle(localized("myaccount.settings.profile.gender_female"), for: .normal)
        femaleButton.setTitle(localized("myaccount.settings.profile.gender_female"), for: .selected)
        femaleButton.setTitleColor(UIColor(hex: "#333333"), for:.normal)
        femaleButton.setTitleColor(UIColor.blue, for: .selected)
        femaleButton.iconColor = UIColor.blue
        femaleButton.indicatorColor = UIColor.blue
        femaleButton.contentHorizontalAlignment = UIControl.ContentHorizontalAlignment.left;
        femaleButton.addTarget(self, action:#selector(EditGenderCell.radioButtonTapped(_:)), for: UIControl.Event.touchUpInside)
        femaleButton.sizeThatFits(CGSize.init(width: 80, height: 30))
        self.contentView.addSubview(self.femaleButton)
        maleButton.otherButtons = [femaleButton]
        maleButton.isSelected = true
        
        
        self.titleLabel.topAnchor.constraint(equalTo: self.contentView.topAnchor, constant: 11).isActive = true
        self.titleLabel.bottomAnchor.constraint(equalTo: self.contentView.bottomAnchor, constant: -11).isActive = true
        self.titleLabel.leadingAnchor.constraint(equalTo: self.contentView.leadingAnchor, constant: 10).isActive = true
        self.maleButton.leadingAnchor.constraint(equalTo: self.contentView.leadingAnchor, constant: 100).isActive = true
        self.maleButton.centerYAnchor.constraint(equalTo: self.titleLabel.centerYAnchor).isActive = true
        self.maleButton.trailingAnchor.constraint(equalTo: self.femaleButton.leadingAnchor, constant: -30).isActive = true
        self.maleButton.widthAnchor.constraint(equalToConstant: 80).isActive = true
        self.femaleButton.centerYAnchor.constraint(equalTo: self.titleLabel.centerYAnchor).isActive = true
        self.femaleButton.trailingAnchor.constraint(lessThanOrEqualTo: self.contentView.trailingAnchor, constant: -15).isActive = true
        self.femaleButton.widthAnchor.constraint(equalToConstant: 80).isActive = true
        self.lineView.bottomAnchor.constraint(equalTo: self.contentView.bottomAnchor).isActive = true
        self.lineView.leadingAnchor.constraint(equalTo: self.contentView.leadingAnchor).isActive = true
        self.lineView.trailingAnchor.constraint(equalTo: self.contentView.trailingAnchor).isActive = true
        self.lineView.heightAnchor.constraint(equalToConstant: 0.5).isActive = true
        
    }
    @objc func radioButtonTapped(_ button:DLRadioButton){
        self.buttonSelectedBlock?(button.selected() ?? button)
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
extension EditGenderCell{
    override func applyTheme() {
        
    }
}
