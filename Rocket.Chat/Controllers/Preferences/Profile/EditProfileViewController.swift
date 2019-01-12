//
//  EditProfileViewController.swift
//  Rocket.Chat
//
//  Created by Elen on 11/01/2019.
//  Copyright © 2019 Rocket.Chat. All rights reserved.
//

import UIKit
import RealmSwift
import MobileCoreServices

public enum EditCellType:String, Codable{
    case avatar
    case userName
    case name
    case email
    case gender
    case birthdate
}
public struct EditProfileItem:Codable {
    public var title:String?
    public var value:String?
    public var type:EditCellType?
    
}
class EditProfileViewController: UIViewController {
    var isUpdatingUser = false
    var isUploadingAvatar = false
    var avatarFile:FileUpload?
    var currentPassword:String?
//    var birthdate:String?
    var email:String?
    var updateUser = User()
    public var items:[EditProfileItem]?
    public var tableView:UITableView?
    override public func loadView() {
        super.loadView()
        
        self.view.backgroundColor = UIColor.white
        self.tableView = UITableView(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.size.width, height: UIScreen.main.bounds.size.width))
        self.tableView?.backgroundColor = UIColor.groupTableViewBackground
        self.tableView?.rowHeight = UITableView.automaticDimension
        //        self.tableView?.estimatedRowHeight = 44
        self.tableView?.register(EditAvatarCell.self)
        self.tableView?.register(StatusCell.self)
        self.tableView?.register(EditUserNameCell.self)
        self.tableView?.register(EditNameCell.self)
        self.tableView?.register(EditEmailCell.self)
        self.tableView?.register(EditGenderCell.self)
        self.tableView?.register(EditBirthdateCell.self)
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
        
        let editItem = UIBarButtonItem(title: localized("myaccount.settings.profile.actions.save"), style: .plain, target: self, action: #selector(ProfileViewController.editItemTapped(_:)))
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
        self.items = [
            EditProfileItem(title: self.updateUser.name, value: self.updateUser.avatarURL()?.absoluteString, type: .avatar),
            
            
            
            EditProfileItem(title: localized("myaccount.settings.profile.username_placeholder"), value: self.updateUser.username, type: .userName),
            
            EditProfileItem(title: localized("myaccount.settings.profile.name_placeholder"), value: self.updateUser.name, type: .name),
            
            EditProfileItem(title: localized("myaccount.settings.profile.email_placeholder"), value: self.updateUser.emails.first?.email, type: .email),
            
            EditProfileItem(title: localized("myaccount.settings.profile.gender_placeholder"), value: self.updateUser.gender, type: .gender),
            
            EditProfileItem(title: localized("myaccount.settings.profile.birthdate_placeholder"), value: self.updateUser.birthdate, type: .birthdate),
            
        ]
        self.tableView?.reloadData()
        
        
    }
    @objc func editItemTapped(_ item:UIBarButtonItem){
        if !(self.email == AuthManager.currentUser()?.emails.first?.email) {
            try? Realm.current?.write {
                let email = Email(value: [
                    "email": self.email ?? "",
                    "verified": false
                    ])
                self.updateUser.emails.removeAll()
                self.updateUser.emails.append(email)
                
            }
            requestPasswordToUpdate(user: self.updateUser)
        } else {
            self.update(user: self.updateUser)
        }
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
extension EditProfileViewController:UITableViewDelegate{
    public func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let itemx = self.items?[indexPath.row]
        guard let type = itemx?.type else {return}
        switch type {
        case .birthdate:
            let datePicker = YLDatePicker(currentDate: nil, minLimitDate: Date(), maxLimitDate: nil, datePickerType: .YMD) { (date) in
                //                    self?.navigationItem.title = date.getString(format: "yyyy-MM-dd")
                //                    print(date.getString(format: "yyyy-MM-dd"))
                let dateString = date.getString(format: "yyyy-MM-dd")
                try? Realm.current?.write {
                    
                    self.updateUser.birthdate = dateString
                }
                
                let row = self.items?.firstIndex(where: { (item) -> Bool in
                    return item.type == .birthdate
                }) ?? 0
                let indexPath = IndexPath(row: row, section: 0)
                
                self.tableView?.reloadRows(at: [indexPath], with: .automatic)
                
            }
            
            
            datePicker.show()
            
        default:
            break
        }
    }
}
extension EditProfileViewController:UITableViewDataSource{
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.items?.count ?? 0
    }
    
    
    func openCamera(video: Bool = false) {
        guard UIImagePickerController.isSourceTypeAvailable(.camera) else {
            return assertionFailure("Device camera is not availbale")
        }
        
        let imagePicker  = UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.allowsEditing = true
        imagePicker.sourceType = .camera
        imagePicker.cameraFlashMode = .off
        imagePicker.mediaTypes = video ? [kUTTypeMovie as String] : [kUTTypeImage as String]
        imagePicker.cameraCaptureMode = video ? .video : .photo
        self.present(imagePicker, animated: true, completion: nil)
    }
    
