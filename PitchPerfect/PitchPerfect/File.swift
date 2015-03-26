//
//  File.swift
//  PitchPerfect
//
//  Created by Angel Contreras on 3/10/15.
//  Copyright (c) 2015 Angel Contreras. All rights reserved.
//

import Foundation

class RecordedAudio: NSObject {
    var filePathUrl: NSURL!
    var title: String!
    init(filePathUrl:NSURL, title: String) {
        self.filePathUrl = filePathUrl
        self.title  = title
    }
}