//
//  AccountError.swift
//  stellarsdk
//
//  Created by Razvan Chelemen on 29/01/2018.
//  Copyright © 2018 Soneso. All rights reserved.
//

import Foundation

public enum AccountError: Error {
    case keyGenerationFailed(osStatus: OSStatus)
    case requestFailed(response: String)
    case parsingFailed(response: String)
}