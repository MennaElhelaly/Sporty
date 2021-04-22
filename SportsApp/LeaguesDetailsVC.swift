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
    
    @IBOutlet weak var uiUpcomingCollectionView: UICollectionView!
    
    @IBOutlet weak var uiTableView: UITableView!
    @IBOutlet weak var uiTeamCollectionView: UICollectionView!
    
    
    var leagueId:String! = "4328"
    var strSeason:String! = "2020-2021"
    
    
    var lastArray = [Event]()
    var allTeams = [Team]()

    
    var homeImages = [String]()
    var awayImages = [String]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.setNavigationItem()
        
        let webServiceObj = WebService()
        
        webServiceObj.get
        webServiceObj.getAllTeamsInLeagueByLeagueId(id: leagueId) { (arrayOfTeams) in
            if arrayOfTeams.count == 0{
                print("show alert")
            }else{
                self.allTeams = arrayOfTeams
                DispatchQueue.main.async {
                    self.uiTeamCollectionView.reloadData()
                }
                
                
                webServiceObj.getEventInLeagueById(id: self.leagueId) { (arrayOfEvents) in

                    if arrayOfEvents.count == 0{
                        print("show alert")
                    }else{
                        self.lastArray = arrayOfEvents
                        
                        DispatchQueue.main.async {
                            self.uiTableView.reloadData()
                        }
                        
                        for item in arrayOfEvents{
                            let home = item.idHomeTeam
                            let away = item.idAwayTeam
                            
                            for item2 in arrayOfTeams{
                                if home == item2.idTeam{
                                    self.homeImages.append(item2.strTeamBadge)
                                }else if away == item2.idTeam{
                                    self.awayImages.append(item2.strTeamBadge)
                                }
                            }
                            DispatchQueue.main.async {
                                self.uiTableView.reloadData()
                            }
                        }
                    }
                }
            }
        }

        //                webServiceObj.getEventInLeagueById(leagueId: "4328") { (json) in
        //
        //                    if let array = json["events"].array {
        //                        for item in array { // loop througout all events
        //
        //                            webServiceObj.getTeamDetailsById(teamId: teamOneId) { (json) in
        //                                let team = json["teams"][0].dictionaryObject!
        //                                self.teamOne.append(team)
        //                                DispatchQueue.main.async {
        //                                    self.uiTableView.reloadData()
        //                                }
        //                            }
        //                            webServiceObj.getTeamDetailsById(teamId: teamTwoId) { (json) in
        //                                let team = json["teams"][0].dictionaryObject!
        //                                self.teamTwo.append(team)
        //                                DispatchQueue.main.async {
        //                                    self.uiTableView.reloadData()
        //                                }
        //                            }
        //                        }
        //                    }
        //                }
    }
    
    func setNavigationItem() {
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(named: "heart"), style: .plain, target: self, action: #selector(addTapped))
        navigationItem.title = "Leagues Details"
    }
    @objc func addTapped() {
        navigationItem.rightBarButtonItem?.tintColor = #colorLiteral(red: 0.7450980544, green: 0.1568627506, blue: 0.07450980693, alpha: 1)
        //MARK:: adding current to core data
    }
    
}




//MARK::Upcoming
extension LeaguesDetailsVC: UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        if collectionView == uiUpcomingCollectionView{
            return 5
        }else{
            return allTeams.count
        }
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if collectionView == uiUpcomingCollectionView{
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "upcommingCell", for: indexPath) as! UpcomingCell
            cell.layer.cornerRadius = 20
            
            cell.uiTeamTwoImage.image = #imageLiteral(resourceName: "manu")
            cell.uiTeamOneImage.image = #imageLiteral(resourceName: "arsenal")
            
            cell.uiTeamOneName.text = "arsenal"
            cell.uiTeamTwoName.text = "man red"
            
            
            return cell
        }else{
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "teamCell", for: indexPath) as! TeamCell
            cell.uiTeamImage.sd_imageIndicator = SDWebImageActivityIndicator.gray
            cell.uiTeamImage.sd_setImage(with: URL(string: allTeams[indexPath.row].strTeamBadge), completed: nil)
            return cell
        }
        
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if collectionView == uiUpcomingCollectionView {
            return CGSize(width: (view.window?.layer.frame.width)! - 5 , height: (view.window?.layer.frame.height)! / 4)
        }
        return CGSize(width: (view.window?.layer.frame.width)! / 2, height: (view.window?.layer.frame.height)! / 2)
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets
    {
        let sectionInset = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
        return sectionInset
    }
}

//MARK:- Latest
extension LeaguesDetailsVC: UITableViewDelegate,UITableViewDataSource{
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return lastArray.count
    }
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 30
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "latestCell") as! LatestCell
        cell.layer.cornerRadius = 20
        
        
        
        cell.uiTeamOneImage.sd_imageIndicator = SDWebImageActivityIndicator.gray
        cell.uiTeamOneImage.sd_imageIndicator =  SDWebImageActivityIndicator.gray

        if(homeImages.count > 0 && awayImages.count > 0){
            
            
            cell.uiTeamOneImage.sd_setImage(with: URL(string: homeImages[indexPath.section]), completed: nil)
            
            cell.uiTeamTwoImage.sd_setImage(with: URL(string: awayImages[indexPath.section]), completed: nil)
            
        }
        
        
        cell.uiTeamOneName.text = lastArray[indexPath.section].strHomeTeam
        cell.uiTeamTwoName.text = lastArray[indexPath.section].strAwayTeam
        cell.uiEventDate.text = lastArray[indexPath.section].dateEvent
        
        return cell
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return (view.window?.frame.height)! / 3
    }
    
}

