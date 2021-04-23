//
//  FavouriteTableViewController.swift
//  SportsApp
//
//  Created by Menna Elhelaly on 4/22/21.
//  Copyright © 2021 Menna Elhelaly. All rights reserved.
//

import UIKit
import CoreData

class FavouriteTableViewController: UITableViewController {
    var favourieArr : [NSManagedObject]!
    var context : NSManagedObjectContext!
    var indecator : UIActivityIndicatorView?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        context = appDelegate.persistentContainer.viewContext
        
        indecator = UIActivityIndicatorView(style:.gray)
        indecator?.center = view.center
        indecator?.startAnimating()
        view.addSubview(indecator!)
        tableView.reloadData()
        
        var title = "Menna"
        let entity = NSEntityDescription.entity(forEntityName: "LeaguesCoreData", in: context)
        let myFavouriteLeague = NSManagedObject(entity: entity!, insertInto: self.context)
        myFavouriteLeague.setValue(title , forKey: "leagueID")
        myFavouriteLeague.setValue(title , forKey: "leagueName")
        myFavouriteLeague.setValue(title , forKey: "leagueImage")
        myFavouriteLeague.setValue(title , forKey: "sportName")
        myFavouriteLeague.setValue(title , forKey: "youtubeLink")
        myFavouriteLeague.setValue(true , forKey: "isFavourite")

        
         try?self.context.save()
        print("save done ...")

        let fetchReq = NSFetchRequest<NSManagedObject>(entityName: "LeaguesCoreData")
        self.favourieArr = try? self.context.fetch(fetchReq)
        self.tableView.reloadData()
        self.indecator?.stopAnimating()
    
    
    
    
    }
    override func viewWillAppear(_ animated: Bool) {
          let fetchReq = NSFetchRequest<NSManagedObject>(entityName: "LeaguesCoreData")
           favourieArr = try? context.fetch(fetchReq)
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
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
         cell.textLabel!.text = favourieArr[indexPath.row].value(forKey: "leagueName") as! String
        // Configure the cell...

        return cell
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
