import UIKit
import Kingfisher

class TabsController: UITabBarController {
    let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
    

    let badgeView = View.init()
    
//    let api = Api()
    
    static var unreadMessagesCount = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let height = min(tabBar.frame.height, 50)
        
        badgeView.frame = CGRect(x: 0, y: 0, width: 14.0, height: 14.0)
        badgeView.backgroundColor = .red
        badgeView.layer.cornerRadius = 7.0
        badgeView.clipsToBounds = true
        
        view.insertSubview(badgeView, aboveSubview: tabBar)

        
//        self.getUnreadMessages()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
//        Globals.socket!.on("receive") { (data, SocketAckEmitter) in
//            if self.tabBar.selectedItem != self.tabBar.items![3] {
//                let _data = data[0] as! [String:AnyObject]
//                let threadId = _data["threadId"] as? Int
//
//                if !Globals.unreadThreads.contains(threadId!) {
//                    Globals.unreadThreads.append(threadId!)
//
//                    if let x = self.tabBar.items?[3].badgeValue {
//                        print("x1: \(x)")
//                        if var unreadInt = Int(x) {
//                            unreadInt = unreadInt + 1
//                            self.tabBar.items?[3].badgeValue = unreadInt <= 0 ? nil : "\(unreadInt)"
//                        }
//                    }
//                    else {
//                        print("x2: 1")
//                        self.tabBar.items?[3].badgeValue = "1"
//                    }
//                }
//            }
//        }
        
//        Globals.socket!.on("exchangeRequest") { (data, SocketAckEmitter) in
//            print("exchangeRequest: \(data)")
//        }
        
//        Globals.socket!.on("exchangeRequestStatus") { (data, SocketAckEmitter) in
//            print("exchangeRequestStatus: \(data)")
//        }
    }
    
//    func getUnreadMessages() {
//        self.api.request(endPoint: "user/unread", data: [:], type: RequestTypes.GET).responseJSON { response in
//            switch response.result {
//            case .success(let value):
//                if let _data = value as? [String: AnyObject]{
//                    let count = _data["count"] as! Int
//                    let threads =  _data["threads"] as! [Int]
//
//                    self.tabBar.items![3].badgeValue = count == 0 ? nil : "\(count)"
//                    Globals.unreadThreads = threads
//                }
//            case .failure:
//                self.tabBar.items![3].badgeValue = nil
//            }
//        }
//    }
    
    @objc func btnUserClick(sender: UIButton) {
        //EditProfileVC
        self.selectedIndex = 4
    }
    
    @objc func btnAddClick(sender: UIButton) {
       self.selectedIndex = 2
    }
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        let height = min(tabBar.frame.height, 50)
        
//        btnAdd.frame = CGRect.init(x: tabBar.center.x - 30.0, y: view.bounds.height - ((tabBar.frame.height - 8.0) + 4.0), width: 60.0, height: height - 8.0)
//        btnAdd.imageEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
//
//        btnUser.frame = CGRect.init(x: tabBar.frame.width - (height - 12.0) - 12.0, y: view.bounds.height - ((tabBar.frame.height - 12.0) + 6.0), width: height - 12.0, height: height - 12.0)
//
        badgeView.frame = CGRect.init(x: tabBar.frame.width - 23.0, y: view.bounds.height - ((tabBar.frame.height - 12.0) + 6.0), width: 14.0, height: 14.0)
    }
}
