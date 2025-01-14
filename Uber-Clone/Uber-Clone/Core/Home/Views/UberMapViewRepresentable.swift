//
//  UberMapViewResentable.swift
//  Uber-Clone
//
//  Created by amarjeet patel on 13/01/25.
//

import Foundation
import SwiftUI
import MapKit

struct UberMapRepresentable: UIViewRepresentable {
  
    let mapView = MKMapView()
    let locationManager = LocationManger.shared
    @EnvironmentObject var locationViewModel: LocationSearchViewModel
    @Binding var mapState: MapViewState
    
    
    func makeUIView(context: Context) -> some UIView {
        
        mapView.delegate = context.coordinator
        mapView.isRotateEnabled = false
        mapView.showsUserLocation = true
        mapView.userTrackingMode = .follow
        
        return mapView
    }
    
    func updateUIView(_ uiView: UIViewType, context: Context) {
        
        print("debug: mapState is \(mapState)")
        
        switch mapState {
        case .noInput:
            context.coordinator.clearMapViewAndRecenterOnUserLocation()
            break
        case .searchingForLocation:
            break
        case .LocationSelected:
            if let coordinate = locationViewModel.selectedUberLocation?.coordinate{
               //print("debug: selectec loction map view is \(coordinate)")
                
                context.coordinator.addAndSelectAnnotation(withCoordinate: coordinate)
                context.coordinator.configurePolyline(withDestinationCoordinate: coordinate)
            }
            break
        case.polylineAdded:
            break
        }
        
        
       // if mapState == .noInput{
      //      context.coordinator.clearMapViewAndRecenterOnUserLocation()
     //   }
    }
    
    func makeCoordinator() -> MapCoordinator {
        
        return MapCoordinator(parent: self)
    }
}

extension UberMapRepresentable {
    
    class MapCoordinator: NSObject, MKMapViewDelegate{
        
        //MARK: - properties
        let parent: UberMapRepresentable
        var userLocationCoordinate: CLLocationCoordinate2D?
        var currentRegion: MKCoordinateRegion?
        
        //MARK: - LifeCycle
        
        init(parent: UberMapRepresentable) {
            self.parent = parent
            super.init()
        }
        
        //MARK: - Mapviwew delegate
        
        func mapView(_ mapView: MKMapView, didUpdate userLocation: MKUserLocation) {
            
            self.userLocationCoordinate = userLocation.coordinate
            let region = MKCoordinateRegion(
                center: CLLocationCoordinate2D(latitude: userLocation.coordinate.latitude, longitude: userLocation.coordinate.longitude),
                span: MKCoordinateSpan(latitudeDelta: 0.05, longitudeDelta: 0.05))
            
            self.currentRegion = region
            
            parent.mapView.setRegion(region, animated: true)
            
           
            
        }
        
        func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
            let polyline = MKPolylineRenderer(overlay: overlay)
            polyline.strokeColor = .systemBlue
            polyline.lineWidth = 6
            return polyline
        }
        
        //MARK: - helpers
        
        func addAndSelectAnnotation(withCoordinate coordinate: CLLocationCoordinate2D) {
           
            parent.mapView.removeAnnotations(parent.mapView.annotations)
            
            let anno = MKPointAnnotation()
            anno.coordinate = coordinate
            self.parent.mapView.addAnnotation(anno)
            self.parent.mapView.selectAnnotation(anno, animated: true)
            
            //parent.mapView.showAnnotations(parent.mapView.annotations, animated: true)
        }
        
        func configurePolyline(withDestinationCoordinate coordinate: CLLocationCoordinate2D){
            
            guard let userLocationCoordinate = self.userLocationCoordinate else{return}
            parent.locationViewModel.getdestinationRoute(from:userLocationCoordinate , to: coordinate) { route in
                self.parent.mapView.addOverlay(route.polyline)
                self.parent.mapState = .polylineAdded
                let react =  self.parent.mapView.mapRectThatFits(route.polyline.boundingMapRect, edgePadding: .init(top: 64, left: 32, bottom: 500, right: 32))
                self.parent.mapView.setRegion(MKCoordinateRegion(react), animated:true)
                
            }
            
        }
        
        
        
        func clearMapViewAndRecenterOnUserLocation() {
            parent.mapView.removeAnnotations(parent.mapView.annotations)
            parent.mapView.removeOverlays(parent.mapView.overlays)
            
            if let currentRegion = currentRegion {
                parent.mapView.setRegion(currentRegion, animated: true)
            }
        }
        
    }
}
