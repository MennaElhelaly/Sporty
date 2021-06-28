//
//  LeaguesTableViewController.swift
//  SportsApp
//
//  Created by Ayman Omara on 20/04/2021.
//

import UIKit
import Alamofire
import SDWebImage
import SkeletonView
import RxCocoa
import RxSwift
class LeaguesViewController: UIViewController{
    
    @IBOutlet private var leaguesTableOutlet: UITableView!
    @IBOutlet weak var uiSearch: UISearchBar!
    
    
    let webService = WebService();
    var bag:DisposeBag?
    var strSport:String!;
    var isSearching = false
    var searchedArray:[Leagues]!
    
    let searchController = UISearchController()
    var viewModel:LeaguesViewModel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        bag = DisposeBag()
        viewModel = LeaguesViewModel()
        leaguesTableOutlet.showAnimatedGradientSkeleton()
        viewModel.fetchAllLeagues()
        
        self.rxSearch()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.tabBarController?.tabBar.isHidden = true
        self.prepareScreenData()
    }
    
    func rxSearch() {
        uiSearch.rx.text.orEmpty.throttle(.seconds(3), scheduler: MainScheduler.instance).distinctUntilChanged().subscribe(onNext: { [weak self] query in
            guard let self = self else {return}
            if self.viewModel.isSearchTextEmpty(text:query){
                self.isSearching = false
                self.leaguesTableOutlet.reloadData()
            }else{
                self.isSearching = true
                self.searchedArray = [Leagues]();
                for iteam in self.viewModel.matchedLeagues {
                    
                    
                    if ((iteam.strLeague?.lowercased().contains(query.lowercased())) != nil) {
                        
                        self.searchedArray.append(iteam)
                    }
                    self.leaguesTableOutlet.reloadData()
                }
               
            }
        }).disposed(by: bag!)
    }
    func prepareScreenData() {
        if viewModel.isConnectedToNetwork(){
            
            viewModel.bindinLeaguesData = { [weak self] in
                guard let self = self  else {return}
                self.getLeagueData()
            }
            
            viewModel.bindingConnectionError = { [weak self] in
                guard let self = self  else {return}
                self.handleConnectionError()
            }
            
            viewModel.bindingDataError = { [weak self] in
                guard let self = self  else {return}
                self.handleDataError()
            }
            
            viewModel.bindingLeagueDetails = { [weak self] in
                guard let self = self  else {return}
                DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
                    self.leaguesTableOutlet.hideSkeleton()
                }
                self.leaguesTableOutlet.reloadData()
            }
            
            viewModel.bindingMatchedLeagues = { [weak self] in
                guard  let self = self else {return}
                self.viewModel.fetchLeagueDetails(matchedArray: self.viewModel.matchedLeagues)
                self.leaguesTableOutlet.reloadData()
            }
        }else{
            leaguesTableOutlet.backgroundView = UIImageView(image: UIImage(named: "404")!)
            viewModel.allLeaguesData = [Leagues]()
            leaguesTableOutlet.reloadData()
            
        }
        
        
    }
    
    func handleDataError() {
        let alert = UIAlertController(title: "dataError", message: "returned data is null", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "ok", style: .default, handler: nil))
        present(alert, animated: true, completion: nil)
    }
    func handleConnectionError() {
        
        if viewModel.isConnectedToNetwork(){
//            print(viewModel.bindingConnectionError)
        }else{
            self.present(connectionIssue(), animated: true, completion: nil)
        }
    }
    func getLeagueData() {
        viewModel.getMatchedLeagues(strSport: strSport)
    }
    
    
    @objc func youtubeTapped(sender:UIButton){
        let url = sender.accessibilityValue!        
        viewModel.openYoutube(url: url)
    }
}



