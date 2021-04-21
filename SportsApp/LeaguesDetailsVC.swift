//
//  LeaguesDetailsVC.swift
//  SportsApp
//
//  Created by Amin on 19/04/2021.
//

import UIKit
import SwiftyJSON
import SDWebImage

class LeaguesDetailsVC: UIViewController {

    @IBOutlet weak var uiCollectionView: UICollectionView!
    
    var upcomingArray = [JSON]();
    
    
    var teamOne = [[String:Any]]()
    var teamTwo = [[String:Any]]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.setNavigationItem()
        
        let webServiceObj = WebService()
        
        
        // leage id from ayman page
        webServiceObj.getEventInLeagueById(leagueId: "4328") { (json) in
                
            if let array = json["events"].array {
                
                for item in array { // loop througout all events
                    let teamOneId = item["idHomeTeam"].string!
                    let teamTwoId = item["idAwayTeam"].string!
                    
                    webServiceObj.getTeamDetailsById(teamId: teamOneId) { (json) in
                        let team  = json["teams"][0].dictionaryObject!
                        self.teamOne.append(team)
                        DispatchQueue.main.async {
                            self.uiCollectionView.reloadData()
                        }
                    }
                    
                    webServiceObj.getTeamDetailsById(teamId: teamTwoId) { (json) in
                        let team = json["teams"][0].dictionaryObject!
                        self.teamTwo.append(team)
                        DispatchQueue.main.async {
                            self.uiCollectionView.reloadData()
                        }
                    }
                    self.upcomingArray = array
                }
            }
        }
    }
    
    func setNavigationItem() {
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(named: "heart"), style: .plain, target: self, action: #selector(addTapped))
    }
    @objc func addTapped() {
        navigationItem.rightBarButtonItem?.tintColor = #colorLiteral(red: 0.7450980544, green: 0.1568627506, blue: 0.07450980693, alpha: 1)
        //MARK:: adding current to core data
    }

}




//MARK::Upcoming
extension LeaguesDetailsVC: UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return upcomingArray.count
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "upcommingCell", for: indexPath) as! UpcomingCell
        cell.layer.cornerRadius = 20

      //  cell.uiTeamOneImage.sd_setImage(with: URL(string: teamOne[indexPath.row]["strTeamBadge"] as! String), placeholderImage: UIImage(named: "placeholder"))
//        cell.uiTeamTwoImage.sd_setImage(with: URL(string: teamTwo[indexPath.row]["strTeamBadge"] as! String), placeholderImage: UIImage(named: "placeholder"))
        cell.uiTeamOneName.text = upcomingArray[indexPath.row]["strHomeTeam"].string
        cell.uiTeamTwoName.text = upcomingArray[indexPath.row]["strAwayTeam"].string
        cell.uiEventDate.text = upcomingArray[indexPath.row]["dateEvent"].string
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: (view.window?.layer.frame.width)! - 5 , height: (view.window?.layer.frame.height)! / 4)
      }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets
    {
        let sectionInset = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
        return sectionInset
    }
}

//MARK::Latest
extension LeaguesDetailsVC: UITableViewDelegate,UITableViewDataSource{
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 5
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "latestCell") as! LatestCell
        cell.layer.cornerRadius = 20
        cell.uiTeamOneImage.image = #imageLiteral(resourceName: "arsenal")
        cell.uiTeamTwoImage.image = #imageLiteral(resourceName: "manu")
        
        return cell
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return (view.window?.frame.height)! / 3
    }
    
    
//    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
//            return 5
//    }
    
    

}


