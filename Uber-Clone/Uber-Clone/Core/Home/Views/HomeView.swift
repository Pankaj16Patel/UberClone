//
//  HomeView.swift
//  Uber-Clone
//
//  Created by amarjeet patel on 13/01/25.
//

import SwiftUI

struct HomeView: View {
    
    //@State private var showLocationSearchView: Bool = false
    @State var mapState = MapViewState.noInput
    @EnvironmentObject var locationViewModel: LocationSearchViewModel
    
    var body: some View {
        ZStack(alignment: .bottom){
        ZStack(alignment: .top){
            
            UberMapRepresentable(mapState: $mapState)
                .ignoresSafeArea(.all)
            
            if mapState == .searchingForLocation {
                LocationSearchView( mapState: $mapState)
            }else if mapState == .noInput{
                LocationSearchActivationView()
                    .padding(.top , 70)
                    .onTapGesture {
                        withAnimation(.spring()){
                            mapState = .searchingForLocation
                        }
                    }
            }
            
            MapViewActionView(mapState: $mapState)
                .padding(.leading)
                .padding(.top,4)
            
        }
            
            if mapState == .LocationSelected || mapState == .polylineAdded{
                RideRequestView()
                    .transition(.move(edge: .bottom))
            }
        
        }.edgesIgnoringSafeArea(.bottom)
            .onReceive(LocationManger.shared.$userLocation) { location in
                if let location = location{
                    //print("debug: user location in home view in \(location)")
                    locationViewModel.userLocation = location
                }
            }
    }
}

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView()
            .environmentObject(LocationSearchViewModel())
    }
}
