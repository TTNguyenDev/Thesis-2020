//
//  MedicineTable.swift
//  Thesis_2020
//
//  Created by Triet Nguyen on 10/12/20.
//

import SwiftUI

struct MedicineTable: View {
    @Binding var image: Image?
    @ObservedObject var observed = Observer()
    
    var body: some View {
            List(observed.jokes){ i in
                NavigationLink(destination: MedicineDetail(jokes: i)) {
                    MedicineRow(jokes: i)
                }
            }
            .navigationBarTitle("Medicine List", displayMode: .inline)
    }
    
}
