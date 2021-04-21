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
    
    var sportsArr = [Sport]()
    let arrData :[String] = ["Egypt","Cairo","Damitta","Menna","Alex"]
    @IBOutlet weak var collectionView: UICollectionView!
    let arrImg :[String] = ["arsenal","arsenal","arsenal","arsenal","arsenal"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
    }
    override func viewWillAppear(_ animated: Bool) {
        
        let webServiceObj = WebService()
        
        webServiceObj.callSportsAPI(compilation: { (arrayOfSports) in
            if arrayOfSports.count == 0{
                print("show alert")
            }else{
                
            }
            self.sportsArr = arrayOfSports
            
            DispatchQueue.main.async {
                self.collectionView.reloadData()
            }
            
        })
            
           
    }
    //---------------------------------------
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }


    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of items
        return sportsArr.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as? SportCollectionViewCell
        cell?.sportLabel.text = sportsArr[indexPath.row].strSport
        let url = URL(string: sportsArr[indexPath.row].strSportThumb)
        cell?.sportImge.sd_setImage(with: url, completed: nil)
            //.image = UIImage.init(named: arrImg[indexPath.row])
        cell?.layer.cornerRadius = 20
        cell?.sportImge.layer.cornerRadius = 20
        // Configure the cell
    
        return cell!
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize
    {
        let cellSize = CGSize(width: 169, height: 163)
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
    //----------
    
   /* func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: (view.window?.layer.frame.width)! - 5 , height: (view.window?.layer.frame.height)! / 4)
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets
    {
        let sectionInset = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
        return sectionInset
    }*/
    

