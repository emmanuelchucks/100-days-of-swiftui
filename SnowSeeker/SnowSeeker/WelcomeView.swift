//
//  WelcomeView.swift
//  SnowSeeker
//
//  Created by Emmanuel Chucks on 22/04/2022.
//

import SwiftUI

struct WelcomeView: View {
    var body: some View {
        VStack {
            Text("Welcome to SnowSeeker!")
                .font(.largeTitle)
            Text("Select a resort from the left-hand menu. Swipe from the left to show it.")
                .foregroundColor(.secondary)
        }
    }
}

struct WelcomeView_Previews: PreviewProvider {
    static var previews: some View {
        WelcomeView()
    }
}
