//
//  NewPostViewController.swift
//  Course2FinalTask
//
//  Created by Radislav Gaynanov on 22/03/2019.
//  Copyright © 2019 e-Legion. All rights reserved.
//

import UIKit

protocol NewPostViewControllerOutputProtocol {
    var callBack: (() -> Void)? {set get}
    var onClickPhoto: ((UIImage) -> Void)? {get set}
    
}

protocol NewPostViewControllerInputProtocol {
    
}

class NewPostViewController: UIViewController, NewPostViewControllerOutputProtocol, NewPostViewControllerInputProtocol {
    
    var onClickPhoto: ((UIImage) -> Void)?
    var callBack: (() -> Void)?
    
    private var newCollectionView: UICollectionView!
    private var viewModel = NewPostViewModel()
    
    init() {
        super.init(nibName: nil, bundle: nil)
        title = "New post"
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
        newCollectionView = UICollectionView.init(frame: view.bounds,
                                                  collectionViewLayout: UICollectionViewFlowLayout())
        
        newCollectionView.register(NewPostCollectionViewCell.self, forCellWithReuseIdentifier: "new")
        newCollectionView.delegate = self
        newCollectionView.dataSource = self
        newCollectionView.backgroundColor = UIColor.white
        view.addSubview(newCollectionView)
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        viewModel.setDataViewModel()
        self.newCollectionView.reloadData()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
    }

}

extension NewPostViewController: UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.countItem()
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "new", for: indexPath) as! NewPostCollectionViewCell
        cell.setViewModel(viewModel.getNewPostCellViewModel(for: indexPath.row))
        return cell
    }
}

extension NewPostViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath){
        if onClickPhoto != nil {
            onClickPhoto!(viewModel.qetImage(indexPath.row))
        }
    }
}

extension NewPostViewController: UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let sideSize = collectionView.bounds.width/3
        
        return CGSize(width: sideSize, height: sideSize)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat{
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat{
        return 0
    }
}
