//
//  AddOppurtunity.swift
//  ShelterHiveApp
//
//  Created by Alondra Correa on 11/21/23.
//
// Description: View for users to add volunteer opportunities for the shelter.

import SwiftUI
import FirebaseFirestore


struct AddOppurtunity: View {
    @AppStorage("uid") var userID = ""
    
    //variable for data input
    @State var title = ""
    @State var date = Date.now
    @State var duty = ""
    @State var location = ""
    
    let shelterName: String
    
    var body: some View {
        NavigationStack{
            VStack{
                
                Spacer()
                //main title
                Text("Volunteer")
                    .fontWeight(.bold)
                    .font(.system(size: 40))
                Text("Join the busy bees at:")
                Text("(\(shelterName))!")
                    .font(.system(size: 15))
                    .fontWeight(.semibold)
                Spacer()
                
                Text("Opportunity*")
                VStack{
                    HStack{
                        Text("Title:")
                        TextField("Help the Dogs", text: $title)
                            .padding()
                            .frame(width: 300)
                            .frame(height: 50)
                            .background(
                                Rectangle()
                                    .fill(Color.white)
                                    .border(/*@START_MENU_TOKEN@*/Color.black/*@END_MENU_TOKEN@*/)
                            )
                    }
                    
                    HStack{
                        Text("Date: ")
                        DatePicker(selection: $date, in: ...Date(), displayedComponents: .date) {
                        }
                        
                    }
                    
                    HStack{
                        Text("Duty:")
                        TextField("Walk a dog at the shelter", text: $duty)
                            .padding()
                            .frame(width: 300)
                            .frame(height: 50)
                            .background(
                                Rectangle()
                                    .fill(Color.white)
                                    .border(Color.black)
                            )
                    }
                    
                    HStack{
                        Text("Location:")
                        TextField("\(shelterName)", text: $location)
                            .padding()
                            .frame(width: 300)
                            .frame(height: 50)
                            .background(
                                Rectangle()
                                    .fill(Color.white)
                                    .border(/*@START_MENU_TOKEN@*/Color.black/*@END_MENU_TOKEN@*/)
                            )
                    }
                    
                    //Using current user id, stores the vol. opp. into Firebase
                    Button {
                        let db = Firestore.firestore()
                        let dateString = String(date.formatted(date: .long, time: .omitted))
                        let volunteerData =  [
                            "title": title,
                            "date": dateString,
                            "duty": duty,
                            "locationName": location
                        ]
                        
                        db.collection("users").document(userID).updateData([
                            "opportunities": FieldValue.arrayUnion([volunteerData])
                        ]) { error in
                            if let error = error {
                                print("error: \(error)")
                            } else {
                                print("Volunteer data added successfully.")
                                title = ""
                                duty = ""
                                location = ""
                                
                            }
                        }
                        
                    } label: {
                        Text("Submit")
                            .foregroundColor(.black)
                            .font(.headline)
                            .padding()
                            .frame(width: 100)
                            .background(
                                RoundedRectangle(cornerRadius: 10)
                                    .fill(Color.green))
                    }
                }
                Spacer()
                Spacer()
                Spacer()
                
            }
            
            .padding()
            .background(
                Image("volBackground")
                    .resizable()
                    .scaledToFill()
                    .frame(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height)
                    .edgesIgnoringSafeArea(.all)
            )
        }
    }
}


#Preview {
    AddOppurtunity(shelterName: "N/A")
}
