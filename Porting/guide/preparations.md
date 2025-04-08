## Building a release - advance actions

The work of building a release candidate for an even numbered release
(BLEAD-FINAL) of perl generally starts several weeks before the first
release candidate.  Some of the following steps should be done regularly,
but all _must_ be done in the run up to a release.

### Dual-life CPAN module synchronisation

To see which core distro versions differ from the current CPAN versions:

    $ ./perl -Ilib Porting/core-cpan-diff -x -a

However, this only checks whether the version recorded in
`Porting/Maintainers.pl` differs from the latest on CPAN.  It doesn't tell you
if the code itself has diverged from CPAN.

You can also run an actual diff of the contents of the modules, comparing core
to CPAN, to ensure that there were no erroneous/extraneous changes that need to
be dealt with. You do this by not passing the `-x` option:

    $ ./perl -Ilib Porting/core-cpan-diff -a -o ~/corediffs

Passing `-u cpan` will probably be helpful, since it limits the search to
distributions with 'cpan' upstream source.  (It's OK for blead upstream to
differ from CPAN because those dual-life releases usually come _after_ perl
is released.)

See also the `-d` and `-v` options for more detail (and the `-u` option as
mentioned above).  You'll probably want to use the `-c cachedir` option to
avoid repeated CPAN downloads and may want to use `-m file:///mirror/path` if
you made a local CPAN mirror. Note that a minicpan mirror won't actually work,
but can provide a good first pass to quickly get a list of modules which
definitely haven't changed, to avoid having to download absolutely everything.

For a BLEAD-POINT or BLEAD-FINAL release with 'cpan' upstream, if a CPAN
release appears to be ahead of blead, then consider updating it (or asking the
relevant porter to do so). (However, if this is a BLEAD-FINAL release or one of
the last BLEAD-POINT releases before it and hence blead is in some kind of
"code freeze" state (e.g. the sequence might be "contentious changes freeze",
then "user-visible changes freeze" and finally "full code freeze") then any
CPAN module updates must be subject to the same restrictions, so it may not be
possible to update all modules until after the BLEAD-FINAL release.) If blead
contains edits to a 'cpan' upstream module, this is naughty but sometimes
unavoidable to keep blead tests passing. Make sure the affected file has a
CUSTOMIZED entry in `Porting/Maintainers.pl`.

If you are making a MAINT release, run `core-cpan-diff` on both blead and
maint, then diff the two outputs. Compare this with what you expect, and if
necessary, fix things up. For example, you might think that both blead
and maint are synchronised with a particular CPAN module, but one might
have some extra changes.

In any case, any cpan-first distribution that is listed as having files
"Customized for blead" in the output of cpan-core-diff should have requests
submitted to the maintainer(s) to make a cpan release to catch up with blead.

Additionally, all files listed as "modified" but not "customized for blead"
should have entries added under the `CUSTOMIZED` key in
`Porting/Maintainers.pl`, as well as checksums updated via:

    $ cd t; ../perl -I../lib porting/customized.t --regen

#### Sync CPAN modules with the corresponding cpan/ distro

In most cases, once a new version of a distribution shipped with core has been
uploaded to CPAN, the core version thereof can be synchronized automatically
with the program `Porting/sync-with-cpan`. For example:

    $ perl Porting/sync-with-cpan Archive::Tar

(But see the comments at the beginning of that program.  In particular, it has
not yet been exercised on Windows as much as it has on Unix-like platforms.)

If, however, `Porting/sync-with-cpan` does not provide good results, follow
the steps below.

- Fetch the most recent version from CPAN.
- Unpack the retrieved tarball. Rename the old directory; rename the new
directory to the original name.
- Restore any `.gitignore` file. This can be done by issuing
`git checkout .gitignore` in the `cpan/Distro` directory.
- Remove files we do not need. That is, remove any files that match the
entries in `@IGNORABLE` in `Porting/Maintainers.pl`, and anything that
matches the `EXCLUDED` section of the distro's entry in the `%Modules`
hash.
- Restore any files mentioned in the `CUSTOMIZED` section, using
`git checkout`. Make any new customizations if necessary. Also,
restore any files that are mentioned in `@IGNORE`, but were checked
into the repository anyway.
- For any new files in the distro, determine whether they are needed.
If not, delete them, and list them in either `EXCLUDED` or `@IGNORABLE`.
Otherwise, add them to `MANIFEST`, and run `git add` to add the files
to the repository.
- For any files that are gone, remove them from `MANIFEST`, and use
`git rm` to tell git the files will be gone.
- If the `MANIFEST` file was changed in any of the previous steps, run
`perl Porting/manisort --output MANIFEST.sort; mv MANIFEST.sort MANIFEST`.
- For any files that have an execute bit set, either remove the execute
bit, or edit `Porting/exec-bit.txt`
- Run `make` (or `nmake` on Windows), see if `perl` compiles.
- Run the tests for the package.
- Run the tests in `t/porting` (`make test_porting`).
- Update the `DISTRIBUTION` entry in `Porting/Maintainers.pl`.
- Run a full configure/build/test cycle.
- If everything is ok, commit the changes.

