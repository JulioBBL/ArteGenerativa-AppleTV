//
//  ViewController.swift
//  MetalGenerativeArt
//
//  Created by Lia Kassardjian on 09/07/20.
//  Copyright © 2020 Lia Kassardjian. All rights reserved.
//

import UIKit
import MetalKit

class GenerativeArtViewController: UIViewController {
    
    @IBOutlet weak var imageView: UIImageView!
    
    var set: Sets = .some
    
    var metalView: MTKView {
        return self.view as! MTKView
    }
    
    var renderer: Renderer?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupMetal()
    }
    
    func setupMetal() {
        metalView.device = MTLCreateSystemDefaultDevice()
        metalView.depthStencilPixelFormat = MTLPixelFormat.depth32Float_stencil8
        metalView.preferredFramesPerSecond = 60
        metalView.clearColor = MTLClearColor(red: 1.0, green: 0.4, blue: 0.0, alpha: 1.0)
        metalView.framebufferOnly = false
        
        self.renderer = Renderer(device: metalView.device!, metalView: metalView, set: set)
        metalView.delegate = self.renderer
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        renderer?.animate.toggle()
    }
    
    @IBAction func saveImage(_ sender: Any) {
        guard let texture = metalView.currentDrawable?.texture,
            let image = texture.toImage()
            else { return }
        
        imageView.image = UIImage(cgImage: image)
    }

}