extension LeaguesViewController : UITableViewDelegate,SkeletonTableViewDataSource{
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if isSearching {
            return searchedArray.count
        }
        else{
            return viewModel.matchedLeagues.count
        }
    }
    
    
    
    func numSections(in collectionSkeletonView: UITableView) -> Int{
        return 1
    }
    
    func collectionSkeletonView(_ skeletonView: UITableView, numberOfRowsInSection section: Int) -> Int{
        return viewModel.matchedLeagues.count
    }
    func collectionSkeletonView(_ skeletonView: UITableView, cellIdentifierForRowAt indexPath: IndexPath) -> ReusableCellIdentifier{
        return "cell"
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100;
    }
    
    func setLeagueCell(cell: LeaguesTableViewCell,item:LeagueDetails)  {
        if let validImage = item.strBadge{
            cell.leagueTitleImage.sd_setImage(with: URL(string: validImage), completed: {(image,error,cach,url)in
                cell.leagueTitleImage.sd_imageIndicator?.stopAnimatingIndicator()
            })
        }else{
            cell.leagueTitleImage.image = #imageLiteral(resourceName: "anonymousLogo")
        }
        
        cell.youtubeBtn.accessibilityValue = item.strYoutube
        if item.strYoutube == ""{
            cell.youtubeBtn.isEnabled = false
        }else{
            cell.youtubeBtn.isEnabled = true
        }
        cell.youtubeBtn.isHidden = false
        cell.youtubeBtn.hideSkeleton()
        
        cell.youtubeBtn.addTarget(self, action: #selector(self.youtubeTapped), for: .touchUpInside)
        cell.leagueTitleImage.sd_imageIndicator?.stopAnimatingIndicator()
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! LeaguesTableViewCell;
        
        cell.leagueTitleImage.hideSkeleton()
        cell.leageNameOutlet.hideSkeleton()
        cell.leagueTitleImage.sd_imageIndicator = SDWebImageActivityIndicator.gray
        cell.leagueTitleImage.sd_imageIndicator?.startAnimatingIndicator()
        
        if isSearching{
            cell.leageNameOutlet.text = searchedArray[indexPath.row].strLeague
            
            if let idLeague = searchedArray[indexPath.row].idLeague {
                viewModel.searchForLeagueDetails(withId: idLeague) { [weak self] (item) in
                    guard let self = self else {return}
                    self.setLeagueCell(cell: cell, item: item)
                }
            }
            
            return cell
        }else{
            cell.leageNameOutlet.text = viewModel.matchedLeagues[indexPath.row].strLeague
            if viewModel.leagueDetails.count == viewModel.matchedLeagues.count {
                
                
                
                if let idLeague = viewModel.matchedLeagues[indexPath.row].idLeague {
                    viewModel.searchForLeagueDetails(withId: idLeague) { [weak self] (item) in
                        guard let self = self else {return}
                        self.setLeagueCell(cell: cell, item: item)
                    }
                }
            }
        }
        return cell
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let detailsVc = self.storyboard?.instantiateViewController(identifier: "LeaguesDetailsVC") as! LeaguesDetailsVC
        
        if isSearching{
            for i in viewModel.leagueDetails{
                if i.idLeague == searchedArray[indexPath.row].idLeague{
                    
                    let sendData = FavouriteData(idLeague: i.idLeague!, strLeague: i.strLeague!, strYoutube: i.strYoutube!, strBadge: i.strBadge!)
                    detailsVc.leagueData = sendData
                    break
                }
            }
            self.navigationController?.pushViewController(detailsVc, animated: true)
        }
        else{
            viewModel.searchForLeagueDetails(withId: viewModel.matchedLeagues[indexPath.row].idLeague!) { (item) in
                let sendData = FavouriteData(idLeague: item.idLeague!, strLeague: item.strLeague!, strYoutube: item.strYoutube!, strBadge: item.strBadge!)
                detailsVc.leagueData = sendData
                self.navigationController?.pushViewController(detailsVc, animated: true)
            }
            
        }
    }
}
