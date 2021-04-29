//
//  WebServiceTest.swift
//  SportsAppTests
//
//  Created by Menna Elhelaly on 4/28/21.
//  Copyright © 2021 Menna Elhelaly. All rights reserved.
//

import XCTest
@testable import SportsApp


class WebServiceTest: XCTestCase {
    var webService : WebService!
    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
        webService = WebService()
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        webService = nil
    }
    func testSportsApi()  {
        let expecttionObj = expectation(description: "Wait for response")
        
        webService.callSportsAPI(compilation: { (sportsData,error) in
               
            if let err:Error = error {
               XCTFail()
            }else{  // testing on details view controller
                guard let data = sportsData else{
                    print("error in data")
                    return
                }
                expecttionObj.fulfill()
                XCTAssertEqual(sportsData?.count, 20)
            }
        })
        waitForExpectations(timeout: 5)
    }
   func testFetchAllLeagues() {
        let expecttionObj = expectation(description: "Wait for response")

       webService.allLeaguesAPI(compilation: { (sportsData,error) in
              
           if let err:Error = error {
               XCTFail()
           }else{  // testing on details view controller
               guard let data = sportsData else{
                   print("error in data")
                   return
               }
              expecttionObj.fulfill()
              XCTAssertEqual(sportsData?.count, 582)
               
           }
       })
    waitForExpectations(timeout: 5)

   }
   func testgetAllTeams() {
       let expecttionObj = expectation(description: "Wait for response")

    webService.getAllTeamsInLeagueByLeagueId(id: "4329", completion: { (arrayOfTeams,error)  in // load all teams in league
           
          if let err:Error = error {
               XCTFail()
           }else{  // testing on details view controller
               guard let data = arrayOfTeams else{
                   print("error in data")
                   return
               }
               expecttionObj.fulfill()
               XCTAssertEqual(arrayOfTeams?.count, 24)
           }
       })
    waitForExpectations(timeout: 5)

   }
    func testGetUpcoming(){
        let expecttionObj = expectation(description: "Wait for response")
        webService.getUpcomingEvents(id: "4329", strSeason: "2020-2021", round: "38") { (arrayOfUpcomings,error) in
            if let err:Error = error {
                XCTFail()
            }else{  // testing on details view controller
                guard let data = arrayOfUpcomings else{
                    print("error in data")
                    return
                }
                expecttionObj.fulfill()
                XCTAssertEqual(arrayOfUpcomings?.count, 12)
            }
        }
        waitForExpectations(timeout: 5)

    }
    func testGetLatestEvents(){
        let expecttionObj = expectation(description: "Wait for response")
        webService.getLatestInLeagueById(id:"4329") { (arrayOfEvents,error) in // load previous events (tableview)
            if let err:Error = error {
                XCTFail()
            }else{  // testing on details view controller
                guard let data = arrayOfEvents else{
                    print("error in data")
                    return
                }
                expecttionObj.fulfill()
                XCTAssertEqual(arrayOfEvents?.count, 15)
            }
            
        }
        waitForExpectations(timeout: 5)

    }
    func testLookUp(){
        let expecttionObj = expectation(description: "Wait for response")
        
        webService.lookUpLeagueById(id: "4329") { (LeagueById,error) in
            if let err:Error = error {
                XCTFail()
            }else{  // testing on details view controller
                guard let data = LeagueById else{
                    print("error in data")
                    return
                }
                expecttionObj.fulfill()
                XCTAssertEqual(LeagueById?.count, 1)
            }
        }
        waitForExpectations(timeout: 5)

    }
    func testExample() throws {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
    }

    func testPerformanceExample() throws {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }

}
