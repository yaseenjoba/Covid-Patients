//
//  AddPatientViewController.swift
//  Covid Patients
//
//  Created by Yassen Joba on 03/07/2023.
//

import Cocoa

protocol AddPatientViewControllerDelegate: AnyObject{
    // FIXME: - better naming
    // FIXME: - should be addPAtientViewController(_ sender: AddPatientViewController, didCreateNew patient: Patient)
    func didReceiveData(_ patient: Patient)
}

// FIXME: - please make sure protocol confirmation is done on a seperate extension
class AddPatientViewController: NSViewController, NSTextFieldDelegate {
    // MARK: - Public properties
    // FIXME: - delegates !!!!MUST!!! always be weak
    var delegate: AddPatientViewControllerDelegate?
    // MARK: - IBOutlets
    @IBOutlet private weak var patientName: NSTextField!
    @IBOutlet private weak var symptomsTime: NSSlider!
    @IBOutlet private weak var testTypeStack: NSStackView!
    @IBOutlet private weak var numberOfDays: NSTextField!
    @IBOutlet private weak var testResultStack: NSStackView!
    @IBOutlet private weak var savePatientButton: NSButton!
    // FIXME: - public vars should be above
    // FIXME: - these should be private
    var patientTestType: TestType?
    var patientTestResult: TestStatus?
    // MARK: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        // FIXME: - delegate = self should be done in the didSet of the outlet itself
        patientName.delegate = self
        addButtons()
    }
    
    override func viewWillAppear() {
        // FIXME: - should call super
        // FIXME: - should move setup function in clear named function and call it
        // FIXME: - better way to call it is in the didLoad function
        patientName.stringValue = ""
        symptomsTime.doubleValue = 50
        for choice in testTypeStack.arrangedSubviews{
            let radio = choice as? NSButton
            radio?.state = .off
        }
        for choice in testResultStack.arrangedSubviews{
            let radio = choice as? NSButton
            radio?.state = .off
        }
        savePatientButton.isEnabled = false
    }
    // MARK: - IBActions
    @IBAction func SliderChanged(_ sender: NSSlider) {
        let sliderValue = sender.doubleValue
        let days = Int(sliderValue * 14.0 / 100.0)
        numberOfDays.stringValue = "\(days) days"
    }
    
    // FIXME: - why is this a ibaction and it's still added in code
    // FIXME: - just add @objc for the selector to work
    @IBAction func testTypeClicked(_ sender: NSButton){
        
        patientTestType = TestType(rawValue: sender.tag)
        checkSaveButtonForEnable()
        
    }
    @IBAction func testRessultClicked(_ sender: NSButton){
        patientTestResult = TestStatus(rawValue: sender.tag)
        checkSaveButtonForEnable()
    }
    
    // FIXME: - should be move to its own seperate extension
    func controlTextDidChange(_ obj: Notification) {
        // FIXME: - guard statments are cleaner
        if obj.object is NSTextField {
            checkSaveButtonForEnable()
        }
    }
    
    // FIXME: - functions should be private also
    
    @IBAction func save(_ sender: NSButton) {
        // FIXME: - seperate each let in a new line for better debug using break points and better readability
        guard let testType = patientTestType, let testResult = patientTestResult, !patientName.stringValue.isEmpty else{
            return
        }
        let sliderValue = symptomsTime.doubleValue
        let days = Int(sliderValue * 14.0 / 100.0)
        let patient = Patient(name: patientName.stringValue, testType: testType, testStatus: testResult, daysOfSymptoms: days)
        delegate?.didReceiveData(patient)
        dismiss(self)
    }
    
    @IBAction func closeWindow(_ sender: Any) {
        dismiss(self)
    }
    // MARK: - Private functions
    private func addButtons(){
        testResultStack.arrangedSubviews.forEach({ $0.removeFromSuperview() })
        testTypeStack.arrangedSubviews.forEach({ $0.removeFromSuperview() })
        for test in TestType.allCases {
            let label = test.longText + " (\(test.shortText))"
            // FIXME: - create a function that creates the buttons and takes name and selector to be used here and below
            let button = NSButton(title: label , target: self, action: #selector(testTypeClicked(_:)))
            button.setButtonType(.radio)
            button.tag = test.rawValue
            button.translatesAutoresizingMaskIntoConstraints = false
            testTypeStack.addArrangedSubview(button)
        }
        for state in TestStatus.allCases{
            let button = NSButton(title: state.text, target: self, action: #selector(testRessultClicked(_:)))
            button.setButtonType(.radio)
            button.tag = state.rawValue
            button.translatesAutoresizingMaskIntoConstraints = false
            testResultStack.addArrangedSubview(button)
        }
    }
    // FIXME: - should have @objc annotation
    // FIXME: - this is also a duplicate function
    // FIXME: - also empty functions should be removed
    private func testTypeClicked(){
        
    }
    // FIXME: - this is not used why is here
    private func sendDataToParent(_ patient: Patient) {
        delegate?.didReceiveData(patient)
    }
    
    
    private func checkSaveButtonForEnable(){
        // FIXME: - you can just have this as 2 lines, 1 line to get the result of the validations 1 line to assigen it to the .isEnabled
        guard !patientName.stringValue.isEmpty, patientTestType != nil, patientTestResult != nil else{
            savePatientButton.isEnabled = false
            return
        }
        savePatientButton.isEnabled = true
    }
    
}
