//
//  RideRequestView.swift
//  Uber-Clone
//
//  Created by amarjeet patel on 14/01/25.
//

import SwiftUI

struct RideRequestView: View {
    
    @State private var selectedRideType: RideType = .uberX
    @EnvironmentObject var locationViewModel: LocationSearchViewModel
    
    var body: some View {
        VStack{
            Capsule()
                .foregroundColor(.gray)
                .frame(width: 48,height: 6)
                .padding(.top,6)
            
            //trip info
            HStack{
                VStack{
                    Circle()
                        .fill(Color(.systemGray3))
                        .frame(width: 8,height: 8)
                    
                    Rectangle()
                        .fill(Color(.systemGray3))
                        .frame(width: 1,height: 32)
                    
                    Rectangle()
                        .fill(.black)
                        .frame(width: 8,height: 8)
                       
                }
                
                VStack(alignment: .leading, spacing: 24){
                    HStack{
                        Text("current location")
                            .font(.system(size: 16))
                            .foregroundColor(.gray)
                            .fontWeight(.semibold)
                        
                        Spacer()
                        
                        Text(locationViewModel.pickupTime ?? "")
                            .font(.system(size: 14))
                            .fontWeight(.semibold)
                            .foregroundColor(.gray)
                        
                    }.padding(.bottom,10)
                    
                    HStack{
                        if let location = locationViewModel.selectedUberLocation{
                            Text(location.title)
                                .font(.system(size: 16))
                                .fontWeight(.semibold)
                        }
                        
                        Spacer()
                        
                        Text(locationViewModel.dropOffTime ?? "")
                            .font(.system(size: 14))
                            .fontWeight(.semibold)
                            .foregroundColor(.gray)
                        
                    }
                }.padding(.leading,8)
            }.padding()
            
            Divider()
            
            //ride type selection view
            Text("Suggested Rides")
                .font(.subheadline)
                .fontWeight(.semibold)
                .padding()
                .foregroundColor(.gray)
                .frame(maxWidth: .infinity,alignment: .leading)
            
            ScrollView(.horizontal){
                HStack(spacing: 12) {
                    ForEach(RideType.allCases){ type in
                        
                        VStack(alignment: .leading){
                            Image( type.imageName)
                                .resizable()
                                .scaledToFit()
                                
                            
                            VStack(alignment: .leading ,spacing:4){
                                Text(type.description)
                                    .font(.system(size: 14))
                                    .fontWeight(.semibold)
                                 
                                Text(locationViewModel.computeRidePrice(forType: type).toCurrency())
                                    .font(.system(size: 14))
                                    .fontWeight(.semibold)
                                    
                            }.padding()
                            
                        }.frame(width: 112, height: 140)
                            .foregroundColor(type == selectedRideType ? .white : .black)
                            .background(Color(type == selectedRideType ? .systemBlue : .systemGroupedBackground))
                            .scaleEffect(type == selectedRideType ? 1.2: 1.0)
                            .cornerRadius(10)
                            .onTapGesture {
                                withAnimation(.spring()){
                                    selectedRideType = type
                                }
                            }
                        
                    }
                }
            }.padding(.horizontal)
               
            Divider()
                .padding(.vertical,5)
            //payment option view
            
            HStack( spacing: 12) {
                Text("Visa")
                    .font(.subheadline)
                    .fontWeight(.semibold)
                    .padding(6)
                    .background(.blue)
                    .cornerRadius(4)
                    .foregroundColor(.white)
                    .padding(.leading)
                
                Text("*****1234")
                    .fontWeight(.bold)
                
                Spacer()
                
                Image(systemName: "chevron.right")
                    .imageScale(.medium)
                    .padding()
           
            }
            .frame( height: 50)
            .background(Color(.systemGroupedBackground))
            .cornerRadius(10)
            .padding(.horizontal)
            
            //request ride button
            
            Button {
                
            } label: {
                Text("CONFIRM RIDE")
                    .fontWeight(.bold)
                    .frame(width: UIScreen.main.bounds.width - 32, height: 50)
                    .background(Color.blue)
                    .cornerRadius(10)
                    .foregroundColor(.white)
            }

        }
        .padding(.bottom ,24)
        .background(Color.white)
        .cornerRadius(12)
    }
}

struct RideRequestView_Previews: PreviewProvider {
    static var previews: some View {
        RideRequestView()
            .environmentObject(LocationSearchViewModel())
        
    }
}
