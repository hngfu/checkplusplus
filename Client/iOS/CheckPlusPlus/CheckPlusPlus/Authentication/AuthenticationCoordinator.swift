//
//  AuthenticationCoordinator.swift
//  CheckPlusPlus
//
//  Created by 조재흥 on 2021/04/02.
//

import UIKit
import FirebaseUI
import os.log

final class AuthenticationCoordinator: Coordinator {

    func start() {
        guard let authUI = FUIAuth.defaultAuthUI() else { return }
        authUI.delegate = self.authController
        authUI.providers = [
            FUIGoogleAuth(authUI: authUI),
            FUIOAuth.appleAuthProvider(with: .dark),
        ]
        let authViewController = authUI.authViewController()
        authViewController.modalPresentationStyle = .fullScreen
        navigationController.present(authViewController, animated: false)
    }
    
    //MARK: - Private
    private let authController = AuthController()
    
    private final class AuthController: NSObject, FUIAuthDelegate {
        
        func authUI(_ authUI: FUIAuth, didSignInWith authDataResult: AuthDataResult?, error: Error?) {
            if let error = error {
                os_log("Auth error: %{private}@", error.localizedDescription)
                return
            }
            
        }
        
        func authPickerViewController(forAuthUI authUI: FUIAuth) -> FUIAuthPickerViewController {
            return AuthPickerViewController(nibName: "AuthPickerViewController",
                                            bundle: Bundle.main,
                                            authUI: authUI)
        }
    }
}

