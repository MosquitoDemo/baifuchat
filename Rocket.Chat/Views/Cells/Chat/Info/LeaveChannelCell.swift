//
//  LeaveChannelCell.swift
//  Rocket.Chat
//
//  Created by Elen on 09/01/2019.
//  Copyright © 2019 Rocket.Chat. All rights reserved.
//

import UIKit

struct LeaveChannelCellData: ChannelInfoCellDataProtocol {
    let cellType = LeaveChannelCell.self
    var title: String?
}
protocol LeaveChannelCellDelegate {
    func leaveChannel(_ sender:UIButton,_ cell:LeaveChannelCell)
    
}
class LeaveChannelCell: UITableViewCell,ChannelInfoCellProtocol {
    static var identifier: String = String(describing: LeaveChannelCell.self)
    
    static var defaultHeight: CGFloat = UITableView.automaticDimension
    
    
    var leaveBlock:((UIButton)->Void)?
    var data:LeaveChannelCellData?{
        didSet{
        
            self.leaveChannelButton.setTitle(data?.title, for: .normal)
            self.leaveChannelButton.setTitle(data?.title, for: .selected)
            self.leaveChannelButton.setTitleColor(UIColor.init(hex: "#ff001f"), for: .normal)
            self.leaveChannelButton.setTitleColor(UIColor.init(hex: "#ff001f"), for: .selected)
            
        }
    }
    var delegate:LeaveChannelCellDelegate?

    @IBAction func leaveButtonTapped(_ sender: UIButton) {
        self.leaveBlock?(sender)
        delegate?.leaveChannel(sender, self)
        sender.isSelected = !sender.isSelected
    }
    @IBOutlet weak var leaveChannelButton: UIButton!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        self.leaveChannelButton.setTitle(localized("chat.info.item.leave"), for: .normal)
        self.leaveChannelButton.setTitle(localized("chat.info.item.leave"), for: .selected)
        self.leaveChannelButton.setTitleColor(UIColor.init(hex: "#ff001f"), for: .normal)
        self.leaveChannelButton.setTitleColor(UIColor.init(hex: "#ff001f"), for: .selected)
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        self.leaveChannelButton.isSelected = selected

        // Configure the view for the selected state
    }
    
}
extension LeaveChannelCell{
    override func applyTheme() {
//        super.applyTheme()
    }
}
