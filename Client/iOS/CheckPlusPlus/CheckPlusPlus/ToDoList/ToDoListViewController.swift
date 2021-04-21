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
    @IBOutlet weak var positiveFeedbackView: PositiveFeedbackView!
    
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
                .bind { [weak self] in
                    guard let `self` = self else { return }
                    let alert = self.makeAlertController {
                        self.positiveFeedbackView.play()
                        self.viewModel?.deleteToDo(with: todo.id)
                    } cancelHandler: {
                        //TODO: checkbutton -> animatable, reverse
                    }

                    self.present(alert, animated: true)
                }
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
    
    private func makeAlertController(completeHandler: @escaping (() -> Void), cancelHandler: (() -> Void)?) -> UIAlertController {
        let alertController = UIAlertController(title: nil,
                                                message: "완료 처리하시겠습니까?",
                                                preferredStyle: .alert)
        let completeAction = UIAlertAction(title: "완료", style: .default) { _ in
            completeHandler()
        }
        alertController.addAction(completeAction)
        let cancelAction = UIAlertAction(title: "취소", style: .cancel) { _ in
            cancelHandler?()
        }
        alertController.addAction(cancelAction)
        return alertController
    }
}
