
import Foundation

struct Lesson: Hashable {
    let name: String
    let audience: String
    let timeStart: String
    let timeEnd: String
    let type: String
    let professor: String
}

struct SchoolDay: Hashable {
    let dayWeek: String
    let lessons: [Lesson]
}
