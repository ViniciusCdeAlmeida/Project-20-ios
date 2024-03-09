//
//  ViewController.swift
//  Seafood
//
//  Created by Apple Multiplier on 09/03/24.
//

import CoreML
import UIKit
import Vision

class ViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    @IBOutlet var imageView: UIImageView!

    let imagePicker = UIImagePickerController()

    override func viewDidLoad() {
        super.viewDidLoad()
        imagePicker.delegate = self

        imagePicker.sourceType = .camera
        imagePicker.allowsEditing = true
    }

    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey: Any]) {
        if let image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
            imageView.image = image

            guard let ciImage = CIImage(image: image) else {
                fatalError("Sorryyyy")
            }
            detect(image: ciImage)
        }
        imagePicker.dismiss(animated: true, completion: nil)
    }

    func detect(image: CIImage) {
        guard let model = try? VNCoreMLModel(for: Inceptionv3().model) else {
            fatalError("erro COREML")
        }

        let request = VNCoreMLRequest(model: model) { req, _ in
            guard let results = req.results as? [VNClassificationObservation] else {
                fatalError("error")
            }
            if let firstResult = results.first {
                if firstResult.identifier.contains("hotdog") {
                    self.navigationItem.title = "Hotdog"
                } else {
                    self.navigationItem.title = "Not Hotdog"
                }
            }
        }

        let handler = VNImageRequestHandler(ciImage: image)

        try! handler.perform([request])
    }

    @IBAction func cameraTap(_ sender: UIBarButtonItem) {
        present(imagePicker, animated: true, completion: nil)
    }
}
