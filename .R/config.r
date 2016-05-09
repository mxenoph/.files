options(pager = file.path(Sys.getenv('HOME'), '.R/pager.sh'),
        # Imperial College London
        repos = c(CRAN = 'http://cran.ma.imperial.ac.uk/'),
        menu.graphics = FALSE, # Seriously, WHAT THE FUCK, R!?
        import.path = '~/Projects/R',
        devtools.name = 'Konrad Rudolph',
        devtools.desc.author = 'Konrad Rudolph <konrad.rudolph@gmail.com> [aut, cre]',
        devtools.desc.license = 'file LICENSE',
        devtools.desc.suggests = c('knitr', 'testthat'))

.libPaths('~/R-dev')

# All the following is executed in its own environment, which will subsequently
# be attached to the object search path.

if (interactive()) {
    local({
        # Load individual source files
        profile_env = new.env()
        local_r_path = file.path(Sys.getenv('HOME'), '.R')
        sourcefiles = list.files(local_r_path, pattern = '\\.[rR]$', full.names = TRUE)
        sourcefiles = sourcefiles[-grep('config\\.[rR]', sourcefiles)]

        for (sourcefile in sourcefiles)
            # Ignore errors in individual files.
            try(eval(parse(sourcefile, encoding = 'UTF-8'), envir = profile_env))

        attach(profile_env, name = 'rprofile', warn.conflicts = FALSE)

        library(colorout)
        setOutputColors256(verbose = FALSE)
        library(setwidth)

        if (Sys.getenv('NVIMR_TMPDIR') != '') {
            options(nvimcom.verbose = 1)
            library(nvimcom)
        } else {
            library(vimcom)
        }

        # Load `modules` last to make `modules::?` findable.
        options(defaultPackages = c(getOption('defaultPackages'), 'setwidth', 'modules'))

        .Last = function ()
            try(savehistory(Sys.getenv('R_HISTFILE', '~/.Rhistory')))

        message(R.version$version.string)
    })
}
