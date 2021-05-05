//
//  JourneyView.swift
//  Distance Tracker
//
//  Created by Jeet Gandhi on 6/4/21.
//

import SwiftUI

struct JourneyView: View {
    
    @State private var animationAmount: CGFloat = 1
    @State private var distance = 0.0
    @State private var journeyStarted = false
    @State private var errorMessage = ""
    
    @ObservedObject private var viewModel = JourneyViewModel()
    let cancelBag = CancelBag()
    
    var body: some View {
        VStack {
            MapView(coordinates: viewModel.locationList)
            Spacer(minLength: 20)
            Button(journeyStarted ? "End Journey" : "Start Journey") {
                if journeyStarted {
                    viewModel.end()
                } else {
                    viewModel.start()
                }
                journeyStarted.toggle()
            }.font(Font.system(size: 18))
            .padding(60)
            .background(journeyStarted ? Color.red : Color.green)
            .foregroundColor(.white)
            .clipShape(Circle())
            .overlay(
                Circle()
                    .stroke(journeyStarted ? Color.red : Color.green)
                    .scaleEffect(animationAmount)
                    .opacity(Double(2 - animationAmount))
                    .animation(
                        Animation.easeOut(duration: 1)
                            .repeatForever(autoreverses: false)
                    )
            ).onAppear {
                self.animationAmount = 2
            }
            Spacer(minLength: 50)
            Text("Distance walked or ran in journey \(viewModel.distance.value, specifier: "%.2f")")
            Spacer(minLength: 10)
        }
        .padding()
        .onAppear {
            viewModel.locationManager.requestAlwaysAuthorization()
        }
    }
}

struct JourneyView_Previews: PreviewProvider {
    static var previews: some View {
        JourneyView()
    }
}
