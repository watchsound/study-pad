//
//  R9DBConnectionManager.swift
//  StudyPad
//
//  Created by Hanning Ni on 8/1/15.
//  Copyright (c) 2015 Hanning Ni. All rights reserved.
//

import Foundation


public class R9DBConnectionManager {
    
    //通过关键字static来保存实例引用
    private static let instance = R9DBConnectionManager()
    
    //私有化构造方法
    private init() {
    }
    
    //提供静态访问方法
    public static var shared: R9DBConnectionManager {
        return self.instance
    }

//    public func createEditableCopyOfDatabaseIfNeeded( dbName : String ){
//     
//        var success : Bool;
//        var fileManager = NSFileManager.defaultManager()
//        var error : NSError
//        var path  = NSSearchPathForDirectoriesInDomains(NSSearchPathDirectory.DocumentDirectory, NSSearchPathDomainMask.UserDomainMask, true);
//        var documentsDirectory = path[0]
//        var writableDBPath = documentsDirectory.stringByAppendingPathComponent(dbName)
//        success = fileManager.fileExistsAtPath(writableDBPath)
//        if (success) { return; }
//        
//        var defaultDBPath = NSBundle.mainBundle().resourcePath?.stringByAppendingPathComponent(dbName)
//        success = fileManager.copyItemAtPath(defaultDBPath!, toPath: writableDBPath, error: nil)
//        if (!success) {
//            //?
//        }
//    }
    
    public func getDatabase() -> Database {
   
        let path = NSSearchPathForDirectoriesInDomains(
                .DocumentDirectory, .UserDomainMask, true
                ).first as! String
    
        var db : Database =  Database("\(path)/db.sqlite3")
        
        db.execute(
            "CREATE TABLE IF NOT EXISTS \"learning_units\" (" +
                "unit_id integer primary key autoincrement, " +
            "uuid varchar(64), " +
            "folder_name text, " +
            "from_source integer, " +
            "name text, " +
            "description text, " +
            "chapter text, " +
            "chapter_number integer, " +
            "concept_name text, " +
            "in_chapter_number integer, " +
            "difficult_level integer, " +
            "bookmarked integer, " +
            "notes text " +
            ")"
        )
        
         //event_status : 0 : open  1: pause : 2 : close
        
        db.execute(
            "CREATE TABLE IF NOT EXISTS \"study_events\" (" +
                "event_id integer primary key autoincrement, " +
                "event_name varchar(64), " +
            "event_day float, " +
            "event_start float, " +
            "event_end  float, " +
            "event_type integer, " +
            "event_status integer, " +
            "learning_unit_id integer, " +
                "FOREIGN KEY(learning_unit_id) REFERENCES learning_units(unit_id) " +
            ")"
        )
        
        return db
    }
    
//    var unitId : Int = 0
//    var uuid : String?
//    var name : String?
//    var description : String?
//    var studyPoints : [StudyPoint] = []
//    var folderName : String?
//    var fromSource : Int = 0   //assets : 0
//    var bookmarked : Bool = false
    
    public func populateLearningUnitsFromAssets(learningUnits :NSArray)->Void {
        let db : Database = getDatabase()
        let learning_units_tb : Query = db["learning_units"]
        let unit_id = Expression<Int64>("unit_id")
        let uuid = Expression<String>("uuid")
         let folder_name = Expression<String>("folder_name")
         let from_source = Expression<Int>("from_source")
         let name = Expression<String>("name")
          let description = Expression<String>("description")
          let chapter = Expression<String>("chapter")
         let chapter_number = Expression<Int>("chapter_number")
         let in_chapter_number = Expression<Int>("in_chapter_number")
        let concept_name = Expression<String>("concept_name")
        let difficult_level = Expression<Int>("difficult_level")
        let bookmarked = Expression<Int>("bookmarked")
        let notes = Expression<String>("notes")
       
        
        var unit : AnyObject
        for  unit in learningUnits {
             var lunit : LearningUnit = unit as! LearningUnit
             var studyPoint = lunit.studyPoints[0]
             var _unit_id = lunit.uuid
            var _folder_name = lunit.folderName
            var _from_source = lunit.fromSource
            var _name = lunit.name
            var _description = lunit.description
               var _chapter = lunit.chapter
            var _chapter_number = lunit.chapterNumber
            var _in_chapter_number = lunit.inChapterNumber
            var _concept_name = studyPoint.conceptName
            
            var _difficult_level = studyPoint.difficultLevel
            var _bookmarked = lunit.bookmarked
            var _notes = lunit.notes
            
           
            
            let jr :Statement = db.prepare( "INSERT INTO learning_units (uuid, folder_name, from_source, name, description, chapter, chapter_number, concept_name, in_chapter_number, difficult_level, bookmarked, notes ) VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)" )
            jr.run( _unit_id, _folder_name, _from_source, _name, _description, _chapter, _chapter_number, _concept_name, _in_chapter_number, _difficult_level, _bookmarked, _notes)
            
//            learning_units_tb.insert(
//                unit_id <- _unit_id,
//                folder_name <- _folder_name )
//                from_source <- _from_source,
//                name <- _name,
//                description <- _description,
//                concept_name <- _concept_name,
//                difficult_level <- _difficult_level,
//                bookmarked <- _bookmarked)
        }
    }
    
