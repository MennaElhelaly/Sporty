//
//  FavouriteTableViewController.swift
//  SportsApp
//
//  Created by Menna Elhelaly on 4/22/21.
//  Copyright © 2021 Menna Elhelaly. All rights reserved.
//

import UIKit
import CoreData
import SDWebImage
import ProgressHUD
class FavouriteTableViewController: UITableViewController {
    var favourieArr : [NSManagedObject]!
    var indecator : UIActivityIndicatorView?
    let coreData = CoreData.getInstance()

    var sendingDetails:FavouriteData! = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        indecator = UIActivityIndicatorView(style:.gray)
        indecator?.center = view.center
        indecator?.startAnimating()
        view.addSubview(indecator!)
        tableView.reloadData()
        navigationItem.title = "Favourites"

    }
    override func viewWillAppear(_ animated: Bool) {
        //get
        if let arr = coreData.fetchData() {
            favourieArr = arr
        }else{
            favourieArr = nil
        }
        self.tableView.reloadData()
        self.indecator?.stopAnimating()
        tableView.reloadData()
    }
    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if favourieArr != nil
        {
            return favourieArr.count
        }
        return 0
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
         let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! LeaguesTableViewCell
        if favourieArr != nil
        {
            if favourieArr[0].value(forKey: "leagueName") == nil {
                //
            }else{
                cell.leagueTitleImage.sd_imageIndicator = SDWebImageActivityIndicator.gray
                cell.leagueTitleImage.sd_imageIndicator?.startAnimatingIndicator()
                cell.leageNameOutlet.text = (favourieArr[indexPath.row].value(forKey: "leagueName") as! String)
                let image = (favourieArr[indexPath.row].value(forKey: "leagueImage") as! String)
                if image == "anonymousLogo" {
                    cell.leagueTitleImage.image = #imageLiteral(resourceName: "anonymousLogo")
                    
                }else{
                    cell.leagueTitleImage.sd_setImage(with: URL(string: image), completed: {(image,error,cach,url)in
                        cell.leagueTitleImage.sd_imageIndicator?.stopAnimatingIndicator()
                    })
                }
                
                
                let youtube = (favourieArr[indexPath.row].value(forKey: "youtubeLink") as! String)
                cell.youtubeBtn.accessibilityValue = youtube
                
                if youtube == ""{
                    cell.youtubeBtn.isEnabled = false
                }else{
                    cell.youtubeBtn.isEnabled = true
                }
                cell.youtubeBtn.isHidden = false
                let leagesVC = self.storyboard?.instantiateViewController(identifier: "LeaguesTableViewController") as! LeaguesViewController
                cell.youtubeBtn.addTarget(leagesVC, action: #selector(leagesVC.youtubeTapped), for: .touchUpInside)
               
            }

        }
        else {
            // empty
        }
        return cell
    }
  
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            coreData.deleteItem(id: indexPath.row)
           favourieArr?.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }
    }
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return "Favourite Leagues "
    }
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print((favourieArr[indexPath.row].value(forKey: "leagueName") as! String))
        
        if Network.shared.isConnected{
            print("network onlin")
        
            let idLeague = (favourieArr[indexPath.row].value(forKey: "LeagueID") as! String)
            let strBadge = (favourieArr[indexPath.row].value(forKey: "LeagueImage") as! String)
            let strLeague = (favourieArr[indexPath.row].value(forKey: "LeagueName") as! String)
            let strYoutube = (favourieArr[indexPath.row].value(forKey: "YoutubeLink") as! String)
            
            var image : String?
            if strBadge == "anonymousLogo" {
                image = nil
            }else{
                image = strBadge
            }
          
            sendingDetails = FavouriteData(idLeague: idLeague, strLeague:strLeague , strYoutube: strYoutube, strBadge: image)
            print("didselect")
            performSegue(withIdentifier: "favourite", sender: self)
            
        }else{
            print("network Offline")
            ProgressHUD.showError("no internet connection, Try again")
        }
       
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destinationVC = segue.destination as! LeaguesDetailsVC
        destinationVC.leagueData = sendingDetails
    }

    @objc func youtubeTapped(sender:UIButton){
        print(sender.accessibilityValue!)
        let application = UIApplication.shared
        let url = sender.accessibilityValue!

        if application.canOpenURL(URL(string: url)!) {
             application.open(URL(string: url)!)
         }else {
             // if Youtube app is not installed, open URL inside Safari
            application.open(URL(string: "https://\(url)")!)
         }
    }
    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
