//
//  ToDoListViewController.swift
//  CheckPlusPlus
//
//  Created by 조재흥 on 2021/04/02.
//

import UIKit

final class ToDoListViewController: UIViewController {
    
    @IBOutlet weak var toDoListTableView: UITableView!
    
    var viewModel: ToDoListViewModel?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.setNavigationBarHidden(true, animated: false)
    }

    @IBAction func tapSettingButton(_ sender: UIBarButtonItem) {
    }
    
    @IBAction func tapAddToDoButton(_ sender: UIBarButtonItem) {
    }
}
