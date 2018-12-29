//
//  GroupAnnouncementViewController.swift
//  Rocket.Chat
//
//  Created by Elen on 29/12/2018.
//  Copyright © 2018 Rocket.Chat. All rights reserved.
//

import UIKit


class GroupAnnouncementViewController: UIViewController {

    
    var canEdit:Bool = false
    var mainTextView:KMPlaceholderTextView?
    var numberLabel:UILabel?
    override func loadView() {
        super.loadView()
        self.automaticallyAdjustsScrollViewInsets = false
        self.hidesBottomBarWhenPushed = true
        self.view.backgroundColor = UIColor.groupTableViewBackground
    
        self.mainTextView = KMPlaceholderTextView(frame: .zero)
        self.mainTextView?.delegate = self
        self.mainTextView?.layer.backgroundColor = UIColor.white.cgColor
        self.mainTextView?.layer.cornerRadius = 5
        self.mainTextView?.layer.masksToBounds = true
        self.view.addSubview(self.mainTextView ?? KMPlaceholderTextView())
        self.numberLabel = UILabel()
        self.numberLabel?.text = "0/200"

        self.numberLabel?.textColor = UIColor.groupTableViewBackground
        self.numberLabel?.numberOfLines = 0
        self.mainTextView?.addSubview(self.numberLabel ?? UILabel())
        
        self.mainTextView?.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor,constant:15).isActive = true
        self.mainTextView?.leadingAnchor.constraint(equalTo: self.view.leadingAnchor,constant:15).isActive = true
        self.mainTextView?.trailingAnchor.constraint(equalTo: self.view.trailingAnchor,constant:15).isActive = true
        self.mainTextView?.heightAnchor.constraint(equalToConstant: 200).isActive = true
        self.numberLabel?.bottomAnchor.constraint(equalTo: self.mainTextView?.bottomAnchor ?? NSLayoutAnchor(), constant: 15).isActive = true
        self.numberLabel?.trailingAnchor.constraint(equalTo: self.mainTextView?.trailingAnchor ?? NSLayoutAnchor(), constant: 15).isActive = true
        
        
    }
    override func viewDidLoad() {
        super.viewDidLoad()

        self.title = localized("chat.info.item.topic")
        self.mainTextView?.placeholder = localized("chat.info.item.no_topic")
        self.mainTextView?.isEditable = self.canEdit
        // Do any additional setup after loading the view.
        
        let doneItem = UIBarButtonItem.init(barButtonSystemItem: .done, target: self, action: #selector(GroupAnnouncementViewController.doneItemTapped(_:)))
        if canEdit == true{
            self.navigationItem.rightBarButtonItem = doneItem
        }else{
            self.navigationItem.rightBarButtonItem = nil
            
        }
    }
    
    
    @objc func doneItemTapped(_ item:UIBarButtonItem){
        
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
