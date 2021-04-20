//
//  InputToDoViewController.swift
//  CheckPlusPlus
//
//  Created by 조재흥 on 2021/04/20.
//

import UIKit

class InputToDoViewController: UIViewController {
    
    @IBOutlet weak var inputTextView: UITextView!
    @IBOutlet weak var textViewBottomConstraint: NSLayoutConstraint!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        inputTextView.delegate = self
        inputTextView.textContainerInset = UIEdgeInsets(top: 4, left: 6, bottom: 4, right: 6);
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow),
                                               name: UIResponder.keyboardWillShowNotification, object: nil)
        inputTextView.becomeFirstResponder()
    }
    
    @IBAction func tapCloseButton(_ sender: UIBarButtonItem) {
        dismiss(animated: true)
    }
    
    //MARK: - Private
    @objc private func keyboardWillShow(_ notification: Notification) {
        guard let userInfo = notification.userInfo,
           let keyboardRectangle = userInfo[UIResponder.keyboardFrameEndUserInfoKey] as? CGRect else {
            return
        }
        let keyboardHeight = keyboardRectangle.height - self.view.safeAreaInsets.bottom
        textViewBottomConstraint.constant = keyboardHeight
    }
}

extension InputToDoViewController: UITextViewDelegate {
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        let maximumCharacterCount = 100
        return (textView.text.count + text.count) <= maximumCharacterCount
    }
}
