//
//  ChannelActionsViewController.swift
//  Rocket.Chat
//
//  Created by Rafael Kellermann Streit on 9/24/17.
//  Copyright © 2017 Rocket.Chat. All rights reserved.
//

import UIKit

private typealias ListSegueData = (title: String, query: String?, isListingMentions: Bool)

class ChannelActionsViewController: BaseViewController {

    internal let kShareRoomSection = 2

    @IBOutlet weak var tableView: UITableView!

    weak var buttonFavorite: UIBarButtonItem?
    weak var shareRoomCell: UITableViewCell!

    var membersPages: [[UnmanagedUser]] = []
    var members: FlattenCollection<[[UnmanagedUser]]> {
        return membersPages.joined()
    }
    
    func member(at index: Int) -> UnmanagedUser {
        return members[members.index(members.startIndex, offsetBy: index)]
    }
    
    var tableViewData: [[Any?]] = [] {
        didSet {
            tableView?.reloadData()
        }
    }

    func refreshMembers() {
        let data = MembersListViewData()
        data.subscription = self.subscription
        data.loadMoreMembers {
            
        }
    }
    
    var subscription: Subscription? {
        didSet {
            func title(for menuTitle: String) -> String {
                return localized("chat.info.item.\(menuTitle)")
            }
            guard self.subscription?.isInvalidated == false else { return }

            guard let subscriptionx = self.subscription else {
                return
            }
            let isDirectMessage = subscriptionx.type == .directMessage

            var header: [Any?]?

            if isDirectMessage {
                header = [ChannelInfoUserCellData(user: subscriptionx.directMessageUser)]
            } else {
                let hasDescription = !(subscriptionx.roomDescription?.isEmpty ?? true)
                let hasTopic = !(subscriptionx.roomTopic?.isEmpty ?? true)

                let memberData = MembersListViewData()
                memberData.subscription = subscriptionx
//         print(memberData.members.count)
                
//                refreshMembers()
                //shuju
//                let options: APIRequestOptionSet = [.paginated(count: 50, offset: 0)]
//                let client = API.current()?.client(SubscriptionsClient.self)
//
//                client?.fetchMembersList(subscription: self.subscription!, options: options) { [weak self] response, users in
//                    guard
//                        let self = self,
//                        let users = users,
//                        case let .resource(resource) = response
//                        else {
//                            return Alert.defaultError.present()
//                    }
//                     self.membersPages.append(users)
//
//                }
                
                
                let data = MembersListViewData()
                data.subscription = subscriptionx
                data.loadMoreMembers { [weak self] in
//                    print(data.member(at: 1).displayName)
//                    https://chat-stg.baifu-tech.net/avatar/Abc199?format=jpeg
                    
                }
                
                header = [
//                    ChannelInfoBasicCellData(title: "#\(subscription.name)"),
                   
                    ChannelInfoMembersCellData(
                        icon: UIImage.init(named: ""), title: "" ,subscription: subscriptionx ,action: showMembersList
                    ),
                    
                    ChannelInfoDescriptionCellData(
                        title: localized("chat.info.item.description"),
                        descriptionText: hasDescription ? subscriptionx.roomDescription : localized("chat.info.item.no_description")
                    ),
                    ChannelInfoDescriptionCellData(
                        title: localized("chat.info.item.topic"),
                        descriptionText: hasTopic ? subscriptionx.roomTopic : localized("chat.info.item.no_topic")
                    ),
                    ChannelInfoAnnouncementCellData(
                        title: title(for: "announcement"),
                        announcement: subscriptionx.roomAnnouncement)
                ]
            }

            

            var data = [header, [
                ChannelInfoActionCellData(icon: UIImage(named: "Attachments"), title: title(for: "files"), action: showFilesList),
                
                
                ///commented by steve 2019-01-10 16:18:59
//                isDirectMessage ? nil : ChannelInfoActionCellData(icon: UIImage(named: "Mentions"), title: title(for: "mentions"), action: showMentionsList),
                
                
                isDirectMessage ? nil : ChannelInfoActionCellData(icon: UIImage(named: "Members"), title: title(for: "members"), action: showMembersList),
                
                
                ///commented by steve 2019-01-10 16:18:59
//                ChannelInfoActionCellData(icon: UIImage(named: "Star"), title: title(for: "starred"), action: showStarredList),
                
                
                ///commented by steve 2019-01-10 16:18:59
                isDirectMessage ? nil : ChannelInfoActionCellData(icon: UIImage(named: "announcement"), title: title(for: "announcement"), action: showStarredList),
                
                
                ///commented by steve 2019-01-10 16:18:59
//                ChannelInfoActionCellData(icon: UIImage(named: "Pinned"), title: title(for: "pinned"), action: showPinnedList),
                
                
                ChannelInfoActionCellData(icon: UIImage(named: "Notifications"), title: title(for: "notifications"), action: showNotificationsSettings)
                
                
            ], [
                ChannelInfoActionCellData(icon: UIImage(named: "Share"), title: title(for: "share"), detail: false, action: shareRoom)
            ]]
            if subscriptionx.type == .directMessage{
                
            }else{
            if subscriptionx.roomOwnerId == AuthManager.currentUser()?.identifier {
                data.append([DeleteChannelCellData(title: localized("chat.info.item.delete"))])
            }else{
                data.append([LeaveChannelCellData(title: localized("chat.info.item.leave"))])
            }

            }
        
            tableViewData = data.compactMap({ $0 })
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        title = localized("chat.info.item.Actions")

        if #available(iOS 11.0, *) {
            tableView?.contentInsetAdjustmentBehavior = .never
        }

        setupFavoriteButton()
        registerCells()
    }

