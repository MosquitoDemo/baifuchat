//
//  MessagesViewControllerSearching.swift
//  Rocket.Chat
//
//  Created by Matheus Cardoso on 11/12/18.
//  Copyright © 2018 Rocket.Chat. All rights reserved.
//

extension MessagesViewController {
    func updateSearchMessagesButton() {
        if subscription != nil {
            navigationItem.rightBarButtonItem = UIBarButtonItem(
                image: UIImage(named: "Search"),
                style: .done,
                target: self,
                action: #selector(showSearchMessages)
//                action: #selector(showGroupMessages)

//                showGroupMessages
            )
        } else {
            navigationItem.rightBarButtonItem = nil
        }
    }

    @objc func showSearchMessages() {
        guard
            let controller = storyboard?.instantiateViewController(withIdentifier: "MessagesList"),
            let messageList = controller as? MessagesListViewController
            else {
                return
        }

        messageList.data.subscription = subscription
        messageList.data.isSearchingMessages = true
        let searchMessagesNav = BaseNavigationController(rootViewController: messageList)

        present(searchMessagesNav, animated: true, completion: nil)

    }
    
    //展示群组功能
    @objc func showGroupMessages() {
        guard
            let controller = storyboard?.instantiateViewController(withIdentifier: "MessagesGroup"),
            let messageList = controller as? MessagesViewControllerGroup
            else {
                return
        }
        
        
//        messageList.data.subscription = subscription
//        messageList.data.isSearchingMessages = true
        let searchMessagesNav = BaseNavigationController(rootViewController: messageList)
        
        present(searchMessagesNav, animated: true, completion: nil)
        
        
       
    }
    
    
//    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
//        if let membersList = segue.destination as? MessagesViewControllerGroup {
//            membersList.data.subscription = self.subscription
//        }
    
}
