//
//  GenerativeJuliaVC.swift
//  TestingAppleTV
//
//  Created by Guilherme Enes on 09/07/20.
//  Copyright © 2020 Guilherme Enes. All rights reserved.
//

import Foundation
import UIKit
import MetalKit
import CoreData
import AVKit

class GenerativeArtVC: UIViewController {
    
    var metalView: MTKView {
        return self.view as! MTKView
    }
    
    @IBOutlet weak var descriptionView: DescriptionView!
    
    var set: Sets = .some
    var setIndex: Int = 0
    var renderer: Renderer?
    
    var context: NSManagedObjectContext?
    
    var audioPlayer: AVAudioPlayer?
        
    override func viewDidLoad() {
        super.viewDidLoad()
        context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        
        setupMetal()
        renderer?.animate = true
        
        startBackgroundMusic()
        
        setupTagGesture()
        descriptionView.descriptionText.text = artData[setIndex].description
    }
    
    override func pressesBegan(_ presses: Set<UIPress>, with event: UIPressesEvent?) {
        guard let context = self.context,
            let texture = metalView.currentDrawable?.texture,
            let image = texture.toImage()
            else { return }
        
        let uiimage = UIImage(cgImage: image)
        
        let newMemory = NSEntityDescription.insertNewObject(forEntityName: "Memory", into: context) as! Memory
        newMemory.set = self.set.rawValue
        newMemory.image = uiimage.pngData()
        
        (UIApplication.shared.delegate as! AppDelegate).saveContext()
        
        // Music
        for press in presses {
            if press.type == .playPause {
                if (audioPlayer!.isPlaying == true) {
                    audioPlayer!.stop()
                    metalView.isPaused =  true
                } else {
                    audioPlayer!.play()
                    metalView.isPaused =  false
                }
            }
            
            if press.type == .menu {
                MusicPlayer.shared.stopPlaying()
            }
            
        // DescriptionView
            if  press.type == .select {
                    if (descriptionView.isHidden == true) {
                                descriptionView.isHidden = false

                            } else {
                        descriptionView.isHidden = true
                            }
                    }
            }
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
    
    func startBackgroundMusic() {
        var songName = ""
        switch set {
        case .julia:
            songName = "bensound-birthofahero"
        case .mandelbrot:
            songName = "bensound-tomorrow"
        case.some:
            songName = "bensound-memories"
        }
        
        if let bundle = Bundle.main.path(forResource: "\(songName.self)", ofType: "mp3") {
            let backgroundMusic = NSURL(fileURLWithPath: bundle)
            do {
                audioPlayer = try AVAudioPlayer(contentsOf:backgroundMusic as URL)
                guard let audioPlayer = audioPlayer else { return }
                audioPlayer.numberOfLoops = -1
                audioPlayer.prepareToPlay()
                audioPlayer.play()
                
                if audioPlayer.isPlaying {
                    audioPlayer.play()
                } else {
                    audioPlayer.stop()
                }
                
            } catch {
                print(error)
            }
        }
    }
    
    func setupTagGesture() {
        let tapRecognizer = UITapGestureRecognizer(target: self, action: #selector(didTap))
        tapRecognizer.allowedPressTypes = [NSNumber(value: UIPress.PressType.select.rawValue)]
        self.view.addGestureRecognizer(tapRecognizer)
    }
    
    @objc func didTap(gesture: UITapGestureRecognizer) {
        self.descriptionView.layer.opacity = 0
        UIView.animate(withDuration: 1, animations: {
            self.descriptionView.isHidden = false
            self.descriptionView.layer.opacity = 1
        }) { (completed) in
            UIView.animate(withDuration: 1, delay: 10, animations: {
                self.descriptionView.layer.opacity = 0
            }) { (completed) in
                self.descriptionView.isHidden = true
            }
        }
        
    }
    
}