    func registerCells() {
        tableView.registerNib(ChannelInfoAnnouncementCell.self)
        tableView.registerNib(ChannelInfoMembersCell.self)
        tableView.registerNib(ChannelInfoMemberCell.self)
        tableView.registerNib(ChannelInfoUserCell.self)
        tableView.registerNib(ChannelInfoActionCell.self)
        tableView.registerNib(ChannelInfoDescriptionCell.self)
        tableView.registerNib(ChannelInfoBasicCell.self)
        tableView.registerNib(DeleteChannelCell.self)
        tableView.registerNib(LeaveChannelCell.self)
/*
        tableView?.register(UINib(
            nibName: "ChannelInfoUserCell",
            bundle: Bundle.main
        ), forCellReuseIdentifier: ChannelInfoUserCell.identifier)

        tableView?.register(UINib(
            nibName: "ChannelInfoActionCell",
            bundle: Bundle.main
        ), forCellReuseIdentifier: ChannelInfoActionCell.identifier)

        tableView?.register(UINib(
            nibName: "ChannelInfoDescriptionCell",
            bundle: Bundle.main
        ), forCellReuseIdentifier: ChannelInfoDescriptionCell.identifier)

        
        tableView?.register(UINib(
            nibName: "ChannelInfoBasicCell",
            bundle: Bundle.main
        ), forCellReuseIdentifier: ChannelInfoBasicCell.identifier)
 */
    }

    func setupFavoriteButton() {
               if let settings = AuthSettingsManager.settings {
            if settings.favoriteRooms {
                let defaultImage = UIImage(named: "Star")?.imageWithTint(UIColor.RCGray()).withRenderingMode(.alwaysOriginal)
                let buttonFavorite = UIBarButtonItem(image: defaultImage, style: .plain, target: self, action: #selector(buttonFavoriteDidPressed))
                navigationItem.rightBarButtonItem = buttonFavorite
                self.buttonFavorite = buttonFavorite
                updateButtonFavoriteImage()
            }
        }
    }

    func updateButtonFavoriteImage(_ force: Bool = false, value: Bool = false) {
        guard let buttonFavorite = self.buttonFavorite else { return }
        let favorite = force ? value : subscription?.favorite ?? false
        var image: UIImage?

        if favorite {
            image = UIImage(named: "Star-Filled")?.imageWithTint(UIColor.RCFavoriteMark())
        } else {
            image = UIImage(named: "Star")?.imageWithTint(UIColor.RCGray())
        }

        buttonFavorite.image = image?.withRenderingMode(.alwaysOriginal)
    }

}

// MARK: IBAction

extension ChannelActionsViewController {

    @IBAction func buttonCloseDidPressed(sender: Any) {
        dismiss(animated: true, completion: nil)
    }

    @objc func buttonFavoriteDidPressed(_ sender: Any) {
        guard self.subscription?.isInvalidated == false else { return  }
        guard let subscription = self.subscription else { return }

        SubscriptionManager.toggleFavorite(subscription) { [unowned self] (response) in
            DispatchQueue.main.async {
                if response.isError() {
                    subscription.updateFavorite(!subscription.favorite)
                }

                self.updateButtonFavoriteImage()
            }
        }

        self.subscription?.updateFavorite(!subscription.favorite)
        updateButtonFavoriteImage()
    }

}

// MARK: Actions

extension ChannelActionsViewController {

    func showUserDetails(_ user: User) {
        let controller = UserDetailViewController.fromStoryboard().withModel(.forUser(user))
        navigationController?.pushViewController(controller, animated: true)
    }

    func showMembersList() {
        self.performSegue(withIdentifier: "toMembersList", sender: self)
    }

    func showPinnedList() {
        let data = ListSegueData(
            title: localized("chat.messages.pinned.list.title"),
            query: "{\"pinned\":true}",
            isListingMentions: false
        )

        self.performSegue(withIdentifier: "toMessagesList", sender: data)
    }

