//
//  DescribePostViewController.swift
//  Course2FinalTask
//
//  Created by Radislav Gaynanov on 22/03/2019.
//  Copyright © 2019 e-Legion. All rights reserved.
//

import UIKit

protocol DescribePostViewControllerInputProtocol {
    func setViewModel(_ viewModel: DescriptionPostViewModelProtocol)
}

protocol DescribePostViewControllerOutputProtocol {
    var onClickShare: ((Eerr, Bool) -> Void)? {set get}
}


class DescribePostViewController: UIViewController, DescribePostViewControllerOutputProtocol, DescribePostViewControllerInputProtocol {
    
    private lazy var image: UIImageView = {
        let iv = UIImageView.init()
        iv.translatesAutoresizingMaskIntoConstraints = false
        iv.contentMode = .scaleAspectFill
        iv.backgroundColor = UIColor.gray
        return iv
    }()
    
    private lazy var label: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Add description"
        label.numberOfLines = 1
        label.textAlignment = .left
        label.font = UIFont.systemFont(ofSize: 17.0)
        label.textColor = UIColor.black
        return label
    }()
    
    private lazy var descriptionTextField: UITextField = {
        let tf = UITextField()
        tf.translatesAutoresizingMaskIntoConstraints = false
        tf.borderStyle = .roundedRect
        tf.returnKeyType = .go
        tf.autocapitalizationType = .none
        return tf
    }()
   
    var onClickShare: ((Eerr, Bool) -> Void)?
    private var viewModel: DescriptionPostViewModelProtocol?
    
    init() {
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let shareButton = UIBarButtonItem.init(title: "Share",
                                               style: .plain,
                                               target: self,
                                               action: #selector(share))
        self.navigationItem.setRightBarButton(shareButton, animated: true)
        view.backgroundColor = UIColor.white
        view.addSubview(image)
        view.addSubview(label)
        view.addSubview(descriptionTextField)
        descriptionTextField.becomeFirstResponder()
    }
    
    func setViewModel(_ viewModel: DescriptionPostViewModelProtocol) {
        self.viewModel = viewModel
        self.viewModel?.dataIsReady = {[weak self](eerr) in
            if eerr == .noerr || eerr == .submit{  //надо разделить ответ с ошибкой и без
                self?.onClickShare!(eerr, true)
            } else {
                self?.onClickShare!(eerr, false)
            }
        }
        image.image = viewModel.getImage()
    }
    
    @objc
    func share() {
        descriptionTextField.resignFirstResponder()
        if onClickShare != nil {
            viewModel?.share(text: descriptionTextField.text)
            onClickShare!(.submit, true)
        }
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        var topSafeArea: CGFloat
        if #available(iOS 11.0, *){
            topSafeArea = view.safeAreaInsets.top
        } else {
            topSafeArea = topLayoutGuide.length
        }
        
        image.topAnchor.constraint(equalTo: view.topAnchor, constant: topSafeArea + 16).isActive = true
        image.heightAnchor.constraint(equalToConstant: 100).isActive = true
        image.widthAnchor.constraint(equalToConstant: 100).isActive = true
        image.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16).isActive = true
        
        label.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16).isActive = true
        label.topAnchor.constraint(equalTo: image.bottomAnchor, constant: 32).isActive = true
        
        descriptionTextField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16).isActive = true
        descriptionTextField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16).isActive = true
        descriptionTextField.topAnchor.constraint(equalTo: label.bottomAnchor, constant: 8).isActive = true
        
    }
}


