//
//  FeedTableViewCell.swift
//  Course2FinalTask
//
//  Created by Radislav Gaynanov on 08.08.2018.
//  Copyright © 2018 e-Legion. All rights reserved.
//

import UIKit
import Kingfisher

class FeedTableViewCell: UITableViewCell {
    
    private lazy var avatarImageView:UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFill
        imageView.isUserInteractionEnabled = true
        imageView.backgroundColor = UIColor.lightGray
        let tap = UITapGestureRecognizer.init(target: self, action: #selector(clikProfile))
        tap.numberOfTapsRequired = 1
        imageView.addGestureRecognizer(tap)
        return imageView
    }()
    private lazy var nameLabel:UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .left
        label.numberOfLines = 1
        let font = UIFont.systemFont(ofSize: 14.0, weight: .semibold)
        label.font = font
        label.isUserInteractionEnabled = true
        label.textColor = UIColor.black
        label.text = "name"
        let tap = UITapGestureRecognizer.init(target: self, action: #selector(clikProfile))
        tap.numberOfTapsRequired = 1
        label.addGestureRecognizer(tap)
        label.backgroundColor = UIColor.white
        return label
    }()
    private lazy var dateLabel:UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .left
        label.numberOfLines = 1
        let font = UIFont.systemFont(ofSize: 14.0)
        label.font = font
        label.isUserInteractionEnabled = true
        label.textColor = UIColor.black
        label.text = "date"
        label.backgroundColor = UIColor.white
        return label
    }()
    
    private lazy var feedImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.frame.origin = CGPoint.zero
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFill
        imageView.backgroundColor = UIColor.lightGray
        imageView.isUserInteractionEnabled = true
        let tap = UITapGestureRecognizer.init(target: self, action: #selector(dubleTap(_:)))
        tap.numberOfTapsRequired = 2
        imageView.addGestureRecognizer(tap)
        return imageView
    }()
    
    private lazy var bigLikeImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.frame.origin = CGPoint.zero
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .center
        imageView.backgroundColor = UIColor.clear
        imageView.isUserInteractionEnabled = true
        imageView.layer.opacity = 0
        imageView.image = UIImage.init(named: "bigLike")
        return imageView
    }()
    
    private lazy var likeLable: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .left
        label.numberOfLines = 1
        let font = UIFont.systemFont(ofSize: 14.0)
        label.font = font
        label.textColor = UIColor.black
        let tap = UITapGestureRecognizer.init(target: self, action: #selector(clikLabelLike))
        tap.numberOfTapsRequired = 1
        label.addGestureRecognizer(tap)
        label.isUserInteractionEnabled = true
        label.backgroundColor = UIColor.white
        return label
    }()
    
    private lazy var likeButton:UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(like(_:)), for: .touchUpInside)
        button.setImage(UIImage.init(named: "like"), for: .normal)
        return button
    }()

    
    private func setSubviews(){
        addSubview(avatarImageView)
        addSubview(nameLabel)
        addSubview(dateLabel)
        addSubview(feedImageView)
        addSubview(bigLikeImageView)
        addSubview(likeButton)
        addSubview(likeLable)
    }
    
    private var side:CGFloat = 0.0
    private var defaultTintColor = UIView().tintColor!
    private var viewModel: FeedCellViewModelProtocol?
    private var kfErrorhandler: ErrorsHandlerProtocol? 
    private var isLiked: Bool {
        didSet{
            if isLiked {
                likeButton.imageView?.tintColor = defaultTintColor
            }else{
                likeButton.imageView?.tintColor = UIColor.lightGray
            }
        }
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        self.isLiked = false
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.backgroundColor = UIColor.white
        setSubviews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        side = contentView.frame.width
        setConstrint()
    }
    
    func setViewModel(_ viewModel: FeedCellViewModelProtocol?) {
        self.viewModel = viewModel
        self.setData()
    }
    
    
    private func setData() {
        if let vm = viewModel{
            if let url = vm.getAvatar(){
                let resours1 = ImageResource.init(downloadURL: url)
                avatarImageView.kf.setImage(with: resours1, placeholder: nil, options: nil, progressBlock: nil)
                {[weak self] (res) in
                    switch res {
                    case .success(_): break
                    case .failure(let e):
                        switch e {
                        case .requestError(_), .responseError(_): break
                        case .cacheError(_), .processorError(_), .imageSettingError(_):
                            self?.kfErrorhandler?.recevedError(e.errorCode)
                        }
                    }
                }
            }
            if let n = vm.getName() {nameLabel.text = n}
            if let d = vm.getFormatedDate() {dateLabel.text = d}
            // тест ошибки
            //var url = vm.getPostImage()
            //url?.appendPathComponent("e")
            //
            if let url2 = vm.getPostImage() {
                let resours2 = ImageResource.init(downloadURL: url2)
                feedImageView.kf.setImage(with: resours2, placeholder: nil, options: nil, progressBlock: nil)
                {[weak self] (res) in
                    switch res {
                    case .success(_): break
                    case .failure(let e):
                        switch e {
                        case .requestError(_), .responseError(_): break
                        case .cacheError(_), .processorError(_), .imageSettingError(_):
                            self?.kfErrorhandler?.recevedError(e.errorCode)
                        }
                    }
                }
            }
            setLike()
        }
    }
    
    func setLike(){
       if let vm = viewModel {
            if let c = vm.getLike() {
                self.likeLable.text = "like: " + String(c.count)
                self.isLiked = c.like
            }
        }
    }
    
    func setKfErrorHandler(errHandler: ErrorsHandlerProtocol?) {
        self.kfErrorhandler = errHandler
    }
    
    // Animation
    
    private func bigLikeAnimation(){
        let animation = CAKeyframeAnimation.init(keyPath: #keyPath(CALayer.opacity))
        animation.values = [0, 1, 1, 0]
        animation.keyTimes = [0, 0.1, 0.2, 0.3]
        animation.calculationMode = kCAAnimationCubicPaced
        bigLikeImageView.layer.add(animation, forKey: "opacity")
    }
    
    
    //MARK: - Action
    @objc
    func clikLabelLike() {
        viewModel?.onClikCellCountLike!()
    }
    
    @objc
    func clikProfile() {
        viewModel?.onClikCellProfile!()
    }
    
    @objc
    func like(_ sender: UIButton){
        viewModel?.clicLike()
        setLike()
    }
    
    @objc
    func dubleTap(_ sender: UITapGestureRecognizer){
        bigLikeAnimation()
        if !isLiked {
            viewModel?.clicLike()
            setLike()
        }
    }
    
    
    //MARK - setConstriant
    
    private func setConstrint(){
        avatarViewConfig()
        nameLabelConfig()
        dateLabelConfig()
        feedImageConstraint()
        likeLabelConstraint()
        likeButtonConstraint()
        bigLikeImageConstraint()
    }
    
    private func avatarViewConfig(){
        avatarImageView.topAnchor.constraint(equalTo: self.contentView.topAnchor, constant: 8.0).isActive = true
        avatarImageView.leadingAnchor.constraint(equalTo: self.contentView.leadingAnchor, constant: 15.0).isActive = true
        avatarImageView.heightAnchor.constraint(equalToConstant: 35.0).isActive = true
        avatarImageView.widthAnchor.constraint(equalToConstant: 35.0).isActive = true
        avatarImageView.bottomAnchor.constraint(equalTo: feedImageView.topAnchor, constant: -8.0).isActive = true
    }
    private func nameLabelConfig(){
        nameLabel.topAnchor.constraint(equalTo: self.contentView.topAnchor, constant: 8.0).isActive = true
        nameLabel.leadingAnchor.constraint(equalTo: avatarImageView.trailingAnchor, constant: 8.0).isActive = true
        nameLabel.trailingAnchor.constraint(equalTo: self.contentView.trailingAnchor, constant: -15.0).isActive = true
    }
    private func dateLabelConfig(){
        dateLabel.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: 1.0).isActive = true
        dateLabel.leadingAnchor.constraint(equalTo: avatarImageView.trailingAnchor, constant: 8.0).isActive = true
        dateLabel.trailingAnchor.constraint(equalTo: self.contentView.trailingAnchor, constant: -15.0).isActive = true
        dateLabel.bottomAnchor.constraint(equalTo: feedImageView.topAnchor, constant: -8.0).isActive = true
    }
    private func feedImageConstraint(){
        feedImageView.leadingAnchor.constraint(equalTo: self.contentView.leadingAnchor, constant: 0).isActive = true
        feedImageView.trailingAnchor.constraint(equalTo: self.contentView.trailingAnchor, constant: 0).isActive = true
        feedImageView.widthAnchor.constraint(equalToConstant: side).isActive = true
        feedImageView.heightAnchor.constraint(equalToConstant: side).isActive = true
    }
    private func bigLikeImageConstraint(){
        bigLikeImageView.leadingAnchor.constraint(equalTo: self.contentView.leadingAnchor, constant: 0).isActive = true
        bigLikeImageView.trailingAnchor.constraint(equalTo: self.contentView.trailingAnchor, constant: 0).isActive = true
        bigLikeImageView.topAnchor.constraint(equalTo: feedImageView.topAnchor, constant: 0.0).isActive = true
        bigLikeImageView.bottomAnchor.constraint(equalTo: feedImageView.bottomAnchor, constant: 0.0).isActive = true
    }
    private func likeLabelConstraint(){
        likeLable.leadingAnchor.constraint(equalTo: self.contentView.leadingAnchor, constant: 15.0).isActive = true
        likeLable.topAnchor.constraint(equalTo: feedImageView.bottomAnchor, constant: 0.0).isActive = true
        likeLable.trailingAnchor.constraint(equalTo: likeButton.leadingAnchor, constant: 0.0).isActive = true
        likeLable.heightAnchor.constraint(equalToConstant: 44.0).isActive = true
    }
    
    private func likeButtonConstraint(){
        likeButton.trailingAnchor.constraint(equalTo: self.contentView.trailingAnchor, constant: -15.0).isActive = true
        likeButton.topAnchor.constraint(equalTo: feedImageView.bottomAnchor, constant: 0.0).isActive = true

        likeButton.widthAnchor.constraint(equalToConstant: 44.0).isActive = true
        likeButton.heightAnchor.constraint(equalToConstant: 44.0).isActive = true
    }

}