    private func showNotificationsSettings() {
        self.performSegue(withIdentifier: "toNotificationsSettings", sender: self)
    }

    func showStarredList() {
        guard let userId = AuthManager.currentUser()?.identifier else {
            alert(title: localized("error.socket.default_error.title"), message: localized("error.socket.default_error.message"))
            return
        }

        let data = ListSegueData(
            title: localized("chat.messages.starred.list.title"),
            query: "{\"starred._id\":{\"$in\":[\"\(userId)\"]}}",
            isListingMentions: false
        )

        self.performSegue(withIdentifier: "toMessagesList", sender: data)
    }

    func showMentionsList() {
        let data = ListSegueData(
            title: localized("chat.messages.mentions.list.title"),
            query: nil,
            isListingMentions: true
        )

        self.performSegue(withIdentifier: "toMessagesList", sender: data)
    }

    func showFilesList() {
        let data = ListSegueData(
            title: localized("chat.messages.files.list.title"),
            query: nil,
            isListingMentions: false
        )

        self.performSegue(withIdentifier: "toFilesList", sender: data)
    }

    func shareRoom() {
        guard subscription?.isInvalidated == false else {
            return
        }
        guard let url = subscription?.externalURL() else { return }
        let controller = UIActivityViewController(activityItems: [url], applicationActivities: nil)

        if shareRoomCell != nil && UIDevice.current.userInterfaceIdiom == .pad {
            controller.modalPresentationStyle = .popover
            controller.popoverPresentationController?.sourceView = shareRoomCell
            controller.popoverPresentationController?.sourceRect = shareRoomCell.bounds
        }

        present(controller, animated: true, completion: nil)
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let membersList = segue.destination as? MembersListViewController {
            membersList.data.subscription = self.subscription
        }

        if let messagesList = segue.destination as? MessagesListViewController {
            messagesList.data.subscription = self.subscription

            if let segueData = sender as? ListSegueData {
                messagesList.data.title = segueData.title
                messagesList.data.query = segueData.query
                messagesList.data.isListingMentions = segueData.isListingMentions
            }
        }

        if let filesList = segue.destination as? FilesListViewController {
            filesList.data.subscription = self.subscription

            if let segueData = sender as? ListSegueData {
                filesList.data.title = segueData.title
            }
        }

        if let notificationsSettings = segue.destination as? NotificationsPreferencesViewController {
            notificationsSettings.subscription = subscription
        }
    }

}

// MARK: UITableViewDelegate

extension ChannelActionsViewController: UITableViewDelegate {

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let data = tableViewData[indexPath.section][indexPath.row]

        if let data = data as? ChannelInfoActionCellData {
            let cell = tableView.dequeueReusableCell(ChannelInfoActionCell.self)
            cell.data = data
            cell.separatorInset = UIEdgeInsets(top: 0, left: 48, bottom: 0, right: 0)
            return cell
            
        }

        if let data = data as? ChannelInfoUserCellData {
            let cell = tableView.dequeueReusableCell(ChannelInfoUserCell.self)
            cell.data = data
            return cell
        }

        if let data = data as? ChannelInfoDescriptionCellData {

            let cell = tableView.dequeueReusableCell(ChannelInfoDescriptionCell.self)
                cell.data = data
                return cell
        }
        if let data = data as? ChannelInfoAnnouncementCellData {
            
            let cell = tableView.dequeueReusableCell(ChannelInfoAnnouncementCell.self)
            cell.data = data
            return cell
        }
        // member cell
        if let data = data as? ChannelInfoMembersCellData {
            
            let cell = tableView.dequeueReusableCell(ChannelInfoMembersCell.self)
            cell.data = data
            return cell
        }
        

        if let data = data as? ChannelInfoBasicCellData {
            let cell = tableView.dequeueReusableCell(ChannelInfoBasicCell.self)
            cell.data = data
            return cell
        }

        if let datax = data as? DeleteChannelCellData{
            let cell = tableView.dequeueReusableCell(DeleteChannelCell.self)
            cell.data = datax
            cell.deleteBlock = {bt in
                self.deleteChannel()
            }
            return cell
        }
        if let datax = data as? LeaveChannelCellData{
            let cell = tableView.dequeueReusableCell(LeaveChannelCell.self)
            cell.data = datax
            cell.leaveBlock = {bt in
                self.leaveChannel()
            }
            return cell
        }
        return UITableViewCell()
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let data = tableViewData[indexPath.section][indexPath.row]

        if data as? ChannelInfoActionCellData != nil {
            return ChannelInfoActionCell.defaultHeight
        }

        if data as? ChannelInfoUserCellData != nil {
            return ChannelInfoUserCell.defaultHeight
        }

        if data as? ChannelInfoDescriptionCellData != nil {
            return ChannelInfoDescriptionCell.defaultHeight
        }
//member Data
        if data as? ChannelInfoMembersCellData != nil {
            return ChannelInfoMembersCell.defaultHeight
        }
        
