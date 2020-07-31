//
//  Logs.swift
//  direct-type
//
//  Created by ms-mb015 on 2020/05/08.
//  Copyright © 2020 ms-mb015. All rights reserved.
//

import UIKit

public struct Log {
    private static var dateString: String {
        let date = Date()
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy/MM/dd HH:mm:ss"
        return formatter.string(from: date)
    }

    public enum LogLevel: String {
        case verbose
        case progress
        case debug
        case info
        case warn
        case error
    }
    
    public static func selectLog(logLevel: LogLevel,file: String = #file, function: String = #function, line: Int = #line, _ message: String = "") {
        switch logLevel {
        case .error:
            printToConsole(logLevel: .error, file: file, function: function, line: line, message: message)
            //assertionFailure(message)
            LogManager.appendLog(.ALWAYS, "Log.selectLog", message)
            print(message)
        default:
            printToConsole(logLevel: logLevel, file: file, function: function, line: line, message: message)
        }
    }

    private static func className(from filePath: String) -> String {
        let fileName = filePath.components(separatedBy: "/").last
        return fileName?.components(separatedBy: ".").first ?? ""
    }

    private static func printToConsole(logLevel: LogLevel, file: String, function: String, line: Int, message: String) {
        #if DEBUG
            print("\(dateString) [\(logLevel.rawValue.uppercased())] \(className(from: file)).\(function) #\(line): \(message)")
        #endif
    }
}

/// 通常ログ表示
func debugLog(_ obj: Any?,
              function: String = #function,
              line: Int = #line) {
    #if DEBUG
        if let obj = obj {
            print("DEBUG [Function:\(function) Line:\(line)] : \(obj)")
        } else {
            print("DEBUG [Function:\(function) Line:\(line)]")
        }
    #endif
}

func apiLog(_ obj: Any?,
          function: String = #function,
          line: Int = #line) {
    #if DEBUG
        if let obj = obj {
            print("API [Function:\(function) Line:\(line)] : \(obj)")
        } else {
            print("API [Function:\(function) Line:\(line)]")
        }
    #endif
}

