//
//  AuthenticationCoordinator.swift
//  CheckPlusPlus
//
//  Created by 조재흥 on 2021/04/02.
//

import FirebaseUI
import os.log

protocol AuthCoordinatorDelegate: AnyObject {
    func showToDoList(with uid: String)
}

final class AuthCoordinator: Coordinator {
    
    weak var delegate: AuthCoordinatorDelegate?

    func start() {
        guard let authUI = FUIAuth.defaultAuthUI() else { return }
        authController.didSignInHandler = { [weak self] (uid: String) in
            self?.delegate?.showToDoList(with: uid)
        }
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
    
    //MARK: - class AuthController
    private final class AuthController: NSObject, FUIAuthDelegate {
        
        var didSignInHandler: ((String) -> Void)?
        
        //MARK: - FUIAuthDelegate
        func authUI(_ authUI: FUIAuth, didSignInWith authDataResult: AuthDataResult?, error: Error?) {
            if let error = error {
                os_log("Auth error: %{private}@", error.localizedDescription)
                return
            }
            
            guard let uid = authDataResult?.user.uid else { return }
            didSignInHandler?(uid)
        }
        
        //MARK: - Custom FirebaseUI ViewController
        func authPickerViewController(forAuthUI authUI: FUIAuth) -> FUIAuthPickerViewController {
            return AuthPickerViewController(nibName: "AuthPickerViewController",
                                            bundle: Bundle.main,
                                            authUI: authUI)
        }
    }
}

