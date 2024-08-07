//
//  ShieldManager.swift
//  ScreenTimeDemo
//
//  Created by Nguyen Van Chien on 6/8/24.
//

import SwiftUI
import FamilyControls
import ManagedSettings
import DeviceActivity

class ShieldManager: ObservableObject {
    @Published var discouragedSelections = FamilyActivitySelection()
    
    private let store = ManagedSettingsStore()
    
    func shieldActivities() {
        // Clear to reset previous settings
        store.clearAllSettings()
                     
        let applications = discouragedSelections.applicationTokens
        let categories = discouragedSelections.categoryTokens
        if !applications.isEmpty {
            print("applications: \(applications)")
        }
        if !categories.isEmpty {
            print("categories: \(categories)")
        }
        // block all activities
        store.shield.applications = applications.isEmpty ? nil : applications
        store.shield.applicationCategories = categories.isEmpty ? nil : .specific(categories)
        store.shield.webDomainCategories = categories.isEmpty ? nil : .specific(categories)
        
        // start monitoring
        startMonitoring()
    }
    
    func startMonitoring() {
        let timeLimitMinutes = 1
        let event = DeviceActivityEvent(
            applications: discouragedSelections.applicationTokens,
            categories: discouragedSelections.categoryTokens,
            webDomains: discouragedSelections.webDomainTokens,
            threshold: DateComponents(minute: timeLimitMinutes)
        )
        
        let intervalEnd = Calendar.current.dateComponents(
            [.hour, .minute, .second],
            from: Calendar.current.date(byAdding: .minute, value: timeLimitMinutes, to: Date.now) ?? Date.now
        )
        let schedule = DeviceActivitySchedule(
            intervalStart: DateComponents(hour: 0, minute: 0),
            intervalEnd: intervalEnd,
            repeats: false
        )
        
        let center = DeviceActivityCenter()
        do {
            print("startMonitoring DeviceActivityName: \(UUID().uuidString) during: \(schedule)")
            try center.startMonitoring(DeviceActivityName(UUID().uuidString), during: schedule, events: [DeviceActivityEvent.Name(UUID().uuidString): event])
        } catch {
            print("Error monitoring schedule: \(error)")
        }
    }
    
    func unlockActivities() {
        self.store.shield.applications?.removeAll()
    }
}
