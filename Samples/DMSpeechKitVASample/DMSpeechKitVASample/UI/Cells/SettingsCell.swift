//
//  SettingsCell.swift
//  DMSpeechKitVASample
//
//  Copyright © 2019 Nuance Communications Inc. All rights reserved.
//

import UIKit

class SettingsCell: UITableViewCell, UITextViewDelegate {
    
    @IBOutlet weak var settingsTitle: UILabel?
    @IBOutlet weak var settingsValue: UITextView?
    
    var setting: Setting?
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        if text == "\n" {
            textView.resignFirstResponder()
            setting?.value = textView.text
            return false
        }
        return true
    }
    
    func setSetting(setting: Setting) {
        self.setting = setting
        settingsTitle?.text = setting.key
        settingsValue?.text = setting.value
        settingsValue?.isEditable = setting.editable
    }
    
}
