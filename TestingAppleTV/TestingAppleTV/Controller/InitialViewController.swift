//
//  InitialViewController.swift
//  TestingAppleTV
//
//  Created by Tamara Erlij on 09/07/20.
//  Copyright © 2020 Guilherme Enes. All rights reserved.
//

import UIKit
import MetalKit

class InitialViewController: UIViewController {
    
    var metalView: MTKView {
        return self.view as! MTKView
    }
    
    var renderer: Renderer?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTap()
        setupMetal()
        renderer?.animate = true
        renderer?.isOnboarding = true
    }
    
    func setupTap() {
        let defaults = UserDefaults.standard
        let touchDown = UILongPressGestureRecognizer(target:self, action: #selector(didTouchDown))
        defaults.set(true, forKey: "hasViewedWalkthrough")
        touchDown.minimumPressDuration = 0
        dismiss(animated: true, completion: nil)
        view.addGestureRecognizer(touchDown)
    }
    
    func setupMetal() {
        metalView.device = MTLCreateSystemDefaultDevice()
        metalView.depthStencilPixelFormat = MTLPixelFormat.depth32Float_stencil8
        metalView.preferredFramesPerSecond = 60
        metalView.clearColor = MTLClearColor(red: 1.0, green: 0.4, blue: 0.0, alpha: 1.0)
        metalView.framebufferOnly = false
        
        self.renderer = Renderer(device: metalView.device!, metalView: metalView, set: .julia)
        metalView.delegate = self.renderer
    }
    
    @objc func didTouchDown(gesture: UILongPressGestureRecognizer) {
        if gesture.state == .began {
            performSegue(withIdentifier: "goToMainScreen", sender: self)
        }
    }
}
