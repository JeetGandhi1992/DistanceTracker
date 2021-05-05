//
//  ContentView.swift
//  Distance Tracker
//
//  Created by Jeet Gandhi on 5/4/21.
//

import SwiftUI

struct ContentView: View {
    
    @State private var animationAmount: CGFloat = 1
    @State private var stepCount = 0.0
    @State private var journeyStarted = false
    @State private var errorMessage = ""
    
    private var viewModel = DistanceManagerViewModel()
    let cancelBag = CancelBag()
    
    var body: some View {
        VStack {
            Spacer(minLength: 50)
            Button(journeyStarted ? "End Journey" : "Start Journey") {
                if journeyStarted {
                    viewModel.endJourney()
                } else {
                    viewModel.getHealthAuthorization()
                }
                journeyStarted.toggle()
            }
            .padding(60)
            .background(Color.red)
            .foregroundColor(.white)
            .clipShape(Circle())
            .overlay(
                Circle()
                    .stroke(Color.red)
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
            Text("Distance in walked or ran in journey \(stepCount, specifier: "%.2f")")
            if self.errorMessage != "" {
                Text("\(viewModel.errorMessage)")
            }
            Spacer(minLength: 50)
        }
        .onReceive(viewModel.$stepCount, perform: { value in
            self.stepCount = Double(value)
            self.errorMessage = viewModel.errorMessage
        })
        .padding()
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
