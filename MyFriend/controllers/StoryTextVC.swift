//
//  imagesController.swift
//  MyFriend
//
//  Created by hossam Adawi on 1/8/19.
//  Copyright © 2019 MacBook Pro. All rights reserved.
//

import UIKit

class StoryTextVC: BaseViewController {

    @IBOutlet weak var textview: UITextView!
    @IBOutlet weak var storyText: UIView!
    @IBOutlet weak var btnCons: NSLayoutConstraint!
    @IBOutlet weak var sendCons: NSLayoutConstraint!
    @IBOutlet weak var brushConst: NSLayoutConstraint!
    @IBOutlet weak var sendConst: NSLayoutConstraint!
    
    
    var initialTouchPoint:CGPoint = CGPoint(x: 0, y: 0)
    
    var color: UIColor = .red
    override func viewDidLoad() {
        super.viewDidLoad()

        textview.delegate = self
        // Do any additional setup after loading the view.
    }
    
    @IBAction func changeColor(_ sender: UIButton) {
        color = UIColor().getRandom()
        storyText.backgroundColor = color
    }
    
    @IBAction func sendText(_ sender: UIButton) {
        self.showLoading()
        let uid = helper.getUserId()
        let colorhex = color.hex1String(.d6)
        guard let storyText = textview.text, storyText.count > 0 else {return}
        
        ApiCalls.sendTextStory(text: storyText, bgcolor: colorhex) { (error: Error?, success: Bool, file: String) in
            if success {
                self.hideLoading()
                SocketIOManager.sharedInstance.sendStroyToServerSocket(user_id: uid!, fileBase64: file, text: storyText, bgcolor: colorhex, fileType: "text")
                self.dismiss(animated: true, completion: nil)
            }else {
                let alert = UIAlertController(title: "error", message: "Please try again later", preferredStyle: UIAlertController.Style.alert)
                alert.addAction(UIAlertAction(title: "Try Again", style: UIAlertAction.Style.default, handler: nil))
                self.hideLoading()
                self.present(alert, animated: true, completion: nil)
            }
        }
    }
    
    @IBAction func closePhoto(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func swipeDown(_ sender: UIPanGestureRecognizer) {
        let touchPoint = sender.location(in: self.view?.window)
        
        if sender.state == UIGestureRecognizer.State.began {
            initialTouchPoint = touchPoint
        } else if sender.state == UIGestureRecognizer.State.changed {
            if touchPoint.y - initialTouchPoint.y > 0 {
                self.view.frame = CGRect(x: 0, y: touchPoint.y - initialTouchPoint.y, width: self.view.frame.size.width, height: self.view.frame.size.height)
            }
        } else if sender.state == UIGestureRecognizer.State.ended || sender.state == UIGestureRecognizer.State.cancelled {
            if touchPoint.y - initialTouchPoint.y > 100 {
                self.dismiss(animated: true, completion: nil)
            } else {
                UIView.animate(withDuration: 0.3, animations: {
                    self.view.frame = CGRect(x: 0, y: 0, width: self.view.frame.size.width, height: self.view.frame.size.height)
                })
            }
        }
    }
    

}
extension StoryTextVC: UITextViewDelegate{
    func textViewDidBeginEditing(_ textView: UITextView) {
        textView.text = String()
    }
}
