//
//  ContentView.swift
//  SimpleMetalRenderer
//
//  Created by Alex Shepard on 4/16/24.
//

import SwiftUI

struct ContentView: View {
    @State private var item = "box"
    private var items = ["box", "sphere"]
    var body: some View {
        VStack {
            MetalView(shape: $item)
                .border(Color.black, width: 2)
            Picker("Shape", selection: $item) {
                ForEach(items, id: \.self) { item in
                    Text(item)
                }
            }
            Text("Hello, \(item)")
        }
        .padding()
    }
}

#Preview {
    ContentView()
}
