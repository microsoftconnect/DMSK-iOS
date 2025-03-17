//
//  NotesTracker.swift
//  DMSpeechKitVASample
//
//  Copyright © 2019 Nuance Communications Inc. All rights reserved.
//

import Foundation

protocol NotesTracker {
    /**
     In dictation, save the current state of notes to be resumed from the same state
     */
    func setNotes(_ notes: String)
    
    /**
     Fetching the last saved state of notes
     */
    func notes() -> String
}

class NotesTrackerImpl: NotesTracker {
    
    static let shared = NotesTrackerImpl()
    private var notesBuffer = ""
    
    private init() { }
    
    internal func setNotes(_ notes: String) {
        notesBuffer = String(notes)
    }
    
    internal func notes() -> String {
        return notesBuffer
    }
}
