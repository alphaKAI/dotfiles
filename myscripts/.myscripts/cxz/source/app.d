import std.process,
       std.stdio,
       std.conv,
       std.file;

void cxz(string fileName) {
  enum CompressLevel = 9;
  enum CPU_CORE      = 4;

  writeln("Make tar package ", fileName ~ " into " ~ fileName ~ ".tar");
  executeShell("tar -cf " ~ fileName ~ ".tar " ~ fileName);
  writeln("Compress " ~ fileName ~ ".tar into " ~ fileName ~ ".tar.xz" ~ " with xz - CompressLevel: ", CompressLevel);
  //executeShell("xz -z" ~ CompressLevel.to!string ~ " " ~ fileName ~ ".tar");
  executeShell("pxz --threads=" ~ CPU_CORE.to!string ~ " -z" ~ CompressLevel.to!string ~ " " ~ fileName ~ ".tar");
}

void main(string[] args) {
  args = args[1..$];
  if (args.length < 1) {
    throw new Error("Too few arguments");
  }

  foreach (arg; args) {
    if (exists(arg)) {
      cxz(arg);
    } else {
      writeln("Not found such a file or directory - ", arg);
      continue;
    }
  }
}

