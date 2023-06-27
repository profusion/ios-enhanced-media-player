// SettingsPreferences.swift
import Combine

public class SettingsPreferences: ObservableObject {
    public init() {}
    
    @Published public var isShowingSettingsMenu: Bool = false
}
