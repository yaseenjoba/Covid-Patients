//
//  AddPatientViewController.swift
//  Covid Patients
//
//  Created by Yassen Joba on 03/07/2023.
//

import Cocoa

protocol AddPatientViewControllerDelegate: AnyObject{
    func didReceiveData(_ patient: Patient)
}

class AddPatientViewController: NSViewController, NSTextFieldDelegate {
    // MARK: - Public properties
    var delegate: AddPatientViewControllerDelegate?
    // MARK: - IBOutlets
    @IBOutlet private weak var patientName: NSTextField!
    @IBOutlet private weak var symptomsTime: NSSlider!
    @IBOutlet private weak var testTypeStack: NSStackView!
    @IBOutlet private weak var numberOfDays: NSTextField!
    @IBOutlet private weak var testResultStack: NSStackView!
    @IBOutlet private weak var savePatientButton: NSButton!
    var patientTestType: TestType?
    var patientTestResult: TestStatus?
    // MARK: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        patientName.delegate = self
        addButtons()
    }
    
    override func viewWillAppear() {
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
    @IBAction func testTypeClicked(_ sender: NSButton){
        
        patientTestType = TestType(rawValue: sender.tag)
        checkSaveButtonForEnable()
        
    }
    @IBAction func testRessultClicked(_ sender: NSButton){
        patientTestResult = TestStatus(rawValue: sender.tag)
        checkSaveButtonForEnable()
    }
    
    func controlTextDidChange(_ obj: Notification) {
        if obj.object is NSTextField {
            checkSaveButtonForEnable()
        }
    }
    
    @IBAction func save(_ sender: NSButton) {
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
    private func testTypeClicked(){
        
    }
    private func sendDataToParent(_ patient: Patient) {
        delegate?.didReceiveData(patient)
    }
    
    private func checkSaveButtonForEnable(){
        guard !patientName.stringValue.isEmpty, patientTestType != nil, patientTestResult != nil else{
            savePatientButton.isEnabled = false
            return
        }
        savePatientButton.isEnabled = true
    }
    
}
