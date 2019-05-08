//
//  ProfilViewController.swift
//  Course2FinalTask
//
//  Created by Radislav Gaynanov on 05.08.2018.
//  Copyright © 2018 e-Legion. All rights reserved.
//

import UIKit

protocol ProfileViewControllerOutputProtocol {
    var logOut: (() -> Void)? {get set}
    
    var onClick: ((_ viewModel: ListViewModelProtocol?) -> Void)? {get set}
    
    var callBack: ((Eerr, Bool) -> Void)? {set get} // убирает активити индикатор
    
    var kfErrorhandler: ErrorsHandlerProtocol? {set get}
}

protocol ProfileViewControllerInputProtocol {
       func setViewModel(_ vm: ProfileViewModelProtocol)
}

class ProfilViewController: UIViewController, ProfileViewControllerOutputProtocol, ProfileViewControllerInputProtocol{
    
    //MARK: - input
    private var viewModel: ProfileViewModelProtocol?
    
    //MARK: - Output
    var onClick: ((_ viewModel: ListViewModelProtocol?) -> Void)?
    var callBack: ((Eerr, Bool) -> Void)?
    var logOut: (() -> Void)?
    var kfErrorhandler: ErrorsHandlerProtocol?


    private var profileCollectionView:UICollectionView!

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
    
    func setViewModel(_ vm: ProfileViewModelProtocol) {
        viewModel = vm
        viewModel?.dataIsReady = {[weak self] (eerr) in
            DispatchQueue.main.async {
                if self?.profileCollectionView != nil {
                    self?.title = self?.viewModel?.name
                    self?.profileCollectionView.reloadData()
                    if self?.callBack != nil {
                        self?.callBack!(eerr, false)
                    }
                }
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        profileCollectionView = UICollectionView.init(frame: view.bounds, collectionViewLayout: CollectionViewLayout())
        
        profileCollectionView.register(ImageCollectionViewCell.self, forCellWithReuseIdentifier: "imagecell")
        profileCollectionView.register(ProfileCollectonViewCell.self, forCellWithReuseIdentifier: "header")
        
        profileCollectionView.dataSource = self
        profileCollectionView.delegate = self
        
        profileCollectionView.backgroundColor = UIColor.white
        
        self.view.addSubview(profileCollectionView)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        if self.viewModel != nil, viewModel?.name == "Profile" {
            let barButton = UIBarButtonItem.init(title: "Log out",
                                                 style: UIBarButtonItemStyle.plain,
                                                 target: self,
                                                 action: #selector(exit))
            self.navigationItem.setRightBarButton(barButton, animated: true)
        }
        
        if callBack != nil {
            callBack!(.submit, true)
        }
        if viewModel != nil {
            viewModel!.setData()
        }
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
    }
    
    @objc
    func exit(){
        if logOut != nil {
            viewModel?.logOut()
            logOut!()
        }
    }
}
extension ProfilViewController: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        var count = 0
        if let vm = viewModel {
            count = vm.countItems() + 1
        }
        return count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if indexPath.row == 0 {
            let cell = profileCollectionView.dequeueReusableCell(withReuseIdentifier: "header", for: indexPath) as! ProfileCollectonViewCell
            
            cell.setViewModel(viewModel?.getCellViewModel())
            cell.setKfErrorHandler(errHandler: kfErrorhandler)
            
            let fed = UITapGestureRecognizer.init(
                target: self,
                action: #selector(followedTap(sender:)))
            let fing = UITapGestureRecognizer.init(
                target: self,
                action: #selector(followingTap(sender:)))
            cell.setTapeInteraction(forFollower: fed, forfollowing: fing)

            return cell
            
        } else {
        let cell = profileCollectionView.dequeueReusableCell(withReuseIdentifier: "imagecell", for: indexPath) as! ImageCollectionViewCell
        
        cell.setViewModel(viewModel?.getImageCellViewModel(for: indexPath.row - 1))
        cell.setKfErrorHandler(errHandler: kfErrorhandler)
            return cell

        }
    }
}


extension ProfilViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
       
    }
}



extension ProfilViewController {
    //MARK: call Output var
    @objc
    func followedTap(sender:UITapGestureRecognizer){
        if onClick != nil {
            onClick!(viewModel?.getListViewModel(type: .follover))
        }
    }
    @objc
    func followingTap(sender:UITapGestureRecognizer){
        if onClick != nil {
            onClick!(viewModel?.getListViewModel(type: .folloving))
        }
    }
   
}
