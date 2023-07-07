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
    func testAddingPatient() throws {
        try XCTSkipUnless(
            sut != nil,
            "There is No patient!")
        let patient = Patient(name: "YASEEN", testType: .PCR, testStatus: .negative)
        sut.addPatient(patient)
        XCTAssertEqual(sut.patients.contains(where: { $0.id == patient.id }), true, "The patient has't been addded")
        
    }
    func testPerformanceExample() throws {
        // This is an example of a performance test case.
        measure {
            // Put the code you want to measure the time of here.
        }
    }

}
