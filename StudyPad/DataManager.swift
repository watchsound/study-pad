//
//  DataManager.swift
//  StudyPad
//
//  Created by Hanning Ni on 7/31/15.
//  Copyright (c) 2015 Hanning Ni. All rights reserved.
//

import Foundation

public class DataManager {
    
    //通过关键字static来保存实例引用
    private static let instance = DataManager()
    
    //私有化构造方法
    private init() {
    }
    
    //提供静态访问方法
    public static var shared: DataManager {
        return self.instance
    }
    
    public func tryToPopulateDatabaseFromAssets() -> Void{
        if  R9Properties.shared.getAppStatus() > 0 { return };
        R9Properties.shared.setAppStatus(1);
        
        var metaData : [LearningUnit] = tryToReadLearningUnitsFromAssets()
        
        var conceptSet : Set<String> = Set<String>()
        for unit in metaData {
            conceptSet.insert( unit.getFirstStudyPoint().conceptName )
        }
        var summary : String = ""
        for name in conceptSet  {
            summary = summary + " | " + name
        }
        R9Properties.shared.setSummary(summary)
        
        R9DBConnectionManager.shared.populateLearningUnitsFromAssets( metaData )
    }
    
    public func tryToReadLearningUnitsFromAssets() -> [LearningUnit]{
        var result : [LearningUnit] = []
        var dataPath : String = NSBundle.mainBundle().resourcePath!
        dataPath = dataPath.stringByAppendingPathComponent("r9data");
        
        var dirList : [AnyObject] = NSFileManager.defaultManager().contentsOfDirectoryAtPath(dataPath, error: nil)!
        var file : AnyObject;
        for   file in dirList {
            var filename : String = file as! String
            var isDir : Bool = false
            var pathForMetaFile = dataPath.stringByAppendingPathComponent(filename).stringByAppendingPathComponent("learningunit.json")
            
           if  NSFileManager.defaultManager().fileExistsAtPath(pathForMetaFile)  {
            //reading
                let metaData = NSData(contentsOfFile: pathForMetaFile, options: .DataReadingMappedIfSafe, error: nil)
               // let metaData = String(contentsOfFile: pathForMetaFile, encoding: NSUTF8StringEncoding, error: nil)
                let json = JSON(data: metaData!)
                var learningUnit  =  LearningUnit()
                learningUnit.uuid = json["id"].stringValue
                learningUnit.name = json["name"].stringValue
                learningUnit.description = json["description"].stringValue
                learningUnit.chapter = json["chapter"].stringValue
                learningUnit.chapterNumber = json["chapterOrder"].intValue
                learningUnit.inChapterNumber = json["inChapterOrder"].intValue
                learningUnit.folderName = filename
                learningUnit.fromSource = 0
                var sp = StudyPoint();
                if let sp1 = json["studyPoints"][0]["conceptName"].string {
                    sp.conceptName = sp1
                    sp.difficultLevel =  json["studyPoints"][0]["difficultLevel"].intValue
                 }
                 learningUnit.studyPoints.append(sp)
                 result.append(learningUnit);
            }
        }
        return result
    }
    
    public func getPathForLearningUnitInAssets(learningUnitFolderName:String ) -> String {
        return NSBundle.mainBundle().resourcePath!.stringByAppendingPathComponent("r9data")
            .stringByAppendingPathComponent(learningUnitFolderName)
    }
    
    public func loadImageIconForLearningUnit(learningUnitFolderName:String) -> UIImage? {
        var dataPath : String = getPathForLearningUnitInAssets(learningUnitFolderName)
            .stringByAppendingPathComponent("r9icon.png")
        
        if  NSFileManager.defaultManager().fileExistsAtPath(dataPath)  {
            return UIImage(contentsOfFile: dataPath)!;
        } else {
            return nil
        }
    
    }
   
}