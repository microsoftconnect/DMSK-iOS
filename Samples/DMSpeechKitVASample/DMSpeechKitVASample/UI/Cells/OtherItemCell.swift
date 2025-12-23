//
//  OtherItemCell.swift
//  DMSpeechKitVASample
//
//  Copyright © 2019 Nuance Communications Inc. All rights reserved.
//

import UIKit

class OtherItemCell: UITableViewCell {
    
    @IBOutlet weak var intentName: UILabel!
    @IBOutlet weak var otherSubject: UILabel!
    @IBOutlet weak var otherDetail: UILabel!
    
    func updateData(_ data: OtherItem) {
        intentName?.text = data.otherItemIntent
        otherSubject?.text = data.otherItemTitle
        otherDetail?.text = data.otherItemDescription
    }
}
