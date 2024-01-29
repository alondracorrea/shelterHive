//
//  AddReview.swift
//  ShelterHiveApp
//
//  Created by Alondra Correa on 11/21/23.
//
// Description: View for users to add volunteer opportunities for the shelter.

import SwiftUI
import FirebaseFirestore

struct AddReview: View {
    @AppStorage("uid") var userID = ""
    
    let shelterName: String
    //var for data input
    @State var reviewText = ""
    
    var body: some View {
        NavigationStack{
            VStack{
                Spacer()
                                
                Text("Leave a review")
                    .fontWeight(.bold)
                    .font(.system(size: 40))
                Text("How would you rate your experience at:")
                Text("(\(shelterName))?")
                    .font(.system(size: 15))
                    .fontWeight(.semibold)
                Spacer()
                
                Text("Review*")
                TextField("This place is great!", text: $reviewText, axis: .vertical)
                    .textFieldStyle(.roundedBorder)
                    .padding()
                
                //stores review for current user into Firebase user userid
                Button {
                    
                    let db = Firestore.firestore()
                    let reviewData =  [
                        "locationName": shelterName,
                        "reviewText": reviewText
                    ]
                    
                    db.collection("users").document(userID).updateData([
                        "reviews": FieldValue.arrayUnion([reviewData])
                    ]) { error in
                        if let error = error {
                            print("error: \(error)")
                        } else {
                            print("review added successfully")
                            reviewText = ""
                        }
                    }
                    
                }label: {
                    Text("Submit")
                        .foregroundColor(.black)
                        .font(.headline)
                        .padding()
                        .frame(width: 100)
                        .background(
                            RoundedRectangle(cornerRadius: 10)
                                .fill(Color.green))
                }
                
                Spacer()
                Spacer()
                Spacer()
                
            }
            
            .background(
                Image("reviewBackground")
                    .resizable()
                    .scaledToFill()
                    .frame(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height)
                    .edgesIgnoringSafeArea(.all)
            )
        }
        
    }
}

#Preview {
    AddReview(shelterName: "N/A")
}