    public func getLearingUnitById(_unitId :Int64)-> LearningUnit? {
        let db : Database = getDatabase()
        let learning_units_tb : Query = db["learning_units"]
        let unit_id = Expression<Int64>("unit_id")
        
        
        let updaterow = learning_units_tb.filter(unit_id == _unitId)
        
        for row in updaterow {
            return mapQueryRowToLearningUnit( row )
        }
        
        return nil
    }
    
    
    public func bookmarkLearningUnit(learningUnits :LearningUnit, bookmarkIt :Bool )->Void {
        let db : Database = getDatabase()
        let learning_units_tb : Query = db["learning_units"]
        let unit_id = Expression<Int64>("unit_id")
 
        let bookmarked = Expression<Int>("bookmarked")
      
        let updaterow = learning_units_tb.filter(unit_id == learningUnits.unitId)
        if bookmarkIt {
            updaterow.update( bookmarked <- 1)
            learningUnits.bookmarked = 1
        } else {
             updaterow.update( bookmarked <- 0)
            learningUnits.bookmarked = 0
        }
    }
    
    public func mapQueryRowToLearningUnit( learningunit_row :Row ) -> LearningUnit{
        let unit_id = Expression<Int64>("unit_id")
        let uuid = Expression<String>("uuid")
        let folder_name = Expression<String>("folder_name")
        let from_source = Expression<Int>("from_source")
        let name = Expression<String>("name")
        let description = Expression<String>("description")
        let chapter = Expression<String>("chapter")
        let chapter_number = Expression<Int>("chapter_number")
         let in_chapter_number = Expression<Int>("in_chapter_number")
        let concept_name = Expression<String>("concept_name")
        let difficult_level = Expression<Int>("difficult_level")
        let bookmarked = Expression<Int>("bookmarked")
        let notes = Expression<String>("notes")
        
            var learningUnit : LearningUnit = LearningUnit()
            learningUnit.unitId  = learningunit_row[unit_id]
            learningUnit.uuid  = learningunit_row[uuid]
            learningUnit.folderName  = learningunit_row[folder_name]
            learningUnit.fromSource  = learningunit_row[from_source]
            learningUnit.name  = learningunit_row[name]
            learningUnit.description  = learningunit_row[description]
            learningUnit.chapter  = learningunit_row[chapter]
            learningUnit.chapterNumber  = learningunit_row[chapter_number]
          learningUnit.inChapterNumber  = learningunit_row[in_chapter_number]
            var sp:StudyPoint = learningUnit.getFirstStudyPoint()
            sp.conceptName  = learningunit_row[concept_name]
            sp.difficultLevel  = learningunit_row[difficult_level]
            learningUnit.bookmarked  = learningunit_row[bookmarked]
            learningUnit.notes  = learningunit_row[notes]
        
        return learningUnit
    }
    
