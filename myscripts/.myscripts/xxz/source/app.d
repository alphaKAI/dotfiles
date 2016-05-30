import std.process,
       std.stdio,
       std.conv,
       std.file,
       std.path;

void xxz(string fileName) {
  enum CPU_CORE = 4;

  writeln("Extract tar package " ~ fileName ~ " into " ~ baseName(fileName, ".xz"));
  executeShell("tar -xf " ~ fileName);
  writeln("Decompress " ~ baseName(fileName, ".xz") ~ " into " ~ baseName(fileName, ".tar.xz") ~ " with xz");
  //executeShell("xz -x" ~ baseName(fileName, ".xz"));
  executeShell("xz --threads=" ~ CPU_CORE.to!string ~ "-x" ~ baseName(fileName, ".xz"));
  writeln("Remove tar package " ~ baseName(fileName, ".xz"));
  executeShell("rm " ~ baseName(fileName, "xz"));
}

void main(string[] args) {
  args = args[1..$];
  if (args.length < 1) {
    throw new Error("Too few arguments");
  }

  foreach (arg; args) {
    if (exists(arg)) {
      xxz(arg);
    } else {
      writeln("Not found such a file", arg);
      continue;
    }
  }
}


