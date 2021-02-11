import Foundation

struct ConversationItemUIModel {

    enum Direction: CaseIterable {
        case left, right
    }

    let direction: Direction
    let text: String

    static var fake: ConversationItemUIModel {
        let text = (0..<Int.random(in: 3..<10)).map { (_) in
            random_country_name()
        }.joined(separator: ", ")
        return ConversationItemUIModel(
            direction: Direction.allCases.randomElement()!,
            text: text
        )
    }
}



