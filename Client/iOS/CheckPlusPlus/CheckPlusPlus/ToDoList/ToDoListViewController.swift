//
//  ToDoListViewController.swift
//  CheckPlusPlus
//
//  Created by 조재흥 on 2021/04/02.
//

import UIKit
import RxSwift
import RxCocoa

final class ToDoListViewController: UIViewController {
    
    @IBOutlet weak var toDoListTableView: UITableView!

    var viewModel: ToDoListViewModel?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.setNavigationBarHidden(true, animated: false)
        
        toDoListTableView.register(UINib(nibName: "\(ToDoTableViewCell.self)", bundle: nil),
                                   forCellReuseIdentifier: ToDoTableViewCell.identifier)
        bind()
    }
    
    @IBAction func tapCreateToDoButton(_ sender: UIBarButtonItem) {
        let vc = CreateToDoViewController(nibName: "\(CreateToDoViewController.self)", bundle: nil)
        vc.viewModel = viewModel
        self.present(vc, animated: true)
    }
    
    @IBAction func tapSettingButton(_ sender: UIBarButtonItem) {
        
    }
    
    //MARK: - Private
    private var disposeBag = DisposeBag()
    
    private func bind() {
        guard let viewModel = self.viewModel else { return }
        
        //ToDoListTableView
        viewModel.todos.bind(to: toDoListTableView.rx.items(cellIdentifier: ToDoTableViewCell.identifier,
                                                            cellType: ToDoTableViewCell.self)) { _, todo, cell in
            cell.toDoContentLabel.text = todo.content
            cell.checkButton.rx.tap
                .subscribe(onNext:  { viewModel.deleteToDo(with: todo.id) })
                .disposed(by: cell.disposeBag)
        }
        .disposed(by: disposeBag)
        
        toDoListTableView.rx.modelSelected(ToDo.self)
            .bind { [weak self] todo in
                guard let `self` = self else { return }
                let vc = EditToDoViewController(nibName: "\(EditToDoViewController.self)", bundle: nil)
                vc.viewModel = viewModel
                vc.todo = todo
                self.present(vc, animated: true)
            }
            .disposed(by: disposeBag)
    }
}
