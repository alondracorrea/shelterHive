//
//  HiveUserVM.swift
//  ShelterHiveApp
//
//  Created by Alondra Correa on 11/14/23.
//
// Description: The HiveUserVM (ViewModel) manages and fetches user data from Firebase
//This is the ViewModel for the Profile View to manage and retrieve user data from the Firebase
//The HiveUserVM contains a @Published hiveUser that represents the usser model HiveUser

import Foundation
import FirebaseFirestore

class HiveUserVM: ObservableObject {
   
    //published var represents user model
    @Published var hiveUser: HiveUser?
    
    //to give real-time updates
    private var firestoreListener: ListenerRegistration?
    
    deinit {
        firestoreListener?.remove()
    }
    
    
    //function to get user data from Firebase
    func getUserData(userID: String){
        print("getUserData")
        
        let db = Firestore.firestore()
        
        let usersCollection = db.collection("users")
        
        // query gets data for logged in user's id ONLY
        let query = usersCollection.whereField(FieldPath.documentID(), isEqualTo: userID)
        
        // gets field data for user
        query.getDocuments { (querySnapshot, error) in
            if let error = error {
                print("error: \(error)")
            } else {
                for document in querySnapshot!.documents {
                    
                    let userData = document.data()
                    
                   //  print("userID: \(document.documentID), full name: \(userData["fullName"] ?? ""), email: \(userData["email"] ?? ""), review: \(userData["reviews"] ?? ""), opps: \(userData["opportunities"] ?? "")")
                
                    //retrieve and parse review array information
                    var reviews: [Review] = []
                    if let reviewsData = userData["reviews"] as? [[String: Any]] {
                        for reviewData in reviewsData {
                            if let locationName = reviewData["locationName"] as? String,
                               let reviewText = reviewData["reviewText"] as? String {
                                let review = Review(locationName: locationName, reviewText: reviewText)
                                reviews.append(review)
                            }
                        }
                    }
                    
                    //retrieve and parse volunteer oppurtunities information 
                    var opportunities: [VolunteerOpportunity] = []
                    if let opportunitiesData = userData["opportunities"] as? [[String: Any]] {
                        for opportunityData in opportunitiesData {
                            if let title = opportunityData["title"] as? String,
                               let date = opportunityData["date"] as? String,
                               let duty = opportunityData["duty"] as? String,
                               let locationName = opportunityData["locationName"] as? String {
                                let opportunity = VolunteerOpportunity(title: title, date: date, duty: duty, locationName: locationName)
                                opportunities.append(opportunity)
                            }
                        }
                    }
                    
                    // updates hiverUser
                    self.hiveUser = HiveUser(
                        id: document.documentID,
                        fullName: userData["fullName"] as? String ?? "",
                        email: userData["email"] as? String ?? "",
                        reviews: reviews,
                       opportunities: opportunities
                    )
                }
            }
        }
    }
}
