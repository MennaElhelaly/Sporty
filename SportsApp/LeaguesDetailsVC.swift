//
//  LeaguesDetailsVC.swift
//  SportsApp
//
//  Created by Amin on 19/04/2021.
//

import UIKit
import SDWebImage
import MarqueeLabel
import ProgressHUD

class LeaguesDetailsVC: UIViewController{
    
    @IBOutlet weak var uiUpcomingCollectionView: UICollectionView!
    @IBOutlet weak var uiTableView: UITableView!
    @IBOutlet weak var uiTeamCollectionView: UICollectionView!
    @IBOutlet weak var loadingLbl: MarqueeLabel!
    
    @IBOutlet weak var uiScrollView: UIScrollView!
    
    @IBOutlet weak var upcomingLbl: UILabel!
    @IBOutlet weak var lastLbl: UILabel!
    @IBOutlet weak var teamsLbl: UILabel!
    @IBOutlet weak var uiTableViewHegith: NSLayoutConstraint!
    
    public var leagueData:FavouriteData!
   
    private var upcomingArray = [Event]()
    private var lastArray = [Event]()
    private var allTeams = [Team]()
    
    private var viewModel:LeagueDetailsViewModel!

    
    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel = LeagueDetailsViewModel()
        viewModel.getAllTeams(leagueId: leagueData.idLeague)
        self.prepareBindings()
        
        self.setNavigationItem()
        self.prepareSwipe()
        self.checkFavouriteState()
        
        uiTableView.register(UINib(nibName: "LatestCell", bundle: nil), forCellReuseIdentifier: "latestCell")
 
    }
    
    func prepareBindings() {
        viewModel.bindingConnectionError = {
            self.showMarqueeOnly()
            
        }
        
        viewModel.bindingDataError = {
            print("bindingDataError")
            if self.viewModel.dataError == true{
                self.showMarqueeOnly()
            }else{
                // MARK:  no internet connection
                self.navigationController?.popToRootViewController(animated: true)
            }
        }
        
        viewModel.bindingUpcomingConnection = {
//            print("upcoming connection , found nil in error")
        }
        viewModel.bindingUpcomingState = {

            if self.viewModel.upcomingState == true{
                self.loadingLbl.isHidden = false
                self.loadingLbl.type = .continuous
                self.loadingLbl.animationCurve = .easeInOut
            }else{
                // MARK:  no internet connection
                self.navigationController?.popToRootViewController(animated: true)
            }
        }
        
        
        viewModel.bindingAllTeams = {
            self.receiveAllTeams()
        }
        
        viewModel.bindingLatestEvents = { 
            self.receiveLatestEvents()
        }
        
        viewModel.bindingUpcomingEvents = {
            self.receiveUpcomintEvents()
        }
        
    }
    
    
    
    // MARK:-  Receiving bindings
    func receiveAllTeams() {
        guard let validArrayOfTeams = viewModel.allTeamsData else {
            return
        }
        self.allTeams = validArrayOfTeams
        self.uiTeamCollectionView.reloadData()
        
        self.viewModel.getLatestEvents(leagueId: self.leagueData.idLeague)
    }
    
    func receiveLatestEvents() {
        guard let validArrayOfEvents = viewModel.latestEvents else {
            return
        }
        self.lastArray = validArrayOfEvents

        self.uiTableView.reloadData()
        
        self.viewModel.getUpcomingEvents(leagueId: self.leagueData.idLeague, strSeason: self.viewModel.strSeason, round: self.viewModel.round)
    }
    
    func receiveUpcomintEvents(){
   

        guard let events = viewModel.upcomingEvents else {
            return
        }
        self.upcomingArray = events
        self.uiUpcomingCollectionView.reloadData()
    }
    
    
    
    
    
    @objc func respondToSwipe(){
        dismiss(animated: true, completion: nil)
    }
    
    func prepareSwipe() {
        let swipeRight = UISwipeGestureRecognizer(target: self, action: #selector(respondToSwipe))
        swipeRight.direction = .right
        self.view.addGestureRecognizer(swipeRight)
    }

    func showMarqueeOnly()  {
        loadingLbl.isHidden = false
        loadingLbl.type = .continuous
        loadingLbl.animationCurve = .easeInOut
        uiScrollView.isScrollEnabled = false
        upcomingLbl.isHidden = true
        lastLbl.isHidden = true
        teamsLbl.isHidden = true
    }
    
    func setNavigationItem() {
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(named: "heart"), style: .plain, target: self, action: #selector(addTapped))
        navigationItem.title = leagueData.strLeague
    }
    
    func checkFavouriteState(){
        let state = viewModel.checkFavouriteState(leagueId: leagueData.idLeague)
        if state {
            self.navigationItem.rightBarButtonItem?.tintColor = #colorLiteral(red: 0.7450980544, green: 0.1568627506, blue: 0.07450980693, alpha: 1)
        }else{
            self.navigationItem.rightBarButtonItem?.tintColor = #colorLiteral(red: 0.01680417731, green: 0.1983509958, blue: 1, alpha: 1)
        }
    }
    @objc func addTapped() {
        if viewModel.favouriteState { // league is assigned to be favourite, then we will delete it
            
            viewModel.deleteItem(leagueId:leagueData.idLeague)
            ProgressHUD.showSuccess("\(leagueData.strLeague) deleted from your Favourites")
            self.navigationItem.rightBarButtonItem?.tintColor = #colorLiteral(red: 0.01680417731, green: 0.1983509958, blue: 1, alpha: 1)

        }else{  // league is not favourite, then we will save it as favourite
            viewModel.addToFavourite(leagueData: leagueData)
            ProgressHUD.showSuccess("\(leagueData.strLeague) added to your Favourites")
            navigationItem.rightBarButtonItem?.tintColor = #colorLiteral(red: 0.7450980544, green: 0.1568627506, blue: 0.07450980693, alpha: 1)
            
        }
        
    }
    
}




