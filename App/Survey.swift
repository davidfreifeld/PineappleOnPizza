//
//  Survey.swift
//  PineappleOnPizza
//
//  Created by David Freifeld on 8/11/23.
//

import Foundation
import RealmSwift

class Survey: Object, ObjectKeyIdentifiable {
    @Persisted(primaryKey: true) var _id: ObjectId
    @Persisted var owner_id: String
    @Persisted var questionText: String
    @Persisted var answers: List<Answer>
    @Persisted var status: Status
    @Persisted var code: String
    @Persisted var users: List<String>
    @Persisted var minVotes: Int
    
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
    
    func getUserFinalScore(user_id: String) -> Double {
        var totalError = 0.0
        for answer in self.answers {
            let userPrediction = answer.predictions.first(where: { $0.user_id == user_id })!.predictionValue
            let actualScore = (Double(answer.currentVotes) / Double(self.totalVotes) * 100).rounded()
            totalError += pow((userPrediction - actualScore), 2)
        }
        return sqrt(totalError)
    }
    
    func getFinalScoresSortedUserList() -> [String] {
        var resultsDict = [String: Double]()
        for user_id in self.users {
            resultsDict[user_id] = getUserFinalScore(user_id: user_id)
        }
        return Array(resultsDict.keys).sorted() { $0 < $1 }
    }
    
    var statusString: String {
        if self.status == Status.new {
            return "This is a new survey, still accepting user predictions. Once all the predictions are in, you can open it for voting!"
        } else if self.status == Status.open {
            if self.totalVotes >= self.minVotes {
                return "This survey has the minimum required votes, so it is ready to be completed!"
            } else {
                return "This survey only has \(self.totalVotes) votes, but requires \(self.minVotes) before it can be completed."
            }
        } else {
            return "This survey is completed, and you can view the results!"
        }
    }

}

class Answer: EmbeddedObject, ObjectKeyIdentifiable {
    @Persisted var answerText: String
    @Persisted var currentVotes: Int
    @Persisted var predictions: List<Prediction>
    
    func getUserPrediction(user_id: String) -> Double {
        self.predictions.first( where: { $0.user_id == user_id } )!.predictionValue
    }
}

class Prediction: EmbeddedObject, ObjectKeyIdentifiable {
    @Persisted var user_id: String
    @Persisted var predictionValue: Double
}


