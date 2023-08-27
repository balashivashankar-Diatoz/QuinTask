//
//  BottomCardView.swift
//  AppleMapsFirstProject
//
//  Created by Bala Shiva Shankar on 26/08/23.
//

import SwiftUI
// MARK: - BottomCardView
struct BottomCardView: View {
    // MARK: - Properties
    @ObservedObject var tripData = TripData.shared
    @Environment(\.dismiss) private var dismiss
    @Environment(\.managedObjectContext) private var context
    var body: some View {
        VStack{
            Spacer()
            HStack{
                Button(action: tripData.multiBtnAction){
                    Text(tripData.tripState == .paused ? "RESUME":"PAUSE")
                }
                .modifier(CustomButtonModifier(backroundColor: Color.yellow))
                Spacer()
                if tripData.tripState == .paused{
                    Button(action: endAction){
                        Text("End Trip")
                    }
                    .modifier(CustomButtonModifier(backroundColor: Color.red))
                }
            }
            .padding([.leading,.trailing],UIScreen.main.bounds.size.width/12.5)
            Spacer()
            HStack{
                // MARK: - Time
                VStack{
                    Text("Time")
                        .bold()
                    Text("\(tripData.timeElasped.asUniversalTime(style: .abbreviated).0)")
                        .bold()
                        .foregroundColor(tripData.tripState == .paused ? Color.yellow:Color.black)
                }
                Spacer()
                // MARK: - Distance
                VStack{
                    Text("Distance")
                        .bold()
                    Text("\(String(format: "%.2f", getDistance(distanceInMetres: tripData.distance))) KM")
                        .bold()
                        .foregroundColor(tripData.tripState == .paused ? Color.yellow:Color.black)
                }
            }
            .padding([.leading,.trailing],UIScreen.main.bounds.size.width/12.5)
            .background(Color.purple)
            Spacer()
        }
        .frame(width:UIScreen.main.bounds.size.width/1.11940299, height: UIScreen.main.bounds.size.width/3.75)
        .background(Color.black.opacity(0.4))
        .cornerRadius(10)
        
    }
    // End ride Button Action
    func endAction(){
        do{
            let tripsDetails = TripsDetails(context: self.context)
            tripsDetails.id = .init()
            tripsDetails.tripTime = "\(tripData.timeElasped.asUniversalTime(style: .abbreviated).0)"
            tripsDetails.tripDistance = getDistance(distanceInMetres: tripData.distance)
            try self.context.save()
            self.dismiss()
            tripData.endBtnAction()
        }
        catch{
            print(error.localizedDescription)
        }
    }
}

struct BottomCardView_Previews: PreviewProvider {
    static var previews: some View {
        BottomCardView()
    }
}

// function to convert meters to KiloMeters
func getDistance(distanceInMetres: Double) -> Double {
    return distanceInMetres/1000.0
}
