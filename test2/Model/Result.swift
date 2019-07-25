//
//  Result.swift
//  test2
//
//  Created by McEntire, Allison on 7/25/19.
//  Copyright © 2019 Deloitte Digital. All rights reserved.
//

import Foundation

enum Result<ResultType> {
    case results(ResultType)
    case error(Error)
}
