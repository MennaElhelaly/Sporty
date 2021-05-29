//
//  SplashVC.swift
//  SportsApp
//
//  Created by Amin on 03/05/2021.
//  Copyright © 2021 Menna Elhelaly. All rights reserved.
//

import UIKit
import Lottie
class SplashVC: UIViewController {

    @IBOutlet weak var animationView: UIImageView!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.animation()
        self.endSplash()
    }
    
    func animation() -> Void {
        let animationView = AnimationView();
        animationView.animation = Animation.named("animation")
        animationView.contentMode = .scaleAspectFit
        animationView.frame = view.bounds
        animationView.loopMode = .loop
        view.addSubview(animationView)
        animationView.play()
    }
    
    func endSplash() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 5) { [weak self] in
            guard let self = self else {return}
            self.performSegue(withIdentifier: "segueToNextScreen", sender:self)
        }
        
    }
    
}
