//
//  ActivityIndicator.swift
//  Course2FinalTask
//
//  Created by Radislav Gaynanov on 18/03/2019.
//  Copyright © 2019 e-Legion. All rights reserved.
//

import UIKit

public class ActivityIndicator: UIView {
    
    private lazy var actIndicator: UIActivityIndicatorView = {
        let view = UIActivityIndicatorView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.activityIndicatorViewStyle = .whiteLarge
        return view
    }()
    
    public init(){
        super.init(frame: UIScreen.main.bounds)
        self.backgroundColor = UIColor.black.withAlphaComponent(0.8)
        self.addSubview(actIndicator)
        actIndicator.centerXAnchor.constraint(equalTo: self.centerXAnchor).isActive = true
        actIndicator.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
        actIndicator.startAnimating()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
