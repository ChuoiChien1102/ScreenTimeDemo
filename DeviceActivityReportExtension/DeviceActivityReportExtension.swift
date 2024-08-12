//
//  DeviceActivityReportExtension.swift
//  DeviceActivityReportExtension
//
//  Created by Nguyen Van Chien on 8/8/24.
//

import DeviceActivity
import SwiftUI

@main
struct ActivityReportExtension: DeviceActivityReportExtension {
    var body: some DeviceActivityReportScene {
        // Create a report for each DeviceActivityReport.Context that your app supports.
        TotalActivityReport { totalActivity in
            return TotalActivityView(activityReport: totalActivity)
        }
        // Add more reports here...
        
    }
}
