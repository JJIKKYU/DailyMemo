//
//  DiaryReplayModel.swift
//  Menual
//
//  Created by 정진균 on 2022/06/05.
//

import Foundation
import RealmSwift

// MARK: - Realm에 저장하기 위한 Class
public class DiaryReplyModelRealm: EmbeddedObject {
    @Persisted var uuid: String = ""
    @Persisted var replyNum: Int
    @Persisted var diaryUuid: String
    @Persisted var desc: String
    @Persisted var createdAt: Date
    @Persisted var isDeleted: Bool
    
    convenience init(uuid: String, replyNum: Int, diaryUuid: String, desc: String, createdAt: Date, isDeleted: Bool) {
        self.init()
        self.uuid = uuid
        self.replyNum = replyNum
        self.diaryUuid = diaryUuid
        self.desc = desc
        self.createdAt = createdAt
        self.isDeleted = isDeleted
    }
    
    func updateReplyNum(replyNum: Int) {
        self.replyNum = replyNum + 1
    }
}
