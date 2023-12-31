//
//  Survey.swift
//  PineappleOnPizza
//
//  Created by David Freifeld on 8/11/23.
//

import Foundation
import RealmSwift

//enum SurveyError: Error {
//    case userPredictionNotFound
//}

class Survey: Object, ObjectKeyIdentifiable {
    @Persisted(primaryKey: true) var _id: ObjectId
    @Persisted var owner_id: String
    @Persisted var questionText: String
    @Persisted var answers: List<Answer>
    @Persisted var status: Status
    @Persisted var code: String
    @Persisted var userMap: Map<String,String> // user_id, nickname
    @Persisted var minVotes: Int
    
    var totalVotes: Int {
        self.answers.reduce(0, { runningSum, nextAnswer in
            runningSum + nextAnswer.currentVotes
        })
    }
    
    var areAllPredictionsIn: Bool {
        for user in userMap.keys {
            if !self.answers[0].predictions.contains(where: { $0.user_id == user }) {
                return false
            }
        }
        return true
    }
    
    var userHasPrediction: Bool {
        self.answers[0].predictions.contains(where: { $0.user_id == app.currentUser?.id })
    }
    
    // uses root mean squared error to give the user a final score
    func getUserFinalScore(user_id: String) -> Double? {
        var totalError = 0.0
        for answer in self.answers {
            guard let userPrediction = answer.getUserPrediction(user_id: user_id) else {
                return nil
            }
            let actualScore = (Double(answer.currentVotes) / Double(self.totalVotes) * 100).rounded()
            totalError += pow(((userPrediction * 100) - actualScore), 2)
        }
        return sqrt(totalError)
    }
    
    func getFinalScoresSortedUserList() -> [(String, Double?)] {
        var resultsDict = [String: Double?]()
        for user_id in self.userMap.keys {
            resultsDict[user_id] = getUserFinalScore(user_id: user_id)
        }
        return resultsDict.sorted {
            if let one = $0.1 {
                if let two = $1.1 {
                    return one < two
                } else {
                    return true
                }
            } else {
                return false
            }
        }
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

extension Survey {
    static let pineapple_open = Survey(value: [
        "owner_id": "abc123",
        "questionText": "Do you like pineapple on pizza?",
        "answers": [
            Answer(value: [
                "answerText": "Yes",
                "currentVotes": 0,
                "predictions": List<Prediction>()
            ] as [String: Any]),
            Answer(value: [
                "answerText": "No",
                "currentVotes": 0,
                "predictions": List<Prediction>()
            ] as [String: Any]),
            Answer(value: [
                "answerText": "Kind of",
                "currentVotes": 0,
                "predictions": List<Prediction>()
            ] as [String: Any]),
            Answer(value: [
                "answerText": "I'm not sure",
                "currentVotes": 0,
                "predictions": List<Prediction>()
            ] as [String: Any])
            
        ],
        "status": Status.open,
        "code": "XYZ456",
        "userMap": Map<String, String>(),
        "minVotes": 2
    ] as [String: Any])
    
    static let blank_survey = Survey(value: [
        "owner_id": "abc123",
        "questionText": "",
        "answers": [],
        "status": Status.new,
        "code": "XYZ456",
        "userMap": Map<String, String>(),
        "minVotes": 0
    ] as [String: Any])
}

class Answer: EmbeddedObject, ObjectKeyIdentifiable {
    @Persisted var answerText: String
    @Persisted var currentVotes: Int
    @Persisted var predictions: List<Prediction>
    
    func getUserPrediction(user_id: String) -> Double? {
        guard let prediction = self.predictions.first( where: { $0.user_id == user_id } ) else {
            return nil
        }
        return prediction.predictionValue / Double(100)
    }
}

class Prediction: EmbeddedObject, ObjectKeyIdentifiable {
    @Persisted var user_id: String
    @Persisted var predictionValue: Double
}