//MARK:-Upcoming & Teams
extension LeaguesDetailsVC: UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        if collectionView == uiUpcomingCollectionView{
            return upcomingArray.count
        }else{
            return allTeams.count
        }
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if collectionView == uiUpcomingCollectionView{
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "upcommingCell", for: indexPath) as! UpcomingCell
            cell.layer.cornerRadius = 20
            
            cell.uiTeamOneImage.sd_imageIndicator = SDWebImageActivityIndicator.gray
            cell.uiTeamOneImage.sd_imageIndicator?.startAnimatingIndicator()
            
            cell.uiTeamTwoImage.sd_imageIndicator = SDWebImageActivityIndicator.gray
            cell.uiTeamTwoImage.sd_imageIndicator?.startAnimatingIndicator()
            
            for item in allTeams{
                if item.idTeam == upcomingArray[indexPath.row].idHomeTeam{
                    if let validImage = item.strTeamBadge{
                        cell.uiTeamOneImage.sd_setImage(with: URL(string: validImage)) { (image, error, cache, url) in
                            cell.uiTeamOneImage.sd_imageIndicator?.stopAnimatingIndicator()
                        }
                    }else{
                        cell.uiTeamOneImage.image = #imageLiteral(resourceName: "anonymousLogo")
                        cell.self.uiTeamOneImage.sd_imageIndicator?.stopAnimatingIndicator()
                    }
                    
                    
                }else if item.idTeam == upcomingArray[indexPath.row].idAwayTeam{
                    if let validImage = item.strTeamBadge{
                        cell.uiTeamTwoImage.sd_setImage(with: URL(string: validImage), completed: { (image,error,cache,url) in
                            cell.uiTeamTwoImage.sd_imageIndicator?.stopAnimatingIndicator()
                        })
                    }else{
                        cell.uiTeamTwoImage.image = #imageLiteral(resourceName: "anonymousLogo")
                        cell.self.uiTeamTwoImage.sd_imageIndicator?.stopAnimatingIndicator()
                    }
                    
                }
            }
            
            
            cell.uiTeamOneName.text = upcomingArray[indexPath.row].strHomeTeam
            cell.uiTeamTwoName.text = upcomingArray[indexPath.row].strAwayTeam
            cell.uiEventDate.text = upcomingArray[indexPath.row].dateEvent
            cell.uiTim.text = upcomingArray[indexPath.row].strTime
            return cell
        }else{
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "teamCell", for: indexPath) as! TeamCell
            cell.uiTeamName.text = allTeams[indexPath.row].strTeam
            cell.uiTeamImage.sd_imageIndicator = SDWebImageActivityIndicator.gray
            
            if let validImage = allTeams[indexPath.row].strTeamBadge{
                
                cell.uiTeamImage.sd_setImage(with: URL(string: validImage)) { (image, error, cache, url) in
                    cell.uiTeamImage.sd_imageIndicator?.stopAnimatingIndicator()
                }
            }else{
                cell.uiTeamImage.image = #imageLiteral(resourceName: "anonymousLogo")
                cell.uiTeamImage.sd_imageIndicator?.stopAnimatingIndicator()
            }
            
            
            return cell
        }
        
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if collectionView == uiUpcomingCollectionView {
            return CGSize(width: ((view.window?.layer.frame.width)! * 3/4) , height: (view.window?.layer.frame.height)! / 5)
        }else{
            return CGSize(width: (view.window?.layer.frame.width)! * 1/4, height: (view.window?.layer.frame.height)! * 1/3.5)
        }
        
    }
    
    
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        if collectionView == uiTeamCollectionView{
            let teamVc = self.storyboard?.instantiateViewController(identifier: "TeamTableViewController") as! TeamTableViewController
            teamVc.teamDeatails = allTeams[indexPath.row]
            present(teamVc, animated: true, completion: nil)
        }
    }
}

