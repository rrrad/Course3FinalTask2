//
//  FilterViewController.swift
//  Course2FinalTask
//
//  Created by Radislav Gaynanov on 22/03/2019.
//  Copyright © 2019 e-Legion. All rights reserved.
//

import UIKit

protocol FilterViewControllerOutputProtocol {
    var onClickNext: ((UIImage?) -> Void)? {set get}
    var callBack: ((Eerr, Bool) -> Void)? {set get}
}
protocol FilterViewControllerInputProtocol {
    func setViewModel(_ viewModel: FilterViewModelProtocol)
}

class FilterViewController: UIViewController, FilterViewControllerOutputProtocol, FilterViewControllerInputProtocol {
    
    var onClickNext: ((UIImage?) -> Void)?
    var callBack: ((Eerr, Bool) -> Void)?
    
    private lazy var imageView: UIImageView = {
        let iv = UIImageView.init(frame: CGRect.zero)
        iv.translatesAutoresizingMaskIntoConstraints = false
        iv.contentMode = .scaleAspectFill
        iv.backgroundColor = UIColor.gray
        return iv
    }()
    
    private lazy var filterCollection: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        let cv = UICollectionView.init(frame: CGRect.zero, collectionViewLayout: layout)
        cv.register(FilterCollectionViewCell.self, forCellWithReuseIdentifier: "filter")
        cv.backgroundColor = UIColor.white
        cv.translatesAutoresizingMaskIntoConstraints = false
        layout.scrollDirection = .horizontal
        layout.itemSize = CGSize.init(width: 120, height: 120)
        layout.minimumInteritemSpacing = 16.0
        return cv
    }()
    
    private var barButton: UIBarButtonItem!
    private var viewModel: FilterViewModelProtocol?

    init() {
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.white
        filterCollection.dataSource = self
        filterCollection.delegate = self
        
        barButton = UIBarButtonItem.init(title: "Next",
                                         style: .plain,
                                         target: self,
                                         action:#selector(nextStep))
        self.navigationItem.setRightBarButton(barButton, animated: true)
        barButton.isEnabled = false
        
        view.addSubview(imageView)
        view.addSubview(filterCollection)
        
    }
    
    func setViewModel(_ viewModel: FilterViewModelProtocol) {
        self.viewModel = viewModel
        imageView.image = viewModel.getImage()
    }
    
    override func viewDidLayoutSubviews() {
        super .viewDidLayoutSubviews()
        setConstrint()
    }
    
    @objc
    func nextStep() {
        if onClickNext != nil {
            onClickNext!(imageView.image)
        }
    }
}

extension FilterViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView,
                        didSelectItemAt indexPath: IndexPath){
        if viewModel != nil, callBack != nil {
            callBack!(.submit, true )
            viewModel!.choise(index: indexPath.row) { [weak self] (image) in
                self?.imageView.image = image
                self?.callBack!(.submit, false)
            }
        }
    }
}

extension FilterViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView,
                        numberOfItemsInSection section: Int) -> Int {
        return viewModel?.getCountItem() ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = filterCollection.dequeueReusableCell(withReuseIdentifier: "filter",
                                                        for: indexPath) as! FilterCollectionViewCell
        cell.callBackView = { [weak self] in
            if (self?.barButton.isEnabled)! == false {
                DispatchQueue.main.async {
                 self?.barButton.isEnabled = true
                }
            }
        }
        
        cell.setViewModel(viewModel?.getCellViewModel(index: indexPath.row))
        return cell
    }
    
}

extension FilterViewController {
    
    func setConstrint() {
        var topSafeArea: CGFloat
        var bottomSafeAarea: CGFloat
        if #available(iOS 11.0, *){
            topSafeArea = view.safeAreaInsets.top
            bottomSafeAarea = view.safeAreaInsets.bottom
        } else {
            topSafeArea = topLayoutGuide.length
            bottomSafeAarea = bottomLayoutGuide.length
        }
        
        let width = view.bounds.width
        
        let hfc = (view.bounds.height - width) / 2 - bottomSafeAarea
        if hfc < 60 {
            filterCollection.bottomAnchor.constraint(equalTo: view.bottomAnchor,
                                                     constant: -bottomSafeAarea).isActive = true
        } else {
            filterCollection.bottomAnchor.constraint(equalTo: view.bottomAnchor,
                                                     constant: -hfc).isActive = true
        }
        
        imageView.topAnchor.constraint(equalTo: view.topAnchor,
                                       constant: topSafeArea).isActive = true
        imageView.widthAnchor.constraint(equalToConstant: width).isActive = true
        imageView.heightAnchor.constraint(equalToConstant: width).isActive = true
        imageView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        
        filterCollection.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        filterCollection.widthAnchor.constraint(equalToConstant: width).isActive = true
        filterCollection.heightAnchor.constraint(equalToConstant: CGFloat(150)).isActive = true
        
    }
}
