//
//  ViewController.swift
//  IDTest
//
//  Created by Classera on 3/8/21.
//

import UIKit


import UIKit
import Vision

class ViewController: UIViewController, CardDetectionViewControllerDelegate {
    
    @IBOutlet var scanButton: UIButton!
    @IBOutlet var cardImageView: UIImageView!
    @IBOutlet var doneButton: UIButton!
    
    @IBAction func startIDCardScan() {
        let alert = UIAlertController(title: nil, message: nil, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Scan front", style: .default, handler: { _ in
            let controller = CardDetectionViewController()
            controller.delegate = self
            self.present(controller, animated: true)
        }))
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        self.present(alert, animated: true)
    }
    
    @IBAction func done() {
        self.cardImageView.isHidden = true
        self.doneButton.isHidden = true
        self.scanButton.isHidden = false
    }
    
    func cardDetectionViewController(_ viewController: CardDetectionViewController, didDetectCard image: CGImage, withSettings settings: CardDetectionSettings) {
        self.displayDetectedImage(image, aspectRatio: settings.size.width/settings.size.height)
    }
    
//    // Uncomment to implement your own image quality detection
//    func qualityOfImage(_ image: CGImage) -> NSNumber? {
//        if #available(iOS 13, *) {
//            // Return `nil` to use image sharpness as quality score
//            return nil
//        }
//        return NSNumber(value: 1) // Implement your own quality scoring
//    }
    
    func displayDetectedImage(_ image: CGImage, aspectRatio: CGFloat) {
        self.scanButton.isHidden = true
        self.cardImageView.isHidden = false
        self.doneButton.isHidden = false
        if let aspectRatioConstraint = self.cardImageView.constraints.first(where: { $0.identifier == "aspectRatio" }) {
            self.cardImageView.removeConstraint(aspectRatioConstraint)
        }
        let aspectRatioConstraint = NSLayoutConstraint(item: self.cardImageView!, attribute: .width, relatedBy: .equal, toItem: self.cardImageView, attribute: .height, multiplier: aspectRatio, constant: 0)
        aspectRatioConstraint.identifier = "aspectRatio"
        self.cardImageView.addConstraint(aspectRatioConstraint)
        let uiImage = UIImage(cgImage: image)
        self.cardImageView.image = uiImage
    }
    
    func displayBarcodes(_ barcodes: [VNBarcodeObservation]) {
        guard let barcode = barcodes.first?.payloadStringValue else {
            return
        }
        DispatchQueue.main.async {
            let alert = UIAlertController(title: "Barcode", message: barcode, preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
            self.present(alert, animated: true)
        }
    }
}

