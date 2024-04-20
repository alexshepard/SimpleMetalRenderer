//
//  MetalView.swift
//  SimpleMetalRenderer
//
//  Created by Alex Shepard on 4/19/24.
//

import SwiftUI
import MetalKit



struct MetalViewRepresentable: NSViewRepresentable {
    @Binding var metalView: MTKView
    
    func makeNSView(context: Context) -> some NSView {
        metalView
    }
    
    func updateNSView(_ nsView: NSViewType, context: Context) { 
        print("update nsview")
    }
}

struct MetalView: View {
    @State private var renderer: Renderer?
    @State private var metalView = MTKView()
    @Binding var shape: String
    
    var body: some View {
        VStack {
            MetalViewRepresentable(metalView: $metalView)
            Text(shape)
        }
        .onAppear {
            print("shape is \(shape)")
            renderer = Renderer(metalView: metalView, shape: shape)
        }
        .onChange(of: shape) { _, _ in
            if shape == "box" {
                renderer?.showBox()
            } else {
                renderer?.showSphere()
            }
            print("shape changed")
        }
    }
}

