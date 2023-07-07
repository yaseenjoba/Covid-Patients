//
//  CustomCell.swift
//  Covid Patients
//
//  Created by Yassen Joba on 02/07/2023.
//

import Cocoa
protocol CustomCellDelegate: AnyObject {
    
    func updatePatient(newName: String, index: Int)
}
protocol CustomCellDatasource: AnyObject {
    
    func getRowNumberForTextField(textFiled: NSTextField) -> Int
}
class CustomCell: NSTableCellView, NSTextFieldDelegate {
    // MARK: - Public properties
    var delegate: CustomCellDelegate?
    var datasource: CustomCellDatasource?
    // MARK: - IBOutlets
    @IBOutlet weak var image: NSImageView!
    // MARK: - Life Cycle
    @IBOutlet weak var text: NSTextField!
    
    override func draw(_ dirtyRect: NSRect) {
        super.draw(dirtyRect)
        // Drawing code here.
    }
    // MARK: - Public functions
    func nameCellSetup(patient: Patient) {
        self.text.stringValue = patient.name
        let positveImage = NSImage(imageLiteralResourceName: "positive")
        let negativeImage = NSImage(imageLiteralResourceName: "negative")
        self.image.image = patient.testStatus == .positve ? positveImage : negativeImage
        self.text.isEditable = true
        self.text.delegate = self
        self.text.maximumNumberOfLines = 0 // Allow multiple lines
    }
    
    func typeCellSetup(patient: Patient) {
        self.text.stringValue = patient.testType.shortText
        self.image.isHidden = true
    }
    
    func statusCellSetup(patient: Patient) {
        var testStatusString = ""
        testStatusString = patient.testStatus.text
        if let days = patient.daysOfSymptoms {
            if patient.testStatus == .positve {
                testStatusString += " (\(days) days)"
            }
        }
        self.text.stringValue = testStatusString
        self.image.isHidden = true
    }
    
    func controlTextDidEndEditing(_ obj: Notification) {
        if let textField = obj.object as? NSTextField {
            let row = datasource?.getRowNumberForTextField(textFiled: textField)
            guard let index = row, index >= 0 else {
                return
            }
            delegate?.updatePatient(newName: textField.stringValue, index: index)
        }
    }
}
