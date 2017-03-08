//
//  PhotoTaggerViewController.swift
//  PhotoTagger
//
//  Created by Matheus Pacheco Fusco on 07/03/17.
//  Copyright © 2017 Matheus Pacheco Fusco. All rights reserved.
//

import UIKit
import Alamofire

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

extension PhotoTaggerViewController {
    func upload (image : UIImage,
                 progressCompletion : @escaping ( _ percent : Float) -> Void,
                 completion : @escaping ( _ tags : [String], _ colors : [PhotoColor]) -> Void){
        guard let imageData = UIImageJPEGRepresentation(image, 0.5) else {
            print("Could not get JPEG representation of image")
            return
        }
        
        Alamofire.upload(multipartFormData: { (multipartFormData) in
            multipartFormData.append(imageData,
                                     withName: "imagefile",
                                     fileName: "image.jpeg",
                                     mimeType: "image/jpeg")
        },
        to: "http://api.imagga.com/v1/content",
        headers : ["Authorization" : "Basic YWNjXzg0NTRjMGMyY2FiZDc0MzpiNTkyODU2MDllN2U0NzdiNjRlODQxZWViMzFmNjg2Yg=="],
        encodingCompletion: { (encodingResult) in
            switch encodingResult {
                case .success(request: let upload, _, _) :
                    upload.uploadProgress(closure: { (progress) in
                        progressCompletion(Float(progress.fractionCompleted))
                    })
                    upload.validate()
                    upload.responseJSON(completionHandler: { (response) in
                        guard response.result.isSuccess else {
                            completion([String](), [PhotoColor]())
                            return
                        }
                        
                        guard let responseJSON = response.result.value as? [String : Any], let uploadedFile = responseJSON["uploaded"] as? [[String : Any]], let firstFile = uploadedFile.first, let firstFileID = firstFile["id"] as? String else {
                            print("Invalid information received from service")
                            completion([String](), [PhotoColor]())
                            return
                        }
                        
                        print("File uploaded successfully: \(firstFileID)")
                        
                        completion([String](), [PhotoColor]())
                    })
                    break
                
                case .failure(let encodingError) :
                    print(encodingError)
                    break
            }
        })
        
    }
}

//MARK: - UIImagePickerController Delegate
extension PhotoTaggerViewController: UIImagePickerControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        
        guard let image = info[UIImagePickerControllerOriginalImage] as? UIImage else {
            dismiss(animated: true, completion: nil)
            return
        }
        
        imageView.image = image
        
        takePhotoButton.isHidden = true
        
        progressView.progress = 0.0
        progressView.isHidden = false
        
        activityIndicatorView.startAnimating()
        
        upload(image: image,
               progressCompletion: { (percent) in
                self.progressView.setProgress(percent, animated: true)
        }) { (tags, colors) in
            
            self.takePhotoButton.isHidden = false
            self.progressView.isHidden = true
            self.activityIndicatorView.stopAnimating()
            
            self.tags = tags
            self.colors = colors
            
            self.performSegue(withIdentifier: "ShowResults", sender: self)
        }
        
        dismiss(animated: true, completion: nil)
    }
}

//MARK: - UINavigationController Delegate
extension PhotoTaggerViewController: UINavigationControllerDelegate {
    
}
