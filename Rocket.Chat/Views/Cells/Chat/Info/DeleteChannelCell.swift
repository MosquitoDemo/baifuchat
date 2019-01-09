//
//  DeleteChannelCell.swift
//  Rocket.Chat
//
//  Created by Elen on 09/01/2019.
//  Copyright © 2019 Rocket.Chat. All rights reserved.
//

import UIKit

struct DeleteChannelCellData: ChannelInfoCellDataProtocol {
    let cellType = DeleteChannelCell.self
    var title: String?
}
protocol DeleteChannelCellDelegate {
    func deleteChannel(_ sender:UIButton,_ cell:DeleteChannelCell)
}
class DeleteChannelCell: UITableViewCell,ChannelInfoCellProtocol {
    static var identifier: String = String(describing: DeleteChannelCell.self)
    
    static var defaultHeight: CGFloat = UITableView.automaticDimension
    var deleteBlock:((UIButton)->Void)?
    var data:DeleteChannelCellData?{
        didSet{
            self.deleteChannelButton.setTitle(data?.title, for: .normal)
            self.deleteChannelButton.setTitle(data?.title, for: .selected)
        }
    }
    var delegate:DeleteChannelCellDelegate?

    @IBOutlet weak var deleteChannelButton: UIButton!
    
    
    @IBAction func deleteButtonTapped(_ sender: UIButton) {
        self.deleteBlock?(sender)
        delegate?.deleteChannel(sender, self)
        sender.isSelected = !sender.isSelected
        
    }
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        self.deleteChannelButton.setTitle(localized("chat.info.item.delete"), for: .normal)
        self.deleteChannelButton.setTitle(localized("chat.info.item.delete"), for: .selected)
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
