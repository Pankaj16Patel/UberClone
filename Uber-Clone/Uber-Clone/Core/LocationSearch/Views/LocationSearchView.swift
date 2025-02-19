//
//  LocationSearchView.swift
//  Uber-Clone
//
//  Created by amarjeet patel on 13/01/25.
//

import SwiftUI

struct LocationSearchView: View {
    
    @State var startLocationText = ""
  //  @Binding var showLocationSearchView: Bool
    @State var destinationText = ""
    @Binding var mapState: MapViewState
    @EnvironmentObject var viewModel: LocationSearchViewModel
    
    
    var body: some View {
        VStack{
            //header view
            HStack{
                VStack{
                    Circle()
                        .fill(Color(.systemGray3))
                        .frame(width: 6,height: 6)
                    
                    Rectangle()
                        .fill(Color(.systemGray3))
                        .frame(width: 1,height: 24)
                    
                    Rectangle()
                        .fill(.black)
                        .frame(width: 6,height: 6)
                       
                }
                
                VStack{
                    
                   TextField("Current location", text: $startLocationText)
                        .frame(height: 32)
                        .background(Color(.systemGroupedBackground))
                        .padding(.trailing)
                    
                    
                    TextField("Where to?", text: $viewModel.queryFragment)
                        .frame(height: 32)
                        .background(Color(.systemGray4))
                        .padding(.trailing)
                }
            }.padding(.horizontal)
                .padding(.top ,64)
            
            Divider()
                .padding(.vertical)
            
            // list view
            
            ScrollView{
                VStack(alignment: .leading){
                    ForEach(viewModel.results, id: \.self){ result in
                        LocationSearchResultCell(title: result.title, subTitle: result.subtitle)
                            .onTapGesture {
                                withAnimation(.spring()){
                                    viewModel.selectLocation(result)
                                   // showLocationSearchView.toggle()
                                    mapState = .LocationSelected
                                }
                             
                               
                            }
                    }
                }
            }
            
          
            
        }
        .background(.white)
    }
}

struct LocationSearchView_Previews: PreviewProvider {
    static var previews: some View {
        LocationSearchView(mapState: .constant(.searchingForLocation))
    }
}
