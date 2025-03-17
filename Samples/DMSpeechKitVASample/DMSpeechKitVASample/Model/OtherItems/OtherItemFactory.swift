//
//  OtherItemFactory.swift
//  DMSpeechKitVASample
//
//  Copyright © 2019 Nuance Communications Inc. All rights reserved.
//

import Foundation

class OtherItemFactory {
    static func createOtherItem(_ dialogResult: DialogResult?) -> OtherItem {
        switch dialogResult?.intent {
        case Constants.INTENT_OTHERS_TELL_ME_ITEM:
            return OthersTellMeItem(dialogResult)
        case Constants.INTENT_OTHERS_CANCEL_CONFIRM:
            return OthersCancelConfirm(dialogResult)
        case Constants.INTENT_OTHERS_SCHEDULE_SEARCH:
            return OthersScheduleSearch(dialogResult)
        case Constants.INTENT_OTHERS_CALL:
            return OthersCall(dialogResult)
        case Constants.INTENT_OTHERS_RETRIEVE_MESSAGE:
            return OthersRetrieveMessage(dialogResult)
        case Constants.INTENT_OTHERS_MEMBER_LOOKUP:
            return OthersMemberLookup(dialogResult)
        case Constants.INTENT_OTHERS_MEMBER_CLOSE:
            return OthersCloseMember(dialogResult)
        case Constants.INTENT_OTHERS_REPEAT_TTS:
            return OthersRepeatTTS(dialogResult)
        case Constants.INTENT_OTHERS_LIST_SELECTION:
            return OthersListSelection(dialogResult)
        case Constants.INTENT_OTHERS_LIST_NAVIGATION:
            return OthersListNavigation(dialogResult)
        case Constants.INTENT_OTHERS_NOTE:
            return OthersNote(dialogResult)
        default:
            return OtherItem(dialogResult)
        }
    }
}
