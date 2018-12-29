//
//  ChannelInfoMemberCell.swift
//  Rocket.Chat
//
//  Created by Winston on 2018/12/27.
//  Copyright © 2018 Rocket.Chat. All rights reserved.
//

import UIKit
import RealmSwift

struct ChannelInfoMemberCellData: ChannelInfoCellDataProtocol {
    let cellType = ChannelInfoMemberCell.self
    
    var icon: UIImage?
    var title: String?
    var data: MembersListViewData?
    
    
    let action: (() -> Void)?
    
    init(icon: UIImage?, title: String = "",action: (() -> Void)? = nil) {
        self.icon = icon
        self.title = title
        self.action = action

    }
    
    init(data: NSObject? ,action: (() -> Void)? = nil) {
//        self.data = data
        self.action = action
        
    }
    
    // 测试
}

class ChannelInfoMemberCell: UITableViewCell, ChannelInfoCellProtocol {
    
    typealias DataType = ChannelInfoMemberCellData
    
    
    
    static let identifier = "ChannelInfoMemberCell"
    
    static let defaultHeight: CGFloat = 105
    
    
    var data: DataType? {
        didSet {
            
            imageOne.image = data?.icon
            labelOne.text = data?.title
            
            imageTow.image = data?.icon
            labelTow.text = data?.title
            
            imageThree.image = data?.icon
            labelThree.text = data?.title
            
            imageFour.image = data?.icon
            labelFour.text = data?.title
            
            imageFive.image = data?.icon
            labelFive.text = data?.title
//
            imageSix.image = data?.icon
            labelSix.text = data?.title
            
        }
    }
    
    //image and  title 拉线
    
    @IBOutlet weak var imageOne: UIImageView!
    @IBOutlet weak var labelOne: UILabel!
    
    @IBOutlet weak var imageTow: UIImageView!
    @IBOutlet weak var labelTow: UILabel!
    
    @IBOutlet weak var imageThree: UIImageView!
    @IBOutlet weak var labelThree: UILabel!
    
    @IBOutlet weak var imageFour: UIImageView!
    @IBOutlet weak var labelFour: UILabel!
    
    @IBOutlet weak var imageFive: UIImageView!
    @IBOutlet weak var labelFive: UILabel!
    
    @IBOutlet weak var imageSix: UIImageView!
    @IBOutlet weak var labelSix: UILabel!
    
    
    

    
}

extension ChannelInfoMemberCell {
    override func applyTheme() {
        super.applyTheme()
        guard let theme = theme else { return }
//        imageViewIcon.tintColor = theme.titleText
    }
}
