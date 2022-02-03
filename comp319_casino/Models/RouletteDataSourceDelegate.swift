import Foundation

protocol RouletteDataSourceDelegate{
    func spinRouletteWheel(angle: Int)
    func updateWinner(number: Int)
    func giveAlert(alert: String, msg: String)
    func updateBet(value: Int)
    func updateWinnings(value: Int)
}
