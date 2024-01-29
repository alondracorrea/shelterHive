//
//  AuthView.swift
//  ShelterHiveApp
//
//  Created by Alondra Correa on 11/14/23.
// Description: Handles the views according to authentication

import SwiftUI

struct AuthView: View {
    
    @State private var currentViewShowing: String = "login" // login or signup
    
    var body: some View {
        if(currentViewShowing == "login") {
            LoginView(currentView: $currentViewShowing)
                .preferredColorScheme(.light)
        } else {
            SignUpView(currentView: $currentViewShowing)
                .preferredColorScheme(.dark)
                .transition(.move(edge: .bottom))
        }
    }
}

#Preview {
    AuthView()
}
