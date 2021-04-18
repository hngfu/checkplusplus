//
//  ToDoListViewController.swift
//  CheckPlusPlus
//
//  Created by 조재흥 on 2021/04/02.
//

import UIKit
import RxCocoa

final class ToDoListViewController: UIViewController {
    
    @IBOutlet weak var toDoListTableView: UITableView!
    @IBOutlet weak var settingButton: UIBarButtonItem!
    @IBOutlet weak var editToDoButton: UIBarButtonItem!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.setNavigationBarHidden(true, animated: false)
    }
    
    func bind(to viewModel: ToDoListViewModel) {
        self.viewModel = viewModel
        
    }
    
    //MARK: - Private
    private var viewModel: ToDoListViewModel?
}
