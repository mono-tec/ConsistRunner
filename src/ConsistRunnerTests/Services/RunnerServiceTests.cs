using Microsoft.VisualStudio.TestTools.UnitTesting;
using ConsistRunner.Services;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using Serilog;
using ConsistRunnerTests.Extentions;
using Serilog.Events;

namespace ConsistRunner.Services.Tests
{
    /// <summary>
    /// <see cref="RunnerService"/> の動作を検証するユニットテスト。
    /// </summary>
    [TestClass]
    public class RunnerServiceTests
    {
        /// <summary>
        /// テスト用の Serilog ロガーを生成する。
        /// </summary>
        /// <param name="sink">ログイベントを収集する <see cref="TestSink"/>。</param>
        /// <returns>収集用シンクを出力先とした Serilog ロガー。</returns>
        private static ILogger CreateLogger(TestSink sink)
            => new LoggerConfiguration()
                .MinimumLevel.Debug()
                .WriteTo.Sink(sink)
                .CreateLogger();

        /// <summary>
        /// 引数なしで <see cref="RunnerService.Run(string[])"/> を実行した場合、
        /// 開始・完了ログが出力され、Ping ログが出力されないことを検証する。
        /// </summary>
        [TestMethod]
        public void Run_WithoutArgs_LogsStartAndComplete_NoPing()
        {
            // Arrange
            var sink = new TestSink();
            var logger = CreateLogger(sink);
            var sut = new RunnerService(logger);

            // Act
            sut.Run(null);

            // Assert
            var started = sink.WhereMessageTemplate("RunnerService started with {ArgCount} args.").SingleOrDefault();
            Assert.IsNotNull(started, "Start log was not written.");
            Assert.AreEqual(0, (int)started.Properties["ArgCount"].LiteralValue());

            var ping = sink.WhereMessageTemplate("Ping: {Utc}").SingleOrDefault();
            Assert.IsNull(ping, "Ping log should not be written without --ping.");

            var completed = sink.WhereMessageTemplate("RunnerService completed.").SingleOrDefault();
            Assert.IsNotNull(completed, "Completion log was not written.");
        }

        /// <summary>
        /// <c>--ping</c> 引数を指定して <see cref="RunnerService.Run(string[])"/> を実行した場合、
        /// Ping ログが出力されることを検証する。
        /// </summary>
        [TestMethod]
        public void Run_WithPingArg_LogsPing()
        {
            // Arrange
            var sink = new TestSink();
            var logger = CreateLogger(sink);
            var sut = new RunnerService(logger);

            // Act
            sut.Run(new[] { "--ping" });

            // Assert
            var started = sink.WhereMessageTemplate("RunnerService started with {ArgCount} args.").SingleOrDefault();
            Assert.IsNotNull(started);
            Assert.AreEqual(1, (int)started.Properties["ArgCount"].LiteralValue());

            var ping = sink.WhereMessageTemplate("Ping: {Utc}").SingleOrDefault();
            Assert.IsNotNull(ping, "Ping log was not written even though --ping was supplied.");
            Assert.IsTrue(ping.Properties.ContainsKey("Utc"), "Ping log must contain Utc property.");

            var completed = sink.WhereMessageTemplate("RunnerService completed.").SingleOrDefault();
            Assert.IsNotNull(completed);
        }
    }

    /// <summary>
    /// Serilog の <see cref="LogEventPropertyValue"/> からスカラ値を直接取り出す拡張メソッド。
    /// </summary>
    internal static class SerilogPropertyValueExtensions
    {
        /// <summary>
        /// <see cref="ScalarValue"/> の値をそのまま返す。
        /// それ以外の型の場合は <c>null</c> を返す。
        /// </summary>
        /// <param name="v">Serilog のプロパティ値。</param>
        /// <returns>スカラの実際の値、または null。</returns>
        public static object LiteralValue(this LogEventPropertyValue v)
            => v is ScalarValue s ? s.Value : null;
    }
}
