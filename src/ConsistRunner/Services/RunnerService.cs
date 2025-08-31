using ConsistRunner.Services.Interfaces;
using Serilog;
using System;

namespace ConsistRunner.Services
{

    public class RunnerService : IRunnerService
    {
        private readonly ILogger _log;           // Serilog ILogger

        public RunnerService(ILogger log)
        {
            _log = log;
        }

        public void Run(string[] args)
        {
            // ここにバッチ本体処理を記述（今回はサンプルとしてダミー処理）
            _log.Information("RunnerService started with {ArgCount} args.", args?.Length ?? 0);


            // 例: 引数に --ping があれば現在時刻を出力
            if (args != null && Array.Exists(args, a => string.Equals(a, "--ping", StringComparison.OrdinalIgnoreCase)))
            {
                _log.Information("Ping: {Utc}", DateTime.UtcNow);
            }


            // 例: 実運用ではここでDBアクセス、ファイルI/O、API呼び出しなど
            _log.Information("RunnerService completed.");
        }
    }
}
