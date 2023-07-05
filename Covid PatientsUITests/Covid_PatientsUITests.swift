//
//  Covid_PatientsUITests.swift
//  Covid PatientsUITests
//
//  Created by Yassen Joba on 05/07/2023.
//

import XCTest
@testable import Covid_Patients
final class Covid_PatientsUITests: XCTestCase {
    var app: XCUIApplication!
    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.

        // In UI tests it is usually best to stop immediately when a failure occurs.
        try super.setUpWithError()
        continueAfterFailure = false
       app = XCUIApplication()
       app.launch()

        // In UI tests it’s important to set the initial state - such as interface orientation - required for your tests before they run. The setUp method is a good place to do this.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        app = nil
        try super.tearDownWithError()
    }

    func testAddPatientWindow() throws {
        // UI tests must launch the application that they test.
        let covidPatientsWindow = XCUIApplication().windows["Covid Patients"]
        covidPatientsWindow/*@START_MENU_TOKEN@*/.buttons["add"]/*[[".groups.buttons[\"add\"]",".buttons[\"add\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/.click()
        XCTAssertNotEqual(covidPatientsWindow.sheets["addPatient"].exists, true,"Add window didn't open!")
        // Use XCTAssert and related functions to verify your tests produce the correct results.
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
