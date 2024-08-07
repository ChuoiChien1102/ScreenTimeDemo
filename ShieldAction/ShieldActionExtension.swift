//
//  ShieldActionExtension.swift
//  ShieldAction
//
//  Created by Nguyen Van Chien on 6/8/24.
//

import ManagedSettings
import DeviceActivity
import Foundation
import UserNotifications
// Override the functions below to customize the shield actions used in various situations.
// The system provides a default response for any functions that your subclass doesn't override.
// Make sure that your class name matches the NSExtensionPrincipalClass in your Info.plist.
class ShieldActionExtension: ShieldActionDelegate {
    var applicationProfile: ApplicationProfile!
    
    func scheduleNotification(with title: String) {
        let center = UNUserNotificationCenter.current()
        center.requestAuthorization(options: [.alert, .sound, .badge]) { granted, error in
            if granted {
                let content = UNMutableNotificationContent()
                content.title = title // Using the custom title here
                content.body = "Someone have just opened application during lock time."
                content.sound = UNNotificationSound.default
                
                let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 5, repeats: false) // 5 seconds from now
                
                let request = UNNotificationRequest(identifier: "MyNotification", content: content, trigger: trigger)
                
                center.add(request) { error in
                    if let error = error {
                        print("Error scheduling notification: \(error)")
                    }
                }
            } else {
                print("Permission denied. \(error?.localizedDescription ?? "")")
            }
        }
    }
    
    override func handle(action: ShieldAction, for application: ApplicationToken, completionHandler: @escaping (ShieldActionResponse) -> Void) {
        // Handle the action as needed.
        switch action {
        case .primaryButtonPressed:
            scheduleNotification(with: "Notificaion")
//            createApplicationProfile(for: application)
//            startMonitoring()
//            unlockApp()
            completionHandler(.close)
        case .secondaryButtonPressed:
            completionHandler(.close)
        @unknown default:
            fatalError()
        }
    }
    
    override func handle(action: ShieldAction, for webDomain: WebDomainToken, completionHandler: @escaping (ShieldActionResponse) -> Void) {
        // Handle the action as needed.
        completionHandler(.close)
    }
    
    override func handle(action: ShieldAction, for category: ActivityCategoryToken, completionHandler: @escaping (ShieldActionResponse) -> Void) {
        // Handle the action as needed.
        completionHandler(.close)
    }
    
    func createApplicationProfile(for application: ApplicationToken) {
        print("createApplicationProfile")
        applicationProfile = ApplicationProfile(applicationToken: application)
        let dataBase = DataBase()
        dataBase.addApplicationProfile(applicationProfile)
    }
    // Start a device activity for this particular application
    func startMonitoring() {
        let unlockTime = 2
        let event: [DeviceActivityEvent.Name: DeviceActivityEvent] = [
            DeviceActivityEvent.Name(applicationProfile.id.uuidString) : DeviceActivityEvent(
                applications: Set<ApplicationToken>([applicationProfile.applicationToken]),
                threshold: DateComponents(minute: unlockTime)
            )
        ]
        
        let intervalEnd = Calendar.current.dateComponents(
            [.hour, .minute, .second],
            from: Calendar.current.date(byAdding: .minute, value: unlockTime, to: Date.now) ?? Date.now
        )
        let schedule = DeviceActivitySchedule(
            intervalStart: DateComponents(hour: 0, minute: 0),
            intervalEnd: intervalEnd,
            repeats: false
        )
        
        let center = DeviceActivityCenter()
        do {
            print("startMonitoring DeviceActivityName: \(applicationProfile.id.uuidString) during: \(schedule)")
            try center.startMonitoring(DeviceActivityName(applicationProfile.id.uuidString), during: schedule, events: event)
        } catch {
            print("Error monitoring schedule: \(error)")
        }
    }
    
    // remove the shield of this application
    func unlockApp() {
        print("unlockApp")
        let store = ManagedSettingsStore()
        store.shield.applications?.remove(applicationProfile.applicationToken)
    }
}
