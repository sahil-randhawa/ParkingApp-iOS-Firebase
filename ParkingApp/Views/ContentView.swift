//
//  ContentView.swift
//  ParkingApp
//
//  Created by super on 2023-06-24.
//

import SwiftUI

struct ContentView: View {
    
    @EnvironmentObject var authHelper : FireAuthController
    private var dbHelper = FirestoreController.getInstance()
    
    @State private var root : RootView = .Login
    
    var body: some View {
        NavigationView{
            switch root {
            case .Login:
                SignInView(rootScreen: $root)
                    .environmentObject(authHelper)
                    .environmentObject(self.dbHelper)
            case .Home:
                TabView{
                    HomeView(rootScreen: $root)
                        .environmentObject(authHelper)
                        .environmentObject(self.dbHelper)
                        .tabItem{
                            Image(systemName: "house")
                            Text("Home")
                        }
                        .padding(.vertical, 10)
                    UserProfileView(rootScreen: $root)
                        .environmentObject(authHelper)
                        .environmentObject(self.dbHelper)
                        .tabItem {
                            Image(systemName: "person")
                            Text("Profile")
                        }
                        .padding(.vertical, 10)
                }//tabview
            }// switch
        }//navView
    }//body
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
