//
//  TestStatusEnum.swift
//  Covid Patients
//
//  Created by Yassen Joba on 02/07/2023.
//

import Foundation
// FIXME: - maybe a better name since this is to general, CovidTestResult?
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
