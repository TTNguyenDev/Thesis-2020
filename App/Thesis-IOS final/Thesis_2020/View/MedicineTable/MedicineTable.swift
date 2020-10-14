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
    @State var firstLoading = false
    @Binding var uiimage: UIImage?
    
    var body: some View {
            List(observed.dlResults){ i in
                NavigationLink(destination: MedicineDetail(dlResult: i)) {
                    MedicineRow(dlResult: i)
                }
            }
            .navigationBarTitle("Medicine List", displayMode: .inline)
            .onAppear() {
               
                if (!firstLoading) {
                    observed.getTextWithImage(image: uiimage!)
                    firstLoading = true
                }
            
            }
    }
    
}
