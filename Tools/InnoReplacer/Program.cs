using InnoReplacer.Services;
using System;
using System.Collections.Generic;
using System.IO;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace InnoReplacer
{
    internal class Program
    {
        internal static int Main(string[] args)
        {
            if (args.Length < 3)
            {
                Console.Error.WriteLine("Usage: EncodingPreservingReplacer.exe <filepath> <searchText> <replaceText>");
                return 1;
            }

            string filePath = args[0];
            string searchText = args[1];
            string replaceText = args[2];

            var svc = new FileTextReplaceService();
            var code = svc.ReplaceInPlace(filePath, searchText, replaceText);

            if (code != 0 && code != 2 && code != 9) code = 9; // 念のため集約
            if (code == 2) Console.Error.WriteLine($"File not found: {filePath}");
            return code;
        }
    }
}
