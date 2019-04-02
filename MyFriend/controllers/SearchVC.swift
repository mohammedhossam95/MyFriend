//
//  SearchVC.swift
//  MyFriend
//
//  Created by MacBook Pro on 12/12/18.
//  Copyright © 2018 MacBook Pro. All rights reserved.
//

import UIKit
import Kingfisher
import AVKit
import GoogleMobileAds

class SearchVC: UIViewController, CustomLayoutDelegate {
    
    @IBOutlet weak var searchView: UIView!
    @IBOutlet weak var searchViewBtn: UIView!
    @IBOutlet weak var SearchTable: UITableView!
    @IBOutlet weak var randomSearch: UICollectionView!
    @IBOutlet weak var searchTF: UITextField!
    var randomSearchArr = [RandomUser]()
    var SearchReslts = [RandomUser]()
    
    var isLoading = false
    var current_page = 1
    var last_page = 1
    
    var interstitial: GADInterstitial?
    lazy var adBannerView: GADBannerView = {
        let adBannerView = GADBannerView(adSize: kGADAdSizeSmartBannerPortrait)
        adBannerView.adUnitID = URLs.bannarId
        adBannerView.delegate = self
        adBannerView.rootViewController = self
        
        return adBannerView
    }()
    
    lazy var refresher: UIRefreshControl = {
        let refresher = UIRefreshControl()
        refresher.addTarget(self, action: #selector(handleSearchRefresh), for: .valueChanged)
        return refresher
    }()
    
    public var customCollectionViewLayout: UICustomCollectionViewLayout? {
        get {
            return randomSearch.collectionViewLayout as? UICustomCollectionViewLayout
        }
        set {
            if newValue != nil {
                self.randomSearch?.collectionViewLayout = newValue!
            }
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, heightForItemAt indexPath: IndexPath, with width: CGFloat) -> CGFloat {
        let heightSizes = [150,275]
        if randomSearchArr[indexPath.row].type == "video" {
            return CGFloat(heightSizes[1])
        }else {
            return CGFloat(heightSizes[0])
        }
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.hideKeyboardWhenTappedAround()
        SearchTable.isHidden = true
        self.customCollectionViewLayout?.delegate = self
        self.customCollectionViewLayout?.numberOfColumns = 2
        self.customCollectionViewLayout?.cellPadding = 2
        self.showLoading()
        self.setupView()
        self.searchTF.delegate = self
        self.handleSearchRefresh()
        adBannerView.load(GADRequest())
        randomSearch.alwaysBounceVertical = true
        self.randomSearch.addSubview(refresher)
        interstitial = createAndLoadInterstitial()
    }
    
    @IBAction func backPressed(_ sender: UIButton) {
        _ = self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func SearchBtn(_ sender: UIButton) {
        self.search()
    }
    
    func search()  {
        guard let searchText = searchTF.text, !searchText.isEmpty else { return }
        self.randomSearch.isHidden = true
        self.showLoading()
        self.SearchTable.isHidden = false
        self.handleSearchReslts(word: searchText)
    }
    
    func setupView() {
        searchView.layer.cornerRadius = 15.0
        searchView.clipsToBounds = true
        searchView.layer.borderWidth = 1
        searchView.layer.masksToBounds = false
        searchView.layer.borderColor = UIColor(hexString: "bfbdbd").cgColor
        searchViewBtn.layer.cornerRadius = 15.0
        searchViewBtn.clipsToBounds = true
    }
    
    @objc func handleSearchRefresh()  {
        self.refresher.endRefreshing()
        guard !isLoading else { return }
        isLoading = true
        ApiCalls.randomSearch { (error: Error?, randomImages: [RandomUser]?, last_page: Int) in
            self.isLoading = false
            if let randomImages = randomImages {
                self.randomSearchArr = randomImages
                self.hideLoading()
                self.randomSearch.reloadData()
                self.current_page = 1
                self.last_page = last_page
            }
        }
    }
    @objc func handleSearchReslts(word: String)  {
        guard !isLoading else { return }
        isLoading = true
        ApiCalls.getSearchResults(search: word) { (error: Error?, SearchReslts: [RandomUser]?, last_page:Int) in
            self.isLoading = false
            if let Reslts = SearchReslts {
                self.SearchReslts = Reslts
                self.hideLoading()
                self.SearchTable.reloadData()
                self.current_page = 1
                self.last_page = last_page
            }
        }
    }
    
    fileprivate func LoadMore() {
        self.showLoading()
        guard !isLoading else { return }
        guard current_page < last_page else { return }
        isLoading = true
        print(current_page)
        print(last_page)
        ApiCalls.randomSearch(page: current_page+1) { (error: Error?, randomImages: [RandomUser]?, last_page: Int) in
            self.isLoading = false
            if let randomImages = randomImages{
                self.randomSearchArr.append(contentsOf: randomImages)
                self.randomSearch.reloadData()
                self.current_page += 1
                self.hideLoading()
                self.last_page = last_page
                
            }
        }
    }
    func openProfileFromHome(Id:Int) {
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let VC = storyboard.instantiateViewController(withIdentifier: "FollowerProfileVC") as! FollowerProfileVC
        print(Id)
        VC.userId = Id
        userAboutVC.userId = Id
        userGallaryVC.id = Id
        
        self.navigationController?.pushViewController(VC, animated: true)
    }
    
    
    func openPhotofile(Id:Int) {
        let storyboard = UIStoryboard(name: "MainTab", bundle: nil)
        let VC = storyboard.instantiateViewController(withIdentifier: "PhotosVC") as! PhotosVC
        VC.gallery_id = Id
        self.navigationController?.present(VC, animated: true, completion: nil)
    }
    
    
    
    var overlayView = UIView()
    var activityIndicator = UIActivityIndicatorView()
    
    func showLoading() {
        if  let appDelegate = UIApplication.shared.delegate as? AppDelegate,
            let window = appDelegate.window {
            overlayView.frame = CGRect(x:0, y:0, width:80, height:80)
            overlayView.center = CGPoint(x: window.frame.width / 2.0, y: window.frame.height / 2.0)
            
            overlayView.backgroundColor = UIColor.clear
            overlayView.clipsToBounds = true
            overlayView.layer.cornerRadius = 10
            activityIndicator.frame = CGRect(x:0, y:0, width:40, height:40)
            activityIndicator.style = .whiteLarge
            activityIndicator.color = .red
            activityIndicator.center = CGPoint(x: overlayView.bounds.width / 2, y: overlayView.bounds.height / 2)
            overlayView.addSubview(activityIndicator)
            window.addSubview(overlayView)
            activityIndicator.startAnimating()
        }
    }
    
    func hideLoading() {
        activityIndicator.stopAnimating()
        overlayView.removeFromSuperview()
    }
}

extension SearchVC : UICollectionViewDataSource, UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        let count = self.randomSearchArr.count
        if indexPath.item == count-1 {
            self.LoadMore()
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.randomSearchArr.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {

        if randomSearchArr[indexPath.row].type == "video"{
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "searchVideoCollectionCell", for: indexPath) as! searchVideoCollectionCell
            
            cell.searchRandomImage.isHidden = true
            cell.videoView.isHidden = false
            cell.videoicon.isHidden = false
            
            let url = URLs.photoMain + self.randomSearchArr[indexPath.row].galleryFile
            cell.videoView?.configure(url: url, bound: cell.bounds)
            cell.videoView.play()
            cell.videoView.Mute()
            return cell
        }else{
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "searchCollectionCell", for: indexPath) as! searchCollectionCell
            cell.searchRandomImage.isHidden = false
            cell.videoView.isHidden = true
            cell.videoicon.isHidden = true
            cell.searchRandomImage.kf.indicatorType = .activity
            if let url = URL(string: URLs.photoMain + randomSearchArr[indexPath.row].galleryFile){
                cell.searchRandomImage.kf.setImage(with: url, placeholder: nil, options: [.transition(ImageTransition.flipFromLeft(0.5))], progressBlock: nil, completionHandler: nil)
            }
            return cell
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if randomSearchArr[indexPath.row].type == "video"{
            ApiCalls.getSinglePhoto(gallery_id: self.randomSearchArr[indexPath.row].id) { (error: Error?, singleGallery: SingleGallery?) in
                if let singleGallery = singleGallery{
                    print(singleGallery.galleryId)
                    if let url = URL(string: "\(URLs.photoMain)\(self.randomSearchArr[indexPath.row].galleryFile)"){
                        let video = AVPlayer(url: url)
                        let videoPlayer = AVPlayerViewController()
                        videoPlayer.player = video
                        self.present(videoPlayer, animated: true, completion: {
                            video.play()
                        })
                    }
                }
            }
            
        }else{
            self.openPhotofile(Id: self.randomSearchArr[indexPath.row].id)
        }
    }
    
}

extension SearchVC :UITableViewDataSource,UITableViewDelegate{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return SearchReslts.count
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        return adBannerView
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return adBannerView.frame.height
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "searchCell", for: indexPath) as! searchCell
        let user = SearchReslts[indexPath.row]
        cell.configreCell(user: user)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.openProfileFromHome(Id: self.SearchReslts[indexPath.row].userId)
    }
    
}