        if data as? ChannelInfoBasicCellData != nil {
            return ChannelInfoBasicCell.defaultHeight
        }
        if data as? ChannelInfoAnnouncementCellData != nil {
            return ChannelInfoAnnouncementCell.defaultHeight
        }
        if data as? DeleteChannelCellData != nil{
            return DeleteChannelCell.defaultHeight
        }
        if data as? LeaveChannelCellData != nil{
            return LeaveChannelCell.defaultHeight
        }

        return 0
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)        
//        if indexPath.section == 1 && indexPath.row == 4{
//            let vc = GroupAnnouncementViewController()
//            vc.canEdit = subscription?.roomOwnerId == AuthManager.currentUser()?.identifier
//
//            vc.subscription = self.subscription
//            vc.hidesBottomBarWhenPushed = true
//            self.navigationController?.pushViewController(vc, animated: true)
//            return
//        }
        if indexPath.section == kShareRoomSection && UIDevice.current.userInterfaceIdiom == .pad {
            shareRoomCell = tableView.cellForRow(at: indexPath)
        }

        let data = tableViewData[indexPath.section][indexPath.row]

        if let data = data as? ChannelInfoUserCellData, let user = data.user {
            showUserDetails(user)
        }
        /*群公告*/

        if let data = data as? ChannelInfoAnnouncementCellData{
            let vc = GroupAnnouncementViewController()
            vc.subscription = self.subscription
            vc.data = data
            vc.canEdit = subscription?.roomOwnerId == AuthManager.currentUser()?.identifier
            
            vc.hidesBottomBarWhenPushed = true
            self.navigationController?.pushViewController(vc, animated: true)
        }

        if let data = data as? ChannelInfoMembersCellData {
            guard let action = data.action else {
                alert(title: localized("alert.feature.wip.title"), message: localized("alert.feature.wip.message"))
                return
            }
            action()
        }
        
        if let data = data as? ChannelInfoActionCellData {
            guard let action = data.action else {
                alert(title: localized("alert.feature.wip.title"), message: localized("alert.feature.wip.message"))
                return
            }

            action()
        }
        
        if let _ = data as? DeleteChannelCellData{

            deleteChannel()
            
        }
        if let _ = data as? LeaveChannelCellData{
            leaveChannel()
        }
    }

    func deleteChannel(){
        let cancelAction = UIAlertAction.init(title: localized("alert.channel.delete.confirmation.cancel"), style: .cancel) { (action) in
            
        }
        let sureAction = UIAlertAction.init(title: localized("alert.channel.delete.confirmation.confirm"), style: .default) { (action) in
            guard let rid = self.subscription?.rid else { return  }
            guard let type = self.subscription?.type else { return  }
            
            let request = RoomDeleteRequest(roomId: rid, roomType: type)
            
            API.current()?.fetch(request, completion: { (response) in
                switch response{
                case .resource(let result):
                    print(result)
                    
                    
                    self.alertSuccess(title: result.raw?.stringValue ?? "")
                    
                    ///added by steve
                    self.dismiss(animated: true, completion: nil)
                    
                case .error(let error):
                    print(error)
                    
                    
                    self.alert(title: localized("error.socket.default_error.title"), message: error.description)
                }
            })
            
        }
        alert(with: [cancelAction,sureAction], title: localized("alert.channel.delete.confirmation.title"), message: localized("alert.channel.delete.confirmation.confirm"))
    }
    func leaveChannel(){
        let cancelAction = UIAlertAction.init(title: localized("alert.channel.leave.confirmation.cancel"), style: .cancel) { (action) in
            
        }
        let sureAction = UIAlertAction.init(title: localized("alert.channel.leave.confirmation.confirm"), style: .default) { (action) in
            guard let rid = self.subscription?.rid else { return  }
            guard let type = self.subscription?.type else { return  }
            
            let request = RoomLeaveRequest(roomId: rid, roomType: type)
            
            API.current()?.fetch(request, completion: { (response) in
                switch response{
                case .resource(let result):
                    print(result)
                    
                    
                    self.alertSuccess(title: result.raw?.stringValue ?? "")
                    
                    ///added by steve
                    self.dismiss(animated: true, completion: nil)
                    
                case .error(let error):
                    print(error)
                    
                    
                    self.alert(title: localized("error.socket.default_error.title"), message: error.description)
                }
            })
            
        }
        alert(with: [cancelAction,sureAction], title: localized("alert.channel.leave.confirmation.title"), message: localized("alert.channel.leave.confirmation.message"))
    }
}

// MARK: UITableViewDataSource

extension ChannelActionsViewController: UITableViewDataSource {

    func numberOfSections(in tableView: UITableView) -> Int {
        return tableViewData.count
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tableViewData[section].count
    }

}
