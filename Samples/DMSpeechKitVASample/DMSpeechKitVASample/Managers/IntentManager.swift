//
//  IntentManager.swift
//  DMSpeechKitVASample
//
//  Copyright © 2019 Nuance Communications Inc. All rights reserved.
//

import Foundation

protocol IntentManager {
    /**
     Setting the screen at the launch
     */
    func setInitialScreen(type: ScreenType)
    
    /**
     Class listening for different intent results
     */
    func intentDelegate(_ delegate: IntentDelegate)
    
    /**
     Returns the provider of a type
     */
    func getProviderType(_ type: ScreenType) -> CellDataProvider?
    
    /**
     Handles update in the dialog when it completes
     */
    func intentUpdate(_ dialogResult: DialogResult?)
}

class IntentManagerImpl: IntentManager  {
    
    static let shared: IntentManager = IntentManagerImpl()
    weak var delegate: IntentDelegate?
    var ongoingDialog: DialogResult?

    let homeDataProvider = DataProviderFactory.createDataProvider(type: ScreenType.HOME)
    let medicationDataProvider = DataProviderFactory.createDataProvider(type: ScreenType.MEDICATION)
    let messagesDataProvider = DataProviderFactory.createDataProvider(type: ScreenType.MESSAGES)
    let remindersDataProvider = DataProviderFactory.createDataProvider(type: ScreenType.REMINDER)
    let otherDataProvider = DataProviderFactory.createDataProvider(type: ScreenType.OTHER)
    let showMeDataProvider = DataProviderFactory.createDataProvider(type: ScreenType.SHOWME)
    let notesDataProvider = DataProviderFactory.createDataProvider(type: ScreenType.NOTES)
    
    private init() {
        initializeStaticData()
    }
    
    // MARK: IntentManager
    internal func setInitialScreen(type: ScreenType) {
        delegate?.showScreen(type: type)
    }
    
    internal func intentDelegate(_ delegate: IntentDelegate) {
        self.delegate = delegate
    }
    
    internal func getProviderType(_ type: ScreenType) -> CellDataProvider? {
        switch type {
        case ScreenType.HOME:
            return homeDataProvider
        case ScreenType.MEDICATION:
            return medicationDataProvider
        case ScreenType.MESSAGES:
            return messagesDataProvider
        case ScreenType.REMINDER:
            return remindersDataProvider
        case ScreenType.OTHER:
            return otherDataProvider
        case ScreenType.SHOWME:
            return showMeDataProvider
        case ScreenType.NOTES:
            return notesDataProvider
        default:
            fatalError("Wrong ScreenType")
        }
    }
    
    internal func intentUpdate(_ dialogResult: DialogResult?) {
        let type = dialogResult?.screenType
        switch type {
        case ScreenType.HOME:
            delegate?.showScreen(type: ScreenType.HOME)
        case ScreenType.MEDICATION:
            let provider = getProviderType(ScreenType.MEDICATION)
            provider?.add(item: MedicationItem(dialogResult))
            delegate?.showScreen(type: ScreenType.MEDICATION)
        case ScreenType.MESSAGES:
            let provider = getProviderType(ScreenType.MESSAGES)
            provider?.add(item: MessageItem(dialogResult))
            delegate?.showScreen(type: ScreenType.MESSAGES)
        case ScreenType.OTHER:
            let provider = getProviderType(ScreenType.OTHER)
            provider?.add(item: OtherItemFactory.createOtherItem(dialogResult))
            delegate?.showScreen(type: ScreenType.OTHER)
        case ScreenType.SHOWME:
            let provider = getProviderType(ScreenType.SHOWME)
            provider?.add(item: ShowMeItemFactory.createShowMeItem(dialogResult))
            delegate?.showScreen(type: ScreenType.SHOWME)
        case ScreenType.REMINDER:
            let provider = getProviderType(ScreenType.REMINDER)
            provider?.add(item: ReminderItem(dialogResult))
            delegate?.showScreen(type: ScreenType.REMINDER)
        case ScreenType.HELP:
            delegate?.showHelp()
        case ScreenType.NOTES:
            if (dialogResult?.isDictationRequested)! {
                delegate?.startDictation()
            } else {
                delegate?.showScreen(type: ScreenType.NOTES)
            }
        case ScreenType.SETTING:
            delegate?.showSettings()
        default:
            break
        }
    }

    private func initializeStaticData() {
        homeDataProvider.add(item: HomeItem())
        notesDataProvider.add(item: NotesItem(title: ""))
    }
}
