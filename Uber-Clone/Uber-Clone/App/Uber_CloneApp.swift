//
//  Uber_CloneApp.swift
//  Uber-Clone
//
//  Created by amarjeet patel on 13/01/25.
//

import SwiftUI

@main
struct Uber_CloneApp: App {
    
    @StateObject var locationViewModel = LocationSearchViewModel()
    
    var body: some Scene {
        WindowGroup {
            HomeView()
                .environmentObject(locationViewModel)
        }
    }
}
