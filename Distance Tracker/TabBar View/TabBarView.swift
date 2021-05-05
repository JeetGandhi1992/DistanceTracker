//
//  TabBarView.swift
//  Distance Tracker
//
//  Created by Jeet Gandhi on 6/4/21.
//

import SwiftUI

struct TabBarView: View {
    var body: some View {
        TabView {
            JourneyView()
                .tabItem {
                    Label("Map",
                          systemImage: "figure.walk")
                }
            ContentView()
                .tabItem {
                    Label("HealthKit",
                          systemImage: "bolt.heart.fill")
                }
        }
    }
}

struct TabBarView_Previews: PreviewProvider {
    static var previews: some View {
        TabBarView()
    }
}