extension SearchVC: UITextFieldDelegate{
    func textFieldDidBeginEditing(_ textField: UITextField) {
        if textField == searchTF{
            searchTF.text = ""
            randomSearch.isHidden = true
        }else {
            print("error")
        }
    }
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == searchTF {
            textField.resignFirstResponder()
            self.search()
            return false
        }
        return true
    }
}

extension SearchVC : GADBannerViewDelegate {
    func adViewDidReceiveAd(_ bannerView: GADBannerView) {
        print("Banner loaded successfully")
        
        // Reposition the banner ad to create a slide down effect
        let translateTransform = CGAffineTransform(translationX: 0, y: -bannerView.bounds.size.height)
        bannerView.transform = translateTransform
        
        UIView.animate(withDuration: 0.5) {
            bannerView.transform = CGAffineTransform.identity
        }
        
    }
    
    func adView(_ bannerView: GADBannerView, didFailToReceiveAdWithError error: GADRequestError) {
        print("Fail to receive ads")
        print(error)
    }
}
extension SearchVC : GADInterstitialDelegate {
    private func createAndLoadInterstitial() -> GADInterstitial? {
        interstitial = GADInterstitial(adUnitID: "ca-app-pub-1940793456791298/1319626156")
        guard let interstitial = interstitial else {
            return nil
        }
        
        let request = GADRequest()
        interstitial.load(request)
        interstitial.delegate = self
        
        return interstitial
    }
    
    // MARK: - GADInterstitialDelegate methods
    
    func interstitialDidReceiveAd(_ ad: GADInterstitial) {
        print("Interstitial loaded successfully")
        ad.present(fromRootViewController: self)
    }
    
    func interstitialDidFail(toPresentScreen ad: GADInterstitial) {
        print("Fail to receive interstitial")
    }
}
