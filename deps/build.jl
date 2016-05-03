# Modified from Diercxk.jl:
# https://github.com/kbarbary/Dierckx.jl/blob/master/deps/build.jl  (3-clause BSD license)

# do it by hand since problem with BinDeps


suffix = ""

@unix_only begin
    my_download = @osx ? `curl -O` : `wget`
    suffix = @osx ? "dylib" : "so"
end

@windows_only begin
    warn("CRlibm is not currently available on Windows. An MPFR wrapper will be used.")
end

libname = "crlibm-1.0beta5"
filename = string(libname, ".tgz")

src_dir = "src"
cd(src_dir)

file = "http://lipforge.ens-lyon.fr/frs/download.php/162/$(filename)"

println("Downloading the library files from $file")
println("Working in ", pwd())


run(`$(my_download) $file`)
#download(file)
run(`tar xzf $(filename)`)

#srcdir = "$(src_dir)/$(lib_name)"

cd(lib_name)
println("Working in ", pwd())

suffix = @osx? "dylib" : "so"
run(`./configure CFLAGS=-fpic --silent`)
println("Working in ", pwd())

run(`make -s V=0`)
run(`make -s -f ../shared.mk SUFFIX=$suffix V=0`)
