//
//  DataItemCell.swift
//  DMSpeechKitVASample
//
//  Copyright © 2019 Nuance Communications Inc. All rights reserved.
//

import UIKit

class DataItemCell: UITableViewCell {
    
    func populate(data: String?, label: UILabel) {
        if data?.count ?? 0 > 0 {
            label.text = data
        }
    }
    
    func populate(data: String?, unit: String?, label: UILabel) {
        if data?.count ?? 0 > 0 {
            label.text = data! + " " + (unit ?? Constants.UNIT_DEFAULT)
        }
    }
    
}