    func openPhotosLibrary() {
        let picker = UIImagePickerController()
        picker.delegate = self
        picker.allowsEditing = false
        picker.sourceType = .savedPhotosAlbum
        
        if let mediaTypes = UIImagePickerController.availableMediaTypes(for: .savedPhotosAlbum) {
            picker.mediaTypes = mediaTypes
        }
        
        present(picker, animated: true, completion: nil)
    }
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let itemx = self.items?[indexPath.row]
        guard let type = itemx?.type else {return UITableViewCell()}
        switch type {
        case .avatar:
            let cell = tableView.dequeueReusableCell(indexPath: indexPath, EditAvatarCell.self)
            cell.user = AuthManager.currentUser()
            cell.editBlock = {[weak self] tap in
                let alert = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
                
                if UIImagePickerController.isSourceTypeAvailable(.camera) {
                    alert.addAction(UIAlertAction(title: localized("chat.upload.take_photo"), style: .default, handler: { (_) in
                    
                    
                        
                        self?.openCamera()
                    }))
                }
                
                alert.addAction(UIAlertAction(title: localized("chat.upload.choose_from_library"), style: .default, handler: { (_) in
                    self?.openPhotosLibrary()
                }))
                
                alert.addAction(UIAlertAction(title: localized("global.cancel"), style: .cancel, handler: nil))
                
                self?.present(alert, animated: true, completion: nil)
            }
            return cell
        
            
        case .birthdate:
            let cell = tableView.dequeueReusableCell(indexPath: indexPath, EditBirthdateCell.self)
            cell.user = self.updateUser

            cell.item = itemx
        
            return cell
        case .email:
            let cell = tableView.dequeueReusableCell(indexPath: indexPath, EditEmailCell.self)
            cell.user = self.updateUser

            cell.item = itemx
            cell.emailChangedBlock = {tf in
                self.email = tf.text
               
                
            }
            
            return cell
        
        case .gender:
            let cell = tableView.dequeueReusableCell(indexPath: indexPath, EditGenderCell.self)
            cell.buttonSelectedBlock = {bt in
                try? Realm.current?.write {
                    
                    self.updateUser.gender = bt.tag == 0x11 ? "male":"female"
                }
            }
            cell.user = self.updateUser

            cell.item = itemx
            
            return cell
        case .name:
            let cell = tableView.dequeueReusableCell(indexPath: indexPath, EditNameCell.self)
            cell.nameChangedBlock = {tf in
                try? Realm.current?.write {
                self.updateUser.name = tf.text
                }
            }
            cell.user = self.updateUser
            cell.item = itemx
            
            return cell
        case .userName:
            let cell = tableView.dequeueReusableCell(indexPath: indexPath, EditUserNameCell.self)
            cell.item = itemx
            cell.user = self.updateUser

            return cell
            
        }
        
    }
    public func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        guard let type = self.items?[indexPath.row].type else {return 66}
        switch type {
        case .avatar:
            return 150;
  
        default:
            return 66;
        }
        
    }
}


extension EditProfileViewController: UINavigationControllerDelegate {}

extension EditProfileViewController: UIImagePickerControllerDelegate {
    public func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey: Any]) {
        let filename = String.random()
        var file: FileUpload?
        
        if let image = info[.originalImage] as? UIImage {
            file = UploadHelper.file(
                for: image.compressedForUpload,
                name: "\(filename.components(separatedBy: ".").first ?? "image").jpeg",
                mimeType: "image/jpeg"
            )
            
            let indexPath = IndexPath(row: 0, section: 0)
            
            if let cell = self.tableView?.cellForRow(at: indexPath) as? EditAvatarCell{
                cell.imagex = image
//                self.tableView?.reloadRows(at: [indexPath], with: .automatic)
            }
            
        }
        
        avatarFile = file
        dismiss(animated: true, completion: nil)
    }
    
    public func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
    
    
}
extension EditProfileViewController{
    
