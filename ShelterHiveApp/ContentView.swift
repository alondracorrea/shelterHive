//
//  ContentView.swift
//  ShelterHiveApp
//
//  Created by Alondra Correa on 11/14/23.
//

import SwiftUI
import FirebaseAuth

struct ContentView: View {
    @AppStorage("uid") var userID = ""

       var body: some View {
           NavigationView {
               VStack {
                   if userID == "" {
                       AuthView()
                   } else {
                      HomePageView() 
                   }
               }
           }
       }
}

#Preview {
    ContentView()
}
