//
//  MessagesViewControllerJoining.swift
//  Rocket.Chat
//
//  Created by Matheus Cardoso on 11/14/18.
//  Copyright © 2018 Rocket.Chat. All rights reserved.
//

import RealmSwift

extension MessagesViewController {
    private func showChatPreviewModeView() {
        chatPreviewModeView?.removeFromSuperview()

        if let previewView = ChatPreviewModeView.instantiateFromNib() {
            previewView.delegate = self
            previewView.subscription = subscription
            previewView.translatesAutoresizingMaskIntoConstraints = false

            view.addSubview(previewView)

            NSLayoutConstraint.activate([
                previewView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
                previewView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
                previewView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
            ])

            chatPreviewModeView = previewView
            updateChatPreviewModeViewConstraints()

            previewView.applyTheme()
        }
    }

    func updateJoinedView() {
        guard !subscription.isInvalidated else { return }

        if subscription.isJoined() {
            composerView.isHidden = false
            chatPreviewModeView?.removeFromSuperview()
        } else {
            composerView.isHidden = true
            showChatPreviewModeView()

            if let view = chatPreviewModeView {
                collectionView.contentInset.top = -(view.frame.height + view.bottomInset)
                collectionView.scrollIndicatorInsets = collectionView.contentInset
            }
        }
    }

    private func updateChatPreviewModeViewConstraints() {
        chatPreviewModeView?.bottomInset = view.safeAreaInsets.bottom
    }
}

extension MessagesViewController: ChatPreviewModeViewProtocol {
    func userDidJoinedSubscription() {
        guard let auth = AuthManager.isAuthenticated() else { return }
        guard let subscription = self.subscription else { return }

        Realm.executeOnMainThread({ realm in
            subscription.auth = auth
            subscription.open = true
            realm.add(subscription, update: true)
        })

        self.subscription = subscription
        
        
        
        ///added by steve
//        if(self.subscription != nil && self.subscription.unmanaged?.roomReadOnly ?? false && AuthManager.currentUser()?.identifier != self.subscription.unmanaged?.roomOwnerId){
//
//            composerView.leftButton.isEnabled = false
//            composerView.rightButton.isEnabled = false
//            composerView.textView.isEditable = false
//
//        }
//
//        ///通知SubscriptionViewController刷新subscriptions
//        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "please_fetch_subscriptions"), object: nil)
        
//        self.viewDidAppear(false)
        
        ///added by steve
//        let _ = API.current()?.client(SubscriptionsClient.self).api.fetch(RoomInfoRequest.init(roomId: self.subscription?.rid ?? ""), completion: { (response) in
//            switch response {
//            case .resource(let resultx):
//                print(resultx)
//
//                if(self.subscription != nil && self.subscription.unmanaged?.roomReadOnly ?? false && AuthManager.currentUser()?.identifier != self.subscription.unmanaged?.roomOwnerId){
//
//                    self.composerView.leftButton.isEnabled = false
//                    self.composerView.rightButton.isEnabled = false
//                    self.composerView.textView.isEditable = false
//
//                }
//
//            case .error(let error):
//                print(error)
//            }
//        })
        
        
    }
}
