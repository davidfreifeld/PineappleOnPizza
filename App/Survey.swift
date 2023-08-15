//
//  Survey.swift
//  PineappleOnPizza
//
//  Created by David Freifeld on 8/11/23.
//

import RealmSwift

class Survey: Object, ObjectKeyIdentifiable {
    @Persisted(primaryKey: true) var _id: ObjectId
    @Persisted var owner_id: String
    @Persisted var questionText: String
    @Persisted var answers: List<Answer>
    @Persisted var isComplete = false
    @Persisted var code: String
    @Persisted var users: List<String>
    
    var totalVotes: Int {
        self.answers.reduce(0, { runningSum, nextAnswer in
            runningSum + nextAnswer.currentVotes
        })
    }
}

class Answer: EmbeddedObject, ObjectKeyIdentifiable {
    @Persisted var answerText: String
    @Persisted var currentVotes: Int
    @Persisted var predictions: List<Prediction>
}

class Prediction: EmbeddedObject, ObjectKeyIdentifiable {
    @Persisted var user_id: String
    @Persisted var predictionValue: Double
}
