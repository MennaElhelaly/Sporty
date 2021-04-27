//
//  SportsViewModel.swift
//  SportsApp
//
//  Created by Amin on 27/04/2021.
//  Copyright © 2021 Menna Elhelaly. All rights reserved.
//

import Foundation

class SportsViewModel: NSObject {
    
    var sportsService :WebService!
    
    var SportsData :[Sport]! {
        didSet{
            self.bindSportsData()
        }
    }
    
    var error:String! {
        didSet{
            self.bindError()
        }
    }
    var bindSportsData : (()->()) = {}
    var bindError : (()->()) = {}
    
    override init() {
        super .init()
        self.sportsService = WebService()
        self.fetchSportsData()
    }
    func fetchSportsData (){
        sportsService.callSportsAPI(compilation: { (sportsData,error) in
               
            if let err:Error = error {
                let msg = err.localizedDescription
                self.error = msg
            }else{
                guard let data = sportsData else{
    //                self.present(connectionIssue(), animated: true, completion: nil)
                    print("error in data")
                    return
                }
                print("data is not null \(data)")
    //            self.sportsArr = data
                
                self.SportsData = data
            }
        })
    }
}
