//
//  TeamTableViewController.swift
//  SportsApp
//
//  Created by Menna Elhelaly on 4/25/21.
//  Copyright © 2021 Menna Elhelaly. All rights reserved.
//

import UIKit
import SDWebImage

class TeamTableViewController: UITableViewController {
    
    @IBOutlet weak var offlineView: UIView!
    @IBOutlet weak var firstImage: UIImageView!
    @IBOutlet weak var secondImage: UIImageView!
    
    @IBOutlet weak var instgramLink: UIButton!
    @IBOutlet var twitterLink: UIButton!
    @IBOutlet weak var facebookLink: UIButton!
    @IBOutlet weak var strTeam: UILabel!
    @IBOutlet weak var strLeague: UILabel!
    @IBOutlet weak var strStadium: UILabel!
    @IBOutlet weak var strCountry: UILabel!
    @IBOutlet weak var strDiscription: UITextView!
    
    var teamDeatails : Team!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if Network.shared.isConnected{
            offlineView.isHidden = true
            self.updateUI()
        }else{
            offlineView.isHidden = false

        }
        
        
        
    }
    func updateUI(){
        
        firstImage.sd_imageIndicator = SDWebImageActivityIndicator.gray
        
        if let image = teamDeatails.strStadiumThumb {
            firstImage.sd_setImage(with: URL(string: image), completed: nil)
        }else{
            firstImage.image = #imageLiteral(resourceName: "stadium")
        }
        
        strTeam.text = teamDeatails.strTeam
        strStadium.text = teamDeatails.strStadium
        strLeague.text = teamDeatails.strLeague
        strCountry.text = teamDeatails.strCountry
        strDiscription.text = teamDeatails.strDescriptionEN
        
        let facebook = teamDeatails.strFacebook
        let instgram = teamDeatails.strInstagram
        let twitter = teamDeatails.strTwitter
        
        facebookLink.accessibilityValue = facebook
        instgramLink.accessibilityValue = instgram
        twitterLink.accessibilityValue = twitter
        
        
        facebookLink.addTarget(self, action: #selector(self.anotherScreen), for: .touchUpInside)
        instgramLink.addTarget(self, action: #selector(self.anotherScreen), for: .touchUpInside)
        twitterLink.addTarget(self, action: #selector(self.anotherScreen), for: .touchUpInside)
        
        secondImage.sd_imageIndicator = SDWebImageActivityIndicator.gray
        
        guard let validTeamImage = teamDeatails.strTeamBadge else {
            secondImage.image = #imageLiteral(resourceName: "anonymousLogo")
            secondImage.sd_imageIndicator?.stopAnimatingIndicator()
            return
        }
        secondImage.sd_setImage(with: URL(string: validTeamImage)) { (image, error, cahce, url) in
            self.secondImage.sd_imageIndicator?.stopAnimatingIndicator()
        }
//        secondImage.sd_setImage(with: URL(string: validTeamImage), completed:{secondImage.sd_imageIndicator?.stopAnimatingIndicator()})
    }
    
    @objc func anotherScreen(sender:UIButton){
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
     override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
     let cell = tableView.dequeueReusableCell(withIdentifier: "reuseIdentifier", for: indexPath)
     
     // Configure the cell...
     
     return cell
     }
     */
    
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
