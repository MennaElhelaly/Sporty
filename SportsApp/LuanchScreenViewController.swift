//
//  LuanchScreenViewController.swift
//  SportsApp
//
//  Created by Ayman Omara on 03/05/2021.
//  Copyright © 2021 Menna Elhelaly. All rights reserved.
//

import UIKit
import Lottie
class LuanchScreenViewController: UIViewController {
    private let animationView = AnimationView();
    override func viewDidLoad() {
        super.viewDidLoad()
        self.animation();
        self.gotoHomeVC()
        
    }
    //MARK: -Ayman Animatoin
    private func animation() -> Void {
        animationView.animation = Animation.named("animation")
        animationView.contentMode = .scaleAspectFit
        animationView.frame = view.bounds
        animationView.loopMode = .playOnce
        view.addSubview(animationView)
        animationView.play()
        
    }
    private func gotoHomeVC()->Void{
        let sportsViewController = self.storyboard?.instantiateViewController(identifier: "SportsViewController");
        
        navigationController?.pushViewController(sportsViewController!, animated: true);
        
    }
    
}
