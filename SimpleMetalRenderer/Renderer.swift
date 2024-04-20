//
//  Renderer.swift
//  SimpleMetalRenderer
//
//  Created by Alex Shepard on 4/19/24.
//

import MetalKit

class Renderer: NSObject {
    static var device: MTLDevice!
    static var commandQueue: MTLCommandQueue!
    static var library: MTLLibrary!
    
    var squareMesh: MTKMesh!
    var sphereMesh: MTKMesh!
    var mesh: MTKMesh!
    
    var vertexBuffer: MTLBuffer!
    var pipelineState: MTLRenderPipelineState!
    
    func showBox() {
        mesh = squareMesh
        vertexBuffer = mesh.vertexBuffers[0].buffer
    }
    
    func showSphere() {
        mesh = sphereMesh
        vertexBuffer = mesh.vertexBuffers[0].buffer
    }
    
    init(metalView: MTKView, shape: String) {
        print("shape is \(shape)")
        guard let device = MTLCreateSystemDefaultDevice(),
              let commandQueue = device.makeCommandQueue()
        else {
            fatalError("GPU not available")
        }
        
        Self.device = device
        Self.commandQueue = commandQueue
        metalView.device = device
        
        // create the mesh
        let allocator = MTKMeshBufferAllocator(device: device)
        let size: Float = 0.8
        let mdlMesh = MDLMesh(
            boxWithExtent: [size, size, size],
            segments: [1, 1, 1],
            inwardNormals: false,
            geometryType: .triangles,
            allocator: allocator
        )
        
        let mdlMesh2 = MDLMesh(
            sphereWithExtent: [size, size, size],
            segments: [10, 10],
            inwardNormals: false,
            geometryType: .triangles,
            allocator: allocator
        )

        do {
            squareMesh = try MTKMesh(mesh: mdlMesh, device: device)
            sphereMesh = try MTKMesh(mesh: mdlMesh2, device: device)
        } catch {
            print(error.localizedDescription)
        }
        
        mesh = squareMesh
        vertexBuffer = mesh.vertexBuffers[0].buffer
        
        // create the shader function lib
        let lib = device.makeDefaultLibrary()
        Self.library = lib
        let vertexFn = lib?.makeFunction(name: "vertex_main")
        let fragFn = lib?.makeFunction(name: "fragment_main")
        
        // pipeline state
        let pipelineDescriptor = MTLRenderPipelineDescriptor()
        pipelineDescriptor.vertexFunction = vertexFn
        pipelineDescriptor.fragmentFunction = fragFn
        pipelineDescriptor.colorAttachments[0].pixelFormat = metalView.colorPixelFormat
        pipelineDescriptor.vertexDescriptor = MTKMetalVertexDescriptorFromModelIO(mdlMesh.vertexDescriptor)
        do {
            pipelineState = try device.makeRenderPipelineState(descriptor: pipelineDescriptor)
        } catch {
            fatalError(error.localizedDescription)
        }
        
        super.init()
        
        metalView.clearColor = MTLClearColor(
            red: 1.0,
            green: 1.0,
            blue: 0.8,
            alpha: 1.0
        )
        metalView.delegate = self
        
    }
}

extension Renderer: MTKViewDelegate {
    func mtkView(_ view: MTKView, drawableSizeWillChange size: CGSize) {
        
    }
    
    func draw(in view: MTKView) {
        guard let commandBuffer = Self.commandQueue.makeCommandBuffer(),
              let descriptor = view.currentRenderPassDescriptor,
              let renderEncoder = commandBuffer.makeRenderCommandEncoder(descriptor: descriptor)
        else {
            return
        }
        
        renderEncoder.setRenderPipelineState(pipelineState)
        renderEncoder.setVertexBuffer(vertexBuffer, offset: 0, index: 0)
        for submesh in mesh.submeshes {
            renderEncoder.drawIndexedPrimitives(
                type: .triangle,
                indexCount: submesh.indexCount,
                indexType: submesh.indexType,
                indexBuffer: submesh.indexBuffer.buffer,
                indexBufferOffset: submesh.indexBuffer.offset
            )
        }
        
        renderEncoder.endEncoding()
        guard let drawable = view.currentDrawable else { return }
        commandBuffer.present(drawable)
        commandBuffer.commit()
    }
}
