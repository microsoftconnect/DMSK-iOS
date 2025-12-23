//
//  MessageItemCell.swift
//  DMSpeechKitVASample
//
//  Copyright © 2019 Nuance Communications Inc. All rights reserved.
//

import Foundation

class MessageItemCell: UITableViewCell {
    
    @IBOutlet weak var messageTitle: UILabel!
    @IBOutlet weak var messageText: UILabel!
    
    func updateData(_ data: MessageItem) {
        messageTitle?.text = data.recipient
        messageText?.text = data.message
    }
}
