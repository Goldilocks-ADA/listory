//
//  Photo+CoreDataProperties.swift
//  
//
//  Created by Devi Mandasari on 15/11/20.
//
//

import Foundation
import CoreData


extension Photo {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Photo> {
        return NSFetchRequest<Photo>(entityName: "Photo")
    }

    @NSManaged public var name: String?
    @NSManaged public var id: String?
    @NSManaged public var image: Data?

}
