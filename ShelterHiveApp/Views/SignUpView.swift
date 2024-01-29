//
//  SignUpView.swift
//  ShelterHiveApp
//
//  Created by Alondra Correa on 11/14/23.
//
// Description: View for the signin view
import SwiftUI
import FirebaseAuth
import FirebaseFirestore

struct SignUpView: View {
    
    @State private var fullName: String = ""
    @State private var email: String = ""
    @State private var password: String = ""
    @AppStorage("uid") var userID: String = ""
    @Binding var currentView: String
    
    var body: some View {
        ZStack {
            //black background
            Color.black.edgesIgnoringSafeArea(.all)
            VStack {
                Spacer()
                Spacer()
                HStack {
                    //main title
                    Text("Create an Account")
                        .foregroundColor(.black)
                        .font(.system(size: 50))
                        .bold()
                    
                    Spacer()
                }
                .padding()
                .padding(.top)
                
                Spacer()
                //name input field
                HStack {
                    Image(systemName: "person").foregroundColor(.black)
                    TextField("Full Name", text: $fullName)
                    
                        .foregroundColor(.black)
                        .font(.headline)
                    
                    Spacer()
                    
                }
                .padding()
                .overlay(
                    RoundedRectangle(cornerRadius: 10)
                        .stroke(lineWidth: 2)
                        .foregroundColor(.black)
                    
                )
                .padding()
                //email input fields
                HStack {
                    Image(systemName: "mail")
                        .foregroundColor(.black)
                    TextField("Email", text: $email)
                    
                        .foregroundColor(.black)
                        .font(.headline)
                    
                    Spacer()
                    
                }
                .padding()
                .overlay(
                    RoundedRectangle(cornerRadius: 10)
                        .stroke(lineWidth: 2)
                        .foregroundColor(.black)
                    
                )
                //password input fields
                .padding()
                HStack {
                    Image(systemName: "lock").foregroundColor(.black)
                    SecureField("Password", text: $password).foregroundColor(.black)
                    
                    Spacer()
                    
                }
                .padding()
                .overlay(
                    RoundedRectangle(cornerRadius: 10)
                        .stroke(lineWidth: 2)
                        .foregroundColor(.black)
                    
                )
                .padding()
                Button(action: {
                    withAnimation {
                        self.currentView = "login"
                    }
                }) {
                    Text("Already have an account?")
                        .foregroundColor(.black)
                }
                
                Spacer()
                Spacer()
                
                //Button to store input fields into FirebaseAuth and Firebase Database
                Button {
                    Auth.auth().createUser(withEmail: email, password: password) { authResult, error in
                        
                        if let error = error {
                            print(error)
                            return
                        }
                        
                        if let authResult = authResult {
                            //stores user data in Firebase Auth
                            print(authResult.user.uid)
                            userID = authResult.user.uid
                            
                            // stores user data in Firestore Database
                            let db = Firestore.firestore()
                            db.collection("users").document(userID).setData([
                                "email": email,
                                "fullName": fullName,
                            ]) { error in
                                if let error = error {
                                    print("error: \(error)")
                                } else {
                                    print("user data: \(authResult.user.uid)")
                                }
                            }
                            
                        }
                    }
                } label: {
                    Text("Sign Up")
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
                Image("create")
                    .resizable()
                    .scaledToFill()
                    .frame(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height)
                    .edgesIgnoringSafeArea(.all)
            )
        }
    }
}

#Preview {
    SignUpView(currentView: .constant("signup"))
}








