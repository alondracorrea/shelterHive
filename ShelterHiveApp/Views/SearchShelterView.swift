//
//  SearchShelterView.swift
//  ShelterHiveApp
//
//  Created by Alondra Correa on 11/17/23.
//
// Description: View to search shelter based on user input for location
//Currently set up as user:
//Types in city, ex. Flagstaff and hit Enter
//Then Types in Shelter and hit Enter
//Nearby Places matching Shelter input will appear as map annotations
//When map annotation is clicked/selected a See Shelter Info button will appear
//When clicked will navigate to ShelterInfoView
 

import SwiftUI
import MapKit
import CoreLocation



struct SearchShelterView: View {

    //all these variables modify the UI
    @State var isShelterClicked = false
    @State var searchText = ""
    @State var searchShelter = ""
    @State var locationAnnotation: [MKPointAnnotation] = []
    @State var nearbyShelterAnnotations: [MKPointAnnotation] = []
    @State var shelterName: String = ""
   
    var body: some View {
        NavigationView{
            VStack {
                Text("Search Shelters")
                    .fontWeight(.bold)
                    .font(.system(size: 20))
                
                // MapView for nearby shelters
                MapView(isShelterClicked: $isShelterClicked, cityName: searchShelter, annotations: nearbyShelterAnnotations) { selectedAnnotation in
                    print("Shelter: \(selectedAnnotation)")
                    shelterName = selectedAnnotation
                } onAnnotationTappedAgain: { coordinate in
                    print("Coordinate: \(coordinate)")
                }                .frame(height: 300)
                    .cornerRadius(20)
                
                //Navigation to ShelterInfoView
                //can update Shelter struct to pass in shelter's info
                //ShelterVM and ShelterModel
                
                if isShelterClicked {
                    NavigationLink(destination: ShelterInfoView(latitude: nearbyShelterAnnotations.first?.coordinate.latitude ?? 0.0,
                                                                  longitude: nearbyShelterAnnotations.first?.coordinate.longitude ?? 0.0,
                                                                  shelterName: shelterName)) {
                        Text("See Shelter Info")
                            .padding()
                            .frame(width: 200)
                            .background(
                                RoundedRectangle(cornerRadius: 10)
                                    .fill(Color.yellow)
                            )
                            .foregroundColor(.black)
                    }
                }
                
                Spacer()
                //data field to enter location and Shelter
                HStack {
                    Text("1.)")
                    TextField("Enter Location(ex. Flagstaff)", text: $searchText)
                        .padding()
                        .background(Rectangle().fill(Color.white))
                    
                    Button("Enter") {
                        
                        searchLocation()
                    }.foregroundColor(.black)
                }
              
                HStack {
                    Text("2.)")
                    TextField("Type in Shelter", text: $searchShelter)
                        .padding()
                        .background(Rectangle().fill(Color.white))
                    
                    //calls function to search for the entered location and shelter
                    Button("Enter") {
                    
                        searchNearbyShelters()
                    }.foregroundColor(.black)
                }
                Spacer()
                Spacer()
            }
            
            .padding()
            .background(
                Image("mapBackground")
                    .resizable()
                    .scaledToFill()
                    .frame(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height)
                    .edgesIgnoringSafeArea(.all)
            )
        }
    }
    
    //geocodes the entered location
    func searchLocation() {
        let geocoder = CLGeocoder()
        geocoder.geocodeAddressString(searchText) { placemarks, error in
            if let placemark = placemarks?.first, let location = placemark.location {
                //update locationAnnotation for the entered location
                let annotation = MKPointAnnotation()
                annotation.coordinate = location.coordinate
                annotation.title = searchText
                locationAnnotation = [annotation]
            }
        }
    }
    
    //searches nearby shelters for the location 
    func searchNearbyShelters() {
        guard let locationCoordinate = locationAnnotation.first?.coordinate else {
            print("no nearby shelters found")
            return
        }
        
        let request = MKLocalSearch.Request()
        request.naturalLanguageQuery = searchShelter
        let region = MKCoordinateRegion(center: locationCoordinate, span: MKCoordinateSpan(latitudeDelta: 0.1, longitudeDelta: 0.1))
        request.region = region
        let search = MKLocalSearch(request: request)
        
        search.start { response, _ in
            if let response = response {
                // updates map annotations for nearby shelters for MapView
                nearbyShelterAnnotations = response.mapItems.map { item in
                    let annotation = MKPointAnnotation()
                    annotation.coordinate = item.placemark.coordinate
                    print(annotation.coordinate)
                    annotation.title = item.name
                    return annotation
                }
            }
        }
    }
    
}

#Preview {
    SearchShelterView()
}
