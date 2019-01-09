//
//  DeleteChannelCell.swift
//  Rocket.Chat
//
//  Created by Elen on 09/01/2019.
//  Copyright © 2019 Rocket.Chat. All rights reserved.
//

import UIKit

protocol DeleteChannelCellDelegate {
    func deleteChannel(_ sender:UIButton,_ cell:DeleteChannelCell)
}
class DeleteChannelCell: UITableViewCell {
    
    var delegate:DeleteChannelCellDelegate?

    @IBOutlet weak var deleteChannelButton: UIButton!
    
    
    @IBAction func deleteButtonTapped(_ sender: UIButton) {
        
        delegate?.deleteChannel(sender, self)
        sender.isSelected = !sender.isSelected
        
    }
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        self.deleteChannelButton.setTitle("", for: .normal)
        self.deleteChannelButton.setTitle("", for: .selected)
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        self.deleteChannelButton.isSelected = selected
        

        // Configure the view for the selected state
    }
    
}
extension DeleteChannelCell{
    override func applyTheme() {
        super.applyTheme()
    }
}
