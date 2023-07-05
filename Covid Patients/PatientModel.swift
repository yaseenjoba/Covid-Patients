//
//  PatientModel.swift
//  Covid Patients
//
//  Created by Yassen Joba on 02/07/2023.
//

import Foundation
class Patient{
    // MARK: - Public properties
    var id: UUID
    var name: String
    var testType: TestType
    var testStatus: TestStatus
    var daysOfSymptoms: Int?
    // MARK: - Life Cycle
    init(name: String, testType: TestType, testStatus: TestStatus, daysOfSymptoms: Int = 0) {
        self.id = UUID()
        self.name = name
        self.testType = testType
        self.testStatus = testStatus
        self.daysOfSymptoms = daysOfSymptoms
    }
    
}
