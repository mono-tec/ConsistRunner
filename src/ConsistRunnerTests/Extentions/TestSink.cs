using Serilog.Core;
using Serilog.Events;
using System.Collections.Concurrent;
using System.Collections.Generic;
using System.Linq;

namespace ConsistRunnerTests.Extentions
{
    /// <summary>
    /// Serilog のログイベントをメモリに収集するシンプルなシンク。
    /// </summary>
    /// <remarks>
    /// ユニットテストで利用し、特定のメッセージが出力されたかどうかを検証する目的で使用する。
    /// </remarks>
    public sealed class TestSink : ILogEventSink
    {
        /// <summary>
        /// 収集した <see cref="LogEvent"/> を保持するコンテナ。
        /// </summary>
        private readonly ConcurrentBag<LogEvent> _events = new ConcurrentBag<LogEvent>();

        /// <summary>
        /// Serilog から渡されたログイベントをメモリに追加する。
        /// </summary>
        /// <param name="logEvent">Serilog が生成したログイベント。</param>
        public void Emit(LogEvent logEvent) => _events.Add(logEvent);

        /// <summary>
        /// 収集済みのログイベント一覧を取得する。
        /// </summary>
        public IReadOnlyCollection<LogEvent> Events => _events.ToArray();

        /// <summary>
        /// 指定したメッセージテンプレート文字列と一致するログイベントを列挙する。
        /// </summary>
        /// <param name="template">比較対象となるメッセージテンプレート文字列。</param>
        /// <returns>一致するログイベントの列挙。</returns>
        public IEnumerable<LogEvent> WhereMessageTemplate(string template)
            => _events.Where(e => e.MessageTemplate.Text == template);
    }
}
