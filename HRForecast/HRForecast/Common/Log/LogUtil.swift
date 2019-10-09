//
//  LogUtil.swift
//  OmniMobileApp
//
//  Created by Bonam, Sasikant on 7/11/18.
//  Copyright © 2018 U.S. Bank. All rights reserved.
//

import os
import Foundation

//Log Util to print logs.
class LogUtil: NSObject {

    private static let logPattern: StaticString = "%@:%d %@"

    static func logInfo(_ message: String, file: String = #file, line: Int = #line) {

        let fileName = URL(fileURLWithPath: file).lastPathComponent

        os_log(logPattern, log: OSLog.default, type: OSLogType.info, fileName, line, message)
    }

    static func logDebug(_ message: String, file: String = #file, line: Int = #line) {

        let fileName = URL(fileURLWithPath: file).lastPathComponent

        os_log(logPattern, log: OSLog.default, type: OSLogType.debug, fileName, line, message)
    }

    static func logError(_ message: String, file: String = #file, line: Int = #line) {

        let fileName = URL(fileURLWithPath: file).lastPathComponent

        os_log(logPattern, log: OSLog.default, type: OSLogType.error, fileName, line, message)
    }

    /// Application layer description
    ///
    /// - app: Application layer log
    /// - ui: User Experience layer log
    /// - network: Networking layer log
    /// - database: Database layer log
    enum Category: String {
        case app, ui, network
    }

    /// Log accessibility level
    ///
    /// - `public`: Log message will be visible in Console app
    /// - `private`: Log message won't be visible in Console app
    enum AccessLevel: String {
        case accessPublic
        case accessPrivate
    }

    /// Returns current thread name
    static var currentThread: String {
        var thread = String(format: "%p", Thread.current)
        if Thread.isMainThread {
            thread = "main"
        } else {
            if let threadName = Thread.current.name, !threadName.isEmpty {
                thread = "\(threadName)"
            } else if let queueName = String(validatingUTF8: __dispatch_queue_get_label(nil)), !queueName.isEmpty {
                thread = "\(queueName)"
            }
        }
        return thread
    }

    /// Creates OSLog object which describes log subsystem and category
    ///
    /// - Parameter category: Category, provided predefined log category
    /// - Returns: OSLog
    static func createOSLog(category: Category) -> OSLog {
        return OSLog(subsystem: Bundle.main.bundleIdentifier ?? "-", category: category.rawValue)
    }

    /// Prints provided log message with help of os_log function
    ///
    /// - Parameters:
    ///   - category: Category, provided predefined log category
    ///   - access: AccessLevel, log access level
    ///   - type: OSLogType, log type level, for example, .debug, .info, .error
    ///   - message: String, provided log message
    static func log(category: LogUtil.Category, message: String, access: LogUtil.AccessLevel = LogUtil.AccessLevel.accessPrivate, type: OSLogType = OSLogType.debug, fileName: String = #file, functionName: String = #function, lineNumber: Int = #line) {

        let file = (fileName as NSString).lastPathComponent
        let line = String(lineNumber)

        switch access {
        case .accessPrivate:
            os_log("[%{private}@] [%{private}@:%{private}@ %{private}@] > %{private}@", log: createOSLog(category: category), type: type, currentThread, file, line, functionName, message)
        case .accessPublic:
            os_log("[%{public}@] [%{public}@:%{public}@ %{public}@] > %{public}@", log: createOSLog(category: category), type: type, currentThread, file, line, functionName, message)
        }
        os_log("%@:%d %@", log: OSLog.default, type: OSLogType.error, fileName, line, message)
    }
}
