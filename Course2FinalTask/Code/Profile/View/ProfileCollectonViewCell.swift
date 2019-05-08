//
//  ProfileCollectonReusableView.swift
//  Course2FinalTask
//
//  Created by Radislav Gaynanov on 22.08.2018.
//  Copyright © 2018 e-Legion. All rights reserved.
//

import UIKit
import Kingfisher

class ProfileCollectonViewCell: UICollectionViewCell {
    
    private lazy var avatarImageView:UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFill
        imageView.layer.cornerRadius = 35.0
        imageView.clipsToBounds = true
        imageView.backgroundColor = UIColor.lightGray
        return imageView
    }()
    private lazy var nameLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .left
        label.numberOfLines = 1
        let font = UIFont.systemFont(ofSize: 14.0, weight: .semibold)
        label.font = font
        label.textColor = UIColor.black
        label.text = " "
        label.backgroundColor = UIColor.white
        return label
    }()
    private lazy var followerLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .left
        label.numberOfLines = 1
        let font = UIFont.systemFont(ofSize: 14.0, weight: .semibold)
        label.font = font
        label.textColor = UIColor.black
        label.text = " "
        label.backgroundColor = UIColor.white
        label.isUserInteractionEnabled = true
        return label
    }()
    private lazy var followingLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .right
        label.numberOfLines = 1
        let font = UIFont.systemFont(ofSize: 14.0, weight: .semibold)
        label.font = font
        label.textColor = UIColor.black
        label.text = " "
        label.backgroundColor = UIColor.white
        label.isUserInteractionEnabled = true
        return label
    }()
    
    private lazy var followButton: UIButton = {
        let button = UIButton.init(type:.roundedRect)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.backgroundColor = UIColor.init(hexString: "#0096FF")
        button.setTitleColor(UIColor.white, for: .normal)
        button.layer.cornerRadius = 5
        button.addTarget(self, action: #selector(followUnfollov(_:)), for: .touchUpInside)
        button.setTitle("Unfollow", for: .normal)
        button.isHidden = true
        return button
    }()
    
    private var viewModel: ProfileCellViewModelProtocol?
    var kfErrorhandler: ErrorsHandlerProtocol?

    //MARK: - override
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.addSubview(avatarImageView)
        self.addSubview(nameLabel)
        self.addSubview(followerLabel)
        self.addSubview(followingLabel)
        self.addSubview(followButton)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        setConstraint()
    }
    
    private func setData(){
        if let vm = viewModel {
            
            if let url = vm.getAvatar() {
                let resours = ImageResource.init(downloadURL: url, cacheKey: vm.getAvatar()?.absoluteString)
                avatarImageView.kf.setImage(with: resours, placeholder: nil, options: nil, progressBlock: nil) { [weak self] (res) in
                    switch res{
                        
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
            if let n = vm.getFullName() {
                nameLabel.text = n
            }
            if let f = vm.getFollowers() {
                followerLabel.text = "Follovers: " + String(f)
            }
            if let f = vm.getFollowing() {
                followingLabel.text = "Folloving: " + String(f)
            }
            if let fu = vm.getCurrentUserFollow() {
                followButton.isHidden = false
                followButton.setTitle(fu ? "Unfollow" : "Follow", for: .normal)
            }
        }
    }
    
    
    @objc
    private func followUnfollov(_ sender: UIButton) {
        viewModel?.followUnfollow()
        setData()
    }
    
    //MARK: - public
    func setKfErrorHandler(errHandler: ErrorsHandlerProtocol?) {
        self.kfErrorhandler = errHandler
    }
    
    func setViewModel(_ viewModel: ProfileCellViewModelProtocol?) {
        if let vm = viewModel {
        self.viewModel = vm
        setData()
        }
    }
    
    func setTapeInteraction(forFollower: UITapGestureRecognizer, forfollowing: UITapGestureRecognizer){
        followerLabel.addGestureRecognizer(forFollower)
        followingLabel.addGestureRecognizer(forfollowing)
    }
    
    //MARK: - constrant
    
    private func setConstraint(){
        avatarViewConfig()
        nameLabelConfig()
        followerLabelConfig()
        followingLabelConfig()
        followButtonConfig()
    }
    
    private func avatarViewConfig(){
        avatarImageView.topAnchor.constraint(equalTo: self.contentView.topAnchor, constant: 8.0).isActive = true
        avatarImageView.leadingAnchor.constraint(equalTo: self.contentView.leadingAnchor, constant: 8.0).isActive = true
        avatarImageView.heightAnchor.constraint(equalToConstant: 70.0).isActive = true
        avatarImageView.widthAnchor.constraint(equalToConstant: 70.0).isActive = true
        avatarImageView.bottomAnchor.constraint(equalTo: self.contentView.bottomAnchor, constant: -8.0).isActive = true
    }
    private func nameLabelConfig(){
        nameLabel.topAnchor.constraint(equalTo: self.contentView.topAnchor, constant: 8.0).isActive = true
        nameLabel.leadingAnchor.constraint(equalTo: avatarImageView.trailingAnchor, constant: 8.0).isActive = true
        nameLabel.trailingAnchor.constraint(equalTo: self.contentView.trailingAnchor, constant: -16.0).isActive = true
    }
    private func followerLabelConfig(){
        followerLabel.leadingAnchor.constraint(equalTo: avatarImageView.trailingAnchor, constant: 8.0).isActive = true
        followerLabel.trailingAnchor.constraint(greaterThanOrEqualTo: followingLabel.leadingAnchor, constant: -10.0).isActive = true
    
        followerLabel.bottomAnchor.constraint(equalTo: self.contentView.bottomAnchor, constant: -8.0).isActive = true
    }
    
    private func followingLabelConfig(){
        
        followingLabel.trailingAnchor.constraint(equalTo: self.contentView.trailingAnchor, constant: -16.0).isActive = true
        followingLabel.bottomAnchor.constraint(equalTo: self.contentView.bottomAnchor, constant: -8.0).isActive = true
    }
    
    private func followButtonConfig(){
        followButton.topAnchor.constraint(equalTo: self.contentView.topAnchor, constant: 8.0).isActive = true
        followButton.trailingAnchor.constraint(equalTo: self.contentView.trailingAnchor, constant: -16.0).isActive = true
        followButton.widthAnchor.constraint(equalToConstant: 70.0).isActive = true
    }
}
