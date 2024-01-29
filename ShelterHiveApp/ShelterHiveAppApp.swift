//
//  ShelterHiveAppApp.swift
//  ShelterHiveApp
//
//  Created by Alondra Correa on 11/18/23.
//

import SwiftUI
import FirebaseCore

@main
struct ShelterHiveAppApp: App {
    init(){
        FirebaseApp.configure()
    }
    var body: some Scene {
        WindowGroup {
            ContentView()
                
        }
    }
}
