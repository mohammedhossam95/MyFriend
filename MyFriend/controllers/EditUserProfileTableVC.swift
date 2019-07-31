//
//  EditUserProfileTableVC.swift
//  MyFriend
//
//  Created by MOHAMED HAMAD on 7/30/19.
//  Copyright © 2019 MacBook Pro. All rights reserved.
//

import UIKit
import Kingfisher
import Fusuma
import IQKeyboardManagerSwift
import WSTagsField

class EditUserProfileTableVC: BaseTableViewController {
    
    @IBOutlet weak var backBtnPressed: UIButton!
    @IBOutlet weak var picView: UIView!
    @IBOutlet weak var profileImage: UIImageView!
    @IBOutlet weak var fullNameTF: MyFriendTextField!
    @IBOutlet weak var birthdateTF: MyFriendTextField!
    @IBOutlet weak var genderTF: MyFriendTextField!
    @IBOutlet weak var interestsTF: MyFriendTextField!
    @IBOutlet weak var workTF: MyFriendTextField!
    @IBOutlet weak var camView: UIView!
    @IBOutlet weak var bioTV: UITextView!
    @IBOutlet weak var hoppies: UIView!
    

    private var datepicker: UIDatePicker?
    let keywordsField = WSTagsField()
    var imagePiker: UIImagePickerController!
    var UProfile = infoProfile()
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUI()
        handleInfoRefresh()
        // Do any additional setup after loading the view.
    }
    
   private func setupUI(){
        title = ""
        picView.layer.cornerRadius = picView.bounds.height / 2
        picView.clipsToBounds = true
        picView.layer.borderWidth = 1
        picView.layer.borderColor = UIColor(hexString: "f92d2d").cgColor
        picView.layer.masksToBounds = false
        
        profileImage.layer.cornerRadius = profileImage.bounds.height / 2
        profileImage.clipsToBounds = true
        
        camView.layer.cornerRadius = camView.bounds.height / 2
        camView.clipsToBounds = true
        
        datepicker = UIDatePicker()
        datepicker?.datePickerMode = .date
        birthdateTF.inputView = datepicker
        datepicker?.addTarget(self, action: #selector(EditUserProfileTableVC.dateChanged(datePicker:)), for: .valueChanged)
        
        bioTV.delegate = self
        tableView.estimatedRowHeight = 80
        tableView.rowHeight = UITableView.automaticDimension
    
        let tab = UITapGestureRecognizer(target: self, action: #selector(EditUserProfileTableVC.viewTapped(gesture:)))
        view.addGestureRecognizer(tab)
    
        addHobbiesFieldEvents()
    }
    
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    
    func handleInfoRefresh()  {
        self.showLoading()
        self.showSpecificLoading()
        ApiCalls.getUserInfo(completion: { (error: Error?, profile: infoProfile?) in
            if let profile = profile{
                self.UProfile = profile
                self.updateUI(profile: self.UProfile)
            }
        })
        
    }
    func updateUI(profile: infoProfile)  {
        self.profileImage.kf.indicatorType = .activity
        if let url = URL(string: "\(URLs.photoMain)\(profile.avatar)")
        {
            self.profileImage.kf.setImage(with: url, placeholder: nil, options: [.transition(ImageTransition.flipFromLeft(0.5))], progressBlock: nil, completionHandler: nil)
        }
        self.fullNameTF.text = profile.name
        self.birthdateTF.text = profile.birthdate
        self.genderTF.text = profile.gender
        self.interestsTF.text = profile.interest_in
        
        if profile.work == ""{
            self.workTF.text = "Please enter short info About your work"
        }else {
            self.workTF.text = profile.work
        }
        
        if profile.bio == ""{
            self.bioTV.text = "Please enter short info About you"
        }else {
            self.bioTV.text = profile.bio
        }
        if profile.hobbies.count > 0 {
            keywordsField.addTags(profile.hobbies)
        }

        
        self.hideSpecificLoading()
        self.hideLoading()
        
    }
    
    
    @objc func viewTapped(gesture: UITapGestureRecognizer) {
        view.endEditing(true)
    }
    
    
    @objc func dateChanged(datePicker: UIDatePicker){
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MM/dd/yyyy"
        birthdateTF.text = dateFormatter.string(from: (datepicker?.date)!)
    }
    
    @IBAction func backPressed(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
    
    
    
    @IBAction func changePicBtn(_ sender: UIButton) {
        
        let fusma = FusumaViewController()
        fusma.delegate = self
        fusma.cropHeightRatio = 1.0
        fusma.allowMultipleSelection = false
        fusma.availableModes = [.library, .camera]
        fusma.photoSelectionLimit = 4
        fusumaSavesImage = true
        
        present(fusma, animated: true, completion: nil)
    }
    
    
    @IBAction func changeGender(_ sender: UIButton) {
        let alertController = UIAlertController(title: "Choose Your Gender", message: "Please select Your Gender", preferredStyle: .actionSheet)
        
        let Male = UIAlertAction(title: "Male", style: .default) { (action) in
            self.genderTF.text = "Male"
        }
        
        let Female = UIAlertAction(title: "Female", style: .default) { (action) in
            self.genderTF.text = "Female"
        }
        
        let cancelBtn = UIAlertAction(title: "Cancel", style: .cancel) { (action) in
            print("Cancel btn")
        }
        alertController.addAction(Male)
        alertController.addAction(Female)
        alertController.addAction(cancelBtn)
        
        alertController.popoverPresentationController?.sourceView = self.view
        alertController.popoverPresentationController?.permittedArrowDirections = UIPopoverArrowDirection()
        alertController.popoverPresentationController?.sourceRect = CGRect(x: self.view.bounds.midX, y: self.view.bounds.midY, width: 0, height: 0)
        
        self.navigationController?.present(alertController, animated: true, completion: nil)
    }
    
    @IBAction func changeInterests(_ sender: UIButton) {
        let alertController = UIAlertController(title: "Choose Your Gender", message: "Please select Your Gender", preferredStyle: .actionSheet)
        
        let Male = UIAlertAction(title: "Male", style: .default) { (action) in
            self.interestsTF.text = "Male"
        }
        
        let Female = UIAlertAction(title: "Female", style: .default) { (action) in
            self.interestsTF.text = "Female"
        }
        let Both = UIAlertAction(title: "Both", style: .default) { (action) in
            self.interestsTF.text = "Both"
        }
        let cancelBtn = UIAlertAction(title: "Cancel", style: .cancel) { (action) in
            print("Cancel btn")
        }
        alertController.addAction(Male)
        alertController.addAction(Female)
        alertController.addAction(Both)
        alertController.addAction(cancelBtn)
        
        alertController.popoverPresentationController?.sourceView = self.view
        alertController.popoverPresentationController?.permittedArrowDirections = UIPopoverArrowDirection()
        alertController.popoverPresentationController?.sourceRect = CGRect(x: self.view.bounds.midX, y: self.view.bounds.midY, width: 0, height: 0)
        
        self.navigationController?.present(alertController, animated: true, completion: nil)
    }
    @IBAction func saveBtn(_ sender: UIButton) {
        let name = fullNameTF.text!
        let birthdate = birthdateTF.text!
        let gender = genderTF.text!
        let interests = interestsTF.text!
        let bio = bioTV.text!
        let work = workTF.text!
        var hobby = ""
        for key in keywordsField.tags.map({$0.text}){
            hobby += "\(key),"
        }
        
        self.updateInfo(username: name, birthdate: birthdate, gender: gender, interest_in: interests, bio: bio, work: work, hobbies: hobby)
    }
    
    
    func updateInfo(username: String,birthdate: String,gender: String,interest_in: String,bio: String,work: String,hobbies: String) {
        self.showLoading()
        ApiCalls.updateuserInfo(username: username, birthdate: birthdate, gender: gender, interest_in: interest_in, bio: bio, work: work, hobbies: hobbies) { (error: Error?, success: Bool) in
            if success {
                self.hideLoading()
                let alertController = UIAlertController(title: "Update", message: "User Info Updated Succesfully", preferredStyle: .alert)
                
                
                let cancelBtn = UIAlertAction(title: "OK", style: .cancel) { (action) in
                    _ = self.navigationController?.popViewController(animated: true)
                    print("Cancel btn")
                }
                alertController.addAction(cancelBtn)
                
                self.navigationController?.present(alertController, animated: true, completion: nil)
            }else {
                self.hideLoading()
                print(error?.localizedDescription as Any)
            }
        }
    }
    var picker_image: UIImage?{
        didSet{
            self.showLoading()
            guard let image = picker_image else { return }
            let uid = helper.getUserId()
            
            let imageData = image.jpegData(compressionQuality: 0.5)
            let x = imageData?.base64EncodedString(options: Data.Base64EncodingOptions(rawValue: 0))
            //let base64String =  imageData?.base64EncodedString(options: [])
            //guard let base64 = base64String else { return }
            guard let base64 = x else { return }
            let base64String1 = "data:image/jpeg;base64,\(base64)"
            // print("the first photo is \(base64String1) the end")
            SocketIOManager.sharedInstance.sendStroyToServerSocket(user_id: uid!, fileBase64: base64String1, text: "", bgcolor: "", fileType: "image")
        }
    }
    func openCamera() {
        imagePiker = UIImagePickerController()
        if(UIImagePickerController.isSourceTypeAvailable(UIImagePickerController.SourceType.camera)) {
            imagePiker.sourceType = UIImagePickerController.SourceType.camera
            imagePiker.delegate = self
            imagePiker.allowsEditing = true
            imagePiker.setEditing(true, animated: true)
            imagePiker.preferredContentSize = CGSize(width: 100, height: 100)
            imagePiker.cameraFlashMode = .auto
            imagePiker.cameraDevice = .rear
            imagePiker.showsCameraControls = true
            imagePiker.videoMaximumDuration = 40.0
            imagePiker.videoQuality = .typeMedium
            imagePiker.setEditing(true, animated: true)
            imagePiker.mediaTypes = ["public.image", "public.movie"]
            present(imagePiker, animated: true, completion: nil)
        }else {
            opengallery()
        }
    }
    
    func opengallery() {
        imagePiker = UIImagePickerController()
        imagePiker.allowsEditing = true
        imagePiker.videoMaximumDuration = 40.0
        imagePiker.sourceType = .photoLibrary
        imagePiker.mediaTypes = ["public.image", "public.movie"]
        imagePiker.delegate = self
        self.present(imagePiker, animated: true, completion: nil)
    }
    
    fileprivate func addHobbiesFieldEvents() {
        keywordsField.frame = hoppies.bounds
        hoppies.addSubview(keywordsField)
        
        keywordsField.cornerRadius = 8.0
        keywordsField.spaceBetweenLines = 5
        keywordsField.spaceBetweenTags = 5
        
        keywordsField.layoutMargins = UIEdgeInsets(top: 2, left: 6, bottom: 2, right: 6)
        keywordsField.contentInset = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10) //old padding
        keywordsField.placeholder = "Enter your Hobby"
        keywordsField.tintColor = UIColor(hexString: "F78177")
        keywordsField.placeholderAlwaysVisible = true
        keywordsField.backgroundColor = .white
        keywordsField.returnKeyType = .next
        keywordsField.delimiter = ""
        
        
        keywordsField.onDidAddTag = { field, tag in
            print("onDidAddTag", tag.text)
        }
        
        keywordsField.onDidRemoveTag = { field, tag in
            print("onDidRemoveTag", tag.text)
        }
        
        keywordsField.onDidChangeText = { _, text in
            print("onDidChangeText")
        }
        
        keywordsField.onDidChangeHeightTo = { _, height in
            print("HeightTo \(height)")
        }
        
        keywordsField.onDidSelectTagView = { _, tagView in
            print("Select \(tagView)")
        }
        
        keywordsField.onDidUnselectTagView = { _, tagView in
            print("Unselect \(tagView)")
        }
    }
}
extension EditUserProfileTableVC : FusumaDelegate{
    //Fusuma Delegate Methods
    
    func fusumaMultipleImageSelected(_ images: [UIImage], source: FusumaMode) {
        print("No multible ")
    }
    
    func fusumaImageSelected(_ image: UIImage, source: FusumaMode) {
        self.showLoading()
        switch source {
        case .camera :
            ApiCalls.updateUserPhoto(avatar: image) { (error: Error?, success: Bool) in
                self.showLoading()
                if success {
                    self.hideLoading()
                    self.profileImage.image = image
                    let alertController = UIAlertController(title: "Photo Update", message: "Your Photo was Updated Succesfully", preferredStyle: .alert)
                    let cancelBtn = UIAlertAction(title: "OK", style: .cancel) { (action) in
                        print("Cancel btn")
                    }
                    alertController.addAction(cancelBtn)
                    
                    self.navigationController?.present(alertController, animated: true, completion: nil)
                }else {
                    let alertController = UIAlertController(title: "Try Again", message: "Upload Failure", preferredStyle: .alert)
                    let cancelBtn = UIAlertAction(title: "OK", style: .cancel)
                    alertController.addAction(cancelBtn)
                    self.navigationController?.present(alertController, animated: true, completion: nil)
                    
                    self.hideLoading()
                    print(error?.localizedDescription as Any)
                }
            }
        case .library:
            ApiCalls.updateUserPhoto(avatar: image) { (error: Error?, success: Bool) in
                self.showLoading()
                if success {
                    self.hideLoading()
                    self.profileImage.image = image
                    let alertController = UIAlertController(title: "Photo Update", message: "Your Photo was Updated Succesfully", preferredStyle: .alert)
                    let cancelBtn = UIAlertAction(title: "OK", style: .cancel) { (action) in
                        print("Cancel btn")
                    }
                    alertController.addAction(cancelBtn)
                    
                    self.navigationController?.present(alertController, animated: true, completion: nil)
                }else {
                    let alertController = UIAlertController(title: "Try Again", message: "Upload Failure", preferredStyle: .alert)
                    let cancelBtn = UIAlertAction(title: "OK", style: .cancel)
                    alertController.addAction(cancelBtn)
                    self.navigationController?.present(alertController, animated: true, completion: nil)
                    
                    self.hideLoading()
                    print(error?.localizedDescription as Any)
                }
            }
        default:
            print("image selected")
        }
        
        
        
    }
    
    func fusumaVideoCompleted(withFileURL fileURL: URL) {
        print("no video")
    }
    
    func fusumaCameraRollUnauthorized() {
        print("camera roll un authoraised")
        let alert = UIAlertController(title: "Access Requested",
                                      message: "Saving image needs to access your photo album",
                                      preferredStyle: .alert)
        
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel) { (action) -> Void in
        })
        
        present(alert, animated: true, completion: nil)
    }
}
extension EditUserProfileTableVC: UITextViewDelegate{
    
    func textViewDidChange(_ textView: UITextView) {
        tableView.reloadDataAnimatedKeepingOffset()
        textView.becomeFirstResponder()
    }
    
//    func textViewDidBeginEditing(_ textView: UITextView) {
//        bioTV.text = String()
//
//    }
//    func textFieldDidBeginEditing(_ textField: UITextField) {
//        if textField == workTF{
//            workTF.text = ""
////        }else if textField == hoppiesTF {
////            hoppiesTF.text = ""
//        }else {
//            print("error")
//        }
//
//
//    }
}
extension EditUserProfileTableVC: UIImagePickerControllerDelegate, UINavigationControllerDelegate{

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
