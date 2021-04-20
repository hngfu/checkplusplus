//
//  EditToDoViewController.swift
//  CheckPlusPlus
//
//  Created by 조재흥 on 2021/04/20.
//

import UIKit

final class EditToDoViewController: InputToDoViewController {
    
    var viewModel: ToDoListViewModel?
    var todo: ToDo?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let todo = todo {
            inputTextView.text = todo.content
        }
    }
    
    @IBAction func tapEditButton(_ sender: UIBarButtonItem) {
        guard let content = inputTextView.text,
              inputTextView.text.isEmpty == false else {
            return
        }
        guard let todoID = todo?.id else { return }
        viewModel?.editToDo(with: todoID, content: content)
        dismiss(animated: true)
    }
}
