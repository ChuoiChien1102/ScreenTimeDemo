//
//  ContentView.swift
//  ScreenTimeDemo
//
//  Created by Nguyen Van Chien on 6/8/24.
//

import SwiftUI
import FamilyControls
import DeviceActivity

struct ContentView: View {
    
    @StateObject private var manager = ShieldManager()
    @State private var showActivityPicker = false
    @State private var isGetActivityReport = false
    @State private var context: DeviceActivityReport.Context = .init(rawValue: "Total Activity")
    @State private var filter = DeviceActivityFilter()
    @State private var selection = FamilyActivitySelection()
    
    var body: some View {
        if #available(iOS 17.0, *) {
            VStack {
                Button {
                    showActivityPicker = true
                } label: {
                    Label("List activities, apps", systemImage: "gearshape")
                }
                .buttonStyle(.borderedProminent)
                Button("Apply Shielding in 1 minute") {
                    manager.shieldActivities()
                }
                .buttonStyle(.bordered)
                Button("Get Activity Report") {
                    self.filter = DeviceActivityFilter(
                        segment: .daily(
                            during: Calendar.current.dateInterval(
                                of: .weekOfYear, for: .now
                            )!
                        ),
                        users: .all,
                        devices: .init([.iPhone, .iPad]),
                        applications: manager.discouragedSelections.applicationTokens,
                        categories: manager.discouragedSelections.categoryTokens,
                        webDomains: manager.discouragedSelections.webDomainTokens
                    )
                }
                .buttonStyle(.bordered)
                
                DeviceActivityReport(context, filter: filter)
            }
            .familyActivityPicker(isPresented: $showActivityPicker, selection: $manager.discouragedSelections)
            .onChange(of: selection, initial: true) { oldValue, newValue in
                print("Get Activity Report")
                self.filter = DeviceActivityFilter(
                    segment: .daily(
                        during: Calendar.current.dateInterval(
                            of: .weekOfYear, for: .now
                        )!
                    ),
                    users: .all,
                    devices: .init([.iPhone]),
                    applications: manager.discouragedSelections.applicationTokens,
                    categories: manager.discouragedSelections.categoryTokens,
                    webDomains: manager.discouragedSelections.webDomainTokens
                )
            }
        } else {
            // Fallback on earlier versions
        }
    }
}

#Preview {
    ContentView()
}
