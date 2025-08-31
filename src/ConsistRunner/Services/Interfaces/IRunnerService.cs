namespace ConsistRunner.Services.Interfaces
{
    /// <summary>
    /// ConsistRunner のメイン処理を抽象化するインターフェイス。
    /// </summary>
    /// <remarks>
    /// - 実行エントリーポイント <c>Program.Main</c> から呼び出される。<br/>
    /// - 実装クラス（例: <c>RunnerService</c>）にてバッチ処理の本体を記述する。<br/>
    /// - 将来的にテストやモックを差し込む際にも、このインターフェイス経由で実行できるようにしている。
    /// </remarks>
    public interface IRunnerService
    {
        /// <summary>
        /// バッチ処理を実行する。
        /// </summary>
        /// <param name="args">
        /// コマンドライン引数。<br/>
        /// 例: <c>--ping</c> を指定すると簡易動作確認モードを実行する。
        /// </param>
        void Run(string[] args);
    }
}
