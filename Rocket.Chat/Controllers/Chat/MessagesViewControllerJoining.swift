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
        ///点击加入通道——判断是否是只读通道，如果是，则把j控件都置灰不可操作
        ///注意这里y需要调接口拉一下数据
        let _ = API.current()?.client(SubscriptionsClient.self).api.fetch(RoomInfoRequest.init(roomId: self.subscription?.rid ?? ""), completion: { (response) in

            if(self.viewModel.subscription != nil && self.viewModel.subscription?.unmanaged?.roomReadOnly ?? false && AuthManager.currentUser()?.identifier != self.viewModel.subscription?.unmanaged?.roomOwnerId){

                self.composerView.leftButton.isEnabled = false
                self.composerView.rightButton.isEnabled = false
                self.composerView.textView.isEditable = false

            }
        })
        
    }
}
