//
//  GalleryFoto+CoreDataProperties.swift
//  
//
//  Created by Jogi Oktavianus on 02/11/20.
//
//

import Foundation
import CoreData


extension GalleryFoto {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<GalleryFoto> {
        return NSFetchRequest<GalleryFoto>(entityName: "GalleryFoto")
    }

    @NSManaged public var image: Data?
    @NSManaged public var isWithAudio: Bool
    @NSManaged public var name: String?

}
