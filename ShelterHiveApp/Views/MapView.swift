//
//  MapView.swift
//  ShelterHiveApp
//
//  Created by Alondra Correa on 11/17/23.
//
// Decscription: A SwiftUI that integrates MapKit to display the map and the annotations

import SwiftUI
import MapKit
import CoreLocation

struct MapView: UIViewRepresentable {
    //checks if map annotation is clicked
    @Binding var isShelterClicked: Bool
    //city or address for the map
    let cityName: String
    //annotations for nearby shelters
    let annotations: [MKPointAnnotation]
    //var for tapped annotation title and annotation coordinate
    var onAnnotationTapped: ((String) -> Void)?
    var onAnnotationTappedAgain: ((CLLocationCoordinate2D) -> Void)?
    
    
    //Class handles MapView methods
    class Coordinator: NSObject, MKMapViewDelegate {
        var parent: MapView
        
        init(parent: MapView) {
            self.parent = parent
        }
        
        func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
            if let annotation = view.annotation as? MKPointAnnotation {
                parent.isShelterClicked = true
                parent.onAnnotationTapped?(annotation.title ?? "")
                parent.onAnnotationTappedAgain?(annotation.coordinate)
            }
        }
    }
    
    //to make coordinate instance
    func makeCoordinator() -> Coordinator {
        Coordinator(parent: self)
    }
    
    //to make the initial MapView
    func makeUIView(context: Context) -> MKMapView {
        let mapView = MKMapView()
        mapView.delegate = context.coordinator
        return mapView
    }
    
    //to update the MapView with annotations
    func updateUIView(_ uiView: MKMapView, context: Context) {
        // removes location annotation
        uiView.removeAnnotations(uiView.annotations)
        
        // adds in the nearby shelter annotations
        uiView.addAnnotations(annotations)
        
        //map view span around first shelter(entered input)'s location
        for annotation in annotations {
            uiView.addAnnotation(annotation)
            if let coordinate = annotations.first?.coordinate {
                let region = MKCoordinateRegion(
                    center: coordinate,
                    span: MKCoordinateSpan(latitudeDelta: 0.1, longitudeDelta: 0.1)
                )
                uiView.setRegion(region, animated: true)
            }
        }
    }
    
}
