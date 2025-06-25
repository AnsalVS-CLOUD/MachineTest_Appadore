//
//  TimerUtility.swift
//  FlagsChallenge
//
//  Created by Ansal V S on 24/06/25.
//

import Foundation


class TimerUtility {
    static func createRepeatingTimer(interval: TimeInterval, handler: @escaping () -> Void) -> Timer {
        return Timer.scheduledTimer(withTimeInterval: interval, repeats: true) { _ in handler() }
    }
}
