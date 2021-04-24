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
    
    var strSeason:String! = "2020-2021" // not used for now
    var database:CoreData!
    var favouriteState:Bool!
    
    public var leagueData:LeagueById!
     
    var upcomingArray = [NewEvent]()
    var lastArray = [Event]()
    var allTeams = [Team]()

    var webServiceObj:WebService!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setNavigationItem()
        database = CoreData.getInstance()
        self.checkFavouriteState()
        webServiceObj = WebService()
        self.apiCalling()
    }
    
    func apiCalling() {
        webServiceObj.getAllTeamsInLeagueByLeagueId(id: leagueData.idLeague) { (arrayOfTeams) in // load all teams in league
            
            guard let validArrayOfTeamse = arrayOfTeams else {
                return
            }
            
            self.allTeams = validArrayOfTeamse
            DispatchQueue.main.async {
                self.uiTeamCollectionView.reloadData()
            }
            
            self.webServiceObj.getLatestInLeagueById(id:self.leagueData.idLeague) { (arrayOfEvents) in // load previous events (tableview)
                guard let validArrayOfEvents = arrayOfEvents else {
                    self.present(connectionIssue(), animated: true, completion: nil)
                    return
                }
                self.lastArray = validArrayOfEvents
                
                DispatchQueue.main.async {
                    self.uiTableView.reloadData()
                }
            }
        }
    }
    
    func setNavigationItem() {
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(named: "heart"), style: .plain, target: self, action: #selector(addTapped))
        navigationItem.title = leagueData.strLeague
    }
    
    func checkFavouriteState(){
        if let validState = database.fetchData() {
            for item in validState{
                if item.value(forKey: "leagueID") as! String == leagueData.idLeague {
                    favouriteState = true
                    navigationItem.rightBarButtonItem?.tintColor = #colorLiteral(red: 0.7450980544, green: 0.1568627506, blue: 0.07450980693, alpha: 1)
                    return
                }
            }
            favouriteState = false
            navigationItem.rightBarButtonItem?.tintColor = #colorLiteral(red: 0.01680417731, green: 0.1983509958, blue: 1, alpha: 1)
        }else{
            print("else in checkFavouriteState")
            favouriteState = false
        }
    }
    @objc func addTapped() {
        if favouriteState { // league is assigned to be favourite, then we will delete it
            database.deleteItem(leagueId: leagueData.idLeague)
            navigationItem.rightBarButtonItem?.tintColor = #colorLiteral(red: 0.01680417731, green: 0.1983509958, blue: 1, alpha: 1)
            favouriteState = false
        }else{  // league is not favourite, then we will save it as favourite
            var image:String
            if let validImage = leagueData.strBadge {
                image = validImage
            }else{
                image = "anonymousLogo"
            }
            database.save(fav: FavouriteData(leagueID: leagueData.idLeague, leagueName: leagueData.strLeague, leagueImage: image, youtubeLink: leagueData.strYoutube))
            navigationItem.rightBarButtonItem?.tintColor = #colorLiteral(red: 0.7450980544, green: 0.1568627506, blue: 0.07450980693, alpha: 1)
            favouriteState = true
        }
        
    }
    
}




//MARK::Upcoming
extension LeaguesDetailsVC: UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        if collectionView == uiUpcomingCollectionView{
//            return upcomingArray.count
            return 5
        }else{
            return allTeams.count
        }
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if collectionView == uiUpcomingCollectionView{
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "upcommingCell", for: indexPath) as! UpcomingCell
            cell.layer.cornerRadius = 20
            
            cell.uiTeamTwoImage.image = #imageLiteral(resourceName: "anonymousLogo")
            cell.uiTeamOneImage.image = #imageLiteral(resourceName: "anonymousLogo")
            cell.uiTeamOneName.text = "arsenal"
            cell.uiTeamTwoName.text = "man red"
            
