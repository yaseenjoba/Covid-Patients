//
//  ViewController.swift
//  Covid Patients
//
//  Created by Yassen Joba on 30/06/2023.
//

import Cocoa

class ViewController: NSViewController, NSTableViewDelegate, NSTableViewDataSource, NSTextFieldDelegate {
    
    // MARK: - IBOutlets
    @IBOutlet private weak var refreshData: NSPopUpButton!
    @IBOutlet private weak var refreshInterval: NSTextField!
    @IBOutlet private weak var testTypeFilterStack: NSStackView!
    @IBOutlet private weak var intervalStepper: NSStepper!
    @IBOutlet private weak var tableView: NSTableView!
    @IBOutlet private weak var addDeleteSegment: NSSegmentedControl!
    @IBOutlet private weak var negativeFilterSwitch: NSSwitch!
    @IBOutlet private weak var progressStack: NSStackView!
    @IBOutlet private weak var progressLable: NSTextField!
    @IBOutlet private weak var progressBar: NSProgressIndicator!
    @IBOutlet private weak var refreshIntervalStack: NSStackView!
    @IBOutlet private weak var refreshType: NSPopUpButton!
    // MARK: - Private properties
    private var refreshOptions = ["Auto Refresh", "Manual Refresh"]
    private lazy var addPatientViewController: AddPatientViewController = {
        let storyboard = NSStoryboard(name: "Main", bundle: nil)
        let viewController = storyboard.instantiateController(withIdentifier: "AddPatientViewController") as! AddPatientViewController
        return viewController
    }()
    private var refreshTimer: Timer?
    private var lastRowSelected: Int?
    private var patientViewModel: PatientViewModel = PatientViewModel()
    // MARK: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        viewSetup()
        
    }
    
    deinit {
        stopRefreshTimer()
    }
    // MARK: - IBActions
    @IBAction func stepperValueChanged(_ sender: NSStepper) {
        let newValue = sender.integerValue
        refreshInterval.stringValue = "\(newValue)"
        stopRefreshTimer()
        startRefreshTimer()
    }
    
    @IBAction func textFieldValueChanged(_ sender: NSTextField) {
        if let value = Int(sender.stringValue) {
            intervalStepper.integerValue = value
        }
        stopRefreshTimer()
        startRefreshTimer()
    }
    
    @IBAction func forceRefresh(_ sender: Any) {
        filterPatients()
        refreshTableView()
    }
    
    @IBAction func showNigativeResults(_ sender: NSSwitch) {
        patientViewModel.filterNegatives(nigative: sender.state == .on)
        refreshTableView()
    }
    
    @IBAction func refreshValueChcanged(_ sender: NSPopUpButton) {
        if let selectedItem = sender.selectedItem {
            let selectedOption = selectedItem.title
            if selectedOption == refreshOptions[1]{
                refreshIntervalStack.isHidden = true
                stopRefreshTimer()
            }else{
                startRefreshTimer()
                refreshIntervalStack.isHidden = false
            }
        }
    }
    // MARK: - Public functions
    func numberOfRows(in tableView: NSTableView) -> Int {
        return patientViewModel.patients.count
    }
    
    func tableView(_ tableView: NSTableView, viewFor tableColumn: NSTableColumn?, row: Int) -> NSView? {
        
        let cell = tableView.makeView(withIdentifier: NSUserInterfaceItemIdentifier("CustomCell"), owner: self) as? CustomCell
        cell?.delegate = self
        cell?.datasource = self
        switch tableColumn?.identifier{
        case NSUserInterfaceItemIdentifier("Name"):
            cell?.nameCellSetup(patient: patientViewModel.patients[row])
            return cell
        case NSUserInterfaceItemIdentifier("Type"):
            cell?.typeCellSetup(patient: patientViewModel.patients[row])
            return cell
        case NSUserInterfaceItemIdentifier("Status"):
            cell?.statusCellSetup(patient: patientViewModel.patients[row])
            return cell
        default:
            return nil
        }
        
    }
    
    //update
    func tableViewSelectionDidChange(_ notification: Notification) {
        let selectedRow = tableView.selectedRow
        lastRowSelected = selectedRow
        guard selectedRow != -1 else {
            progressStack.isHidden = true
            return
        }
        addDeleteSegment.setEnabled(true, forSegment: 1)
        if patientViewModel.patients[selectedRow].testStatus == .positve{
            if let days = patientViewModel.patients[selectedRow].daysOfSymptoms{
                progressStack.isHidden = false
                progressLable.stringValue = "\(patientViewModel.patients[selectedRow].name)'s Recovery Progress"
                progressBar.doubleValue = (Double(days) / 14.0) * 100.0
            }
        }else{
            progressStack.isHidden = true
        }
        
    }
    
    @objc func addDeletePatient(_ sender: NSSegmentedControl) {
        let selectedSegment = sender.selectedSegment
        switch selectedSegment {
        case 0:
            openAddWindow()
            break
        case 1:
            guard lastRowSelected != nil else{
                return
            }
            deletePatinet()
            lastRowSelected = -1
            break
        default:
            break
        }
        
    }
    
    // MARK: - Private functions
    private func viewSetup(){
        delegatesSetup()
        refreshSectionSetup()
        filtersSectionSetup()
        addDeleteSectionSetup()
        startRefreshTimer()
    }
    private func startRefreshTimer() {
        guard let value = Double(refreshInterval.stringValue) else{
            return
        }
        let interval: TimeInterval = value
        refreshTimer = Timer.scheduledTimer(timeInterval: interval, target: self, selector: #selector(refreshTableView), userInfo: nil, repeats: true)
    }
    
    private func stopRefreshTimer() {
        refreshTimer?.invalidate()
        refreshTimer = nil
    }
    
    @objc private func refreshTableView() {
        tableView.reloadData()
        progressStack.isHidden = true
        addDeleteSegment.setEnabled(false, forSegment: 1)
    }
    
    private func deletePatinet() {
        guard let row = lastRowSelected,  row != -1 else {return}
        let alert = NSAlert()
        alert.messageText = "Are you sure you want to delete patient \(patientViewModel.patients[row].name)?"
        alert.informativeText = "This can't be undone"
        alert.alertStyle = .warning
        alert.addButton(withTitle: "Delete")
        alert.addButton(withTitle: "Cancel")
        guard let window = view.window else { return }
        alert.beginSheetModal(for: window, completionHandler: { (response) in
            if response == .alertFirstButtonReturn {
                self.patientViewModel.deletePatient(at: row)
                self.refreshTableView()
                print("Item deleted")
            } else {
                // Cancel the deletion
                print("Deletion canceled")
            }
        })
    }
    
    private func openAddWindow() {
        presentAsSheet(addPatientViewController)
    }
    
    private func delegatesSetup(){
        tableView.dataSource = self
        tableView.delegate = self
        addPatientViewController.delegate = self
    }
    
    private func refreshSectionSetup(){
        intervalStepper.minValue = 1
        refreshData.removeAllItems()
        refreshData.addItems(withTitles: refreshOptions)
        refreshInterval.stringValue = "\(intervalStepper.integerValue)"
        refreshIntervalStack.isHidden = true
    }
    
    private func filtersSectionSetup(){
        testTypeFilterStack.arrangedSubviews.forEach({ $0.removeFromSuperview() })
        for test in TestType.allCases {
            var label = test.longText + " (\(test.shortText))"
            let button = NSButton(title: label, target: self, action: nil)
            button.setButtonType(.switch)
            button.tag = test.rawValue
            print(button.tag)
            button.translatesAutoresizingMaskIntoConstraints = false
            testTypeFilterStack.addArrangedSubview(button)
        }
    }
    
    private func addDeleteSectionSetup(){
        addDeleteSegment.setEnabled(false, forSegment: 1)
        addDeleteSegment.action = #selector(addDeletePatient(_:))
        progressStack.isHidden = true
        refreshIntervalStack.isHidden = false
    }
    
    private func filterPatients() {
        // Handle button click event here
        var allFilters: [TestType] = []
        for subview in testTypeFilterStack.arrangedSubviews {
            if let checkbox = subview as? NSButton{
                let isChecked = checkbox.state == .on
                if isChecked, let test = TestType.allCases.first(where: { $0.rawValue == checkbox.tag}) {
                    allFilters.append(test)
                }
                
            }
        }
        patientViewModel.testsFilter(allFilters, nigative: negativeFilterSwitch.state == .on)
        refreshTableView()
    }
}

extension ViewController: AddPatientViewControllerDelegate {
    func didReceiveData(_ patient: Patient) {
        patientViewModel.addPatient(patient)
    }
}

extension ViewController: CustomCellDelegate{
    func updatePatient(newName: String, index: Int) {
        patientViewModel.updateName(newValue: newName, at: index)
    }
    
    
}
extension ViewController: CustomCellDatasource{
    func getRowNumberForTextField(textFiled: NSTextField) -> Int {
        return tableView.row(for: textFiled)
    }
}
