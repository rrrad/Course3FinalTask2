//
//  FeedPostTableViewCell.swift
//  Course2FinalTask
//
//  Created by Radislav Gaynanov on 11.08.2018.
//  Copyright © 2018 e-Legion. All rights reserved.
//

import UIKit

protocol FeedPostCellViewModelProtocol {
    func getDiscription() -> String?
}

class FeedPostTableViewCell: UITableViewCell {
    
    private lazy var postLabel:UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.textAlignment = .left
        label.lineBreakMode = NSLineBreakMode.byWordWrapping
        let font = UIFont.systemFont(ofSize: 14.0)
        label.font = font
        label.text = " "
        label.textColor = UIColor.black
        label.backgroundColor = UIColor.white
        return label
    }()

    private var viewModel: FeedPostCellViewModelProtocol?
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super .init(style: style, reuseIdentifier: reuseIdentifier)
        addSubview(postLabel)

    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        let wightView = self.contentView.bounds.width - 30
        
        postLabel.frame = CGRect.init(x: 15.0, y: 0.0, width: wightView, height: CGFloat.greatestFiniteMagnitude)
        postLabel.sizeToFit()
        self.backgroundColor = UIColor.white

    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

    }

    func setViewModel(_ viewModel: FeedPostCellViewModelProtocol?) {
        self.viewModel = viewModel
        setData()
    }
    
    private func setData(){
        if let vm = viewModel{
            self.postLabel.text = vm.getDiscription()
        }
    }
}
