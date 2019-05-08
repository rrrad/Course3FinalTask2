//
//  EnumError.swift
//  Course2FinalTask
//
//  Created by Radislav Gaynanov on 20/03/2019.
//  Copyright © 2019 e-Legion. All rights reserved.
//

import Foundation

enum Eerr : String {
    case submit // состояние ожидания ответа
    case err = "Transfer error"//получен ответ с ошибкой (прочая ошибка)
    case noerr // состояние получен ответ без ошибок
    case err404 = "Not found"
    case err400 = "Bad request"
    case err401 = "Unauthorized"
    case err406 = "Not acceptable"
    case err422 = "Unprocessable"
    case localerr = "Unknown error"
}
