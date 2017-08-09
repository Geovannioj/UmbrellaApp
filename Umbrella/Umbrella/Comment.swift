//
//  Comment.swift
//  Umbrella
//
//  Created by Geovanni Oliveira de Jesus on 08/08/17.
//  Copyright © 2017 Geovanni Oliveira de Jesus. All rights reserved.
//

import Foundation

class Comment {
    
    var commentId : String
    var content : String
    var reportId : String
    var userId : String
    //colocar imagem do usuário que inseriu o comentário
    
    init(commentId : String, content : String, reportId : String, userId : String) {
        self.commentId = commentId
        self.content = content
        self.reportId = reportId
        self.userId = userId
    }
    
    func turnToDictionary() -> Any {
        
        return ["commentId" : commentId,
                "content" : content,
                "reportId" : reportId,
                "userId" : userId
        ]
    }
}
