//
//  EditNameCell.swift
//  Rocket.Chat
//
//  Created by Elen on 12/01/2019.
//  Copyright © 2019 Rocket.Chat. All rights reserved.
//

import UIKit

class EditNameCell: UITableViewCell {
    typealias UITextFieldBlock = ((UITextField)->Void)
    var user:User?{
        didSet{
        
            self.detailTextField.text = user?.name
            
        }
    }
    var item:EditProfileItem?{
        didSet{
            self.titleLabel.text = item?.title
        }
    }
    
    var nameChangedBlock:UITextFieldBlock?
    var lineView:UIView = UIView()
    var titleLabel:UILabel = UILabel()
    var detailTextField:UITextField = UITextField()
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
        self.detailTextField.translatesAutoresizingMaskIntoConstraints = false
        self.detailTextField.textColor = UIColor(hex: "#666666")
        self.detailTextField.font = UIFont.systemFont(ofSize: 15)
        self.detailTextField.textAlignment = .left
        self.detailTextField.borderStyle = .none
        self.detailTextField.keyboardType = .default
        self.detailTextField.clearButtonMode = .whileEditing
        self.detailTextField.addTarget(self, action: #selector(EditNameCell.editNameChanged(_:)), for: .editingChanged)
        self.contentView.addSubview(self.detailTextField)
        self.lineView.backgroundColor = UIColor.groupTableViewBackground
        self.lineView.translatesAutoresizingMaskIntoConstraints = false
        self.contentView.addSubview(self.lineView)
        self.titleLabel.topAnchor.constraint(equalTo: self.contentView.topAnchor, constant: 11).isActive = true
        self.titleLabel.bottomAnchor.constraint(equalTo: self.contentView.bottomAnchor, constant: -11).isActive = true
        self.titleLabel.leadingAnchor.constraint(equalTo: self.contentView.leadingAnchor, constant: 10).isActive = true
        self.detailTextField.leadingAnchor.constraint(equalTo: self.contentView.leadingAnchor, constant: 100).isActive = true
        self.detailTextField.topAnchor.constraint(equalTo: self.contentView.topAnchor, constant: 11).isActive = true
        self.detailTextField.bottomAnchor.constraint(equalTo: self.contentView.bottomAnchor, constant: -11).isActive = true
        self.detailTextField.trailingAnchor.constraint(equalTo: self.contentView.trailingAnchor, constant: -15).isActive = true
        
        self.lineView.bottomAnchor.constraint(equalTo: self.contentView.bottomAnchor).isActive = true
        self.lineView.leadingAnchor.constraint(equalTo: self.contentView.leadingAnchor).isActive = true
        self.lineView.trailingAnchor.constraint(equalTo: self.contentView.trailingAnchor).isActive = true
        self.lineView.heightAnchor.constraint(equalToConstant: 0.5).isActive = true
        
    }
    @objc func editNameChanged(_ textField:UITextField){
        self.nameChangedBlock?(textField)
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
extension EditNameCell{
    override func applyTheme() {
        
    }
}
