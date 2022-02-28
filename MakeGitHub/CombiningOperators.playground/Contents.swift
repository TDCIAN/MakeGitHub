import RxSwift

let disposeBag = DisposeBag()

print("--- startWith ---")
let yellow = Observable.of("yello1", "yello2", "yello3")

yellow
    .enumerated()
    .map { index, element in
        return element + "어린이" + "\(index)"
    }
    .startWith("teacher")
    .subscribe(onNext: {
        print($0)
    })
    .disposed(by: disposeBag)
