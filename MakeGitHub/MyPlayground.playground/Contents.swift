import Foundation
import RxSwift

print("---- Just ----")
Observable<Int>.just(9)

print("---- Of 1 ----")
Observable<Int>.of(1, 2, 3, 4, 5)

print("---- Of 2 ----")
Observable.of([1, 2, 3, 4, 5])
