//
//  CoordinatorOutputProtocol.swift
//  Course2FinalTask
//
//  Created by Radislav Gaynanov on 19/03/2019.
//  Copyright © 2019 e-Legion. All rights reserved.
//

import Foundation

protocol CoordinatorOutputProtocol {
    var finalBlock: (() -> Void)? {get set}
    var callBack: ((Eerr, Bool) -> Void)? {get set}
}
