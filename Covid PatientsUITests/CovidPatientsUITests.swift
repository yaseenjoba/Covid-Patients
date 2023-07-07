//
//  Covid_PatientsUITests.swift
//  Covid PatientsUITests
//
//  Created by Yassen Joba on 05/07/2023.
//

import XCTest
@testable import Covid_Patients
final class CovidPatientsUITests: XCTestCase {
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
    }
    
    func testLaunchPerformance() throws {
        if #available(macOS 10.15, iOS 13.0, tvOS 13.0, watchOS 7.0, *) {
            // This measures how long it takes to launch your application.
            measure(metrics: [XCTApplicationLaunchMetric()]) {
                XCUIApplication().launch()
            }
        }
    }
}
