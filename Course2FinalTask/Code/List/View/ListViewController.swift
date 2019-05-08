//
//  ListViewController.swift
//  Course2FinalTask
//
//  Created by Radislav Gaynanov on 09/03/2019.
//  Copyright © 2019 e-Legion. All rights reserved.
//

import UIKit
import Kingfisher

protocol ListViewControllerOutputProtocol {
    var onClickCell: ((_ vm: ProfileViewModelProtocol?) -> Void)? {get set}
    
    var callBack: ((Eerr, Bool) -> Void)? {set get} // убирает активити индикатор

    var kfErrorhandler: ErrorsHandlerProtocol? {set get}

}

protocol ListViewControllerInputProtocol {
    func setViewModel(_ viewModel: ListViewModelProtocol?)
}

class ListViewController: UIViewController, ListViewControllerOutputProtocol, ListViewControllerInputProtocol{
    
    //MARK: - input
    private var viewModel: ListViewModelProtocol?
    
    //MARK: - output
    var onClickCell: ((_ vm: ProfileViewModelProtocol?) -> Void)?
    var callBack: ((Eerr, Bool) -> Void)? // убирает активити индикатор
    var kfErrorhandler: ErrorsHandlerProtocol?

    
    private var tableViewFollow: UITableView!
    private var selectedCell: IndexPath?
    private var color = UIColor.init(red: 230/255, green: 230/255, blue: 230/255, alpha: 1.0)
    
    init(someData: String) {
        super.init(nibName: nil, bundle: nil)
        title = someData
    }
    
    func setViewModel(_ viewModel: ListViewModelProtocol?) {
        self.viewModel = viewModel
        title = viewModel?.name
        self.viewModel?.dataIsReady = { [weak self] (eerr) in
            DispatchQueue.main.async {
                if self?.tableViewFollow != nil {
                    self?.tableViewFollow.reloadData()
                    if self?.callBack != nil {
                        self?.callBack!(eerr, false)
                    }
                }
            }
            
        }
    }
    
    @available(*, unavailable, message: "Use init(someData:) instead")
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        fatalError("Use init(someData:) instead of init(nibName:, bundle:)")
    }
    
    @available(*, unavailable, message: "Use init(someData:) instead")
    required init?(coder aDecoder: NSCoder) {
        fatalError("Use init(someData:) instead of init?(coder:)")
    }
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableViewFollow = UITableView.init(frame: self.view.bounds)
        tableViewFollow.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        tableViewFollow.dataSource = self
        tableViewFollow.delegate = self
        self.view.addSubview(tableViewFollow)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if callBack != nil {
            callBack!(.submit, true)
        }
        if viewModel != nil {
            viewModel!.setData()
        }
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super .viewDidAppear(animated)
        if let i = selectedCell{
            tableViewFollow.cellForRow(at: i)?.backgroundColor = UIColor.white
        }
    }
}
extension ListViewController: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel?.countItem() ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        let cell = tableViewFollow.dequeueReusableCell(withIdentifier: "cell")!
        cell.textLabel?.text = viewModel?.getFullName(for: indexPath)
        if let url = viewModel?.getAvatar(for: indexPath) {
            let resours = ImageResource.init(downloadURL: url, cacheKey: url.absoluteString)
            cell.imageView?.kf.setImage(with: resours, placeholder: UIImage(named: "profile"), options: nil, progressBlock: nil, completionHandler: { [weak self] (res) in
                switch res {
                    
                case .success(_):
                    self?.tableViewFollow.reloadRows(at: [indexPath], with: UITableViewRowAnimation.none)

                case .failure(let e):
                    switch e {
                    case .requestError(_), .responseError(_): break
                    case .cacheError(_), .processorError(_), .imageSettingError(_):
                        self?.kfErrorhandler?.recevedError(e.errorCode)
                    }
                }
                
            })
        }
        return cell
        
    }
    
}

extension ListViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 45.0
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.cellForRow(at: indexPath)?.backgroundColor = color
        selectedCell = indexPath
        tableView.deselectRow(at: indexPath, animated: false)
        
        guard onClickCell != nil else { return }
        onClickCell!(viewModel?.getProfileViewModel(at: indexPath))        
    }
}

