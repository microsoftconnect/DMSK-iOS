//
//  OtherItemFactory.swift
//  DMSpeechKitVASample
//
//  Copyright © 2019 Nuance Communications Inc. All rights reserved.
//

import Foundation

class OtherItemFactory {
    static func createOtherItem(_ eventDetail: EventDetail?) -> OtherItem {
        switch eventDetail?.nluResult.intent {
        case Constants.INTENT_OTHERS_TELL_ME_ITEM:
            return OthersTellMeItem(eventDetail)
        case Constants.INTENT_OTHERS_CANCEL_CONFIRM:
            return OthersCancelConfirm(eventDetail)
        case Constants.INTENT_OTHERS_SCHEDULE_SEARCH:
            return OthersScheduleSearch(eventDetail)
        case Constants.INTENT_OTHERS_CALL:
            return OthersCall(eventDetail)
        case Constants.INTENT_OTHERS_RETRIEVE_MESSAGE:
            return OthersRetrieveMessage(eventDetail)
        case Constants.INTENT_OTHERS_MEMBER_LOOKUP:
            return OthersMemberLookup(eventDetail)
        case Constants.INTENT_OTHERS_MEMBER_CLOSE:
            return OthersCloseMember(eventDetail)
        case Constants.INTENT_OTHERS_REPEAT_TTS:
            return OthersRepeatTTS(eventDetail)
        case Constants.INTENT_OTHERS_LIST_SELECTION:
            return OthersListSelection(eventDetail)
        case Constants.INTENT_OTHERS_LIST_NAVIGATION:
            return OthersListNavigation(eventDetail)
        case Constants.INTENT_OTHERS_NOTE:
            return OthersNote(eventDetail)
        default:
            return OtherItem(eventDetail)
        }
    }
}
