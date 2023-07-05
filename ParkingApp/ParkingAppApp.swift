//
//  ParkingAppApp.swift
//  ParkingApp
//
//  Created by super on 2023-06-24.
//

import SwiftUI
import Firebase
import FirebaseCore
import FirebaseAuth
import FirebaseFirestore

@main
struct ParkingAppApp: App {
    
    let authHelper = FireAuthController()
    
    init(){
        //configure Firebase in the project
        FirebaseApp.configure()
    }
    
    var body: some Scene {
        WindowGroup {
            ContentView().environmentObject(authHelper)
        }
    }
}
