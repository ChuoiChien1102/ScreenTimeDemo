//
//  ShieldView.swift
//  ScreenTimeDemo
//
//  Created by Nguyen Van Chien on 6/8/24.
//

import SwiftUI
import FamilyControls

struct ShieldView: View {
    
    @StateObject private var manager = ShieldManager()
    @State private var showActivityPicker = false
    var body: some View {
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
        }
        .familyActivityPicker(isPresented: $showActivityPicker, selection: $manager.discouragedSelections)
    }
}

#Preview {
    ShieldView()
}
