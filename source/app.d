import std.stdio, std.algorithm: canFind;
import std.windows.registry, std.string;
import colorize : color;
import core.thread;

void main(string[] args)
{
    // Fetches your current region from battle.net registry
    auto bKey = Registry.currentUser.getKey(
            `Software\Blizzard Entertainment\Battle.net\Launch Options\Pro`, REGSAM.KEY_ALL_ACCESS);

    auto region = bKey.getValue("REGION").value_SZ;
    auto regions = ["EU","US","KR","CN"];

    if (args.length > 1 && regions.canFind(args[1])) {
        region = args[1];
        bKey.setValue("REGION", region);
    } else {
        writefln("%s:\n\tPlease pass one of these %s\n\tas an argument to not toggle inbetween EU/NA\n", strip(args[0], ".\\"), regions);

        // Default behaviour if no arguments are passed, will switch inbetween EU & NA.
        switch (region)
        {
            case "EU":
                region = "US";
                break;
            case "US":
                region = "EU";
                break;
            default:
                region = "US";
        }

        bKey.setValue("REGION", region);
    }

    writeln("Switched region to: ", region.color("green"));
    Thread.sleep(1.seconds);
}
