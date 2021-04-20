//
//  CreateToDoViewController.swift
//  CheckPlusPlus
//
//  Created by 조재흥 on 2021/04/20.
//

import UIKit

final class CreateToDoViewController: UIViewController {

    @IBOutlet weak var inputTextView: UITextView!
    @IBOutlet weak var textViewBottomConstraint: NSLayoutConstraint!
    
    var viewModel: ToDoListViewModel?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        inputTextView.delegate = self
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow),
                                               name: UIResponder.keyboardWillShowNotification, object: nil)
        inputTextView.becomeFirstResponder()
    }
    
    @IBAction func tapAddButton(_ sender: UIBarButtonItem) {
        guard let content = inputTextView.text,
              inputTextView.text.isEmpty == false else {
            return
        }
        viewModel?.addToDo(with: content)
        dismiss(animated: true)
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

extension CreateToDoViewController: UITextViewDelegate {
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        return (textView.text.count + text.count) <= 100
    }
}
