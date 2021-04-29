//
//  LeaguesTableViewController.swift
//  SportsApp
//
//  Created by Ayman Omara on 20/04/2021.
//

import UIKit
import Alamofire
import SDWebImage
class LeaguesViewController: UIViewController,UISearchBarDelegate,UITableViewDelegate,UITableViewDataSource{
    
    
    @IBOutlet var leaguesTableOutlet: UITableView!
    
    let webService = WebService();
    var array:[LeaguesDataClass] = [LeaguesDataClass]();
    var arrayLeagues:[LeagueById] = [LeagueById]()
    var strSport:String!;
    var isSearching = false
    var searchedArray:[LeaguesDataClass]!

    let searchController = UISearchController()
    var viewModel:LeaguesViewModel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //search bar attributes
        viewModel = LeaguesViewModel()
        viewModel.fetchAllLeagues()
        
//        self.apiCalling()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.tabBarController?.tabBar.isHidden = true
        self.prepareScreenData()
    }

    func prepareScreenData() {
        if Network.shared.isConnected{
            print("connected from leagues")
            viewModel.bindinLeaguesData = {
                self.getLeagueData()
            }
            
            viewModel.bindingConnectionError = {
                self.handleConnectionError()
                print(self.viewModel.connectionError!)
            }
            
            viewModel.bindingDataError = {
                self.handleDataError()
            }
            
            viewModel.bindingLeagueDetails = {
                self.arrayLeagues = self.viewModel.leagueDetails
                self.leaguesTableOutlet.reloadData()
            }
            
        }else{
            print("not connected from leagues")
            leaguesTableOutlet.backgroundView = UIImageView(image: UIImage(named: "404")!)
            array = [LeaguesDataClass]()
            leaguesTableOutlet.reloadData()
        }
    }
    
    func handleDataError() {
        print("returned data is null")
    }
    func handleConnectionError() {
        if Network.shared.isConnected{
            print("url is not correct")
            print(viewModel.bindingConnectionError)
        }else{
            self.present(connectionIssue(), animated: true, completion: nil)
        }
    }
    func getLeagueData() {
        let matched = viewModel.getMatchedLeagues(strSport: strSport)
        self.array = matched
        self.leaguesTableOutlet.reloadData()
        
        viewModel.fetchLeaguesUrlAndImages(matchedArray: matched)
    }
    
    
    func numberOfSections(in tableView: UITableView) -> Int {

        return 1
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if isSearching {
            return searchedArray.count

        }
        else{
        return array.count
        }
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100;
    }


    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! LeaguesTableViewCell;

        cell.leagueTitleImage.layer.cornerRadius = cell.leagueTitleImage.layer.frame.height / 2
        cell.leagueTitleImage.layer.masksToBounds = true
        cell.leagueTitleImage.layer.borderWidth = 0.5
        cell.leagueTitleImage.sd_imageIndicator = SDWebImageActivityIndicator.gray
        cell.leagueTitleImage.sd_imageIndicator?.startAnimatingIndicator()
        if isSearching{
            cell.leageNameOutlet.text = searchedArray[indexPath.row].strLeague

            for item in arrayLeagues {
                if item.idLeague == searchedArray[indexPath.row].idLeague{

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
                    cell.youtubeBtn.addTarget(self, action: #selector(self.youtubeTapped), for: .touchUpInside)
                    cell.leagueTitleImage.sd_imageIndicator?.stopAnimatingIndicator()

                    break
                }
            }

            return cell
        }
        else{
            cell.leageNameOutlet.text = array[indexPath.row].strLeague
            if arrayLeagues.count == array.count {

                for item in arrayLeagues {
                    if item.idLeague == array[indexPath.row].idLeague{

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
                        cell.youtubeBtn.addTarget(self, action: #selector(self.youtubeTapped), for: .touchUpInside)
                        cell.leagueTitleImage.sd_imageIndicator?.stopAnimatingIndicator()

                        break
                    }
                }
            }
            return cell
        }





    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let detailsVc = self.storyboard?.instantiateViewController(identifier: "LeaguesDetailsVC") as! LeaguesDetailsVC

        if isSearching{
            for i in arrayLeagues{
                if i.idLeague == searchedArray[indexPath.row].idLeague{

                    let sendData = FavouriteData(idLeague: i.idLeague, strLeague: i.strLeague, strYoutube: i.strYoutube, strBadge: i.strBadge)
                    detailsVc.leagueData = sendData
                    break
                }
            }
            self.navigationController?.pushViewController(detailsVc, animated: true)
        }
        else{
        for i in arrayLeagues{
            if i.idLeague == array[indexPath.row].idLeague{

                let sendData = FavouriteData(idLeague: i.idLeague, strLeague: i.strLeague, strYoutube: i.strYoutube, strBadge: i.strBadge)
                detailsVc.leagueData = sendData
                break
            }
        }
            self.navigationController?.pushViewController(detailsVc, animated: true)
        }
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
    
    
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        
        if searchText.isEmpty{
            isSearching = false
            leaguesTableOutlet.reloadData()
        }
        else{
        isSearching = true
        
        
        print(searchText)
        searchedArray = [LeaguesDataClass]();
        for iteam in array {
            if iteam.strLeague.lowercased().contains(searchText.lowercased()) {
                
                searchedArray.append(iteam)
            }
            leaguesTableOutlet.reloadData()
        }
        print(searchedArray.count)
        
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
