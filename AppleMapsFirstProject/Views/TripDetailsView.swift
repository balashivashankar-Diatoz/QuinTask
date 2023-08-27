//
//  TripDetailsView.swift
//  AppleMapsFirstProject
//
//  Created by Bala Shiva Shankar on 27/08/23.
//

import SwiftUI
// MARK: - TripDetailsView
struct TripDetailsView: View {
    // MARK: - Properties
    @Environment(\.presentationMode) var presentationMode
    @State var distance:String
    @State var time:String
    var body: some View {
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
            Text("Trip Details")
                .font(.system(size: UIScreen.main.bounds.size.width/10.7142857))
                .bold()
            Spacer().frame(height: UIScreen.main.bounds.size.width/18.75)
            VStack(alignment: .leading){
                Spacer()
                VStack{
                    Text("Distance Travelled by Rider")
                        .bold()
                    Text(distance)
                        .font(.system(size: UIScreen.main.bounds.size.width/10.7142857))
                        .bold()
                        .foregroundColor(Color.white)
                }
                .frame(width:UIScreen.main.bounds.size.width/1.11940299, alignment: .center)
                Spacer()
                VStack{
                    Text("Total Time took to colplete the ride")
                        .bold()
                    Text(time)
                        .font(.system(size: UIScreen.main.bounds.size.width/10.7142857))
                        .bold()
                        .foregroundColor(Color.white)
                }
                .frame(width:UIScreen.main.bounds.size.width/1.11940299, alignment: .center)
                Spacer()
            }
            .frame(width:UIScreen.main.bounds.size.width/1.11940299,height: UIScreen.main.bounds.size.width/2.142, alignment: .center)
            .padding(.leading,UIScreen.main.bounds.size.width/18.75)
            .background(Color.purple)
            .cornerRadius(10)
            Spacer()
        }
        .background(Color.yellow)
        .frame(width:UIScreen.main.bounds.size.width/1.11940299,alignment: .top)
        .ignoresSafeArea()
        
    }
}

struct TripDetailsView_Previews: PreviewProvider {
    static var previews: some View {
        TripDetailsView(distance: "10", time: "1H")
    }
}