    public func addNotesToLearningUnit(learningUnits :LearningUnit, note : String)->Void {
        let db : Database = getDatabase()
        let learning_units_tb : Query = db["learning_units"]
        let unit_id = Expression<Int64>("unit_id")
        
        let _notes = Expression<String>("notes")
        
        let updaterow = learning_units_tb.filter(unit_id == learningUnits.unitId)
        updaterow.update( _notes <- note)
        
        learningUnits.notes = note;
    }
    
    
    public func populateLearningUnitsFromDatabase( )->[LearningUnit] {
        let db : Database = getDatabase()
        let learning_units_tb : Query = db["learning_units"]
       
        var result : [LearningUnit] = []
        for learningunit_row  in learning_units_tb {
            let row =  mapQueryRowToLearningUnit( learningunit_row )
            result.append( row )
        }
        return result
        
//        let unit_id = Expression<Int64>("unit_id")
//        let uuid = Expression<String>("uuid")
//        let folder_name = Expression<String>("folder_name")
//        let from_source = Expression<Int>("from_source")
//        let name = Expression<String>("name")
//        let description = Expression<String>("description")
//        let chapter = Expression<String>("chapter")
//         let chapter_number = Expression<Int>("chapter_number")
//        let concept_name = Expression<String>("concept_name")
//        let difficult_level = Expression<Int>("difficult_level")
//        let bookmarked = Expression<Int>("bookmarked")
//        let notes = Expression<String>("notes")
//        
//        var result : [LearningUnit] = []
//        
//        for learningunit_row  in learning_units_tb {
//            var learningUnit : LearningUnit = LearningUnit()
//            learningUnit.unitId  = learningunit_row[unit_id]
//            learningUnit.uuid  = learningunit_row[uuid]
//            learningUnit.folderName  = learningunit_row[folder_name]
//            learningUnit.fromSource  = learningunit_row[from_source]
//            learningUnit.name  = learningunit_row[name]
//            learningUnit.description  = learningunit_row[description]
//            learningUnit.chapter  = learningunit_row[chapter]
//            learningUnit.chapterNumber  = learningunit_row[chapter_number]
//            var sp:StudyPoint = learningUnit.getFirstStudyPoint()
//            sp.conceptName  = learningunit_row[concept_name]
//            sp.difficultLevel  = learningunit_row[difficult_level]
//            learningUnit.bookmarked  = learningunit_row[bookmarked]
//            learningUnit.notes  = learningunit_row[notes]
//            result.append(learningUnit)
//        }
        return result
    }
    
//    "event_id integer primary key autoincrement, " +
//    "event_name varchar(64), " +
//    "event_day date, " +
//    "event_start datetime, " +
//    "event_end  datetime, " +
//    "event_type integer, " +
    
    public func populateLearningEventsFromDatabase( )->[StudyEvent] {
        let db : Database = getDatabase()
        let study_events_db : Query = db["study_events"]
        let event_id = Expression<Int64>("event_id")
        let event_name = Expression<String>("event_name")
        let event_day = Expression<Double>("event_day")
        let event_start = Expression<Double>("event_start")
        let event_end = Expression<Double>("event_end")
        let event_type = Expression<Int>("event_type")
        let event_status = Expression<Int>("event_status")
        
        var result : [StudyEvent] = []
        
        for event_row  in study_events_db {
            var studyEvent = populateStudyEventFromQuery( event_row )
            result.append(studyEvent)
        }
        return result
    }
    
    public func populateStudyEventFromQuery(event_row : Row) -> StudyEvent {
       
        let event_id = Expression<Int64>("event_id")
        let event_name = Expression<String>("event_name")
        let event_day = Expression<Double>("event_day")
        let event_start = Expression<Double>("event_start")
        let event_end = Expression<Double>("event_end")
        let event_type = Expression<Int>("event_type")
        let event_status = Expression<Int>("event_status")
        
        var studyEvent : StudyEvent = StudyEvent()
        
        
            studyEvent.eventId  = event_row[event_id]
            studyEvent.eventName  = event_row[event_name]
            studyEvent.eventDay  = NSDate(timeIntervalSince1970: event_row[event_day] as NSTimeInterval)
            studyEvent.eventStart  =  NSDate(timeIntervalSince1970: event_row[event_start] as NSTimeInterval)
            studyEvent.eventEnd  = NSDate(timeIntervalSince1970: event_row[event_end] as NSTimeInterval)
        
        
        
           studyEvent.eventType  = event_row[event_type]
            studyEvent.eventStatus  = event_row[event_status]
        
        
        return studyEvent
    }

    public func markStudyEventStart(eventName : String, eventType : Int, learningUnitId : Int64 ) -> StudyEvent{
        var event : StudyEvent = StudyEvent()
        event.eventName = eventName
        event.learningUnitId = learningUnitId
        var year = NSDate.componentsOfCurrentDate().year
        var month = NSDate.componentsOfCurrentDate().month
        var day = NSDate.componentsOfCurrentDate().day  
        var time = NSDate(year: year, month: month, day: day )
        event.eventDay = time
        event.eventStart = NSDate()
        event.eventEnd = NSDate()
        
        addStudyEvent( event, learningUnitId: learningUnitId)
        
        return event;
    }
    
