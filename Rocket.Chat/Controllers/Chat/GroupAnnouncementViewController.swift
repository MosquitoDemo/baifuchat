//
//  GroupAnnouncementViewController.swift
//  Rocket.Chat
//
//  Created by Elen on 29/12/2018.
//  Copyright © 2018 Rocket.Chat. All rights reserved.
//

import UIKit
import RealmSwift

class GroupAnnouncementViewController: UIViewController {

    
    public var subscription:Subscription?
    public var data:ChannelInfoAnnouncementCellData?{
        didSet{
            self.title = data?.title
            self.mainTextView?.text = data?.announcement
        }
    }
    
    var canEdit:Bool = false
    var mainTextView:KMPlaceholderTextView?
    var numberLabel:UILabel?
    override func loadView() {
        super.loadView()
//        self.automaticallyAdjustsScrollViewInsets = false
        self.hidesBottomBarWhenPushed = true
        self.view.backgroundColor = UIColor.groupTableViewBackground
    
        self.mainTextView = KMPlaceholderTextView(frame: CGRect.init(x: 0, y: 0, width: UIScreen.main.bounds.size.width - 30, height: 200))
        self.mainTextView?.translatesAutoresizingMaskIntoConstraints = false
        self.mainTextView?.delegate = self
        self.mainTextView?.layer.backgroundColor = UIColor.white.cgColor
        self.mainTextView?.layer.cornerRadius = 5
        self.mainTextView?.layer.masksToBounds = true
        self.view.addSubview(self.mainTextView ?? KMPlaceholderTextView())
        self.numberLabel = UILabel(frame: CGRect.init(x: UIScreen.main.bounds.size.width - 115, y: 165, width: 100, height: 20))
        self.numberLabel?.translatesAutoresizingMaskIntoConstraints = false
        self.numberLabel?.text = "0/200"
        self.numberLabel?.textColor = UIColor.lightGray
        self.numberLabel?.numberOfLines = 0
        self.numberLabel?.sizeToFit()
        self.view?.addSubview(self.numberLabel ?? UILabel())
        self.view?.bringSubviewToFront(self.numberLabel ?? UILabel())
        
        self.mainTextView?.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor,constant:15).isActive = true
        self.mainTextView?.leadingAnchor.constraint(equalTo: self.view.leadingAnchor,constant:15).isActive = true
        self.mainTextView?.trailingAnchor.constraint(equalTo: self.view.trailingAnchor,constant:-15).isActive = true
        
       self.mainTextView?.heightAnchor.constraint(equalTo: self.view.heightAnchor, multiplier: 0.6).isActive = true

        
        self.numberLabel?.bottomAnchor.constraint(equalTo: self.mainTextView?.bottomAnchor ?? NSLayoutAnchor(), constant: -15).isActive = true
        self.numberLabel?.trailingAnchor.constraint(equalTo: self.mainTextView?.trailingAnchor ?? NSLayoutAnchor(), constant: -15).isActive = true
        
        
        
   
        
        
    }
    override func viewDidLoad() {
        super.viewDidLoad()

        self.title = localized("chat.info.item.announcement")
        
        self.mainTextView?.placeholder = self.canEdit ? localized("chat.info.item.add_announcement"):""
        
        self.mainTextView?.isEditable = self.canEdit
        self.mainTextView?.text = data?.announcement
        
        self.numberLabel?.text = "\(data?.announcement?.count ?? 0)/200"

        self.numberLabel?.isHidden = !self.canEdit
        self.mainTextView?.font = UIFont.systemFont(ofSize: 15)
        // Do any additional setup after loading the view.
        
        let doneItem = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(GroupAnnouncementViewController.doneItemTapped(_:)))
        if canEdit == true{
            self.navigationItem.rightBarButtonItem = doneItem
        }else{
            self.navigationItem.rightBarButtonItem = nil
            
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
       
    }
    @objc func doneItemTapped(_ item:UIBarButtonItem){
        guard let announcement = self.mainTextView?.text else { return  }
        guard let rid = self.subscription?.rid else { return  }
        guard let type = self.subscription?.type else { return  }
        let request = RoomSetAnnouncementRequest(roomId: rid, roomType: type, announcement: announcement)
        
        API.current()?.fetch(request, completion: { (response) in
            switch response{
            case .resource(let result):
                print(result)
                
                try? Realm.current?.write {
                    self.subscription?.roomAnnouncement = result.raw?["announcement"].string
                    /*
                    if let subscriptionx = self.subscription{
                    
                    Realm.current?.add(subscriptionx, update: true)
                    }
                     
 */
                }
                self.alertSuccess(title: result.raw?.stringValue ?? "")
                self.navigationController?.dismiss(animated: true, completion: {
                    
                })
            case .error(let error):
                print(error)
                
                
                self.alert(title: localized("error.socket.default_error.title"), message: error.description)
            }
        })
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
extension GroupAnnouncementViewController:UITextViewDelegate{
    func textViewDidChange(_ textView: UITextView) {
        if textView.text.count > 200{
            let bufferString = textView.text
            guard let startIndex = bufferString?.startIndex else {return}
            guard let endIndex = bufferString?.index(startIndex, offsetBy: 200) else {return}
            guard let subString = bufferString?.prefix(upTo: endIndex) else {return}
            textView.text = String(subString)
            self.numberLabel?.text = "200/200"
        }
        self.numberLabel?.text = "\(textView.text.count)/200"
    }
}
