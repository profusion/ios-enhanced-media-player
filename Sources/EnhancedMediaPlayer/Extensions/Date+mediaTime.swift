//  Date+mediaTime.swift

import Foundation

extension Date {
    private static let formatter: DateComponentsFormatter = .init()

    static func mediaTime(_ timeInSeconds: Float64, totalTimeInSeconds: Float64) -> String {
        formatter.allowedUnits = totalTimeInSeconds >= Constants.secondsPerHour
            ? [.hour, .minute, .second]
            : [.minute, .second]

        formatter.unitsStyle = .positional
        formatter.zeroFormattingBehavior = [.pad]

        return formatter.string(from: TimeInterval(timeInSeconds)) ?? Constants.fallback
    }
}

fileprivate enum Constants {
    static let secondsPerHour: Float64 = 3600
    static let fallback: String = "00:00"
}
