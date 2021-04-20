//
//  tes.swift
//  SportsApp
//
//  Created by Amin on 19/04/2021.
//

import UIKit

class tes: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    @IBAction func button(_ sender: Any) {
        let vc = self.storyboard?.instantiateViewController(identifier: "LeaguesDetailsVC") as! LeaguesDetailsVC
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
}
