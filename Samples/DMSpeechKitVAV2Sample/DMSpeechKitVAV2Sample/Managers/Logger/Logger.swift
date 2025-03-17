//
//  Logger.swift
//  DMSpeechKitVASample
//
//  Copyright © 2019 Nuance Communications Inc. All rights reserved.
//

import Foundation

protocol LoggerStateListener: class {
    /**
     Called when new data is added to the Logger buffer
     */
    func loggerBufferUpdated()
}

final class Logger {
    
    private static var buffer = ""
    private static let semaphore = DispatchSemaphore(value: 1)
    private static var queue = Logger.getLoggerQueue()

    static weak var delegate: LoggerStateListener? = nil

    // Get a queue for logger
    private static func getLoggerQueue() -> OperationQueue {
        let newQueue = OperationQueue()
        newQueue.maxConcurrentOperationCount = 1
        return newQueue
    }

    // Fetch the logger buffer
    internal static func getLoggerDump() -> String {
        var tempBuffer: String
        Logger.semaphore.wait()
        tempBuffer = String(Logger.buffer)
        Logger.semaphore.signal()
        return tempBuffer
    }
    
    internal static func log(_ log: String) {
        print("DMVA Logger: \(log)")
        Logger.queue.addOperation {
            Logger.semaphore.wait()
            Logger.buffer.append("\n\(log)")
            Logger.semaphore.signal()
            OperationQueue.main.addOperation({
                delegate?.loggerBufferUpdated()
            })
        }
    }
}

