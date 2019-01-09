//
//  LeaveChannelCell.swift
//  Rocket.Chat
//
//  Created by Elen on 09/01/2019.
//  Copyright © 2019 Rocket.Chat. All rights reserved.
//

import UIKit
protocol LeaveChannelCellDelegate {
    func leaveChannel(_ sender:UIButton,_ cell:LeaveChannelCell)
    
}
class LeaveChannelCell: UITableViewCell {
    var delegate:LeaveChannelCellDelegate?

    @IBAction func leaveButtonTapped(_ sender: UIButton) {
        delegate?.leaveChannel(sender, self)
        sender.isSelected = !sender.isSelected
    }
    @IBOutlet weak var leaveChannelButton: UIButton!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        self.leaveChannelButton.setTitle("", for: .normal)
        self.leaveChannelButton.setTitle("", for: .selected)
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        self.leaveChannelButton.isSelected = selected

        // Configure the view for the selected state
    }
    
}
extension LeaveChannelCell{
    override func applyTheme() {
        super.applyTheme()
    }
}
