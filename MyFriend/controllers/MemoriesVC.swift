//
//  MemoriesVC.swift
//  MyFriend
//
//  Created by MacBook Pro on 2/6/19.
//  Copyright © 2019 MacBook Pro. All rights reserved.
//

import UIKit
import Kingfisher
import YPImagePicker

class MemoriesVC: BaseViewController {
    
    @IBOutlet weak var memoryImage: UIImageView!
    @IBOutlet weak var memoryText: UITextView!
    @IBOutlet weak var btn: UIButton!
    
    var photo: String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        memoryText.delegate = self
        SetupView()
        // Do any additional setup after loading the view.
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        SocketIOManager.sharedInstance.getgalleryPostsSockets { (post: GPhoto) in
            DispatchQueue.main.async { [weak self] in
                if post.status != "false"{
                    let alertController = UIAlertController(title: "post", message: "User Memory Uploaded Succesfully", preferredStyle: .alert)
                    let okBtn = UIAlertAction(title: "OK", style: .cancel) { (action) in
                        self?.back()
                    }
                    alertController.addAction(okBtn)
                    self?.navigationController?.present(alertController, animated: true, completion: nil)
                    
                }else {
                    let alertController = UIAlertController(title: "Something Error", message:  post.exception, preferredStyle: .alert)
                    alertController.addAction(UIAlertAction(title: "Try Again", style: .cancel))
                    self?.navigationController?.present(alertController, animated: true, completion: nil)
                }
            }
        }
    }
   
    @IBAction func backPressed(_ sender: UIButton) {
        self.back()
    }
    
    @IBAction func ChangePhoto(_ sender: UIButton) {
        changePic()
    }
    
    @objc func changePic() {
        var config = YPImagePickerConfiguration()
        config.showsPhotoFilters = true
        config.startOnScreen = .library
        config.hidesStatusBar = false
        config.screens = [.library]
        config.isScrollToChangeModesEnabled = false
        config.library.maxNumberOfItems = 1
        config.library.mediaType = .photo
        let picker = YPImagePicker(configuration: config)
        picker.didFinishPicking { [unowned picker] items, cancelled in
            if cancelled {
                picker.dismiss(animated: true, completion: nil)
                return
            }
            if let photo = items.singlePhoto {
                let imageData = photo.image.wxCompress().jpegData(compressionQuality: 0.5)
                let base64String =  imageData?.base64EncodedString(options: [])
                guard let base64 = base64String else { return }
                let base64String1 = "data:image/jpeg;base64,\(base64)"
                self.photo = base64String1
                self.memoryImage.image = photo.image
            }
            picker.dismiss(animated: true, completion: nil)
        }
        self.present(picker, animated: true, completion: nil)
    }
    
    @IBAction func postMemory(_ sender: UIButton) {
        self.showLoading()
        let uid = helper.getUserId()
        if memoryText.text.count > 0 && photo != "" {
            guard let storyText = memoryText.text, storyText.count > 0 else {
                showAlertError(title: "Enter Text first")
                return}
            SocketIOManager.sharedInstance.sendVideoToServerSocket(user_id: uid!, text: storyText, fileBase64: photo, fileType: "image")
            self.hideLoading()
        }else {
            self.hideLoading()
            let alertController = UIAlertController(title: "Warning", message: "Please fill all fields", preferredStyle: .alert)
            alertController.addAction(UIAlertAction(title: "Try again", style: .cancel))
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
extension MemoriesVC: UITextViewDelegate{
    func textViewDidBeginEditing(_ textView: UITextView) {
        memoryText.text = String()
    }
}
