//
//  FilterCollectionViewCell.swift
//  Course2FinalTask
//
//  Created by Radislav Gaynanov on 23/03/2019.
//  Copyright © 2019 e-Legion. All rights reserved.
//

import UIKit

class FilterCollectionViewCell: UICollectionViewCell {
    
    private lazy var im: UIImageView = {
        let iv = UIImageView.init()
        iv.translatesAutoresizingMaskIntoConstraints = false
        iv.contentMode = .scaleAspectFill
        iv.backgroundColor = UIColor.white
        return iv
    }()
    
    private lazy var nameFilterLable: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .center
        label.numberOfLines = 1
        let font = UIFont.systemFont(ofSize: 17.0)
        label.font = font
        label.textColor = UIColor.black
        label.isUserInteractionEnabled = true
        label.backgroundColor = UIColor.white
        return label
    }()
    
    private var viewModel: FilterCellViewModelProtocol?
    var callBackView: callBack
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = UIColor.white
        self.addSubview(im)
        self.addSubview(nameFilterLable)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        setConstraint()
    }
    
    func setViewModel(_ viewModel: FilterCellViewModelProtocol?) {
        if let vm = viewModel{
            self.viewModel = vm
            self.nameFilterLable.text = vm.getName()
            self.viewModel?.getImageAfterFilter({[weak self] (image) in
                self?.setData(image)
                if self?.callBackView != nil {
                    self?.callBackView!()
                }
            })
            
        }
    }
    
    func setData(_ image: UIImage?){
        DispatchQueue.main.async {
            self.im.image = image
            self.setNeedsLayout()
        }
        
    }
    
    
    func setConstraint(){
        nameFilterLable.centerXAnchor.constraint(equalTo: self.contentView.centerXAnchor).isActive = true
        nameFilterLable.bottomAnchor.constraint(equalTo: self.contentView.bottomAnchor).isActive = true
        nameFilterLable.trailingAnchor.constraint(equalTo: self.contentView.trailingAnchor).isActive = true
        nameFilterLable.leadingAnchor.constraint(equalTo: self.contentView.leadingAnchor).isActive = true
        nameFilterLable.heightAnchor.constraint(equalToConstant: 20).isActive = true
        im.centerXAnchor.constraint(equalTo: self.centerXAnchor).isActive = true
        im.heightAnchor.constraint(equalToConstant: 50).isActive = true
        im.widthAnchor.constraint(equalToConstant: 50).isActive = true
        im.bottomAnchor.constraint(equalTo: nameFilterLable.topAnchor, constant: -8.0).isActive = true
    }
}

