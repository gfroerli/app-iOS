//
//  File.swift
//  gfroerli
//
//  Created by Marc on 03.01.23.
//

import Foundation

enum ViewModelState: Equatable {
    case initial
    case loading
    case loaded
    case failed(error: LoadingStateError)
}

enum LoadingStateError {
    case otherError
}