For entries with a non-simple `FILES` section, or with a `MAP`, you
may have to take more steps than listed above.

### Ensure dual-life CPAN module stability

This comes down to:

    for each module that fails its regression tests on $current
     did it fail identically on $previous?
     if yes, "SEP" (Somebody Else's Problem, but try to make sure a
       bug ticket is filed)
     else work out why it failed (a bisect is useful for this)

    attempt to group failure causes

    for each failure cause
     is that a regression?
     if yes, figure out how to fix it
         (more code? revert the code that broke it)
     else
         (presumably) it's relying on something un-or-under-documented
         should the existing behaviour stay?
             yes - goto "regression"
             no - note it in perldelta as a significant bugfix
             (also, try to inform the module's author)

### Monitor smoke tests for failures

Similarly, monitor the smoking of core tests, and try to fix.  See
[CoreSmokeDB Web](https://perl5.test-smoke.org/), [Perl Smoke Web](http://perl.develop-help.com) 
and [Smoke Status Report](https://tux.nl/perl5/smoke/index.html) for a summary. See also
[Raw Reports Mailing List](https://www.nntp.perl.org/group/perl.daily-build.reports/) which has emailed raw reports.

Similarly, monitor the smoking of perl for compiler warnings, and try to
fix.

Additionally [GitHub Actions](https://github.com/Perl/perl5/actions) smokers run
automatically.

### Monitor CPAN testers for failures

For any release except a BLEAD-POINT: Examine the relevant analysis report(s)
at [http://analysis.cpantesters.org/beforemaintrelease](http://analysis.cpantesters.org/beforemaintrelease) to see how the
impending release is performing compared to previous releases with
regard to building and testing CPAN modules.

That page accepts a query parameter, `pair` that takes a pair of
colon-delimited versions to use for comparison.  For example:

[http://analysis.cpantesters.org/beforemaintrelease?pair=5.20.2:5.22.0%20RC1](http://analysis.cpantesters.org/beforemaintrelease?pair=5.20.2:5.22.0%20RC1)

### Check POD errors

`t/porting/podcheck.t` is a porting test that will fail if it finds new
problems in pods.  However, it can be taught to ignore problems, and
sometimes people do so for problems that really should be fixed before
release.  To see what it is ignoring, run

    $ ./perl -Ilib t/porting/podcheck.t --counts

Any problems listed as pedantic aren't worth your time investigating.
These have a `?` at the beginning of the text, or are for the too-long
verbatim lines.

But other warnings could be.  In particular, a broken link can well
mean that someone clicking on the pod in a web page will get a 404.

To find out more about any real problems, capture the output from

    $ ./perl -Ilib t/porting/podcheck.t --show-all

and grep for those real problems.  (It can take a minute or so to run.)

If you decide any should be fixed, after that gets done, run

    $ ./perl -Ilib t/porting/podcheck.t

to make sure those fixes were successful, and follow the directions in
the output about regenerating the data base.

### Update perlgov

When doing a MAINT release, check that perlgov lists the _current_
Perl Steering Council and Core Team members, in case they have changed
since the corresponding stable release has been shipped.

### Update perldelta

Get perldelta in a mostly finished state.

It is usual to send a call out to the Perl5-Porters mailing list a few days
ahead of the release to ask for recent committers to add their own notes
relating to their recent work.  Getting other people to write it ahead of
time can save you from having to work out the details during the actual
release process.

Read `Porting/how_to_write_a_perldelta.pod`, and try to make sure that
every section it lists is, if necessary, populated and complete. Copy
edit the whole document.

You won't be able to automatically fill in the "Updated Modules" section until
after [Module::CoreList](https://metacpan.org/pod/Module%3A%3ACoreList) is updated (as described below in
["Update Module::CoreList"](#update-module-corelist)).

### Bump the version number

Do not do this yet for a BLEAD-POINT release! You will do this at the end of
the release process (after building the final tarball, tagging etc).

Increase the version number (e.g. from 5.12.0 to 5.12.1).

For a release candidate for a stable perl, this should happen a week or two
before the first release candidate to allow sufficient time for testing and
smoking with the target version built into the perl executable. For
subsequent release candidates and the final release, it is not necessary to
bump the version further.

There is a tool to semi-automate this process:

    $ ./perl -Ilib Porting/bump-perl-version -i 5.10.0 5.10.1

Remember that this tool is largely just grepping for '5.10.0' or whatever,
so it will generate false positives. Be careful not change text like
"this was fixed in 5.10.0"!

Use git status and git diff to select changes you want to keep.

Be particularly careful with `INSTALL`, which contains a mixture of
`5.10.0`-type strings, some of which need bumping on every release, and
some of which need to be left unchanged.
See below in ["Update INSTALL"](#update-install) for more details.

For the first RC release leading up to a BLEAD-FINAL release, update the
description of which releases are now "officially" supported in
`pod/perlpolicy.pod`.

When doing a BLEAD-POINT or BLEAD-FINAL release, also make sure the
`PERL_API_*` constants in `patchlevel.h` are in sync with the version
you're releasing, unless you're absolutely sure the release you're about to
make is 100% binary compatible to an earlier release. Note: for BLEAD-POINT
releases the bump should have already occurred at the end of the previous
release and this is something you would have to do at the very end.
When releasing a MAINT perl version, the `PERL_API_*` constants `MUST NOT`
be changed as we aim to guarantee binary compatibility in maint branches.

After editing, you may need to regen opcodes:

    $ ./perl -Ilib regen/opcode.pl

Test your changes:

    $ git clean -xdf   # careful if you don't have local files to keep!
    $ ./Configure -des -Dusedevel
    $ make
    $ make test

Do note that at this stage, porting tests will fail. They will continue
to fail until you've updated Module::CoreList, as described below.

Commit your changes:

    $ git status
    $ git diff
    B<review the delta carefully>

    $ git commit -a -m 'Bump the perl version in various places for 5.X.Y'

At this point you may want to compare the commit with a previous bump to
see if they look similar.  See commit f7cf42bb69 for an example of a
previous version bump.

When the version number is bumped, you should also update Module::CoreList
(as described below in ["Update Module::CoreList"](#update-module-corelist)) to reflect the new
version number.

### Update INSTALL

Review and update INSTALL to account for the change in version number.
INSTALL for a BLEAD-POINT release should already contain the expected version.
For MAINT releases, the lines in `INSTALL` about "is not binary compatible
with" may require a correct choice of earlier version to declare
incompatibility with. These are in the "Changes and Incompatibilities" and
"Coexistence with earlier versions of perl 5" sections.

Be particularly careful with the section "Upgrading from 5.X.Y or earlier".
The "X.Y" needs to be changed to the most recent version that we are
_not_ binary compatible with.

For MAINT and BLEAD-FINAL releases, this needs to refer to the last
release in the previous development cycle (so for example, for a 5.14.x
release, this would be 5.13.11).

For BLEAD-POINT releases, it needs to refer to the previous BLEAD-POINT
release (so for 5.15.3 this would be 5.15.2).  If the last release manager
followed instructions, this should have already been done after the last
blead release, so you may find nothing to do here.

### Update AUTHORS

The AUTHORS file can be updated by running `Porting/updateAUTHORS.pl`.
This shouldn't really be necessary anymore, and in theory nothing should
change as our CI should not pass if a commit would result in AUTHORS
needing to change, but do it anyway to be sure. Make sure all your changes
are committed first.

Review the changes to the AUTHORS file, be sure you are not adding duplicate
entries or removing any entries, then commit your changes.

    $ git commit -a AUTHORS -m 'Update AUTHORS list for 5.X.Y'

### Check copyright years

Check that the copyright years are up to date by running:

    $ pushd t; ../perl -I../lib porting/copyright.t --now

Remedy any test failures by editing README or perl.c accordingly (search for
the "Copyright"). If updating perl.c, check if the file's own copyright date in
the C comment at the top needs updating, as well as the one printed by `-v`.

### Check more build configurations

Try running the full test suite against multiple Perl configurations. Here are
some sets of Configure flags you can try:

- `-Duseshrplib -Dusesitecustomize`
- `-Duserelocatableinc`
- `-Dusethreads`

If you have multiple compilers on your machine, you might also consider
compiling with `-Dcc=$other_compiler`.

You can also consider pushing the repo to GitHub where GitHub Actions is enabled
which would smoke different flavors of Perl for you.

### Update perlport

[perlport](https://metacpan.org/pod/perlport) has a section currently named _Supported Platforms_ that
indicates which platforms are known to build in the current release.
If necessary update the list and the indicated version number.

### Check a readonly build

Even before other prep work, follow the steps in ["Build the tarball"](#build-the-tarball) and test
it locally.  Because a perl source tarballs sets many files read-only, it could
test differently than tests run from the repository.  After you're sure
permissions aren't a problem, delete the generated directory and tarballs.
