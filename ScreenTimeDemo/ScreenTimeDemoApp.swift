//
//  ScreenTimeDemoApp.swift
//  ScreenTimeDemo
//
//  Created by Nguyen Van Chien on 6/8/24.
//

import SwiftUI
import FamilyControls

@main
struct ScreenTimeDemoApp: App {
    
    let center = AuthorizationCenter.shared
    var body: some Scene {
        WindowGroup {
            ContentView()
                .task {
                    do {
                        print("try requestAuthorization")
                        try await center.requestAuthorization(for: FamilyControlsMember.individual)
                        print("requestAuthorization success")
                        switch center.authorizationStatus {
                        case .notDetermined:
                            print("not determined")
                        case .denied:
                            print("denied")
                        case .approved:
                            print("approved")
                        @unknown default:
                            break
                        }
                    } catch {
                        print("Failed to get authorization: \(error)")
                    }
                }
        }
    }
}
