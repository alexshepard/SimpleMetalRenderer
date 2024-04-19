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
    
    func updateNSView(_ nsView: NSViewType, context: Context) { }
}

struct MetalView: View {
    @State private var renderer: Renderer?
    @State private var metalView = MTKView()
    
    var body: some View {
        MetalViewRepresentable(metalView: $metalView)
            .onAppear {
                renderer = Renderer(metalView: metalView)
            }
    }
}

