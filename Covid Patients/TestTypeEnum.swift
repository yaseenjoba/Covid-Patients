//
//  TestTypeEnum.swift
//  Covid Patients
//
//  Created by Yassen Joba on 02/07/2023.
//

import Foundation

enum TestType: Int, CaseIterable{
    case PCR
    case LFTS
    case serology
    
    var longText: String{
        switch self {
        case .PCR:
            return "Polymerase chain reaction"
        case .LFTS:
            return "Leteral flow tests"
        case .serology:
            return "Antibody"
        }
    }
    var shortText: String{
        switch self {
        case .PCR:
            return "PCR"
        case .LFTS:
            return "LFTS"
        case .serology:
            return "serology"
        }
    }
}
