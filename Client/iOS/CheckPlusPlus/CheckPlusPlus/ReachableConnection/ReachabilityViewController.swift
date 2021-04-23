//
//  ReachableConnectionViewController.swift
//  CheckPlusPlus
//
//  Created by 조재흥 on 2021/04/23.
//

import UIKit
import Lottie

final class ReachabilityViewController: UIViewController {
    
    @IBOutlet weak var noInternetConnectionAnimationView: AnimationView!

    override func viewDidLoad() {
        super.viewDidLoad()
        noInternetConnectionAnimationView.loopMode = .loop
        noInternetConnectionAnimationView.play()
    }
}
