//
//  ProfileView.swift
//  ShelterHiveApp
//
//  Created by Alondra Correa on 11/14/23.
// Description: The ProfileView displays user info; initials, full name, and email. It contains Navigation Links to see Reviews and Volunteer Opportunities and their rescpective detailed views.
//It used the HiveUerVM(View Model) to fetch and display the user data.

import SwiftUI
import FirebaseAuth
import FirebaseFirestore

struct ProfileView: View {
    //fetches data for the logged in user
    @ObservedObject var viewModel = HiveUserVM()
    let userID: String

    //initializes the HiveUser
    init(userID: String) {
        self.userID = userID
        self.viewModel = HiveUserVM()
    }
    
    //function to get initials from the fullName
    var initials: String {
        guard let fullName = viewModel.hiveUser?.fullName else { return "JD" }
        
        let result = fullName.components(separatedBy: " ").map { String($0.prefix(1))}.joined()
        return result
    }
    
    var body: some View {
        NavigationView {
            VStack {
                //user information displayed in a List and Section
                List {
                    Section {
                        HStack {
                            Text(initials)
                                .font(.title)
                                .fontWeight(.semibold)
                                .foregroundColor(.white)
                                .frame(width: 72, height: 72)
                                .background(Color(.systemGray3))
                                .clipShape(Circle())
                            //VStack displays users name and email
                            //Defaults to Jane Doe until data is fetched
                            VStack(alignment: .leading, spacing: 4) {
                                Text(viewModel.hiveUser?.fullName ?? "Jane Doe")
                                    .font(.subheadline)
                                    .fontWeight(.semibold)
                                    .padding(.top, 4)
                                
                                Text(viewModel.hiveUser?.email ?? "janeDoe@email.com")
                                    .font(.footnote)
                                    .accentColor(.gray)
                            }
                        }
                    }
                    
                    //Section has a navigation link to see reviews
                    Section {
                        let reviews = viewModel.hiveUser?.reviews ?? []
                        
                        NavigationLink(
                            destination: ReviewView(reviews: reviews),
                            label: {
                                Text("Reviews")
                            }
                        )
                    }
                    //Section has a navigation link to see volunteer opportunities
                    Section {
                        let opps = viewModel.hiveUser?.opportunities ?? []
                        
                        NavigationLink(destination: VolunteerView(opportunities: opps),
                                       label: {
                            Text("Volunteer Opportunities")
                        }
                        )
                        
                    }
                    
                }
                .onAppear {
                    viewModel.getUserData(userID: userID)
                    
                }
            }
            .navigationBarTitle("Profile", displayMode: .inline)
            
        }
    }
}

//View displays reviews one by one in a List
struct ReviewView: View {
    let reviews: [Review]
    
    var body: some View {
        VStack {
            Text("Reviews").bold()
                .font(.system(size: 20))
            if reviews.isEmpty {
                Text("No reviews yet! :)")
            } else {
                
                List {
                    ForEach(reviews, id: \.locationName) { review in
                        VStack(alignment: .leading) {
                            Text("\(review.locationName)").bold()
                            Text("Review: \(review.reviewText)")
                        }
                        .padding()
                    }
                }
            }
        }
        .padding()
    }
    
}

//View displays Volunteer Oppurtunities in a List
struct VolunteerView: View{
    let opportunities: [VolunteerOpportunity]
    
    var body: some View {
        VStack {
            Text("Volunteer Opportunities").bold()
                .font(.system(size: 20))
            if opportunities.isEmpty {
                Text("No opportunities yet! :)")
            } else {
                List {
                    ForEach(opportunities, id: \.title) { opportunity in
                        VStack(alignment: .leading) {
                            Text("\(opportunity.title)").bold()
                            Text("Date: \(opportunity.date)")
                            Text("Duty: \(opportunity.duty)")
                            Text("Location: \(opportunity.locationName)")
                        }
                        .padding()
                    }
                }
            }
        }
        .padding()
    }
}


/*#Preview{
 let sample = [
 Review(locationName: "Animal Shelter", reviewText: "This is a review."),
 Review(locationName: "Refugee Shelter", reviewText: "This is a review."),
 ]
 return ReviewView(reviews: sample
 }*/

/*#Preview{
 let sample = [
 VolunteerOpportunity(title: "Help the Dogs", date: "January 1st, 2023", duty: "Walk the dogs", locationName: "Animal Safe Haven")
 
 ]
 return VolunteerView(opportunities: sample)
 }*/

#Preview {
    ProfileView(userID: "123")
}

