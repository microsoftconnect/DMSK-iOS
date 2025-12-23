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
    
    init(_ eventDetail: EventDetail?) {
        super.init(title: "")
        let title = titleEntity()
        self.otherItemTitle = title.count > 0 ? (title + ": " + EntitiesUtil.getEntityValue(entityName: title, eventDetail?.nluResult)) : ""
        let desc = descriptionEntity()
        self.otherItemDescription = desc.count > 0 ? (descriptionEntity() + ": " + EntitiesUtil.getEntityValue(entityName: desc, eventDetail?.nluResult)) : ""
        self.otherItemIntent = "Intent name: " + (eventDetail?.nluResult.intent ?? "")
    }
    
    func titleEntity() -> String {
        return ""
    }
    
    func descriptionEntity() -> String {
        return ""
    }
}
