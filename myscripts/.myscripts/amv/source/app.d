import std.stdio : writeln;
import std.array : array;
import std.regex : regex, match, replace;
import std.file  : exists, isDir, getcwd, dirEntries, SpanMode, rename;
import std.conv  : to;
import std.algorithm : map, each, filter;

void help(){
  immutable space = "  ";
  writeln("All move command - Copyright (C) 2015 alphaKAI");
  writeln("This command move all of files in current directory files and directories to one directory.(default: exclude dot files/directories)");
  writeln("Usage: amv [option] destination");
  writeln("[options]:");
  writeln(space, "-a : include .* files/directories");
  writeln(space, "-h : show this help");
}

T[] exceptElement(T)(T[] arr, T v, bool function(T e, T v) cond = null){
  auto cl = cond ? (T e) => !cond(e, v) : (T e) => e != v;
  return arr.filter!cl.array;
}

bool include(T)(T[] array, T value){
  foreach(e; array)
    if(e == value)
      return true;

  return false;
}

string stripPath(string base, string path){
  return base.replace(regex(path ~ "/?"), "");
}

void main(string[] args){
  args = args[1..$];
  if(args.length == 0 || args.include("-h")){
    help;
    return;
  }

  bool[string] modes;
  if(args.include("-a"))
    modes["all"] = true;
  else
    modes["all"] = false;

  args = args.exceptElement("-",
      (string e, string v) => e.match(regex("^-")) ? true : false);

  if(args.length != 1){
    writeln("[Error] Invalid options"); 
    return;
  }

  if(!exists(args[0]) || !args[0].isDir){
    writeln("Not fund such a directory \"", args[0], "\"");
    return;
  }

  dirEntries(getcwd, SpanMode.shallow)
    .map!((e) => e.name.stripPath(getcwd))
    .array
    .exceptElement(args[0])
    .filter!((e) => modes["all"] ? true : e.match(regex(r"^\.")) ? false : true)
    .map!((e) => e.to!string)
    .each!((e) => rename(e, args[0] ~ "/" ~ e));
}
