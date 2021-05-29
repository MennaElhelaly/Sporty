//
//  TeamVC.swift
//  SportsApp
//
//  Created by Amin on 24/04/2021.
//  Copyright © 2021 Menna Elhelaly. All rights reserved.
//

import UIKit
import SDWebImage

class TeamVC: UIViewController {

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
            print("online")
              self.updateUI()
        }else{
              print("offline")
        }
      
   
        
    }
    func updateUI(){
        
        firstImage.sd_imageIndicator = SDWebImageActivityIndicator.gray
        firstImage.sd_setImage(with: URL(string: teamDeatails.strStadiumThumb), completed: nil)
        secondImage.sd_imageIndicator = SDWebImageActivityIndicator.gray
        secondImage.sd_setImage(with: URL(string: teamDeatails.strTeamBadge), completed: nil)
        
        
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
    }
    
    @objc func anotherScreen(sender:UIButton){
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
    


}
