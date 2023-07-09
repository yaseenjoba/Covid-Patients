//
//  Covid_PatientsUITests.swift
//  Covid PatientsUITests
//
//  Created by Yassen Joba on 05/07/2023.
//

import XCTest
@testable import Covid_Patients
final class PatientsViewModelTests: XCTestCase {
    var app: XCUIApplication!
    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
        
        // In UI tests it is usually best to stop immediately when a failure occurs.
        try super.setUpWithError()
        continueAfterFailure = false
        app = XCUIApplication()
        app.launch()
    }
    
    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        app.terminate()
        app = nil
        try super.tearDownWithError()
    }
    
    func testAddPatientWindow() throws {
        // UI tests must launch the application that they test.
        let covidPatientsWindow = app.windows["Covid Patients"]
        covidPatientsWindow.buttons["add"].click()
        XCTAssertNotEqual(covidPatientsWindow.sheets["addPatient"].exists, true, "Add window didn't open!")
        // Use XCTAssert and related functions to verify your tests produce the correct results.
    }
    func testAddingPatient() throws {
        let covidPatientsWindow = app.windows["Covid Patients"]
        let tableView = app.tables["patientsTable"]
        let oldnNumberOfRows = tableView.tableRows.count
        covidPatientsWindow.buttons["add"].click()
        let addWindow = covidPatientsWindow.sheets
        let nameField = addWindow.textFields["nameField"]
        XCTAssertEqual(nameField.exists, true)
        nameField.typeText("Amr")
        addWindow.radioButtons["PCR"].click()
        addWindow.radioButtons["Positve"].click()
        addWindow.buttons["savePatient"].click()
        Thread.sleep(forTimeInterval: 2.0)
        XCTAssertEqual(oldnNumberOfRows + 1, tableView.tableRows.count)
        let rowIndex = tableView.tableRows.count
        let specificCell = tableView.cells.element(boundBy: rowIndex)
        XCTAssertTrue(specificCell.exists)
        let text = specificCell.textFields.firstMatch
        guard let patientName = text.value as? String else {
            XCTFail("Can't find the added patient")
            return
        }
        XCTAssertEqual(patientName, "Amr", "Wrong patient added!")
    }
    
}
