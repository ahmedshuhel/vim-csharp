" Vim plugin functions
" Language:     Microsoft C#
" Maintainer:   Kian Ryan (kian@orangetentacle.co.uk)
" Last Change:  2015 Apr 22

function! s:get_net_framework_dir(version)

    if exists("g:net_framework_top")
        net_framework_top = g:net_framework_top
    elseif str2nr(a:version) >= 12
        let net_framework_top = "c:\\progra~2\\MSBuild\\"
    else
        let net_framework_top = "c:\\windows\\Microsoft.NET\\Framework\\"
    endif

    if a:version == "1"
        return net_framework_top . "v1.1.4322\\"
    elseif a:version == "2"
        return net_framework_top . "v2.0.50727\\"
    elseif a:version == "3.5"
        return net_framework_top . "v3.5\\"
    elseif a:version == "4"
        return net_framework_top . "v4.0.30319\\"
    elseif a:version == "12"
        return net_framework_top . "12.0\\Bin\\"
    elseif a:version == "14"
        return net_framework_top . "14.0\\Bin\\"
    endif

endfunction

function! cs#get_net_compiler(compiler)

    if exists("g:net_framework_version")
        let msbuild = s:get_net_framework_dir(g:net_framework_version) . a:compiler
        return msbuild
    else
        if executable(a:compiler)
            let msbuild = a:compiler
            return msbuild
        else
            for i in ["14","12","4","3.5","2","1"]
                let msbuild = s:get_net_framework_dir(i) . a:compiler . ".exe"
                if findfile(msbuild) != ""
                    return msbuild
                endif
            endfor
        endif

        " Hail mary test for xbuild
        if executable("xbuild")
            let msbuild = "xbuild"
            return msbuild
        endif
    endif
endfunction

function! cs#find_net_solution_file()
    " Just consider first match
    return get(split(globpath(".", "*.sln"), "\n"), 0, "")
endfunction

