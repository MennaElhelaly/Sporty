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
    var indecator : UIActivityIndicatorView?
    let coreData = CoreData.getInstance()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        indecator = UIActivityIndicatorView(style:.gray)
        indecator?.center = view.center
        indecator?.startAnimating()
        view.addSubview(indecator!)
        tableView.reloadData()

    }
    override func viewWillAppear(_ animated: Bool) {
        //get
        if let arr = coreData.fetchData() {
            favourieArr = arr
        }else{
            favourieArr = nil
        }
        self.tableView.reloadData()
        self.indecator?.stopAnimating()
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
        if favourieArr != nil
        {
            cell.textLabel!.text = (favourieArr[indexPath.row].value(forKey: "leagueName") as! String)
        }
        else {
            // empty
        }
        return cell
    }
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            coreData.deleteItem(id: indexPath.row)
           favourieArr?.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }
    }
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
    }
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return "Favourite Leagues "
    }
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print((favourieArr[indexPath.row].value(forKey: "leagueName") as! String))
       
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