    public func addStudyEvent(event :StudyEvent, learningUnitId : Int64)->Void {
        let db : Database = getDatabase()
         let study_events_db : Query = db["study_events"]
        
        let event_name = event.eventName
        let event_day = event.eventDay.timeIntervalSince1970
        let event_start = event.eventStart.timeIntervalSince1970
        let event_end = event.eventEnd.timeIntervalSince1970
        let event_type = event.eventType
        let event_status = event.eventStatus
        
        
        
        let jr :Statement = db.prepare( "INSERT INTO study_events ( event_name, event_day, event_start, event_end, event_type, event_status, learning_unit_id ) VALUES ( ?, ?, ?, ?, ?, ?, ?)" )
        jr.run(  event_name, event_day, event_start, event_end, event_type, event_status, learningUnitId)
        
    }
    
    
    
    public func getLatestsStudyEvent()-> StudyEvent {
        let db : Database = getDatabase()
        let study_events_db : Query = db["study_events"]
         let event_id = Expression<Int64>("event_id")
       // let event_end = Expression<Double>("event_end")
        
        let max = db.scalar( "SELECT MAX(event_id) FROM study_events" )
        if  max == nil   {
           return StudyEvent()
        }
         let maxV = max   as! Int64
        
        var  updaterow = study_events_db.filter(event_id == maxV)
        for arow in updaterow {
            return populateStudyEventFromQuery(arow)
        }
        return StudyEvent()
    }
    
    public func closeLatestStudyEvent() -> Bool {
        var event = getLatestsStudyEvent();
        if  ( event.eventId == 0  ){
            return false
        }
        if ( event.eventStatus == 2 ){  //closed
            return false
        }
        
        let db : Database = getDatabase()
        let study_events_db : Query = db["study_events"]
        let event_id = Expression<Int64>("event_id")
        let event_end = Expression<Double>("event_end")
         let event_status = Expression<Int>("event_status")
        
         var  updaterow = study_events_db.filter(event_id == event.eventId)
        updaterow.update( event_end <- NSDate().timeIntervalSince1970, event_status <- 2 )
        
        var timeUsed = event.eventEnd.timeIntervalSince1970 - event.eventStart.timeIntervalSince1970
        
        R9Properties.shared.addStudyTtime( timeUsed )
        
        return true
    }
    
    public func pauseLatestStudyEvent() -> Bool {
        var event = getLatestsStudyEvent();
        if  ( event.eventId == 0  ){
            return false
        }
        if ( event.eventStatus == 2 ){  //closed
            return false
        }
        
        let db : Database = getDatabase()
        let study_events_db : Query = db["study_events"]
        let event_id = Expression<Int64>("event_id")
        let event_end = Expression<Double>("event_end")
        let event_status = Expression<Int>("event_status")
        
        var  updaterow = study_events_db.filter(event_id == event.eventId)
        updaterow.update( event_end <- NSDate().timeIntervalSince1970, event_status <- 1 )
        return true
    }
    
    public func resumeLatestStudyEvent() -> Bool {
        var event = getLatestsStudyEvent();
        if  ( event.eventId == 0  ){
            return false
        }
        if ( event.eventStatus == 2 ){  //closed
            return false
        }
       
        
        let db : Database = getDatabase()
        let study_events_db : Query = db["study_events"]
        let event_id = Expression<Int64>("event_id")
        let event_end = Expression<Double>("event_end")
        let event_status = Expression<Int>("event_status")
        
        let time = NSDate()
        //if pause more than 1 minute, treat it as new event
        if ( time.timeIntervalSince1970 - event.eventStart.timeIntervalSince1970 > 60 ){
            var  updaterow = study_events_db.filter(event_id == event.eventId)
            updaterow.update( event_end <- NSDate().timeIntervalSince1970, event_status <- 2 )
            var timeUsed = NSDate().timeIntervalSince1970 - event.eventStart.timeIntervalSince1970
            
            R9Properties.shared.addStudyTtime( timeUsed )
            
            markStudyEventStart(event.eventName, eventType: event.eventType, learningUnitId : event.learningUnitId )
        }
        else {
            //do nothing?
        }
       
        return true
    }
}