//
//  OtherItem.swift
//  DMSpeechKitVASample
//
//  Copyright © 2019 Nuance Communications Inc. All rights reserved.
//

import Foundation

class OtherItem: Model {
    var otherItemTitle: String?
    var otherItemDescription: String?
    var otherItemIntent: String?
    
    init(_ dialogResult: DialogResult?) {
        super.init(title: "")
        let titleC = titleConcept()
        self.otherItemTitle = titleC.count > 0 ? (titleC + ": " + ConceptsUtil.get(conceptName: titleC, dialogResult)) : ""
        let descC = descriptionConcept()
        self.otherItemDescription = descC.count > 0 ? (descriptionConcept() + ": " + ConceptsUtil.get(conceptName: descC, dialogResult)) : ""
        self.otherItemIntent = "Intent name: " + (dialogResult?.intent ?? "")
    }
    
    func titleConcept() -> String {
        return ""
    }
    
    func descriptionConcept() -> String {
        return ""
    }
}
