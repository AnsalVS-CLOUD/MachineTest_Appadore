//
//  TimeFormatterUtil.swift
//  FlagsChallenge
//
//  Created by Ansal V S on 24/06/25.
//

import Foundation

struct TimeFormatterUtil {
    static func formatTime(minutes: Int, seconds: Int) -> String {
        return String(format: "%02d:%02d", minutes, seconds)
    }
    
    static func formatSeconds(seconds: Int) -> String {
        let minutes = seconds / 60
        let secs = seconds % 60
        return String(format: "%02d:%02d", minutes, secs)
    }
}

