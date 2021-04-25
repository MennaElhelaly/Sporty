//
//  LeaguesTableViewController.swift
//  SportsApp
//
//  Created by Ayman Omara on 20/04/2021.
//

import UIKit
import Alamofire
import SDWebImage
class LeaguesTableViewController: UITableViewController,UISearchBarDelegate{
    
    
    
    let webService = WebService();
    var array:[LeaguesDataClass] = [LeaguesDataClass]();
    var arrayLeagues:[LeagueById] = [LeagueById]()
    var strSport:String!;
    var isSearching = false
    var searchedArray:[LeaguesDataClass]!
    var leageArrar:[LeaguesDataClass] = [LeaguesDataClass]();
    
    @IBOutlet var leaguesTableOutlet: UITableView!
    let searchController = UISearchController()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        //search bar attributes
        
        self.apiCalling()
    }
    
    func apiCalling() {
        webService.allLeaguesAPI(compilation: { (allLeagues) in
            if allLeagues.count == 0{
                print("show alert")
            }else{
                                
                for iteam in allLeagues{
                    if iteam.strSport.rawValue == self.strSport {
                        self.array.append(iteam)
                    }
                }
                DispatchQueue.main.async {
                    self.leaguesTableOutlet.reloadData()
                }
                var x = 0
                for i in self.array{
                    
                    self.webService.lookUpLeagueById(id: i.idLeague) { (LeagueById) in
                        if LeagueById.count == 0{
                            print("show alert")
                        }
                        else{
                            x = x + 1
                            print(x)
                            self.arrayLeagues.append(LeagueById[0])
                            DispatchQueue.main.async {
                                self.leaguesTableOutlet.reloadData()
                            }
                        }
                        
                    }
                }
                

            }
        })
    }
    override func viewWillAppear(_ animated: Bool) {
        
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if isSearching {
            return searchedArray.count
            
        }
        else{
        return array.count
        }
    }
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100;
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! LeaguesTableViewCell;
        
       
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
                        break
                    }
                }
            }
            return cell
        }
        
        

        
        
    }
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
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
            tableView.reloadData()
        }
        else{
        isSearching = true
        
        
        print(searchText)
        searchedArray = [LeaguesDataClass]();
        for iteam in array {
            if iteam.strLeague.contains(searchText) {
                
                searchedArray.append(iteam)
            }
            tableView.reloadData()
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
