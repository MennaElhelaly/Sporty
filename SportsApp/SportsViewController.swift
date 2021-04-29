//
//  SportsViewController.swift
//  SportsApp
//
//  Created by Menna Elhelaly on 4/20/21.
//  Copyright © 2021 Menna Elhelaly. All rights reserved.
//

import UIKit
import SDWebImage

class SportsViewController: UIViewController , UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout{
    @IBOutlet weak var collectionView: UICollectionView!
    
    var sportsArr = [Sport]()
    var viewModel:SportsViewModel = SportsViewModel()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
       // navigationItem.title = "ALL SPORTS"
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.tabBarController?.tabBar.isHidden = false
        prepareScreenData()
        
    }
    
    func prepareScreenData() {
        if Network.shared.isConnected{
            print("connected")
            viewModel.bindSportsData = {
                self.getDataFromAPI()
            }
            
            viewModel.bindingConnectionError = {
                self.handleConnectionError()
            }
            
            viewModel.bindingDataError = {
                self.handleDataError()
            }
        }else{
            print("not connected")
            collectionView.backgroundView = UIImageView(image: UIImage(named: "404")!)
            sportsArr = [Sport]()
            collectionView.reloadData()
        }
    }
    func handleDataError() {
        print("returned data is null")
    }
    func handleConnectionError() {
        if Network.shared.isConnected{
            print("url is not correct")
        }else{
            self.navigationController?.popToRootViewController(animated: true)
        }
    }
    func getDataFromAPI() {
        sportsArr = viewModel.sportsData
        self.collectionView.reloadData()
    }
    
    
// MARK:-  collection view
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of items
        return sportsArr.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! SportCollectionViewCell
        cell.sportLabel.text = sportsArr[indexPath.row].strSport
        
        cell.sportImge.sd_imageIndicator = SDWebImageActivityIndicator.gray
        cell.sportImge.sd_imageIndicator?.startAnimatingIndicator()
        
        let url = URL(string: sportsArr[indexPath.row].strSportThumb)
        cell.sportImge.sd_setImage(with: url) { (image, error, cache, url) in
            cell.sportImge.sd_imageIndicator?.stopAnimatingIndicator()
        }
        //cell.layer.cornerRadius = 35
        cell.sportImge.layer.cornerRadius = 35
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let second :LeaguesViewController = (self.storyboard?.instantiateViewController(withIdentifier: "LeaguesTableViewController")) as! LeaguesViewController
        second.strSport = sportsArr[indexPath.row].strSport
        self.navigationController?.pushViewController(second, animated: true)
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize
    {
        let cellSize = CGSize(width: ((view.window?.layer.frame.width)!/2) - 40, height: 150)
        return cellSize
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat
    {
        return 10
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets
    {
        let sectionInset = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
        return sectionInset
    }
}


