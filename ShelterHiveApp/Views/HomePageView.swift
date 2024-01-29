//
//  HomePageView.swift
//  ShelterHiveApp
//
//  Created by Alondra Correa on 11/14/23.
//
// Description: The main view for the navigation links to the profile, shelter search, and news search.

import SwiftUI
import FirebaseAuth

struct HomePageView: View {
    @AppStorage("uid") var userID: String = ""
    
    var body: some View {
        NavigationView{
            VStack(spacing: 20) {
                Image("hivelogo")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 500, height: 200)
                    .padding()
                
                NavigationLink(destination: ProfileView(userID: userID)) {
                    Text("Profile")
                        .foregroundColor(.black)
                        .font(.headline)
                        .padding()
                        .frame(width: 300)
                        .background(
                            RoundedRectangle(cornerRadius: 10)
                                .fill(Color.yellow)
                        )
                }
                
                NavigationLink(destination: SearchShelterView()) {
                    Text("Search Shelters")
                        .foregroundColor(.black)
                        .font(.headline)
                        .padding()
                        .frame(width: 300)
                        .background(
                            RoundedRectangle(cornerRadius: 10)
                                .fill(Color.yellow)
                        )
                }
                
                NavigationLink(destination: InfoView()) {
                    Text("News")
                        .foregroundColor(.black)
                        .font(.headline)
                        .padding()
                        .frame(width: 300)
                        .background(
                            RoundedRectangle(cornerRadius: 10)
                                .fill(Color.yellow)
                        )
                }
                //signs out user
                Button(action: {
                    let firebaseAuth = Auth.auth()
                    do {
                        try firebaseAuth.signOut()
                        userID = ""
                    } catch let signOutError as NSError {
                        print("error: %@", signOutError)
                    }
                }) {
                    
                    let cherry = Color(red: 139 / 255.0, green: 0 / 255.0, blue: 0 / 255.0)
                    Text("Sign Out")
                        .foregroundColor(.white)
                        .font(.headline)
                        .padding()
                        .frame(width: 300)
                        .background(
                            RoundedRectangle(cornerRadius: 10)
                                .fill(cherry)
                        )
                }
                Spacer()
            }
            
            .background(
                Image("homeBackground")
                    .resizable()
                    .scaledToFill()
                    .frame(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height)
                    .edgesIgnoringSafeArea(.all)
            )
        }
    }
}

#Preview {
    HomePageView()
}
