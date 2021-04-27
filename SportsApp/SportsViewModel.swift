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
    
    var sportsData :[Sport]! {
        didSet{
            self.bindSportsData()
        }
    }
    
    var connectionError:String! {
        didSet{
            self.bindingConnectionError()
        }
    }
    
    var dataError:Bool!{
        didSet{
            self.bindingDataError()
        }
    }
    
    var bindSportsData : (()->()) = {}
    var bindingConnectionError : (()->()) = {}
    var bindingDataError : (()->()) = {}
    
    override init() {
        super .init()
        self.sportsService = WebService()
        self.fetchSportsData()
    }

    func fetchSportsData (){
        sportsService.callSportsAPI(compilation: { (sportsData,error) in
               
            if let err:Error = error {
                let msg = err.localizedDescription
                self.connectionError = msg
            }else{  // testing on details view controller
                guard let data = sportsData else{
                    print("error in data")
                    self.dataError = true
                    return
                }
                print("data is not null \(data)")
                self.sportsData = data
            }
        })
    }
}
