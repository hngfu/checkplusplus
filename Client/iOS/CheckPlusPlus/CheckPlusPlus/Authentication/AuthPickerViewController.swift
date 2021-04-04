//
//  AuthPickerViewController.swift
//  CheckPlusPlus
//
//  Created by 조재흥 on 2021/04/04.
//

import UIKit
import FirebaseUI
import Lottie

class AuthPickerViewController: FUIAuthPickerViewController {
    
    @IBOutlet weak var backgroundAnimationView: AnimationView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.leftBarButtonItem = nil
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        backgroundAnimationView.loopMode = .loop
        backgroundAnimationView.animationSpeed = 0.35    // slowly
        backgroundAnimationView.play()
    }
}
