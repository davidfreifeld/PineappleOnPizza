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
    @Persisted var status: Status
    @Persisted var code: String
    @Persisted var users: List<String>
    
    var totalVotes: Int {
        self.answers.reduce(0, { runningSum, nextAnswer in
            runningSum + nextAnswer.currentVotes
        })
    }
    
    var areAllPredictionsIn: Bool {
        for user in users {
            if !self.answers[0].predictions.contains(where: { $0.user_id == user }) {
                return false
            }
        }
        return true
    }
    
    var userHasPrediction: Bool {
        self.answers.first!.predictions.contains(where: { $0.user_id == app.currentUser?.id })
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

