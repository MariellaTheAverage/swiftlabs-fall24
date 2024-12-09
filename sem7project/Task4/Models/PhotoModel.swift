//
//  PhotoModel.swift
//  sem7project
//
//  Created by Mary Grishchenko on 18.09.2024.
//

import Foundation
import SwiftUI

struct PhotoTag: Identifiable, Codable {
    var id: Int
    var Name: String
}

struct Photo: Identifiable, Codable {
    var id: Int
    var FileURL: URL
    var Name: String
    var Description: String
    var Tags: [PhotoTag]
    
    init(pid: Int, sURL: URL, name: String?, desc: String?, tags: [PhotoTag]) {
        self.id = pid
        self.FileURL = sURL
        self.Name = name ?? ""
        self.Description = desc ?? ""
        self.Tags = []
        tags.forEach {
            self.Tags.append($0)
        }
    }
    
    init(tmplt: tempPhoto, pid: Int) {
        self.id = pid
        self.FileURL = tmplt.fileURL
        self.Name = tmplt.Name
        self.Description = tmplt.Description
        self.Tags = tmplt.Tags
    }
}

struct tempPhoto {
    var fileURL: URL
    var Name: String
    var Description: String
    var Tags: [PhotoTag]
    
    init(fileURL: URL, Name: String?, Description: String?, Tags: [PhotoTag]) {
        self.fileURL = fileURL
        self.Name = Name ?? ""
        self.Description = Description ?? ""
        self.Tags = []
        Tags.forEach {
            self.Tags.append($0)
        }
    }
}
