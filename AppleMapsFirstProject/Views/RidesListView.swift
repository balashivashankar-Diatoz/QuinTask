//
//  RidesListView.swift
//  AppleMapsFirstProject
//
//  Created by Bala Shiva Shankar on 27/08/23.
//

import SwiftUI
import CoreData
// MARK: - RidesListView
struct RidesListView: View {
    // MARK: - Properties
    // fetch request to fetch data from Coredata
    @FetchRequest(entity: TripsDetails.entity(), sortDescriptors: [NSSortDescriptor(keyPath: \TripsDetails.id, ascending: false)],animation: .easeOut(duration: 0.3)) private var tripItems:FetchedResults<TripsDetails>
    @Environment(\.presentationMode) var presentationMode
    @State var isTripDetails:Bool = false
    @State var distance:String = ""
    @State var time:String = ""
    var body: some View {
        NavigationView {
            VStack{
                Spacer().frame(height: UIScreen.main.bounds.size.width/6.25)
                HStack{
                    // MARK: - Back Button
                    Button(action: {
                        self.presentationMode.wrappedValue.dismiss()
                    }) {
                        Image(systemName: "chevron.left")
                            .padding(.all)
                            .frame(width: UIScreen.main.bounds.size.width/9.8684210526, height: UIScreen.main.bounds.size.width/9.8684210526)
                    }
                    Spacer()
                }
                .frame(width:UIScreen.main.bounds.size.width)
                .padding(.leading,UIScreen.main.bounds.size.width/18.75)
                Text("Rides List")
                    .font(.system(size: UIScreen.main.bounds.size.width/15))
                    .bold()
                Spacer().frame(height: UIScreen.main.bounds.size.width/18.75)
                ScrollView(Axis.Set.vertical, showsIndicators: false) {
                    ForEach(tripItems){ trip in
                        VStack{
                            HStack{
                                VStack{
                                    Text("Time")
                                        .bold()
                                    if let tripTime = trip.tripTime{
                                        Text(tripTime)
                                            .bold()
                                            .foregroundColor(Color.black)
                                    }
                                }
                                Spacer()
                                VStack{
                                    Text("Distance")
                                        .bold()
                                    Text("\(String(format: "%.2f", trip.tripDistance)) KM")
                                        .bold()
                                        .foregroundColor(Color.black)
                                }
                            }
                            .padding([.leading,.trailing],UIScreen.main.bounds.size.width/12.5)
                            .background(Color.purple)
                            .cornerRadius(UIScreen.main.bounds.size.width/25)
                            Spacer().frame(height: UIScreen.main.bounds.size.width/18.75)
                        }
                        .frame(width:UIScreen.main.bounds.size.width/1.11940299, height: UIScreen.main.bounds.size.width/6.25)
                        .onTapGesture {
                            if let tripTime = trip.tripTime{
                                time = tripTime
                            }
                            distance = "\(String(format: "%.2f", trip.tripDistance)) KM"
                            isTripDetails = true
                        }
                    }
                    Spacer().frame(height: UIScreen.main.bounds.size.width/6.25)
                }
                Spacer()
                NavigationLink(destination: TripDetailsView(distance: distance, time: time).navigationBarTitle("").navigationBarHidden(true),isActive: $isTripDetails) {}
            }
            .frame(width:UIScreen.main.bounds.size.width/1.11940299,alignment: .top)
            .ignoresSafeArea()
        }
        
    }
}

struct RidesListView_Previews: PreviewProvider {
    static var previews: some View {
        RidesListView()
    }
}
