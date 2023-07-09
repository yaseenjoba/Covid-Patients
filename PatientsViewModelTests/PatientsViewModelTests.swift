//
//  Covid_PatientsTests.swift
//  Covid PatientsTests
//
//  Created by Yassen Joba on 05/07/2023.
//

import XCTest
@testable import Covid_Patients
final class CovidPatientsTests: XCTestCase {
    
    var sut: PatientViewModel!
    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
        try super.setUpWithError()
        sut = PatientViewModel()
    }
    
    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        sut = nil
        try super.tearDownWithError()
    }
    
    func generateRandomText(length: Int) -> String {
        let randomUUID = UUID().uuidString
        let randomText = String(randomUUID.prefix(length))
        return randomText
    }
    
    func testAddPatient() throws {
        try XCTSkipUnless(
            sut != nil,
            "There is No patient!")
        let patient = Patient(name: "YASEEN", testType: .PCR, testStatus: .negative)
        sut.addPatient(patient)
        XCTAssertEqual(sut.patients.contains(where: { $0.id == patient.id }), true, "The patient has't been addded")
    }
    
    func testDeletePatient() throws {
        let deletedIndex = sut.patients.count - 1
        let deletedPatientID = sut.patients[deletedIndex].id
        sut.deletePatient(at: deletedIndex)
        let deletingStatus = sut.patients.contains(where: { $0.id == deletedPatientID })
        XCTAssertFalse(deletingStatus, "The patient hasn't been deleted!")
    }
    
    func testUpdatePatientName() throws {
        let updatedIndex = sut.patients.count - 1
        let newPatientName = generateRandomText(length: 10)
        sut.updatePatientName(newValue: newPatientName, atIndex: updatedIndex)
        let patientNameAfterUpdate = sut.patients[updatedIndex].name
        XCTAssertEqual(newPatientName, patientNameAfterUpdate, "The patient has't been updated yet!")
    }
    
    func testFilterNegatives() throws {
        let originalDataSize = sut.patients.count
        sut.filterNegatives(nigative: true)
        let nigatives = sut.patients.contains(where: { $0.testStatus == .positve })
        XCTAssertEqual(nigatives, false, "The negative filter do not work!")
        sut.filterNegatives(nigative: false)
        let sizeWithNoFilter = sut.patients.count
        XCTAssertEqual(originalDataSize, sizeWithNoFilter, "The negative filter do not work!")
    }
    
    func testPCRTestFilter() throws {
        // generate random filter conf.
        let testTypeToBeTested: TestType = .PCR
        var filters: [TestType] = []
        filters.append(testTypeToBeTested)
        var negativeStatus = true
        sut.applyTestsFilters(filters, nigative: negativeStatus)
        var didFilterApplied = true
        for patient in sut.patients {
            if negativeStatus && patient.testStatus == .positve {
                didFilterApplied = false
                break
            }
            if patient.testType != testTypeToBeTested {
                didFilterApplied = false
                break
            }
        }
        XCTAssertTrue(didFilterApplied, "The filtration for PCR with negatives didn't work!")
        negativeStatus = false
        sut.applyTestsFilters(filters, nigative: negativeStatus)
        for patient in sut.patients {
            if negativeStatus && patient.testStatus == .positve {
                didFilterApplied = false
                break
            }
            if patient.testType != testTypeToBeTested {
                didFilterApplied = false
                break
            }
        }
        XCTAssertTrue(didFilterApplied, "The filtration for PCR with positves didn't work!")
    }
    
    func testLFTSTestFilter() throws {
        // generate random filter conf.
        let testTypeToBeTested: TestType = .LFTS
        var filters: [TestType] = []
        filters.append(testTypeToBeTested)
        var negativeStatus = true
        sut.applyTestsFilters(filters, nigative: negativeStatus)
        var didFilterApplied = true
        for patient in sut.patients {
            if negativeStatus && patient.testStatus == .positve {
                didFilterApplied = false
                break
            }
            if patient.testType != testTypeToBeTested {
                didFilterApplied = false
                break
            }
        }
        XCTAssertTrue(didFilterApplied, "The filtration for PCR with negatives didn't work!")
        negativeStatus = false
        sut.applyTestsFilters(filters, nigative: negativeStatus)
        for patient in sut.patients {
            if negativeStatus && patient.testStatus == .positve {
                didFilterApplied = false
                break
            }
            if patient.testType != testTypeToBeTested {
                didFilterApplied = false
                break
            }
        }
        XCTAssertTrue(didFilterApplied, "The filtration for PCR with positves didn't work!")
    }
    
    func testSerologyTestFilter() throws {
        // generate random filter conf.
        let testTypeToBeTested: TestType = .serology
        var filters: [TestType] = []
        filters.append(testTypeToBeTested)
        var negativeStatus = true
        sut.applyTestsFilters(filters, nigative: negativeStatus)
        var didFilterApplied = true
        for patient in sut.patients {
            if negativeStatus && patient.testStatus == .positve {
                didFilterApplied = false
                break
            }
            if patient.testType != testTypeToBeTested {
                didFilterApplied = false
                break
            }
        }
        XCTAssertTrue(didFilterApplied, "The filtration for PCR with negatives didn't work!")
        negativeStatus = false
        sut.applyTestsFilters(filters, nigative: negativeStatus)
        for patient in sut.patients {
            if negativeStatus && patient.testStatus == .positve {
                didFilterApplied = false
                break
            }
            if patient.testType != testTypeToBeTested {
                didFilterApplied = false
                break
            }
        }
        XCTAssertTrue(didFilterApplied, "The filtration for PCR with positves didn't work!")
    }
    
    func testTestWithNegatives() {
        // generate random filter conf.
        var filters: [TestType] = []
        filters.append(.PCR)
        let negativeStatus = true
        sut.applyTestsFilters(filters, nigative: negativeStatus)
        var didFilterApplied = true
        for patient in sut.patients {
            if negativeStatus && patient.testStatus == .positve {
                didFilterApplied = false
                break
            }
            if !filters.contains(patient.testType) {
                didFilterApplied = false
                break
            }
        }
        XCTAssertTrue(didFilterApplied, "The filtration didn't work!")
    }
    
}
