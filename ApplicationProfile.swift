//
//  ApplicationProfile.swift
//  ScreenTimeDemo
//
//  Created by Nguyen Van Chien on 6/8/24.
//

import Foundation
import ManagedSettings

struct ApplicationProfile: Codable, Hashable {
    let id: UUID
    let applicationToken: ApplicationToken
    
    init(id: UUID = UUID(), applicationToken: ApplicationToken) {
        self.applicationToken = applicationToken
        self.id = id
    }
}
