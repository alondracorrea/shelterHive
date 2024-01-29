//
//  ShelterInfoView.swift
//  ShelterHiveApp
//
//  Created by Alondra Correa on 11/21/23.
//
// Description: View uses the Yelp Fusion APi to retrieve shelter information such as address, phone number, and reviews. It also has the options to write reviews and volunteer oppurtunities for the shelter.

import SwiftUI

struct ShelterInfoView: View {
    //manages shelter data
    @ObservedObject var shelterViewModel = ShelterVM()
    //coordinates from previous view for API call
    let latitude: Double
    let longitude: Double
    let shelterName: String
    
    //shelter info variables
    @State var shelterRating = ""
    @State var shelterPhone = ""
    @State var shelterAddress = ""
    @State var shelterReviewCount = ""
    @State var shelterDistance = ""
    
    //provides default values
    init(latitude: Double = 0.0, longitude: Double = 0.0, shelterName: String = "") {
        self.latitude = latitude
        self.longitude = longitude
        self.shelterName = shelterName
    }
    
    var body: some View {
        NavigationStack{
            NavigationView {
                VStack {
                    Spacer()
                    //main title
                    Text("Shelter Name:")
                        .fontWeight(.bold)
                        .font(.system(size: 40))
                    Text("\(shelterName)")
                        .fontWeight(.bold)
                        .foregroundColor(.black)
                        .font(.system(size: 30))
                    HStack{
                        Text("Rating: \(shelterRating)")
                            .fontWeight(.bold)
                            .font(.system(size: 20))
                        Text("(\(shelterReviewCount)) reviews")
                            .fontWeight(.bold)
                            .font(.system(size: 12))
                            .foregroundColor(.blue)
                    }
                    //calculate min away from shelterDistance
                    /* Text(" min away")
                     .fontWeight(.bold)
                     .font(.system(size: 15))
                     */
                    Spacer()
                        .onAppear{
                            shelterViewModel.searchShelters(latitude: latitude, longitude: longitude, term: shelterName) { result in
                                switch result {
                                case .success(let shelterModel):
                                    
                                    if let firstShelter = shelterModel.firstFiveBusinesses.first {
                                        
                                        print("First Shelter:")
                                        print(firstShelter)
                                        
                                        if let displayAddress = firstShelter.location.display_address,
                                           let displayPhone = firstShelter.phone
                                        {
                                            shelterAddress = displayAddress.joined(separator: ", ")
                                            shelterPhone = displayPhone
                                            shelterRating = String(firstShelter.rating)
                                            shelterReviewCount = String(firstShelter.reviewCount)
                                            shelterDistance = String(firstShelter.distance)
                                            
                                        } else {
                                            
                                            shelterAddress = "N/A"
                                            shelterPhone = "N/A"
                                            shelterRating = "N/A"
                                            shelterReviewCount = "N/A"
                                            shelterDistance = "N/A"
                                        }
                                        
                                    } else {
                                        
                                        print("No shelters found.")
                                    }
                                    
                                case .failure(let error):
                                    print("Error searching shelters: \(error)")
                                }
                            }
                        }
                    //navigation links to write a review or write a vol. opp.
                    HStack {
                        NavigationLink(destination: AddReview(shelterName: shelterName)) {
                            Text("Write Review")
                                .foregroundColor(.black)
                                .font(.headline)
                                .padding()
                                .frame(width: 150)
                                .background(
                                    RoundedRectangle(cornerRadius: 10)
                                        .fill(Color.yellow)
                                )
                        }
                        NavigationLink(destination: AddOppurtunity(shelterName: shelterName)) {
                            Text("Volunteer")
                                .foregroundColor(.black)
                                .font(.headline)
                                .padding()
                                .frame(width: 150)
                                .background(
                                    RoundedRectangle(cornerRadius: 10)
                                        .fill(Color.yellow)
                                )
                        }
                    }
                    
                    Spacer()
                    
                    // shelter Details for UI
                    VStack(alignment: .leading) {
                        Text("Address:")
                            .fontWeight(.bold)
                            .font(.system(size: 18))
                        
                        Text("\(shelterAddress)")
                            .multilineTextAlignment(.leading)
                            .padding(1)
                        
                        Text("Phone:")
                            .fontWeight(.bold)
                            .font(.system(size: 18))
                        
                        Text("\(shelterPhone)")
                            .multilineTextAlignment(.leading)
                            .padding(1)
                    }
                    
                    Spacer()
                    Spacer()
                    Spacer()
                }
                
                .background(
                    Image("infoBackground")
                        .resizable()
                        .scaledToFill()
                        .frame(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height)
                        .edgesIgnoringSafeArea(.all)
                )
            }
        }
    }
}


#Preview {
    ShelterInfoView()
}
