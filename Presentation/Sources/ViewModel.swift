protocol ViewModel {
    associatedtype Input
    associatedtype Output
    associatedtype State
    
    /// View側でRxの文脈から外れた処理(ex. UITableViewDelegateの処理など)を行う際に、保持しておく必要がある状態を保持するための変数
    /// Viewの表示のためにはどうしても必要な場合を除いては使わないようにするべき
    var state: State { get }
    
    func transform(from input: Input) -> Output
}
