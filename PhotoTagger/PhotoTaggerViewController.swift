//
//  PhotoTaggerViewController.swift
//  PhotoTagger
//
//  Created by Matheus Pacheco Fusco on 07/03/17.
//  Copyright © 2017 Matheus Pacheco Fusco. All rights reserved.
//

import UIKit

class PhotoTaggerViewController: UIViewController {
    
    //MARK: - IBOutlets
    @IBOutlet weak var takePhotoButton: UIButton!
    @IBOutlet weak var activityIndicatorView: UIActivityIndicatorView!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var progressView: UIProgressView!
    
    //MARK: - Properties
    fileprivate var tags : [String]?
    fileprivate var colors : [PhotoColor]?
    
    //MARK: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        guard !UIImagePickerController.isSourceTypeAvailable(.camera) else {
            return
        }
        takePhotoButton.setTitle("Select photo", for: .normal)
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        imageView.image = nil
    }
    
    // MARK: - Button Actions
    @IBAction func takePictureButtonClicked(_ sender: Any) {
        let picker = UIImagePickerController()
        picker.delegate = self
        picker.allowsEditing = true
        
        if UIImagePickerController.isSourceTypeAvailable(.camera) {
            picker.sourceType = .camera
        }
        else {
            picker.sourceType = .photoLibrary
            picker.modalPresentationStyle = .fullScreen
        }
        
        present(picker, animated: true, completion: nil)
    }
    
    // MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "ShowResults" {
            let tagOrColorVC = segue.destination as! ResultsViewController
            tagOrColorVC.tags = tags
            tagOrColorVC.colors = colors
        }
    }

    //MARK: - Memory Management
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}


extension PhotoTaggerViewController: UIImagePickerControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        guard let image = info[UIImagePickerControllerOriginalImage] as? UIImage else {
            dismiss(animated: true, completion: nil)
            return
        }
        
        imageView.image = image
        dismiss(animated: true, completion: nil)
    }
}

extension PhotoTaggerViewController: UINavigationControllerDelegate {
    
}