    fileprivate func update(user: User) {
        if avatarFile != nil {
            updateAvatar()
        }
        
        
        
        updateUserInformation(user: user)
    }
    func startLoading() {
        view.isUserInteractionEnabled = false
        navigationItem.rightBarButtonItem?.isEnabled = false
        
    }
    
    func stopLoading(shouldEndEditing: Bool = true, shouldRefreshAvatar: Bool = false) {
        if !isUpdatingUser, !isUploadingAvatar {
            view.isUserInteractionEnabled = true
            navigationItem.rightBarButtonItem?.isEnabled = true
            
            
        }
    }
    fileprivate func requestPasswordToUpdate(user: User) {
        let alert = UIAlertController(
            title: localized("myaccount.settings.profile.password_required.title"),
            message: localized("myaccount.settings.profile.password_required.message"),
            preferredStyle: .alert
        )
        
        let updateUserAction = UIAlertAction(title: localized("myaccount.settings.profile.actions.save"), style: .default, handler: { _ in
            self.currentPassword = alert.textFields?.first?.text
            self.update(user: user)
        })
        
        updateUserAction.isEnabled = false
        
        alert.addTextField(configurationHandler: { textField in
            textField.placeholder = localized("myaccount.settings.profile.password_required.placeholder")
            if #available(iOS 11.0, *) {
                textField.textContentType = .password
            }
            textField.isSecureTextEntry = true
            
            _ = NotificationCenter.default.addObserver(forName: UITextField.textDidChangeNotification, object: textField, queue: OperationQueue.main) { _ in
                updateUserAction.isEnabled = !(textField.text?.isEmpty ?? false)
            }
        })
        
        alert.addAction(UIAlertAction(title: localized("global.cancel"), style: .cancel, handler: nil))
        alert.addAction(updateUserAction)
        present(alert, animated: true)
    }
    
    /**
     This method will only update the avatar image
     of the user.
     */
    fileprivate func updateAvatar() {
        guard let avatarFile = avatarFile else { return }
        
        startLoading()
        isUploadingAvatar = true
        
        API.current()?.client(UploadClient.self).uploadAvatar(data: avatarFile.data, filename: avatarFile.name, mimetype: avatarFile.type, completion: { [weak self] _ in
            guard let self = self else { return }
            
            if !self.isUpdatingUser {
                self.alertSuccess(title: localized("alert.update_profile_success.title"))
            }
            
            self.isUploadingAvatar = false
            let indexPath = IndexPath(row: 0, section: 0)
            
            if let cell = self.tableView?.cellForRow(at: indexPath) as? EditAvatarCell{
             
                cell.avatarView.avatarPlaceholder = UIImage(data: avatarFile.data)
                cell.avatarView.refreshCurrentAvatar(withCachedData: avatarFile.data, completion: {
                    self.stopLoading()
                })
            }
            self.avatarFile = nil
        })
    }

    /**
     This method will only update the user information.
     */
    fileprivate func updateUserInformation(user: User) {
        isUpdatingUser = true
        
        if !isUploadingAvatar {
            startLoading()
        }
        
        let stopLoading: (_ shouldEndEditing: Bool) -> Void = { [weak self] shouldEndEditing in
            self?.isUpdatingUser = false
            self?.stopLoading(shouldEndEditing: shouldEndEditing)
        }
        
        let updateUserRequest = UpdateUserBasicInfoRequest(user: user, currentPassword: currentPassword)
        
        API.current()?.fetch(updateUserRequest) {  response in
            //            guard let self = self else { return }
            
            switch response {
            case .resource(let resource):
                if let errorMessage = resource.errorMessage {
                    stopLoading(false)
                    Alert(key: "alert.update_profile_error").withMessage(errorMessage).present()
                    return
                }
                
                self.updateUser = resource.user ?? User()
                
                stopLoading(true)
                
                if !self.isUploadingAvatar {
                    self.alertSuccess(title: localized("alert.update_profile_success.title"))
                }
                self.navigationController?.popViewController(animated: true)
            case .error(let error):
                print(error)
                stopLoading(false)
                Alert(key: "alert.update_profile_error").present()
            }
        }
    }
}
