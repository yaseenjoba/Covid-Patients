//
//  PatientsViewModel.swift
//  Covid Patients
//
//  Created by Yassen Joba on 03/07/2023.
//

import Foundation

class PatientViewModel {
    // MARK: - Public properties
    public var patients: [Patient] = []
    // MARK: - Private properties
    private var originalData: [Patient] = []
    private var lastFilters: [TestType] = []
    private var lastNagativeState: Bool
    // MARK: - Life Cycle
    init() {
        lastNagativeState = false
        addDummyData()
        patients = originalData
    }
    // MARK: - Private functions
    private func addDummyData() {
        originalData.append(Patient(name: "Yaseen", testType: .PCR, testStatus: .negative))
        originalData.append(Patient(name: "Ahmad", testType: .LFTS, testStatus: .negative))
        originalData.append(Patient(name: "Ali", testType: .serology, testStatus: .positve, daysOfSymptoms: 7))
    }
    // MARK: - Public functions
    func testsFilter(_ allFilters: [TestType], nigative: Bool) {
        lastFilters = allFilters
        if allFilters.isEmpty {
            patients = originalData
            return
        }
        let newFilter = originalData.filter({(patient) -> Bool in
            if allFilters.contains(patient.testType) {
                if patient.testStatus == .positve && nigative {
                    return false
                }
                return true
            }
            return false
        })
        patients = newFilter
    }
    
    func filterNegatives(nigative: Bool) {
        lastNagativeState = nigative
        guard nigative else {
            self.testsFilter(lastFilters, nigative: false)
            return
        }
        
        patients = patients.filter({ (patient) -> Bool in
            return patient.testStatus == .negative
            
        })
    }
    
    func deletePatient(at index: Int) {
        let deletedId = patients[index].id
        patients = patients.filter({ $0.id != deletedId })
        originalData = originalData.filter({ $0.id != deletedId })
    }
    
    func addPatient(_ patient: Patient) {
        originalData.append(patient)
        testsFilter(lastFilters, nigative: lastNagativeState)
        
    }
    func updateName(newValue: String, atIndex: Int) {
        let updatedPatientId = patients[atIndex].id
        patients[atIndex].name = newValue
        originalData = originalData.map { patient in
            if patient.id == updatedPatientId {
                let updatedPatient = patient
                updatedPatient.name = newValue
                return updatedPatient
            } else {
                return patient
            }
        }
        
    }
}
