//
//  FirstViewController.swift
//  TestingAppleTV
//
//  Created by Guilherme Enes on 06/07/20.
//  Copyright © 2020 Guilherme Enes. All rights reserved.
//

import UIKit

enum Sets: String {
    case mandelbrot = "Mandelbrot Set"
    case julia = "Julia Set"
    case some = "Some Set"
}

class GaleryViewController: UIViewController, UICollectionViewDataSource {
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    let defaultSize = CGSize(width: 458, height: 458)
    
    let focusSize = CGSize(width: 510, height: 510)
    
    let vcArray: [String] = ["MandelbrotVC", "GenerativeJuliaVC"]
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        collectionView.delegate = self
        collectionView.dataSource = self
    }
    
    
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "GaleriaCell", for: indexPath) as? GaleryCell {
            
            var imageName = ""
            if indexPath.row == 0 {
                imageName = "mandelbrotSet"
            } else {
                imageName = "juliaSet"
            }
            
            cell.galleryImg.image = UIImage(named: imageName)
            
            return cell
            
        } else {
            return GaleryCell()
        }
    }
    
    @objc func tappedAwayFunction(_ sender: UITapGestureRecognizer) {
        print("Reconhecido o toque")
        
    }
    
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return vcArray.count
        
    }
    
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        collectionView.scrollToItem(at: indexPath, at: .centeredHorizontally, animated: true)
        
        performSegue(withIdentifier: vcArray[indexPath.row], sender: self)
        
    }
    
    
    
    
//    override func didUpdateFocus(in context: UIFocusUpdateContext, with coordinator: UIFocusAnimationCoordinator) {
//
//        if let prev = context.previouslyFocusedView as? GaleryCell {
//            UIView.animate(withDuration: 0.1) {
//                prev.galleryImg.frame.size = self.defaultSize
//            }
//        }
//
//        if let next = context.nextFocusedView as? GaleryCell {
//
//            UIView.animate(withDuration: 0.1) {
//                next.galleryImg.frame.size = self.focusSize
//            }
//        }
//    }
}

extension GaleryViewController: UIScrollViewDelegate, UICollectionViewDelegate {
    
    func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
        let layout = self.collectionView?.collectionViewLayout as! UICollectionViewFlowLayout
        
        let cellWidthIncludingSpacing = layout.itemSize.width + layout.minimumLineSpacing
        
        var offset = targetContentOffset.pointee
        let index = (offset.x + scrollView.contentInset.left) / cellWidthIncludingSpacing
        let roundedIndex = round(index)
        
        offset = CGPoint(x: roundedIndex * cellWidthIncludingSpacing - scrollView.contentInset.left, y: -scrollView.contentInset.top)
        targetContentOffset.pointee = offset
    }
}
