//
//  MedicineDetail.swift
//  Thesis_2020
//
//  Created by Triet Nguyen on 10/12/20.
//

import SwiftUI

struct MedicineDetail: View {
    var jokes: JokesData

    var body: some View {
        VStack(alignment: .leading) {
            HStack {
                Image("splashIcon")
                    .resizable()
                    .frame(height: 400)
                    .aspectRatio(contentMode: .fit)
                    .clipped()
                //                .edgesIgnoringSafeArea(.top)
    //                .frame(width: 100, height: 100, alignment: .top)
                    
            }
            

            VStack(alignment: .leading) {
                Text("Name")
                    .font(.largeTitle)
                    .padding(.all)

                HStack(alignment: .top) {
                    Text(jokes.joke)
                        .font(.subheadline)
                        .padding(.leading)
                }
            }
        }
        .navigationBarTitle(Text("Name"), displayMode: .inline)
    }
}

struct LandmarkDetail_Previews: PreviewProvider {
    static var previews: some View {
        let joke = JokesData(id: 1, joke: "Helo", categories: [])
        MedicineDetail(jokes: joke)
    }
}

