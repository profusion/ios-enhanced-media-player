// SettingsPreferences.swift
import Combine

public class SettingsPreferences: ObservableObject {
    public init() {}
    
    @Published public var isShowingSettingsMenu: Bool = false
    @Published public var rate: PlaybackSpeedValues = .defaultSpeed
}

extension SettingsPreferences {
    public enum PlaybackSpeedValues: Float, CaseIterable {
        case speed_0_25 = 0.25
        case speed_0_5 = 0.5
        case speed_0_75 = 0.75
        case defaultSpeed = 1.0
        case speed_1_25 = 1.25
        case speed_1_5 = 1.5
        case speed_1_75 = 1.75
        case speed_2_0 = 2.0
    }
}
