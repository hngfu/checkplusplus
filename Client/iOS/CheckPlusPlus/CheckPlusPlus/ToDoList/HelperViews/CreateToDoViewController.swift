//
//  CreateToDoViewController.swift
//  CheckPlusPlus
//
//  Created by 조재흥 on 2021/04/20.
//

import UIKit

final class CreateToDoViewController: InputToDoViewController {

    var viewModel: ToDoListViewModel?
    
    @IBAction func tapAddButton(_ sender: UIBarButtonItem) {
        guard let content = inputTextView.text,
              inputTextView.text.isEmpty == false else {
            return
        }
        viewModel?.addToDo(with: content)
        dismiss(animated: true)
    }
}
