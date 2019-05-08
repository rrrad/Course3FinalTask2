//
//  ImageCollectionViewCell.swift
//  Course2FinalTask
//
//  Created by Radislav Gaynanov on 22.08.2018.
//  Copyright © 2018 e-Legion. All rights reserved.
//

import UIKit
import Kingfisher


class ImageCollectionViewCell: UICollectionViewCell {
    
    private lazy var postImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.backgroundColor = UIColor.lightGray
        return imageView
    }()
    
    private var viewModel: ProfileImageCellViewModelProtocol?
    var kfErrorhandler: ErrorsHandlerProtocol?
    
    //MARK: - override
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.contentView.addSubview(postImageView)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        postImageView.frame = self.contentView.bounds
    }
    
    private func setData(){
        if let url = viewModel!.getImage() {
            let resours = ImageResource.init(downloadURL: url)//, cacheKey: url.absoluteString)
            postImageView.kf.setImage(with: resours, placeholder: nil, options: nil, progressBlock: nil)
            {[weak self] (res) in
                switch res{
                    
                case .success(_):
                    self?.setNeedsLayout()
                    
                case .failure(let e):
                    switch e {
                    case .requestError(_), .responseError(_): break
                    case .cacheError(_), .processorError(_), .imageSettingError(_):
                        self?.kfErrorhandler?.recevedError(e.errorCode)
                    }
                }
            }
        }
    }
    
    //MARK: - public
    func setViewModel(_ viewModel: ProfileImageCellViewModelProtocol?){
        if let vm = viewModel{
            self.viewModel = vm
            setData()
        }
    }
    
    func setKfErrorHandler(errHandler: ErrorsHandlerProtocol?) {
        self.kfErrorhandler = errHandler
    }

}
