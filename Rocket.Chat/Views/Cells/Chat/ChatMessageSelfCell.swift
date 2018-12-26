//
//  ChatMessageSelfCell.swift
//  Rocket.Chat
//
//  Created by Elen on 26/12/2018.
//  Copyright © 2018 Rocket.Chat. All rights reserved.
//

import UIKit

// swiftlint:disable file_length

 class ChatMessageSelfCell: UICollectionViewCell {
    static let minimumHeight = CGFloat(55)
//    static let identifier = "ChatMessageSelfCell"
    
    weak var longPressGesture: UILongPressGestureRecognizer?
    weak var usernameTapGesture: UITapGestureRecognizer?
    weak var avatarTapGesture: UITapGestureRecognizer?
    weak var delegate: ChatMessageCellProtocol? {
        didSet {
            labelSelfText.delegate = delegate
        }
    }
    
    var message: Message! {
        didSet {
            if oldValue != nil && oldValue == message {
                return
            }
            
            updateMessage()
        }
    }
    
    var settings: AuthSettings? {
        return AuthManager.isAuthenticated()?.settings
    }
    
    @IBOutlet weak var avatarViewSelfContainer: UIView! {
        didSet {
            avatarViewSelfContainer.layer.cornerRadius = 4
            avatarView.frame = avatarViewSelfContainer.bounds
            avatarViewSelfContainer.addSubview(avatarView)
        }
    }
    
    lazy var avatarView: AvatarView = {
        let avatarView = AvatarView()
        avatarView.layer.cornerRadius = 4
        avatarView.layer.masksToBounds = true
        return avatarView
    }()
    
    @IBOutlet weak var labelSelfDate: UILabel!
    @IBOutlet weak var labelSelfUsername: UILabel!
    @IBOutlet weak var labelSelfText: RCTextView!
    
    @IBOutlet weak var statusSelfView: UIImageView!
    
    @IBOutlet weak var mediaSelfViews: UIStackView!

    @IBOutlet weak var mediaSelfViewsHeightConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var reactionsListSelfView: ReactionListView! {
        didSet {
            reactionsListSelfView.reactionTapRecognized = { view, sender in
                let client = API.current()?.client(MessagesClient.self)
                client?.reactMessage(self.message, emoji: view.model.emoji)
                
                if self.isAddingReaction(emoji: view.model.emoji) {
                    UserReviewManager.shared.requestReview()
                }
            }
            
            reactionsListSelfView.reactionLongPressRecognized = { view, sender in
                self.delegate?.handleLongPress(reactionListView: self.reactionsListSelfView, reactionView: view)
            }
        }
    }
    
    private func isAddingReaction(emoji tappedEmoji: String) -> Bool {
        guard let currentUser = AuthManager.currentUser()?.username else {
            return false
        }
        
        if Array(message.reactions).first(where: { $0.emoji == tappedEmoji && Array($0.usernames).contains(currentUser) }) != nil {
            return false
        }
        
        return true
    }
    
    @IBOutlet weak var reactionsListSelfViewConstraint: NSLayoutConstraint!
    
    // MARK: Sequential
    @IBOutlet weak var labelSelfUsernameHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var labelSelfDateHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var avatarSelfContainerHeightConstraint: NSLayoutConstraint!
    
    var sequential: Bool = false {
        didSet {
            avatarSelfContainerHeightConstraint.constant = sequential ? 0 : 35
            labelSelfUsernameHeightConstraint.constant = sequential ? 0 : 21
            labelSelfDateHeightConstraint.constant = sequential ? 0 : 21
        }
    }
    
    // MARK: Read Receipt
    
    @IBOutlet weak var readReceiptSelfButton: UIButton!
    @IBOutlet weak var readReceiptSelfConstraint: NSLayoutConstraint!
    
    func updateReadReceipt() {
        guard let settings = settings else {
            return
        }
        
        if settings.messageReadReceiptEnabled {
            readReceiptSelfConstraint.constant = 12.0
        } else {
            readReceiptSelfConstraint.constant = 0.0
        }
        
        let image = UIImage(named: "Check")?.imageWithTint(message.unread ? #colorLiteral(red: 0.6, green: 0.6, blue: 0.6, alpha: 1) : #colorLiteral(red: 0.1137254902, green: 0.4549019608, blue: 0.9607843137, alpha: 1), alpha: 0.0)
        readReceiptSelfButton.setImage(image, for: .normal)
    }
    
    @IBAction func readReceipt(_ sender: UIButton) {
    
        guard
            let settings = settings,
            settings.messageReadReceiptStoreUsers
            else {
                return
        }
        
        delegate?.handleReadReceiptPress(message, source: (readReceiptSelfButton, readReceiptSelfButton.frame))
    }
    
    
    override func prepareForReuse() {
        super.prepareForReuse()
        labelSelfUsername.text = ""
        labelSelfText.message = nil
        labelSelfText.textView.textAlignment = .right

        labelSelfDate.text = ""
        
        sequential = false
        message = nil
        
        avatarView.prepareForReuse()
        
        for view in mediaSelfViews.arrangedSubviews {
            mediaSelfViews.removeArrangedSubview(view)
            view.removeFromSuperview()
        }
    }
    override func awakeFromNib() {
        super.awakeFromNib()
        labelSelfText.textView.textAlignment = .right
    }
    func insertGesturesIfNeeded() {
        if longPressGesture == nil {
            let gesture = UILongPressGestureRecognizer(target: self, action: #selector(handleLongPressMessageCell(recognizer:)))
            gesture.minimumPressDuration = 0.325
            gesture.delegate = self
            addGestureRecognizer(gesture)
            
            longPressGesture = gesture
        }
        
        if usernameTapGesture == nil {
            let gesture = UITapGestureRecognizer(target: self, action: #selector(handleUsernameTapGestureCell(recognizer:)))
            gesture.delegate = self
            labelSelfUsername.addGestureRecognizer(gesture)
            
            usernameTapGesture = gesture
        }
        
        if avatarTapGesture == nil {
            let gesture = UITapGestureRecognizer(target: self, action: #selector(handleUsernameTapGestureCell(recognizer:)))
            gesture.delegate = self
            avatarView.addGestureRecognizer(gesture)
            
            avatarTapGesture = gesture
        }
    }
    
    func insertButtonActions() -> CGFloat {
        var addedHeight = CGFloat(0)
        
        if message.isBroadcastReplyAvailable() {
            if let view = ChatMessageActionButtonsView.instantiateFromNib() {
                view.message = message
                view.delegate = delegate
                
                mediaSelfViews.addArrangedSubview(view)
                addedHeight += ChatMessageActionButtonsView.defaultHeight
            }
        }
        
        return addedHeight
    }
    
    func insertURLs() -> CGFloat {
        var addedHeight = CGFloat(0)
        message.urls.forEach { url in
            guard url.isValid() else { return }
            if let view = ChatMessageURLView.instantiateFromNib() {
                view.url = url
                view.delegate = delegate
                
                mediaSelfViews.addArrangedSubview(view)
                addedHeight += ChatMessageURLView.defaultHeight
            }
        }
        return addedHeight
    }
    
    func insertAttachments() {
        var mediaViewHeight = CGFloat(0)
        mediaViewHeight += insertURLs()
        
        message.attachments.forEach { attachment in
            let type = attachment.type
            
            switch type {
            case .textAttachment: mediaViewHeight += insertTextAttachment(attachment)
            case .image: mediaViewHeight += insertImageAttachment(attachment)
            case .video: mediaViewHeight += insertVideoAttachment(attachment)
            case .audio: mediaViewHeight += insertAudioAttachment(attachment)
            default: return
            }
        }
        
        mediaViewHeight += insertButtonActions()
        mediaSelfViewsHeightConstraint.constant = CGFloat(mediaViewHeight)
    }
    
    fileprivate func updateMessageHeader() {
        if let createdAt = message.createdAt {
            labelSelfDate.text = RCDateFormatter.time(createdAt)
        }
        
        avatarView.emoji = message.emoji
        avatarView.username = message.user?.username
        
        if let avatar = message.avatar {
            avatarView.avatarURL = URL(string: avatar)
        }
        
        labelSelfUsername.text = message.user?.displayName() ?? "Unknown"
        
        if message.alias.count > 0 {
            labelSelfUsername.text = message.alias
        }
    }
    
    fileprivate func updateMessageContent(force: Bool = false) {
        guard let unmanagedMessage = message.unmanaged else {
            return
        }
        
        if let text = force ? MessageTextCacheManager.shared.update(for: unmanagedMessage, with: theme) : MessageTextCacheManager.shared.message(for: unmanagedMessage, with: theme) {
            if message.temporary {
                text.setFontColor(MessageTextFontAttributes.systemFontColor(for: theme))
                
            } else if message.failed {
                text.setFontColor(MessageTextFontAttributes.failedFontColor(for: theme))
            }
            let ps = NSMutableParagraphStyle()
            ps.alignment = .right
            text.setAttributes([NSAttributedString.Key.paragraphStyle:ps], range: NSRange.init(location: 0, length: text.length))
            labelSelfText.message = text
        }
    }
    
    fileprivate func updateMessage() {
        guard let message = message else { return }
        
        if message.failed {
            statusSelfView.isHidden = false
            statusSelfView.image = UIImage(named: "Exclamation")?.withRenderingMode(.alwaysTemplate)
            statusSelfView.tintColor = .red
        } else {
            statusSelfView.isHidden = true
        }
        
        if !sequential {
            updateMessageHeader()
        }
        
        updateMessageContent()
        insertGesturesIfNeeded()
        insertAttachments()
        updateReactions()
        updateReadReceipt()
    }
    
    @objc func handleLongPressMessageCell(recognizer: UIGestureRecognizer) {
        delegate?.handleLongPressMessageCell(message, view: contentView, recognizer: recognizer)
    }
    
    @objc func handleUsernameTapGestureCell(recognizer: UIGestureRecognizer) {
        delegate?.handleUsernameTapMessageCell(message, view: labelSelfUsername, recognizer: recognizer)
    }
}

extension ChatMessageSelfCell: UIGestureRecognizerDelegate {
    
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRequireFailureOf otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        return false
    }
    
}

// MARK: Height calculation

extension ChatMessageSelfCell {
    
    static func cellMediaHeightFor(message: Message, width: CGFloat, sequential: Bool = true) -> CGFloat {
        guard let unmanagedMessage = message.unmanaged else {
            return 0
        }
        
        let attributedString = MessageTextCacheManager.shared.message(for: unmanagedMessage, with: nil)
        
        var total = (CGFloat)(sequential ? 8 : 29) + (message.reactions.count > 0 ? 40 : 0)
        if attributedString?.string ?? "" != "" {
            total += (attributedString?.heightForView(withWidth: width - 62) ?? 0)
        }
        
        if message.isBroadcastReplyAvailable() {
            total += ChatMessageActionButtonsView.defaultHeight
        }
        
        for url in message.urls {
            guard url.isValid() else { continue }
            total += ChatMessageURLView.defaultHeight
        }
        
        for attachment in message.attachments {
            let type = attachment.type
            
            if type == .textAttachment {
                total += ChatMessageTextView.heightFor(with: width, collapsed: attachment.collapsed, text: attachment.text, isFile: attachment.isFile)
            }
            
            if type == .image {
                total += ChatMessageImageView.heightFor(with: width, description: attachment.descriptionText)
            }
            
            if type == .video {
                total += ChatMessageVideoView.heightFor(with: width, description: attachment.descriptionText)
            }
            
            if type == .audio {
                total += ChatMessageAudioView.heightFor(with: width, description: attachment.descriptionText)
            }
            
            if !attachment.collapsed {
                attachment.fields.forEach {
                    total += ChatMessageTextView.heightFor(with: width, collapsed: false, text: $0.value)
                }
            }
        }
        
        return total
    }
}

// MARK: Reactions

extension ChatMessageSelfCell {
    fileprivate func updateReactions() {
        let username = AuthManager.currentUser()?.username
        
        let models = Array(message.reactions.map { reaction -> ReactionViewModel in
            let highlight: Bool
            if let username = username {
                highlight = reaction.usernames.contains(username)
            } else {
                highlight = false
            }
            
            let emoji = reaction.emoji ?? "?"
            let imageUrl = CustomEmoji.withShortname(emoji)?.imageUrl()
            
            return ReactionViewModel(
                emoji: emoji,
                imageUrl: imageUrl,
                count: reaction.usernames.count.description,
                highlight: highlight,
                reactors: Array(reaction.usernames)
            )
        })
        
        reactionsListSelfView.model = ReactionListViewModel(reactionViewModels: models)
        
        if message.reactions.count > 0 {
            reactionsListSelfView.isHidden = false
            reactionsListSelfViewConstraint.constant = 40
        } else {
            reactionsListSelfView.isHidden = true
            reactionsListSelfViewConstraint.constant = 0
        }
    }
}

// MARK: Insert attachments

extension ChatMessageSelfCell {
    private func insertTextAttachment(_ attachment: Attachment) -> CGFloat {
        guard let view = ChatMessageTextView.instantiateFromNib() else { return 0 }
        view.viewModel = ChatMessageTextViewModel(withAttachment: attachment)
        view.delegate = delegate
        view.translatesAutoresizingMaskIntoConstraints = false
        
        mediaSelfViews.addArrangedSubview(view)
        
        let availableWidth = frame.size.width
        var attachmentHeight = ChatMessageTextView.heightFor(with: availableWidth, collapsed: attachment.collapsed, text: attachment.text, isFile: attachment.isFile)
        
        if !attachment.collapsed {
            attachment.fields.forEach {
                guard let view = ChatMessageTextView.instantiateFromNib() else { return }
                view.viewModel = ChatMessageAttachmentFieldViewModel(withAttachment: attachment, andAttachmentField: $0)
                mediaSelfViews.addArrangedSubview(view)
                attachmentHeight += ChatMessageTextView.heightFor(with: availableWidth, collapsed: false, text: $0.value)
            }
        }
        
        return attachmentHeight
    }
    
    private func insertImageAttachment(_ attachment: Attachment) -> CGFloat {
        guard let view = ChatMessageImageView.instantiateFromNib() else { return 0 }
        view.attachment = attachment
        view.delegate = delegate
        view.translatesAutoresizingMaskIntoConstraints = false
        mediaSelfViews.addArrangedSubview(view)
        
        let availableWidth = frame.size.width
        return ChatMessageImageView.heightFor(with: availableWidth, description: attachment.descriptionText)
    }
    
    private func insertVideoAttachment(_ attachment: Attachment) -> CGFloat {
        guard let view = ChatMessageVideoView.instantiateFromNib() else { return 0 }
        view.attachment = attachment
        view.delegate = delegate
        view.translatesAutoresizingMaskIntoConstraints = false
        mediaSelfViews.addArrangedSubview(view)
        
        let availableWidth = frame.size.width
        return ChatMessageImageView.heightFor(with: availableWidth, description: attachment.descriptionText)
    }
    
    private func insertAudioAttachment(_ attachment: Attachment) -> CGFloat {
        guard let view = ChatMessageAudioView.instantiateFromNib() else { return 0 }
        view.attachment = attachment
        view.translatesAutoresizingMaskIntoConstraints = false
        mediaSelfViews.addArrangedSubview(view)
        
        let availableWidth = frame.size.width
        return ChatMessageImageView.heightFor(with: availableWidth, description: attachment.descriptionText)
    }
}

// MARK: Themeable

extension ChatMessageSelfCell {
    override func applyTheme() {
        super.applyTheme()
        guard let theme = theme else { return }
        labelSelfDate.textColor = theme.auxiliaryText
        labelSelfUsername.textColor = theme.titleText
        updateMessageContent(force: true)
    }
}
