//
//  LearningUnitDetailViewController.swift
//  StudyPad
//
//  Created by Hanning Ni on 8/5/15.
//  Copyright (c) 2015 Hanning Ni. All rights reserved.
//

import Foundation
import UIKit

class LearningUnitDetailViewController : UIViewController{
    
    
    @IBOutlet weak var nameLabel: UILabel!
    
    @IBOutlet weak var conceptLabel: UILabel!
    
    @IBOutlet weak var descriptionLabel: UILabel!
    
    var _learningUnit: LearningUnit?;
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if (_learningUnit != nil) {
            nameLabel.text = _learningUnit?.name
            conceptLabel.text = _learningUnit?.getFirstStudyPoint().description()
            descriptionLabel.text = _learningUnit?.description
        }
    }
    
    
    func setLearningUnit(learningUnit: LearningUnit) {
        _learningUnit = learningUnit;
        
    }
         
}
