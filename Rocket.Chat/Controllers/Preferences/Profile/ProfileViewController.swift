//
//  ProfileViewController.swift
//  Rocket.Chat
//
//  Created by Elen on 11/01/2019.
//  Copyright © 2019 Rocket.Chat. All rights reserved.
//

import UIKit
public enum CellType:String, Codable{
    case avatar
    case userName
    case name
    case email
    case gender
    case birthdate
    case status
    case line
}

public struct ProfileItem:Codable {
   public var title:String?
   public var value:String?
   public var type:CellType?
   
}
public class ProfileViewController: UIViewController {

    
    public var items:[ProfileItem]?
    public var tableView:UITableView?
    override public func loadView() {
        super.loadView()
        
        self.view.backgroundColor = UIColor.white
        self.tableView = UITableView(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.size.width, height: UIScreen.main.bounds.size.width))
        self.tableView?.backgroundColor = UIColor.groupTableViewBackground
        self.tableView?.rowHeight = UITableView.automaticDimension
//        self.tableView?.estimatedRowHeight = 44
        self.tableView?.register(AvatarCell.self)
        self.tableView?.register(StatusCell.self)
        self.tableView?.register(UserNameCell.self)
        self.tableView?.register(NameCell.self)
        self.tableView?.register(EmailCell.self)
        self.tableView?.register(GenderCell.self)
        self.tableView?.register(BirthdateCell.self)
        self.tableView?.register(LineCell.self)

        self.tableView?.translatesAutoresizingMaskIntoConstraints = false
        self.tableView?.tableFooterView = UIView()
        self.tableView?.separatorStyle = .none
        self.tableView?.dataSource = self
        self.tableView?.delegate = self
        self.view.addSubview(self.tableView ?? UITableView())
        self.tableView?.leadingAnchor.constraint(equalTo: self.view.leadingAnchor).isActive = true
        self.tableView?.trailingAnchor.constraint(equalTo: self.view.trailingAnchor).isActive = true
        self.tableView?.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor).isActive = true
        self.tableView?.bottomAnchor.constraint(equalTo: self.view.bottomAnchor).isActive = true
        
    }
    override public func viewDidLoad() {
        super.viewDidLoad()

        self.title = localized("myaccount.settings.profile.title")
        
        let editItem = UIBarButtonItem(title: localized("myaccount.settings.profile.actions.edit"), style: .plain, target: self, action: #selector(ProfileViewController.editItemTapped(_:)))
        self.navigationItem.rightBarButtonItem = editItem
        /*
         internal let title = localized("myaccount.settings.profile.title")
         internal let editingTitle = localized("myaccount.settings.editing_profile.title")
         internal let saveButtonTitle = localized("myaccount.settings.profile.actions.save")
         internal let editButtonTitle = localized("myaccount.settings.profile.actions.edit")
         internal let profileSectionTitle = localized("myaccount.settings.profile.section.profile")
         internal let namePlaceholder = localized("myaccount.settings.profile.name_placeholder")
         internal let usernamePlaceholder = localized("myaccount.settings.profile.username_placeholder")
         internal let emailPlaceholder = localized("myaccount.settings.profile.email_placeholder")
         internal let statusTitle = localized("myaccount.settings.profile.status.title")
         internal let changeYourPasswordTitle = localized("myaccount.settings.profile.actions.change_password")
         
         internal var userStatus: String {
         guard let user = AuthManager.currentUser() else {
         return localized("status.invisible")
         }
         
         return user.status != .offline ? "\(user.status)" : localized("status.invisible")
         }
 */
        // Do any additional setup after loading the view.
     
        
        
    }
    public override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        let user = AuthManager.currentUser()
        self.items = [
            ProfileItem(title: user?.name, value: user?.avatarURL()?.absoluteString, type: .avatar),
            
            ProfileItem(title: localized("myaccount.settings.profile.status.title"), value: (user?.status).map { $0.rawValue }, type: .status),
            
            ProfileItem(title: nil, value: nil, type: .line),
            
            ProfileItem(title: localized("myaccount.settings.profile.username_placeholder"), value: user?.username, type: .userName),
            
            ProfileItem(title: localized("myaccount.settings.profile.name_placeholder"), value: user?.name, type: .name),
            
            ProfileItem(title: localized("myaccount.settings.profile.email_placeholder"), value: user?.emails.first?.email, type: .email),
            
            ProfileItem(title: localized("myaccount.settings.profile.gender_placeholder"), value: user?.gender, type: .gender),
            
            ProfileItem(title: localized("myaccount.settings.profile.birthdate_placeholder"), value: user?.birthdate, type: .birthdate),
            
        ]
        self.tableView?.reloadData()
    }
    @objc func editItemTapped(_ item:UIBarButtonItem){
        let editProfileViewController = EditProfileViewController()
        editProfileViewController.updateUser = AuthManager.currentUser() ?? User()
        self.navigationController?.pushViewController(editProfileViewController, animated: true)
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
extension ProfileViewController:UITableViewDelegate{
    public func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let itemx = self.items?[indexPath.row]
        guard let type = itemx?.type else {return}
        switch type {
        case .status:
            let storyBoard = UIStoryboard.init(name: "Preferences", bundle: Bundle.init(for: ProfileViewController.self))
            let vc = storyBoard.instantiateViewController(withIdentifier: "setStatus")
            self.navigationController?.pushViewController(vc, animated: true)
        default:
            break
        }
    }
}
extension ProfileViewController:UITableViewDataSource{
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.items?.count ?? 0
    }
    
    
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let itemx = self.items?[indexPath.row]
        guard let type = itemx?.type else {return UITableViewCell()}
        switch type {
        case .avatar:
            let cell = tableView.dequeueReusableCell(indexPath: indexPath, AvatarCell.self)
            cell.user = AuthManager.currentUser()
            return cell
        case .status:
            let cell = tableView.dequeueReusableCell(indexPath: indexPath, StatusCell.self)
            cell.user = AuthManager.currentUser()
            cell.item = itemx
            return cell
            
        case .birthdate:
            let cell = tableView.dequeueReusableCell(indexPath: indexPath, BirthdateCell.self)
            cell.item = itemx
            return cell
        case .email:
            let cell = tableView.dequeueReusableCell(indexPath: indexPath, EmailCell.self)
            cell.item = itemx

            return cell
        case .line:
            let cell = tableView.dequeueReusableCell(indexPath: indexPath, LineCell.self)
            return cell
        case .gender:
            let cell = tableView.dequeueReusableCell(indexPath: indexPath, GenderCell.self)
            cell.item = itemx

            return cell
        case .name:
            let cell = tableView.dequeueReusableCell(indexPath: indexPath, NameCell.self)
            cell.item = itemx

            return cell
        case .userName:
            let cell = tableView.dequeueReusableCell(indexPath: indexPath, UserNameCell.self)
            cell.item = itemx

            return cell
            
        }
        
    }
    public func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        guard let type = self.items?[indexPath.row].type else {return 66}
        switch type {
        case .avatar:
            return 150;
        case .line:
            return 44;
        default:
            return 66;
        }

    }
}
