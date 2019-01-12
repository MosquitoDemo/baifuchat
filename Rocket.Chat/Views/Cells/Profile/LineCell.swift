//
//  LineCell.swift
//  Rocket.Chat
//
//  Created by Elen on 11/01/2019.
//  Copyright © 2019 Rocket.Chat. All rights reserved.
//

import UIKit

public class LineCell: UITableViewCell {

    public var lineView:UIView = UIView()
    public override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.selectionStyle = .none
        self.lineView.backgroundColor = UIColor.groupTableViewBackground
        self.lineView.translatesAutoresizingMaskIntoConstraints = false
        self.contentView.addSubview(self.lineView)
        self.lineView.topAnchor.constraint(equalTo: self.contentView.topAnchor).isActive = true
        self.lineView.bottomAnchor.constraint(equalTo: self.contentView.bottomAnchor).isActive = true
        self.lineView.leadingAnchor.constraint(equalTo: self.contentView.leadingAnchor).isActive = true
        self.lineView.trailingAnchor.constraint(equalTo: self.contentView.trailingAnchor).isActive = true
        self.lineView.heightAnchor.constraint(equalToConstant: 44).isActive = true

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
extension LineCell{
    override func applyTheme() {
        
    }
}
