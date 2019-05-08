//
//  NewPostCollectionViewCell.swift
//  Course2FinalTask
//
//  Created by Radislav Gaynanov on 22/03/2019.
//  Copyright © 2019 e-Legion. All rights reserved.
//

import UIKit

class NewPostCollectionViewCell: UICollectionViewCell {
    
    private lazy var newImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.backgroundColor = UIColor.orange
        return imageView
    }()
    
    private var viewModel: NewPostCellViewModelProtocol?
    
    //MARK: - override
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.contentView.addSubview(newImageView)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        newImageView.frame = self.contentView.bounds
    }
    private func setData() {
        newImageView.image = viewModel?.getImage()
        setNeedsLayout()
    }
    
    //MARK: - public
    func setViewModel(_ viewModel: NewPostCellViewModelProtocol?){
        if viewModel != nil {
            self.viewModel = viewModel
            setData()
        }
        
    }
    
    
}
