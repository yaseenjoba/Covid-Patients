//
//  PatientsViewModel.swift
//  Covid Patients
//
//  Created by Yassen Joba on 03/07/2023.
//

import Foundation

class PatientViewModel{
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
    private func addDummyData(){
        originalData.append(Patient(name: "Yaseen", testType: .PCR, testStatus: .negative))
        originalData.append(Patient(name: "Ahmad", testType: .LFTS, testStatus: .negative))
        originalData.append(Patient(name: "Ali", testType: .serology, testStatus: .positve, daysOfSymptoms: 7))
    }
    // MARK: - Public functions
    // FIXME: - should use better names, applyFilters?
    func testsFilter(_ allFilters: [TestType] , nigative: Bool){
        lastFilters = allFilters
        if allFilters.isEmpty{
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
    
    // FIXME: - better naming, applyFilters
    func filterNegatives(nigative: Bool){
        lastNagativeState = nigative
        guard nigative else {
            self.testsFilter(lastFilters, nigative: false)
            return
        }
        
        patients = patients.filter({ (patient) -> Bool in
            return patient.testStatus == .negative
            
        })
    }
    
    func deletePatient(at index: Int){
        // FIXME: - make sure to validate index
        let deletedId = patients[index].id
        // FIXME: - filter is not in the correct context, the item should be removed
        patients = patients.filter({$0.id != deletedId})
        originalData = originalData.filter({$0.id != deletedId})
    }
    
    func addPatient(_ patient: Patient){
        originalData.append(patient)
        testsFilter(lastFilters, nigative: lastNagativeState)
        
    }
    func updateName(newValue: String , at: Int){
        // FIXME: - make sure to validate index
        let updatedPatientId = patients[at].id
        patients[at].name = newValue
        // FIXME: - get first item index, based on id and then update the value
        for patient in originalData{
            if patient.id == updatedPatientId{
                patient.name = newValue
            }
        }
    }
}
