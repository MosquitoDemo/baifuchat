//
//  ChannelInfoMembersCell.swift
//  Rocket.Chat
//
//  Created by Elen on 05/01/2019.
//  Copyright © 2019 Rocket.Chat. All rights reserved.
//

import UIKit

struct ChannelBlankCellData:ChannelInfoCellDataProtocol {
    
    
    let cellType = LineCell.self

}

struct ChannelInfoMembersCellData: ChannelInfoCellDataProtocol {
    let cellType = ChannelInfoMembersCell.self
    
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
class ChannelInfoMembersCell: UITableViewCell,ChannelInfoCellProtocol {
    
    
    var dataBlock:((_ collectionView: UICollectionView, _ indexPath: IndexPath)->Void)?
    
    static var identifier: String = String(describing: ChannelInfoMembersCell.self)
    
    var data: ChannelInfoMembersCellData?{
        didSet{
            if let sub = data?.subscription{
                
                let options: APIRequestOptionSet = [.paginated(count: 50, offset: 0)]
                let client = API.current()?.client(SubscriptionsClient.self)
                
                client?.fetchMembersList(subscription: sub, options: options) { response, users in
                    guard
                        let userxs = users
//                        case let .resource(resource) = response
                        else {
                            return Alert.defaultError.present()
                    }
                    let members = userxs.map({ (userx) -> MemberCellData in
                       
                        return MemberCellData(member: userx)
                    })
                    let first6Elements : [MemberCellData] // An Array of up to the first 3 elements.
                    if members.count >= 6 {
                        first6Elements = Array(members[0 ..< 6])
                    } else {
                        first6Elements = members
                    }
                    self.itemArray = first6Elements
                    self.collectionView.reloadData()
                    
                /*
                    self.membersPages.append(users)
                    
                    self.showing += resource.count ?? 0
                    self.total = resource.total ?? 0
                    self.currentPage += 1
                    
                    self.isLoadingMoreMembers = false
                    
                    completion?()
 */
                }
            }
        }
    }
    var itemArray:[MemberCellData] = [MemberCellData]()

    typealias DataType = ChannelInfoMembersCellData

    static let defaultHeight: CGFloat = 125
    @IBOutlet weak var collectionView: UICollectionView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.collectionView.registerNib(ChannelMemberCollectionCell.self)
        self.collectionView.dataSource = self
        self.collectionView.delegate = self
        self.collectionView.showsHorizontalScrollIndicator = false
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
extension ChannelInfoMembersCell{
    override func applyTheme() {
        super.applyTheme()
    }
}

// MARK: - UICollectionViewDataSource
extension ChannelInfoMembersCell:UICollectionViewDataSource{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.itemArray.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCollectionCell(ChannelMemberCollectionCell.self, indexPath: indexPath)
        cell.user = self.itemArray[indexPath.row]
        return cell
    }
    
    
}

// MARK: - UICollectionViewDelegate
extension ChannelInfoMembersCell:UICollectionViewDelegate{
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        self.dataBlock?(collectionView,indexPath)
    
        
    }
}
