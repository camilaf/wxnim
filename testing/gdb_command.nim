import osproc
import streams
import strutils

proc start_gdb() =

    var p = startProcess("/usr/local/bin/gdb","/Users/cdetrincheria/Desktop/tpp-test/wxnim/testing",["--interpreter=mi2", "--quiet", "factorial"], nil, {poEchoCmd})
    # var fd0 = inputHandle(p)
    echo processID(p)

    var input = inputStream(p)
    var output = outputStream(p)
    
    var line = ""
    while not line.contains("(gdb)"):
        discard output.readLine(line)
        echo line

    input.writeLine("-exec-run")
    input.flush()

    line = ""
    while not line.contains("(gdb)"):
        discard output.readLine(line)
        echo line

    # input.writeLine("-break-insert 12")
    # input.flush()

    input.writeLine("-gdb-exit")
    input.flush()
    echo output.readLine()

    # p.close()


start_gdb()
