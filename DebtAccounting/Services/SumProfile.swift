import UIKit

final class SumProfile {
    static let shared = SumProfile()
    private init() {}

    var sumITo: Int = 0
    var sumToMe: Int = 0
}
