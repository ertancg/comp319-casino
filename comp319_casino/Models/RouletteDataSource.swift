import Foundation
import CoreText
class RouletteDataSource{
    
    
    static var shared: RouletteDataSource = RouletteDataSource()
    
    var delegate: RouletteDataSourceDelegate?
    
    let player = Player.shared
    
    var playerBets: Stack = Stack()
    
    var selectedNumber: Sector = Sector(number: -1, color: .red, value: .even, place: .firstBlock)
    
    let sectors: [Sector] = [Sector(number: 32, color: .red, value: .even, place: .thirdBlock),
                             Sector(number: 15, color: .black, value: .odd, place: .secondBlock),
                             Sector(number: 19, color: .red, value: .odd, place: .secondBlock),
                             Sector(number: 4, color: .black, value: .even, place: .firstBlock),
                             Sector(number: 21, color: .red, value: .odd, place: .secondBlock),
                             Sector(number: 2, color: .black, value: .even, place: .firstBlock),
                             Sector(number: 25, color: .red, value: .odd, place: .secondBlock),
                             Sector(number: 17, color: .black,value: .odd, place: .secondBlock),
                             Sector(number: 34, color: .red, value: .even, place: .thirdBlock),
                             Sector(number: 6, color: .black, value: .even, place: .firstBlock),
                             Sector(number: 27, color: .red, value: .odd, place: .thirdBlock),
                             Sector(number: 13, color: .black, value: .odd, place: .firstBlock),
                             Sector(number: 36, color: .red, value: .even, place: .thirdBlock),
                             Sector(number: 11, color: .black, value: .odd, place: .firstBlock),
                             Sector(number: 30, color: .red, value: .even, place: .thirdBlock),
                             Sector(number: 8, color: .black, value: .even, place: .firstBlock),
                             Sector(number: 23, color: .red, value: .odd, place: .secondBlock),
                             Sector(number: 10, color: .black, value: .even, place: .firstBlock),
                             Sector(number: 5, color: .red, value: .odd, place: .firstBlock),
                             Sector(number: 24, color: .black, value: .even, place: .secondBlock),
                             Sector(number: 16, color: .red, value: .even, place: .secondBlock),
                             Sector(number: 33, color: .black, value: .odd, place: .thirdBlock),
                             Sector(number: 1, color: .red, value: .odd, place: .firstBlock),
                             Sector(number: 20, color: .black, value: .even, place: .secondBlock),
                             Sector(number: 14, color: .red, value: .even, place: .firstBlock),
                             Sector(number: 31, color: .black, value: .odd, place: .thirdBlock),
                             Sector(number: 9, color: .red, value: .odd, place: .firstBlock),
                             Sector(number: 22, color: .black, value: .even, place: .secondBlock),
                             Sector(number: 18, color: .red, value: .even, place: .secondBlock),
                             Sector(number: 29, color: .black, value: .odd, place: .thirdBlock),
                             Sector(number: 7, color: .red, value: .odd, place: .firstBlock),
                             Sector(number: 28, color: .black, value: .even, place: .thirdBlock),
                             Sector(number: 12, color: .red, value: .even, place: .firstBlock),
                             Sector(number: 35, color: .black, value: .odd, place: .thirdBlock),
                             Sector(number: 3, color: .red, value: .odd, place: .firstBlock),
                             Sector(number: 26, color: .black, value: .even, place: .secondBlock),
                             Sector(number: 0, color: .green, value: .even, place: .green)]
    var spinDegree = 0
    let halfSector = 360.0 / 37.0 / 2.0
    
    
    init(){
        
    }
    
    func spinWheel(_ degre: Int){
        let newAngle = getAngle(angle: Double(degre))
        self.selectedNumber = sectorFromAngle(angle: Double(newAngle))
        self.delegate?.spinRouletteWheel(angle: degre)
    }
    
    func getAngle(angle: Double) -> Double{
        let deg = 360 - angle.truncatingRemainder(dividingBy: 360)
        return deg
    }
    
    func getWinner(){
        self.delegate?.updateWinner(number: self.selectedNumber.number)
    }
    
    func sectorFromAngle(angle: Double) -> Sector{
        var i = 0
        var sector: Sector = Sector(number: -1, color: .empty, value: .black, place: .green)
        
        while(sector == Sector(number: -1, color: .empty, value: .black, place: .green) && i < sectors.count){
            let start: Double = halfSector * Double((i*2) + 1) - halfSector
            let end: Double = halfSector * Double((i*2 + 3))
            
            if(angle >= start && angle < end){
                sector = sectors[i]
            }
            i += 1
        }
        return sector
    }
    
    func placeBet(_ bet: betSizes, value: Int){
        if value == 0 || value < 0{
            self.delegate?.giveAlert(alert: "Bet!", msg: "Bet cannot be 0!")
            self.delegate?.updateBet(value: 0)
        }else{
            self.playerBets.push(betObj(betSize: bet, betValue: value))
            self.player.decreaseFunds(value)
            calculateTotalBetSize()
        }
    }
    
    func calculateTotalBetSize(){
        var temp = self.playerBets
        var total = 0
        while(!temp.isEmpty()){
            var val = temp.pop() as! betObj
            total += val.betValue
        }
        self.delegate?.updateBet(value: total)
    }
    func removeBets(){
        self.playerBets.clear()
        calculateTotalBetSize()
    }
    
    func calculateTotal(){
        var tmp = self.playerBets
        var winning = 0
        while(!tmp.isEmpty()){
            var val = tmp.pop() as! betObj
            switch val.betSize{
            case .even:
                if(val.betSize == self.selectedNumber.value){
                    winning += val.betSize.values * val.betValue
                }
            case .odd:
                if(val.betSize == self.selectedNumber.value){
                    winning += val.betSize.values * val.betValue
                }
            case .firstBlock:
                if(val.betSize == self.selectedNumber.place){
                    winning += val.betSize.values * val.betValue
                }
            case .secondBlock:
                if(val.betSize == self.selectedNumber.place){
                    winning += val.betSize.values * val.betValue
                }
            case .thirdBlock:
                if(val.betSize == self.selectedNumber.place){
                    winning += val.betSize.values * val.betValue
                }
            case .black:
                if(val.betSize == self.selectedNumber.color){
                    winning += val.betSize.values * val.betValue
                }
            case .red:
                if(val.betSize == self.selectedNumber.color){
                    winning += val.betSize.values * val.betValue
                }
            case .green:
                if(val.betSize == self.selectedNumber.color){
                    winning += val.betSize.values * val.betValue
                }
            case .singleNumb:
                winning += 0
            case .empty:
                winning = 0
            }
            
        }
        self.player.increaseFunds(winning)
        self.delegate?.updateWinnings(value: winning)
    }
}