//MARK:- Latest table view
extension LeaguesDetailsVC: UITableViewDelegate,UITableViewDataSource{
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return lastArray.count
    }
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 0.5
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
                if item.idTeam == lastArray[indexPath.section].idHomeTeam{
                    
                    if let validImage = item.strTeamBadge{
                        cell.uiTeamOneImage.sd_setImage(with: URL(string: validImage)) { (image, error, cache, url) in
                            cell.uiTeamOneImage.sd_imageIndicator?.stopAnimatingIndicator()
                        }
                    }else{
                        cell.uiTeamOneImage.image = #imageLiteral(resourceName: "anonymousLogo")
                        cell.uiTeamOneImage.sd_imageIndicator?.stopAnimatingIndicator()
                    }
                    
                }
                if item.idTeam == lastArray[indexPath.section].idAwayTeam{
                    if let validImage = item.strTeamBadge {
                        cell.uiTeamTwoImage.sd_setImage(with: URL(string: validImage), completed: { (image,error,cache,url) in
                            cell.uiTeamTwoImage.sd_imageIndicator?.stopAnimatingIndicator()
                        })
                    }else{
                        cell.uiTeamTwoImage.image = #imageLiteral(resourceName: "anonymousLogo")
                        cell.uiTeamTwoImage.sd_imageIndicator?.stopAnimatingIndicator()
                    }
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
        return (view.window?.frame.height)! * 1/4
    }
    
}

//MARK: Scrolling
extension LeaguesDetailsVC{
    
    // add observer on the table view in viewWillAppear
    // remove the observer in viewWillDissappear
    // turn table view isScrollable = false
    
    override func viewWillAppear(_ animated: Bool) {
        uiTableView.addObserver(self, forKeyPath: "contentSize", options: .new, context: nil)
    }
    override func viewWillDisappear(_ animated: Bool) {
        uiTableView.removeObserver(self, forKeyPath: "contentSize")
    }
    
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        if keyPath == "contentSize"{
            if let newValue = change?[.newKey] {
                let newSize = newValue as! CGSize
                uiTableViewHegith.constant = newSize.height
            }
        }
    }
}

//extension LeaguesDetailsVC:UIScrollViewDelegate{
//    func scrollViewDidScroll(_ uiScrollView: UIScrollView) {
//        print("scrollView")
//        if uiScrollView.bounds.contains(uiUpcomingCollectionView.frame) {
//                                print("up")
//            uiTableView.isScrollEnabled = false
//
//        }else{
//            uiTableView.isScrollEnabled = true
//        }
//
//        if uiScrollView == uiTableView {
//                                print("down")
//
//            self.uiTableView.isScrollEnabled = (uiTableView.contentOffset.y > 0)
//        }
//
//    }
//}
