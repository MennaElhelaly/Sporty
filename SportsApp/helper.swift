//
//  helper.swift
//  SportsApp
//
//  Created by Amin on 22/04/2021.
//  Copyright © 2021 Menna Elhelaly. All rights reserved.
//

import Foundation
import UIKit


func connectionIssue() -> UIAlertController{
    let alert = UIAlertController(title: "Connection Issue", message: "an Error Occured, Please Try again!", preferredStyle: .alert)
    let ok = UIAlertAction(title: "OK", style: .default)
    alert.addAction(ok)
    return alert
}

