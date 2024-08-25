//
//  NoteEditorViewController.swift
//  StudyPad
//
//  Created by Hanning Ni on 8/4/15.
//  Copyright (c) 2015 Hanning Ni. All rights reserved.
//

import Foundation
import UIKit

extension String {
    var html2AttributedString:NSAttributedString {
        return NSAttributedString(data: dataUsingEncoding(NSUTF8StringEncoding)!, options:[NSDocumentTypeDocumentAttribute:NSHTMLTextDocumentType, NSCharacterEncodingDocumentAttribute: NSUTF8StringEncoding], documentAttributes: nil, error: nil)!
    }
}


class NoteEditorViewController : UIViewController, RichTextEditorDataSource{
    
    @IBOutlet weak var noteEditor: RichTextEditor!
    
    @IBOutlet weak var saveButton: UIButton!
    var _learningUnit: LearningUnit?;
    
    weak var popover : UIPopoverController?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if (_learningUnit != nil) {
            noteEditor.attributedText = _learningUnit!.notes.html2AttributedString 
        }
    }
    
    @IBAction func saveButtonClicked(sender: AnyObject) {
        R9DBConnectionManager.shared.addNotesToLearningUnit(_learningUnit!, note: noteEditor.htmlString())
        if (popover != nil) {
            popover?.dismissPopoverAnimated(true)
        }
        
    }
    
    func setLearningUnit(learningUnit: LearningUnit) {
        _learningUnit = learningUnit;
        
    }
    
    func featuresEnabledForRichTextEditor(richTextEditor:RichTextEditor) -> RichTextEditorFeature{
        
        return  RichTextEditorFeatureAll;
    }
    
    
}
