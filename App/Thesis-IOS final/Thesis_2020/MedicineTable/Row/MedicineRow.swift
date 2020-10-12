//
//  MedicineRow.swift
//  Thesis_2020
//
//  Created by Triet Nguyen on 10/12/20.
//

import SwiftUI

struct MedicineRow: View {
    var jokes: JokesData

    var body: some View {
        HStack {
            Image("splashIcon")
                .resizable()
                .frame(width: 50, height: 50)
            Spacer()
            VStack {
                Text("Name")
                    .font(.title2)
                    .frame(maxWidth: .infinity, alignment: .leading)
                Text(jokes.joke)
                    .font(.subheadline)
                    .frame(maxWidth: .infinity, alignment: .leading)

            }
            
            Spacer()
        }
    }
}

