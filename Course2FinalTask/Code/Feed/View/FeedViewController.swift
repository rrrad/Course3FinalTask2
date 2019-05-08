//
//  FeedViewController.swift
//  Course2FinalTask
//
//  Created by Radislav Gaynanov on 05.08.2018.
//  Copyright © 2018 e-Legion. All rights reserved.
//

import UIKit

protocol FeedViewControllerOutputProtocol {
    
    var onClickProfile: ((_ viewModel: ProfileViewModelProtocol?) -> Void)? {get set}
    var onClickList: ((_ viewModel: ListViewModelProtocol?) -> Void)? {get set}
    
    var callBack: ((Eerr, Bool) -> Void)? {set get} // убирает активити индикатор
    var kfErrorhandler: ErrorsHandlerProtocol? {set get}

}

protocol FeedViewControllerInputProtocol {
    var scrollToTop: Bool {set get}
    func setViewModel(_ viewModel: FeedViewModelProtocol)
}

class FeedViewController: UIViewController, FeedViewControllerOutputProtocol, FeedViewControllerInputProtocol {
    
   
    //MARK: - Output
    
    var onClickProfile: ((_ viewModel: ProfileViewModelProtocol?) -> Void)?
    var onClickList: ((_ viewModel: ListViewModelProtocol?) -> Void)?
    var callBack: ((Eerr, Bool) -> Void)?
    var kfErrorhandler: ErrorsHandlerProtocol?


    private var feedTableView: UITableView!
    private var viewModel: FeedViewModelProtocol?
    
    init(someData: String) {
        super.init(nibName: nil, bundle: nil)
        title = someData
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
        
        feedTableView = UITableView.init(frame: self.view.bounds)
        feedTableView.backgroundColor = UIColor.white
        feedTableView.separatorColor = UIColor.clear
        
        feedTableView.register(FeedTableViewCell.self, forCellReuseIdentifier: "cell")
        feedTableView.register(FeedPostTableViewCell.self, forCellReuseIdentifier: "postcell")
        
        feedTableView.dataSource = self
        feedTableView.delegate = self
        
        self.view.addSubview(feedTableView)
        
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
    
    private func numberPost(index:IndexPath) -> Int{
        let i:Int = index.row/2
        return i
    }
   
    //MARK: - Input
    var scrollToTop: Bool = false
    
    func setViewModel(_ viewModel: FeedViewModelProtocol) {
        self.viewModel = viewModel
        self.viewModel?.dataIsReady = { [weak self](err) in
            DispatchQueue.main.async {[weak self] in
                self?.feedTableView.reloadData()
                if self?.scrollToTop ?? true && err == .noerr {
                    self?.scrollToTop = false
                    let indexPath = IndexPath.init(row: 0, section: 0)
                    self?.feedTableView.scrollToRow(at: indexPath, at: UITableViewScrollPosition.top, animated: true)
                }
                if self?.callBack != nil {
                    self?.callBack!(err, false)
                }
            }
        }
    }
}

extension FeedViewController: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel?.countItems() ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let number = numberPost(index: indexPath)

        switch indexPath.row % 2 {
        case 0:
            let cell = feedTableView.dequeueReusableCell(withIdentifier: "cell") as! FeedTableViewCell
            var vm = viewModel?.getCellViewModel(for: number)
            if onClickProfile != nil{
                vm?.onClikCellProfile = { [weak self] in
                    let pvm = self?.viewModel?.getProfileViewModel(for: number)
                    self?.onClickProfile!(pvm)
                }
            }
            if onClickList != nil {
                vm?.onClikCellCountLike = { [weak self] in
                    let lvm = self?.viewModel?.getListViewModel(for: number)
                    self?.onClickList!(lvm)
                }
            }
            cell.setViewModel(vm)
            cell.setKfErrorHandler(errHandler: kfErrorhandler)
            return cell
        case 1:
            let cell3 = feedTableView.dequeueReusableCell(withIdentifier: "postcell") as! FeedPostTableViewCell
            cell3.setViewModel(viewModel?.getPostCell(for: number))

            return cell3

        default:
            let cell = UITableViewCell()
            return cell
        }
    }
}

extension FeedViewController: UITableViewDelegate {

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        switch indexPath.row % 2 {
        case 0:
            return 95 + tableView.bounds.width
        case 1:
            let heigtt = heighLabel(text: viewModel?.getText(for: numberPost(index: indexPath)) ?? " ")
            return heigtt + 8
        default:
            return 51
        }
    }
    
    func tableView(_ tableView: UITableView, shouldHighlightRowAt indexPath: IndexPath) -> Bool {
        return false
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: false)
    }
    
    // calculate HeightCell
    private func heighLabel (text: String) -> CGFloat{
        let label = UILabel(frame: CGRect(x: 0, y: 0, width: feedTableView.bounds.width - 30.0, height: CGFloat.greatestFiniteMagnitude))
        label.numberOfLines = 0
        label.lineBreakMode = NSLineBreakMode.byWordWrapping
        label.font = UIFont.systemFont(ofSize: 14.0)
        label.text = text
        label.sizeToFit()
        return label.frame.height
    }
}
