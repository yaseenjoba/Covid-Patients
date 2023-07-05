//
//  DetailsView.swift
//  Covid Patients
//
//  Created by Yassen Joba on 05/07/2023.
//

import Cocoa
import AppCommonComponents

class DetailsView: NSView, NibLoadable {

    var name: String = ""{
        didSet{
            patientName.stringValue = name
        }
    }
    
    @IBOutlet weak var patientName: NSTextField!
    
    override func draw(_ dirtyRect: NSRect) {
        super.draw(dirtyRect)

        // Drawing code here.
    }
    
    @IBAction func CloseWindow(_ sender: NSButton) {
        window?.close()
    }
}
