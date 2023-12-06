//
//  Note.swift
//  MemoirMix
//
//  Created by Tharun on 23/11/23.
//

import Foundation
import CoreData

@objc(Note)
public class Note: NSManagedObject{
    @NSManaged var id: NSNumber!
    @NSManaged var title: String!
    @NSManaged var desc: String!
    @NSManaged var sentiment: String!
    @NSManaged var username: String!
    @NSManaged var dateAdded: Date?
    @NSManaged var deletedDate: Date?
}
