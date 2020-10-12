//
//  SplashView.swift
//  Thesis_2020
//
//  Created by Triet Nguyen on 10/12/20.
//

import SwiftUI

struct SplashView: View {
    @State var isActive:Bool = false
    
    var body: some View {
        Color(#colorLiteral(red: 0.4054629207, green: 1, blue: 0.9102324843, alpha: 1))
            .ignoresSafeArea()
            .overlay(
                VStack {
                    if self.isActive {
                        MainView()
                    } else {
                        Image("splashIcon")
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width: 300, height: 300, alignment: .center)
                    }
                })
            
            .onAppear {
                DispatchQueue.main.asyncAfter(deadline: .now() + 2.5) {
                    withAnimation {
                        self.isActive = true
                    }
                }
            }
    }
}

struct SplashView_Previews: PreviewProvider {
    static var previews: some View {
        SplashView()
    }
}

