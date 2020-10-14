//
//  MainView.swift
//  Thesis_2020
//
//  Created by Triet Nguyen on 10/12/20.
//

import SwiftUI

struct MainView: View {
    
    @State var image: Image? = Image("thuoc1")
    @State var uiimage: UIImage?
    @State var showCaptureImageView: Bool = true
    
    var body: some View {
        NavigationView {
            VStack {
                if (showCaptureImageView) {
                    CaptureImageView(isShown: $showCaptureImageView, image: $image, uiimage: $uiimage)
                } else {
                
                    NavigationLink(destination: MedicineTable(image: $image, uiimage: $uiimage)) {
                        image!
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                    }.navigationBarTitle("Camera View")
                }
            }
        }
    }
}
