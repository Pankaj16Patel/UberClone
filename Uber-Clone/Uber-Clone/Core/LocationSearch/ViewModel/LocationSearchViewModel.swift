//
//  LocationSearchViewModel.swift
//  Uber-Clone
//
//  Created by amarjeet patel on 13/01/25.
//

import Foundation
import MapKit

class LocationSearchViewModel: NSObject, ObservableObject{
    
    // MARK: - Properties
    
    @Published var results = [MKLocalSearchCompletion]()
    @Published var selectedUberLocation: UberLocation?
    @Published var pickupTime: String?
    @Published var dropOffTime: String?
    
    private let searchCompleter = MKLocalSearchCompleter()
    var queryFragment: String = ""{
        didSet{
            //print("debug: queryFragment is \(queryFragment)")
            searchCompleter.queryFragment = queryFragment
        }
    }
    
    var userLocation: CLLocationCoordinate2D?
    
    override init() {
        
        super.init()
        searchCompleter.delegate = self
        searchCompleter.queryFragment = queryFragment
    }
    //MARK: helper
    
    func selectLocation(_ localSearch: MKLocalSearchCompletion){
      
        locationSearch(forLocalSearch: localSearch) { response, error in
            
            if let error = error {
                print("debug: location search fauled with error \(error.localizedDescription)")
                return
            }
            
            guard let item =  response?.mapItems.first else{return}
            let coordinate = item.placemark.coordinate
            self.selectedUberLocation = UberLocation(title: localSearch.title, coordinate: coordinate)
            
            print("debug: location coordinate \(coordinate)")
        }
        
       // print(selectedLocation)
    }
    
    func locationSearch(forLocalSearch localSearch: MKLocalSearchCompletion , completion: @escaping(MKLocalSearch.CompletionHandler)) {
        
        let searchRequest = MKLocalSearch.Request()
        searchRequest.naturalLanguageQuery = localSearch.title.appending(localSearch.subtitle)
        let search = MKLocalSearch(request: searchRequest)
        
        search.start(completionHandler: completion)
        
    }
    func computeRidePrice(forType type: RideType) -> Double{
        guard let Coordinate = selectedUberLocation?.coordinate else{ return 0.0}
        guard let userCoordinate = self.userLocation else { return 0.0}
        
        let userLocation = CLLocation(latitude:userCoordinate.latitude, longitude:userCoordinate.longitude)
        let destination = CLLocation(latitude: Coordinate.latitude, longitude: Coordinate.longitude)
        
        let tripDistanceInMeter = userLocation.distance(from: destination)
        return type.computePrice(for: tripDistanceInMeter)
        
    }
    
    func getdestinationRoute(from userLocation: CLLocationCoordinate2D ,to destination: CLLocationCoordinate2D , completion: @escaping(MKRoute) -> Void){
        
        
        let userPlacemark = MKPlacemark(coordinate: userLocation)
        let destPlacemark = MKPlacemark(coordinate: destination)
        let request = MKDirections.Request()
        request.source = MKMapItem(placemark: userPlacemark)
        request.destination = MKMapItem(placemark: destPlacemark)
        let direction = MKDirections(request: request)
        
        direction.calculate { response , error in
            if let error = error{
                print("debug: failed to get direction with error\(error.localizedDescription)")
                return
            }
            
            guard let route = response?.routes.first else{ return}
            self.configurePickupAndDropOffTime(with: route.expectedTravelTime)
            completion(route)
        }
    }
    
    func configurePickupAndDropOffTime(with  expectedTravelTime: Double){
        let formatter = DateFormatter()
        formatter.dateFormat = "hh:mm a"
        
        pickupTime = formatter.string(from: Date())
        dropOffTime = formatter.string(from: Date() + expectedTravelTime)
    }
}


//MARK: MklocalSearchDelegate

extension LocationSearchViewModel: MKLocalSearchCompleterDelegate{
    
    func completerDidUpdateResults(_ completer: MKLocalSearchCompleter) {
        self.results = completer.results
        //print(results)
    }
    
}
