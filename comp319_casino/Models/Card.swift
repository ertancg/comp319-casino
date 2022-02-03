import Foundation

struct Card{
    let suit: String
    let rank: Int
    let value: Int
    let cardBack = "Card_back_01"
    var isFaceDown = true
    
    mutating func flipCard(){
        isFaceDown.toggle()
    }
    
    var imageName: String{
        var temp: String
        var name: String
        if (isFaceDown){
            name = cardBack
        }else{
            switch rank{
            case 1:
                temp = "ace"
            case 11:
                temp = "jack"
            case 12:
                temp = "queen"
            case 13:
                temp = "king"
            default:
                temp = "\(rank)"
            }
            name = "\(temp)_of_\(suit)"
        }
        return name
    }
}
