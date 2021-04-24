//
//  CoreData.swift
//  SportsApp
//
//  Created by Menna Elhelaly on 4/23/21.
//  Copyright © 2021 Menna Elhelaly. All rights reserved.
//
import  UIKit
import Foundation
import CoreData

class CoreData {
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    let context : NSManagedObjectContext!
    let entity : NSEntityDescription!
    let myFavouriteLeague : NSManagedObject!

    
    private static var dataBaseInstance : CoreData?
    public static func getInstance() -> CoreData{
        if let instance = dataBaseInstance {
            return instance
        }else{
            dataBaseInstance = CoreData()
            return dataBaseInstance!
        }
    }
    private init (){
        context = appDelegate.persistentContainer.viewContext
        entity = NSEntityDescription.entity(forEntityName: "LeaguesCoreData", in: context)
        myFavouriteLeague = NSManagedObject(entity: entity!, insertInto: self.context)
    }
    func save (fav : FavouriteData){
        myFavouriteLeague.setValue(fav.leagueID , forKey: "leagueID")
        myFavouriteLeague.setValue(fav.leagueName , forKey: "leagueName")
        myFavouriteLeague.setValue(fav.leagueImage , forKey: "leagueImage")
        myFavouriteLeague.setValue(fav.youtubeLink , forKey: "youtubeLink")
        try?self.context.save()
        print("save done ...")

    }
    func fetchData() -> [NSManagedObject]?{
        let fetchReq = NSFetchRequest<NSManagedObject>(entityName: "LeaguesCoreData")
        if let arr = try? context.fetch(fetchReq) {
            if arr[0].value(forKey: "leagueID") == nil{
                return nil
            }
           return arr
        }else{
            return nil
        }
    }
    func deleteItem (id : Int){
        let fetchReq = NSFetchRequest<NSManagedObject>(entityName: "LeaguesCoreData")
        if let arr = try? context.fetch(fetchReq) {
            context.delete((arr[id]))
            try?context.save()
            print("delete done ...")
        }else{
            print("not deleted ...")
        }
    }
    func deleteItem(leagueId:String) {
        if let array = fetchData(){
            for item in array {
                if item.value(forKey: "leagueID") as! String == leagueId{
                    context.delete(item)
                    try?context.save()
                    print("deleted")
                }
            }
        }
    }
    
}
