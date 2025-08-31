using ConsistRunner.Services;
using ConsistRunner.Services.Interfaces;
using Serilog;
using System;

namespace ConsistRunner
{
    internal class Program
    {
        /// <summary>
        /// アプリケーションのメインエントリポイント。
        /// Serilog は App.config (appSettings) を読み込み、Debug/Release ビルドで
        /// App.Debug.config / App.Release.config がマージされる。
        /// </summary>
        private static int Main(string[] args)
        {
            // App.config (appSettings) を Serilog にバインド
            Log.Logger = new LoggerConfiguration()
                .ReadFrom.AppSettings()   // ← Serilog.Settings.AppSettings が必要
                .CreateLogger();

            try
            {
                Log.Information("ConsistRunner started.");

                IRunnerService service = new RunnerService(Log.Logger);
                service.Run(args);

                Log.Information("ConsistRunner finished successfully.");
                return 0;
            }
            catch (Exception ex)
            {
                Log.Fatal(ex, "ConsistRunner terminated with an unhandled exception.");
                return 1;
            }
            finally
            {
                Log.CloseAndFlush();
            }
        }
    }
}
