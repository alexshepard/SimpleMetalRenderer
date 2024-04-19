//
//  ContentView.swift
//  SimpleMetalRenderer
//
//  Created by Alex Shepard on 4/16/24.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        VStack {
            MetalView()
                .border(Color.black, width: 2)
            Text("Hello, metal!")
        }
        .padding()
    }
}

#Preview {
    ContentView()
}
