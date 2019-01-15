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
    var subscription: Subscription?
    
    let action: (() -> Void)?
    
    init(icon: UIImage?, title: String = "" ,subscription: Subscription?, action: (() -> Void)? = nil) {
        self.icon = icon
        self.title = title
        self.action = action
        self.subscription = subscription
        
    }
    
    // 测试
}

class ChannelInfoMemberCell: UITableViewCell, ChannelInfoCellProtocol {
    
    typealias DataType = ChannelInfoMemberCellData
    
    static let identifier = "ChannelInfoMemberCell"
    
    static let defaultHeight: CGFloat = 125
    
    
    var data: DataType? {
        didSet {
            
            let dataa = MembersListViewData()
            dataa.subscription = data?.subscription
            dataa.loadMoreMembers { [weak self] in
                
                
                
                let nsdone = NSData(contentsOf: NSURL(string: "https://chat-stg.baifu-tech.net/avatar/\(dataa.member(at: 0).username)?format=jpeg")! as URL)
                self?.imageOne.image = UIImage(data: nsdone! as Data, scale: 1.0)
                self?.labelOne.text = dataa.member(at: 0).username
                
                
                
                if dataa.members.count == 2{
                    
                    let nsdone = NSData(contentsOf: NSURL(string: "https://chat-stg.baifu-tech.net/avatar/\(dataa.member(at: 0).username)?format=jpeg")! as URL)
                    self?.imageOne.image = UIImage(data: nsdone! as Data, scale: 1.0)
                    self?.labelOne.text = dataa.member(at: 0).username
                    
                    let nsdtow = NSData(contentsOf: NSURL(string: "https://chat-stg.baifu-tech.net/avatar/\(dataa.member(at: 1).username)?format=jpeg")! as URL)
                    self?.imageTow.image = UIImage(data: nsdtow! as Data, scale: 1.0)
                    self?.labelTow.text = dataa.member(at: 1).username
                    
                }
                
                
                
                if dataa.members.count == 3{
                    
                    let nsdone = NSData(contentsOf: NSURL(string: "https://chat-stg.baifu-tech.net/avatar/\(dataa.member(at: 0).username)?format=jpeg")! as URL)
                    self?.imageOne.image = UIImage(data: nsdone! as Data, scale: 1.0)
                    self?.labelOne.text = dataa.member(at: 0).username
                    
                    let nsdtow = NSData(contentsOf: NSURL(string: "https://chat-stg.baifu-tech.net/avatar/\(dataa.member(at: 1).username)?format=jpeg")! as URL)
                    self?.imageTow.image = UIImage(data: nsdtow! as Data, scale: 1.0)
                    self?.labelTow.text = dataa.member(at: 1).username
                    
                    
                    let nsdthree = NSData(contentsOf: NSURL(string: "https://chat-stg.baifu-tech.net/avatar/\(dataa.member(at: 2).username)?format=jpeg")! as URL)
                    self?.imageThree.image = UIImage(data: nsdthree! as Data, scale: 1.0)
                    self?.labelThree.text = dataa.member(at: 2).username
                }
                
                
                if dataa.members.count == 4{
                    
                    let nsdone = NSData(contentsOf: NSURL(string: "https://chat-stg.baifu-tech.net/avatar/\(dataa.member(at: 0).username)?format=jpeg")! as URL)
                    self?.imageOne.image = UIImage(data: nsdone! as Data, scale: 1.0)
                    self?.labelOne.text = dataa.member(at: 0).username
                    
                    
                    let nsdtow = NSData(contentsOf: NSURL(string: "https://chat-stg.baifu-tech.net/avatar/\(dataa.member(at: 1).username)?format=jpeg")! as URL)
                    self?.imageTow.image = UIImage(data: nsdtow! as Data, scale: 1.0)
                    self?.labelTow.text = dataa.member(at: 1).username
                    
                    
                    let nsdthree = NSData(contentsOf: NSURL(string: "https://chat-stg.baifu-tech.net/avatar/\(dataa.member(at: 2).username)?format=jpeg")! as URL)
                    self?.imageThree.image = UIImage(data: nsdthree! as Data, scale: 1.0)
                    self?.labelThree.text = dataa.member(at: 2).username
                    
                    
                    let nsdfour = NSData(contentsOf: NSURL(string: "https://chat-stg.baifu-tech.net/avatar/\(dataa.member(at: 3).username)?format=jpeg")! as URL)
                    self?.imageFour.image = UIImage(data: nsdfour! as Data, scale: 1.0)
                    self?.labelFour.text = dataa.member(at: 3).username
                    
                    
                    
                }
                
                if dataa.members.count == 5{
                    let nsdone = NSData(contentsOf: NSURL(string: "https://chat-stg.baifu-tech.net/avatar/\(dataa.member(at: 0).username)?format=jpeg")! as URL)
                    self?.imageOne.image = UIImage(data: nsdone! as Data, scale: 1.0)
                    self?.labelOne.text = dataa.member(at: 0).username
                    
                    
                    let nsdtow = NSData(contentsOf: NSURL(string: "https://chat-stg.baifu-tech.net/avatar/\(dataa.member(at: 1).username)?format=jpeg")! as URL)
                    self?.imageTow.image = UIImage(data: nsdtow! as Data, scale: 1.0)
                    self?.labelTow.text = dataa.member(at: 1).username
                    
                    
                    let nsdthree = NSData(contentsOf: NSURL(string: "https://chat-stg.baifu-tech.net/avatar/\(dataa.member(at: 2).username)?format=jpeg")! as URL)
                    self?.imageThree.image = UIImage(data: nsdthree! as Data, scale: 1.0)
                    self?.labelThree.text = dataa.member(at: 2).username
                    
                    
                    let nsdfour = NSData(contentsOf: NSURL(string: "https://chat-stg.baifu-tech.net/avatar/\(dataa.member(at: 3).username)?format=jpeg")! as URL)
                    self?.imageFour.image = UIImage(data: nsdfour! as Data, scale: 1.0)
                    self?.labelFour.text = dataa.member(at: 3).username
                    
                    
                    let nsdfive = NSData(contentsOf: NSURL(string: "https://chat-stg.baifu-tech.net/avatar/\(dataa.member(at: 4).username)?format=jpeg")! as URL)
                    self?.imageFive.image = UIImage(data: nsdfive! as Data, scale: 1.0)
                    self?.labelFive.text = dataa.member(at: 4).username
                    
                }
                
                if dataa.members.count >= 6{
                    
                    let nsdone = NSData(contentsOf: NSURL(string: "https://chat-stg.baifu-tech.net/avatar/\(dataa.member(at: 0).username)?format=jpeg")! as URL)
                    self?.imageOne.image = UIImage(data: nsdone! as Data, scale: 1.0)
                    self?.labelOne.text = dataa.member(at: 0).username
                    
                    
                    let nsdtow = NSData(contentsOf: NSURL(string: "https://chat-stg.baifu-tech.net/avatar/\(dataa.member(at: 1).username)?format=jpeg")! as URL)
                    self?.imageTow.image = UIImage(data: nsdtow! as Data, scale: 1.0)
                    self?.labelTow.text = dataa.member(at: 1).username
                    
                    
                    let nsdthree = NSData(contentsOf: NSURL(string: "https://chat-stg.baifu-tech.net/avatar/\(dataa.member(at: 2).username)?format=jpeg")! as URL)
                    self?.imageThree.image = UIImage(data: nsdthree! as Data, scale: 1.0)
                    self?.labelThree.text = dataa.member(at: 2).username
                    
                    
                    let nsdfour = NSData(contentsOf: NSURL(string: "https://chat-stg.baifu-tech.net/avatar/\(dataa.member(at: 3).username)?format=jpeg")! as URL)
                    self?.imageFour.image = UIImage(data: nsdfour! as Data, scale: 1.0)
                    self?.labelFour.text = dataa.member(at: 3).username
                    
                    
                    let nsdfive = NSData(contentsOf: NSURL(string: "https://chat-stg.baifu-tech.net/avatar/\(dataa.member(at: 4).username)?format=jpeg")! as URL)
                    self?.imageFive.image = UIImage(data: nsdfive! as Data, scale: 1.0)
                    self?.labelFive.text = dataa.member(at: 4).username
                    
                    
                    let nsdsix = NSData(contentsOf: NSURL(string: "https://chat-stg.baifu-tech.net/avatar/\(dataa.member(at: 5).username)?format=jpeg")! as URL)
                    self?.imageSix.image = UIImage(data: nsdsix! as Data, scale: 1.0)
                    self?.labelSix.text = dataa.member(at: 5).username
                    
                    
                }
                //                let nsdone = NSData(contentsOf: NSURL(string: "https://chat-stg.baifu-tech.net/avatar/\(dataa.member(at: 0).username)?format=jpeg")! as URL)
                //                self?.imageOne.image = UIImage(data: nsdone! as Data, scale: 1.0)
                //                self?.labelOne.text = dataa.member(at: 0).username
                //
                //
                //                let nsdtow = NSData(contentsOf: NSURL(string: "https://chat-stg.baifu-tech.net/avatar/\(dataa.member(at: 1).username)?format=jpeg")! as URL)
                //                self?.imageTow.image = UIImage(data: nsdtow! as Data, scale: 1.0)
                //                self?.labelTow.text = dataa.member(at: 1).username
                //
                //
                //                let nsdthree = NSData(contentsOf: NSURL(string: "https://chat-stg.baifu-tech.net/avatar/\(dataa.member(at: 2).username)?format=jpeg")! as URL)
                //                self?.imageThree.image = UIImage(data: nsdthree! as Data, scale: 1.0)
                //                self?.labelThree.text = dataa.member(at: 2).username
                //
                //
                //                let nsdfour = NSData(contentsOf: NSURL(string: "https://chat-stg.baifu-tech.net/avatar/\(dataa.member(at: 3).username)?format=jpeg")! as URL)
                //                self?.imageFour.image = UIImage(data: nsdfour! as Data, scale: 1.0)
                //                self?.labelFour.text = dataa.member(at: 3).username
                //
                //
                //                let nsdfive = NSData(contentsOf: NSURL(string: "https://chat-stg.baifu-tech.net/avatar/\(dataa.member(at: 4).username)?format=jpeg")! as URL)
                //                self?.imageFive.image = UIImage(data: nsdfive! as Data, scale: 1.0)
                //                self?.labelFive.text = dataa.member(at: 4).username
                //
                //
                //                let nsdsix = NSData(contentsOf: NSURL(string: "https://chat-stg.baifu-tech.net/avatar/\(dataa.member(at: 5).username)?format=jpeg")! as URL)
                //                self?.imageSix.image = UIImage(data: nsdsix! as Data, scale: 1.0)
                //                self?.labelSix.text = dataa.member(at: 5).username
                
                
            }
            
            
            
            //            imageOne.image = data?.icon
            //            labelOne.text = data?.title
            
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
//        super.applyTheme()
        //        guard let theme = theme else { return }
        //        imageViewIcon.tintColor = theme.titleText
    }
}
