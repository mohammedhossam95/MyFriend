//
//  MemoriesVC.swift
//  MyFriend
//
//  Created by MacBook Pro on 2/6/19.
//  Copyright © 2019 MacBook Pro. All rights reserved.
//

import UIKit
import Kingfisher

class MemoriesVC: BaseViewController {
    
    @IBOutlet weak var memoryImage: UIImageView!
    @IBOutlet weak var memoryText: UITextView!
    @IBOutlet weak var btn: UIButton!
    var imagePiker: UIImagePickerController!
    var photo: String = ""
    
    var picker_image: UIImage?{
        didSet{
            guard let image = picker_image else { return }
            
            self.memoryImage.image = image
            let imageData = image.jpegData(compressionQuality: 0.5)
            let base64String =  imageData?.base64EncodedString(options: [])
            guard let base64 = base64String else { return }
            let base64String1 = "data:image/jpeg;base64,\(base64)"
            photo = base64String1
            // print("the first photo is \(base64String1) the end")
            //SocketIOManager.sharedInstance.sendVideoToServerSocket(user_id: uid!, fileBase64: base64String1, fileType: "image")
            

        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        memoryText.delegate = self
        SetupView()
        // Do any additional setup after loading the view.
    }
    
    @IBAction func backPressed(_ sender: UIButton) {
        _ = self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func ChangePhoto(_ sender: UIButton) {
        
        imagePiker = UIImagePickerController()
        imagePiker.allowsEditing = true
        imagePiker.sourceType = .photoLibrary
        imagePiker.setEditing(true, animated: true)
        imagePiker.mediaTypes = ["public.image"]
        imagePiker.delegate = self
        self.present(imagePiker, animated: true, completion: nil)
        
    }
    
    @IBAction func postMemory(_ sender: UIButton) {
        self.showLoading()
        let uid = helper.getUserId()
        if memoryText.text.count > 0 && photo != "" {
            guard let storyText = memoryText.text, storyText.count > 0 else {
                showAlertError(title: "Enter Text first")
                return}
            SocketIOManager.sharedInstance.sendVideoToServerSocket(user_id: uid!, text: storyText, fileBase64: photo, fileType: "image")
            let alertController = UIAlertController(title: "post", message: "User Memory Uploaded Succesfully", preferredStyle: .alert)
            
            
            let cancelBtn = UIAlertAction(title: "OK", style: .cancel) { (action) in
                print("Cancel btn")
            }
            alertController.addAction(cancelBtn)
            
            self.navigationController?.present(alertController, animated: true, completion: nil)
            self.hideLoading()
        }else {
            self.hideLoading()
            let alertController = UIAlertController(title: "post", message: "Please fill all fields", preferredStyle: .alert)
            let cancelBtn = UIAlertAction(title: "Try Again", style: .cancel) { (action) in
                print("Cancel btn")
                _ = self.navigationController?.popViewController(animated: true)
            }
            alertController.addAction(cancelBtn)
            self.navigationController?.present(alertController, animated: true, completion: nil)
        }

    }
    
    func SetupView() {
        
        memoryImage.layer.cornerRadius = 10.0
        memoryImage.clipsToBounds = true
        
        memoryText.layer.cornerRadius = 10.0
        memoryText.clipsToBounds = true
        
        btn.layer.cornerRadius = 10.0
        btn.clipsToBounds = true
        
    }
}
extension MemoriesVC: UIImagePickerControllerDelegate, UINavigationControllerDelegate{
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
         if let editedImage = info[.editedImage] as? UIImage{
            self.picker_image = editedImage
        }else if let originalImage = info[.originalImage] as? UIImage {
            self.picker_image = originalImage
        }
        imagePiker.dismiss(animated: true, completion: nil)
        
    }
}
extension MemoriesVC: UITextViewDelegate{
    func textViewDidBeginEditing(_ textView: UITextView) {
        memoryText.text = String()
    }
}
