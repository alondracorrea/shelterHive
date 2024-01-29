//
//  LoginView.swift
//  ShelterHiveApp
//
//  Created by Alondra Correa on 11/14/23.
//
//credits: https://youtu.be/OTg_yZp3T34?si=K2084cp2dfV0ea3O
// Description: View for the login view
//example login credentials: email: Kurt@gmail.com, password: Kurt1!

import SwiftUI
import FirebaseAuth

struct LoginView: View {
    
    //binding to switch between login and signup views
    @Binding var currentView: String
    @AppStorage("uid") var userID: String = ""
    @State private var email: String = ""
    @State private var password: String = ""
    
    var body: some View {
        
        ZStack {
            //white background
            Color.white.edgesIgnoringSafeArea(.all)
            VStack {
                Spacer()
                Spacer()
                HStack {
                    //main title
                    Text("Login")
                        .bold()
                        .font(.system(size: 50))
                    
                    Spacer()
                }
                .padding()
                .padding(.top)
                
                Spacer()
                // email input fields
                HStack {
                    Image(systemName: "mail")
                    TextField("Email", text: $email)
                    
                    Spacer()
                    
                }
                
                .padding()
                .overlay(
                    RoundedRectangle(cornerRadius: 10)
                        .stroke(lineWidth: 2)
                        .foregroundColor(.black)
                )
                .padding()
                
                //password input fields
                HStack {
                    Image(systemName: "lock")
                    SecureField("Password", text: $password)
                    
                    Spacer()
                    
                }
                .padding()
                .overlay(
                    RoundedRectangle(cornerRadius: 10)
                        .stroke(lineWidth: 2)
                        .foregroundColor(.black)
                )
                .padding()
                //changes view
                Button(action: {
                    withAnimation {
                        self.currentView = "signup"
                    }
                    
                }) {
                    Text("Don't have an account?")
                        .foregroundColor(.black.opacity(0.7))
                }
                
                Spacer()
                Spacer()
                
                Button {
                    Auth.auth().signIn(withEmail: email, password: password) { authResult, error in
                        if let error = error {
                            print(error)
                            return
                        }
                        if let authResult = authResult {
                            print(authResult.user.uid)
                            withAnimation{
                                userID = authResult.user.uid
                            }
                        }
                    }
                } label: {
                    Text("Sign In")
                        .foregroundColor(.white)
                        .font(.title3)
                        .bold()
                    
                        .frame(maxWidth: .infinity)
                        .padding()
                    
                        .background(
                            RoundedRectangle(cornerRadius: 10)
                                .fill(Color.black)
                        )
                        .padding(.horizontal)
                }
                
            }
            
            .background(
                Image("login")
                    .resizable()
                    .scaledToFill()
                    .frame(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height)
                    .edgesIgnoringSafeArea(.all)
            )
        }
    }
}

#Preview {
    LoginView(currentView: .constant("login"))
}