//            cell.uiTeamOneImage.sd_imageIndicator = SDWebImageActivityIndicator.gray
//            cell.uiTeamOneImage.sd_imageIndicator =  SDWebImageActivityIndicator.gray
//            if homeImagesNew.count > 0 && awayImagesNew.count > 0 {
//                cell.uiTeamOneImage.sd_setImage(with: URL(string: homeImagesNew[indexPath.row]), completed: nil)
//
//                cell.uiTeamTwoImage.sd_setImage(with: URL(string: awayImages[indexPath.row]), completed: nil)
//            }
//
//            cell.uiTeamOneName.text = upcomingArray[indexPath.row].strHomeTeam
//            cell.uiTeamTwoName.text = upcomingArray[indexPath.row].strAwayTeam
//            cell.uiEventDate.text = upcomingArray[indexPath.row].dateEvent
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
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
//        print(allTeams[indexPath.row])
        
        let teamVc = self.storyboard?.instantiateViewController(identifier: "TeamVC") as! TeamVC
        self.navigationController?.pushViewController(teamVc, animated: true)
        
    }
}

//MARK:- Latest table view
extension LeaguesDetailsVC: UITableViewDelegate,UITableViewDataSource{
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return lastArray.count
    }
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 10
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "latestCell") as! LatestCell
        cell.layer.cornerRadius = 20
        
        
        
        cell.uiTeamOneImage.sd_imageIndicator = SDWebImageActivityIndicator.gray
        cell.uiTeamOneImage.sd_imageIndicator?.startAnimatingIndicator()
        
        cell.uiTeamTwoImage.sd_imageIndicator =  SDWebImageActivityIndicator.gray
        cell.uiTeamTwoImage.sd_imageIndicator?.startAnimatingIndicator()

        if(allTeams.count > 0){
            for item in allTeams {
                print("item is \(item.idTeam)")
                if item.idTeam == lastArray[indexPath.section].idHomeTeam{
                    cell.uiTeamOneImage.sd_setImage(with: URL(string: item.strTeamBadge)) { (image, error, cache, url) in
                        cell.uiTeamOneImage.sd_imageIndicator?.stopAnimatingIndicator()
                    }
                }
                if item.idTeam == lastArray[indexPath.section].idAwayTeam{
                    cell.uiTeamTwoImage.sd_setImage(with: URL(string: item.strTeamBadge), completed: { (image,error,cache,url) in
                        cell.uiTeamTwoImage.sd_imageIndicator?.stopAnimatingIndicator()
                    })
                }
            }
        }
        
        
        cell.uiTeamOneName.text = lastArray[indexPath.section].strHomeTeam
        cell.uiTeamTwoName.text = lastArray[indexPath.section].strAwayTeam
        cell.uiEventDate.text = lastArray[indexPath.section].dateEvent
        let teamOneScore = tableView.viewWithTag(1)
        let teamTwoScore = tableView.viewWithTag(2)
        
        teamOneScore?.clipsToBounds = true
        teamOneScore?.layer.cornerRadius = (teamOneScore?.layer.frame.height)!/2
        teamTwoScore?.clipsToBounds = true
        teamTwoScore?.layer.cornerRadius = (teamTwoScore?.layer.frame.height)!/2
        
        
        if let scoreOne = lastArray[indexPath.section].intHomeScore{
            if let scoreTwo = lastArray[indexPath.section].intAwayScore{
                print("score two\(scoreTwo)")
                print("score One\(scoreOne)")
                cell.uiTeamOneScore.text = scoreOne
                cell.uiTeamTwoScore.text = scoreTwo
            }else{
                cell.uiTeamOneScore.text = scoreOne
                cell.uiTeamTwoScore.text = "0"
            }
        }else{
            cell.uiTeamOneScore.text = "0"
            cell.uiTeamTwoScore.text = "0"
        }
        return cell
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return (view.window?.frame.height)! / 2.7
    }
    
}

