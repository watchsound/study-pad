//
//  LearningUnit.swift
//  StudyPad
//
//  Created by Hanning Ni on 7/31/15.
//  Copyright (c) 2015 Hanning Ni. All rights reserved.
//

import Foundation

public class StudyPoint {
    var conceptId : String?
    var conceptName : String = ""
    var difficultLevel : Int = 1
    
    public func description() -> String {
        return  "\(conceptName)(\(difficultLevel))"
    }
}

public class LearningUnit {
    var unitId : Int64 = 0
    var uuid : String = ""
    var name : String = ""
    var chapter : String = ""
     var chapterNumber : Int = 0
    var inChapterNumber : Int = 0

    var description : String = ""
    var studyPoints : [StudyPoint] = []
    var folderName : String = ""
    var fromSource : Int = 0   //assets : 0
    var bookmarked : Int = 0
    var notes :String = ""
    
    public func getFirstStudyPoint() -> StudyPoint {
        if studyPoints.count == 0 {
            studyPoints.append( StudyPoint() )
        }
        return studyPoints[0];
    }
  
}

public class Chapter {
    var chapterName : String = ""
    var chapterOrder : Int = 0;
    var learningUnit : [LearningUnit] = []
    
}


public class StudyEvent {
    var  eventId : Int64 = 0
    var eventName : String = ""
    var eventDay : NSDate = NSDate()
    var eventStart : NSDate = NSDate()
    var eventEnd  : NSDate = NSDate()
    var eventType : Int = 0
    var eventStatus : Int = 0
    var learningUnitId : Int64 = 0
}

