//
//  MainView.swift
//  Thesis_2020
//
//  Created by Triet Nguyen on 10/12/20.
//

import SwiftUI

struct MainView: View {
    
    @State var image: Image? = Image("demo")
    @State var showCaptureImageView: Bool = true
    
    var body: some View {
        NavigationView {
            VStack {
//                if (showCaptureImageView) {
//                    CaptureImageView(isShown: $showCaptureImageView, image: $image)
//                } else {
                    NavigationLink(destination: MedicineTable(image: $image)) {
                        image!
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                    }.navigationBarTitle("Camera View")
//                }
            }
        }
    }
}
