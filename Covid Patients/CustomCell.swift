//
//  CustomCell.swift
//  Covid Patients
//
//  Created by Yassen Joba on 02/07/2023.
//

import Cocoa
protocol CustomCellDelegate: AnyObject{
    // FIXME: - should be a sender
    // FIXME: - name should be customCell(_ sender: CustomCell, didUpdatePatient newName: String, at index: Int)
    func updatePatient(newName: String, index: Int)
}
protocol CustomCellDatasource: AnyObject{
    
    // FIXME: - why is this needed,
    // FIXME: - sender should be cell not textField
    // FIXME: - should use better names, shouldn't not indicate which element is requesting the info is required in the cell itself
    func getRowNumberForTextField(textFiled: NSTextField) -> Int
}

// FIXME: - should do a better cell naming
// FIXME: - protocl conforming should be done in a seperate extension
class CustomCell: NSTableCellView, NSTextFieldDelegate {
    // MARK: - Public properties
    var delegate: CustomCellDelegate?
    var datasource: CustomCellDatasource?
    // MARK: - IBOutlets
    @IBOutlet weak var image: NSImageView!
    // MARK: - Life Cycle
    // FIXME: - this is not lifeCycle,
    // FIXME: - byDefault cell has textField and imageView no need to readd them
    @IBOutlet weak var text: NSTextField!
    
    // FIXME: - not used functions should be removed
    override func draw(_ dirtyRect: NSRect) {
        super.draw(dirtyRect)
        // Drawing code here.
    }
    // MARK: - Public functions
    func nameCellSetup(patient: Patient){
        // FIXME: - good use of name setup
        // FIXME: - should use better name, just setup and maybe create an enum for cellTypes
        self.text.stringValue = patient.name
        self.image.image = patient.testStatus == .positve ? NSImage(named: "positive"):  NSImage(named: "negative")
        // FIXME: - setup should include data specific info, view setup should be moved to a more genric function in the life cycle awakeFromNib
        self.text.isEditable = true
        self.text.delegate = self
        self.text.maximumNumberOfLines = 0 // Allow multiple lines
    }
    
    func typeCellSetup(patient: Patient) {
        self.text.stringValue = patient.testType.shortText
        self.image.isHidden = true
    }
    
    func statusCellSetup(patient: Patient){
        var testStatusString = ""
        testStatusString = patient.testStatus.text
        if let days = patient.daysOfSymptoms{
            if patient.testStatus == .positve{
                testStatusString = testStatusString + " (\(days) days)"
            }
        }
        self.text.stringValue = testStatusString
        self.image.isHidden = true
    }
    
    // FIXME: - should place delegate code in a seperate extension
    func controlTextDidEndEditing(_ obj: Notification) {
        if let textField = obj.object as? NSTextField {
            // FIXME: - cell info like rowIndex should be part of setup
            // FIXME: - shoud use patient id to indicate where the change happened
            let row = datasource?.getRowNumberForTextField(textFiled: textField)
            guard let index = row ,  index >= 0 else {
                return
            }
            delegate?.updatePatient(newName: textField.stringValue , index: index)
        }
    }
    
    
}
