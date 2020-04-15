//
//  Terms.swift
//  toget-test
//
//  Created by Michael Hamm on 3/26/20.
//  Copyright © 2020 Michael Hamm. All rights reserved.
//

import UIKit
import WebKit
import PDFKit

class Terms: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let pdfView = PDFView(frame: self.view.bounds)
        pdfView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        self.view.addSubview(pdfView)
        
        pdfView.autoScales = true
        
        let fileURL = Bundle.main.url(forResource: "2Get_Terms_&_Conditions", withExtension: "pdf")
        pdfView.document = PDFDocument(url: fileURL!)
    }
    
}
