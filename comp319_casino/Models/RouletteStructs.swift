import Foundation

struct Sector: Equatable{
    let number: Int
    let color: betSizes
    let value: betSizes
    let place: betSizes
}

struct betObj{
    let betSize: betSizes
    let betValue: Int
}

enum betSizes: Int{
    case even
    case odd
    case firstBlock
    case secondBlock
    case thirdBlock
    case black
    case red
    case green
    case singleNumb
    case empty
    var values: Int{
        switch self{
        case .even:
            return 2
        case .odd:
            return 2
        case .firstBlock:
            return 3
        case .secondBlock:
            return 3
        case .thirdBlock:
            return 3
        case .black:
            return 2
        case .red:
            return 2
        case .green:
            return 36
        case .singleNumb:
            return 36
        case .empty:
            return 0
        }
    }
    
}
struct Stack {
    private var array: [Any] = []
    
    func isEmpty() -> Bool{
        return self.array.isEmpty
    }
    mutating func push(_ element: Any) {
        self.array.append(element)
    }

    mutating func pop() -> Any? {
        return self.array.popLast()
    }

    func peek() -> Any? {
        guard let top = self.array.last else { return nil }
        return top
    }
    mutating func clear(){
        self.array.removeAll()
    }
}
