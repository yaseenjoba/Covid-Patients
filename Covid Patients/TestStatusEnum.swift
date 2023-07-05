//
//  TestStatusEnum.swift
//  Covid Patients
//
//  Created by Yassen Joba on 02/07/2023.
//

import Foundation
enum TestStatus: Int, CaseIterable{
    case positve
    case negative
    
    var text: String{
        switch self{
        case .positve:
            return "Positve"
        case .negative:
            return "Negative"
        }
    }
}
