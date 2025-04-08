<!-- START doctoc generated TOC please keep comment here to allow auto update -->
<!-- DON'T EDIT THIS SECTION, INSTEAD RE-RUN doctoc TO UPDATE -->
**Table of Contents**

<!---toc start-->

* [NAME](#name)
* [MAKING A CHECKLIST](#making-a-checklist)
* [SYNOPSIS](#synopsis)
* [DETAILS](#details)
  * [Release types](#release-types)
  * [Prerequisites](#prerequisites)
    * [PAUSE account with pumpkin status](#pause-account-with-pumpkin-status)
    * [GitHub access](#github-access)
    * [Web-based file share](#web-based-file-share)
    * [Quotation for release announcement epigraph](#quotation-for-release-announcement-epigraph)
    * [Install the previous version of perl](#install-the-previous-version-of-perl)
    * [Email account subscribed to perl5-porters](#email-account-subscribed-to-perl5-porters)
  * [Building a release - advance actions](#building-a-release---advance-actions)
    * [Dual-life CPAN module synchronisation](#dual-life-cpan-module-synchronisation)
      * [Sync CPAN modules with the corresponding cpan/ distro](#sync-cpan-modules-with-the-corresponding-cpan-distro)
    * [Ensure dual-life CPAN module stability](#ensure-dual-life-cpan-module-stability)
    * [Monitor smoke tests for failures](#monitor-smoke-tests-for-failures)
    * [Monitor CPAN testers for failures](#monitor-cpan-testers-for-failures)
    * [Check POD errors](#check-pod-errors)
    * [Update perlgov](#update-perlgov)
    * [Update perldelta](#update-perldelta)
    * [Bump the version number](#bump-the-version-number)
    * [Update INSTALL](#update-install)
    * [Update AUTHORS](#update-authors)
    * [Check copyright years](#check-copyright-years)
    * [Check more build configurations](#check-more-build-configurations)
    * [Update perlport](#update-perlport)
    * [Check a readonly build](#check-a-readonly-build)
  * [Building a release - on the day](#building-a-release---on-the-day)
    * [Re-check earlier actions](#re-check-earlier-actions)
    * [Create a release branch](#create-a-release-branch)
    * [Build a clean perl](#build-a-clean-perl)
    * [Check module versions](#check-module-versions)
    * [Update Module::CoreList](#update-modulecorelist)
      * [Bump Module::CoreList\* $VERSIONs](#bump-modulecorelist-versions)
      * [Update `Module::CoreList` with module version data for the new release](#update-modulecorelist-with-module-version-data-for-the-new-release)
      * [Bump version in Module::CoreList `Changes`](#bump-version-in-modulecorelist-changes)
      * [Add Module::CoreList version bump to perldelta](#add-modulecorelist-version-bump-to-perldelta)
      * [Update `%Module::CoreList::released`](#update-modulecorelistreleased)
      * [Commit Module::CoreList changes](#commit-modulecorelist-changes)
      * [Rebuild and test](#rebuild-and-test)
    * [Finalize perldelta](#finalize-perldelta)
    * [Remove stale perldeltas](#remove-stale-perldeltas)
    * [Add recent perldeltas](#add-recent-perldeltas)
    * [Update and commit perldelta files](#update-and-commit-perldelta-files)
    * [Final check of perldelta placeholders](#final-check-of-perldelta-placeholders)
    * [Build a clean perl](#build-a-clean-perl-1)
    * [Synchronise from blead's perlhist.pod](#synchronise-from-bleads-perlhistpod)
    * [Update perlhist.pod](#update-perlhistpod)
    * [Update patchlevel.h](#update-patchlevelh)
    * [Run makemeta to update META files](#run-makemeta-to-update-meta-files)
    * [Build, test and check a fresh perl](#build-test-and-check-a-fresh-perl)
    * [Create the release tag](#create-the-release-tag)
    * [Build the tarball](#build-the-tarball)
    * [Test the tarball](#test-the-tarball)
      * [Copy the tarball to a web server](#copy-the-tarball-to-a-web-server)
      * [Download the tarball to another machine and unpack it](#download-the-tarball-to-another-machine-and-unpack-it)
      * [Ask #p5p to test the tarball on different platforms](#ask-p5p-to-test-the-tarball-on-different-platforms)
      * [Check that `Configure` works](#check-that-configure-works)
      * [Run the test harness and install](#run-the-test-harness-and-install)
      * [Check `perl -v` and `perl -V`](#check-perl--v-and-perl--v)
      * [Run the Installation Verification Procedure utility](#run-the-installation-verification-procedure-utility)
      * [Compare the installed paths to the last release](#compare-the-installed-paths-to-the-last-release)
      * [Disable `local::lib` if it's turned on](#disable-locallib-if-its-turned-on)
      * [Bootstrap the CPAN client](#bootstrap-the-cpan-client)
      * [Install the Inline module with CPAN and test it](#install-the-inline-module-with-cpan-and-test-it)
      * [Make sure that perlbug works](#make-sure-that-perlbug-works)
    * [Monitor smokes](#monitor-smokes)
    * [Upload to PAUSE](#upload-to-pause)
    * [Wait for indexing](#wait-for-indexing)
    * [Disarm patchlevel.h](#disarm-patchlevelh)
    * [Announce to p5p](#announce-to-p5p)
    * [Merge release branch back to blead](#merge-release-branch-back-to-blead)
    * [Publish the release tag](#publish-the-release-tag)
    * [Update epigraphs.pod](#update-epigraphspod)
    * [Update the link to the latest perl on perlweb](#update-the-link-to-the-latest-perl-on-perlweb)
    * [Release schedule](#release-schedule)
    * [Module::CoreList nagging](#modulecorelist-nagging)
    * [New perldelta](#new-perldelta)
    * [Bump version](#bump-version)
    * [Clean build and test](#clean-build-and-test)
    * [Push commits](#push-commits)
    * [Create maint branch](#create-maint-branch)
    * [Copy perldelta.pod to blead](#copy-perldeltapod-to-blead)
    * [Copy perlhist.pod entries to blead](#copy-perlhistpod-entries-to-blead)
    * [Relax!](#relax)
  * [Building a release - the day after](#building-a-release---the-day-after)
    * [Update Module::CoreList](#update-modulecorelist-1)
    * [Check tarball availability](#check-tarball-availability)
    * [Update release manager's guide](#update-release-managers-guide)
    * [For a BLEAD-POINT .0 release](#for-a-blead-point-0-release)
* [SOURCE](#source)

<!---toc end-->

<!-- END doctoc generated TOC please keep comment here to allow auto update -->
# NAME

release\_managers\_guide - Releasing a new version of perl 5.x

Note that things change at each release, so there may be new things not
covered here, or tools may need updating.

# MAKING A CHECKLIST

If you are preparing to do a release, you can run the
`Porting/make-rmg-checklist` script to generate a new version of this
document that starts with a checklist for your release.

This script is run as:

    $ perl Porting/make-rmg-checklist --version [5.X.Y-RC#] > /tmp/rmg.pod

You can also pass the `--html` flag to generate an HTML document instead of
POD.

    $ perl Porting/make-rmg-checklist --html --version [5.X.Y-RC#] > /tmp/rmg.html

# SYNOPSIS

This document describes the series of tasks required - some automatic, some
manual - to produce a perl release of some description, be that a release
candidate, or final, numbered release of maint or blead.

New releases of perl are made each month on the 20th by a release engineer
appointed by the Steering Council.  The release engineer roster and schedule
can be found in Porting/release\_schedule.pod.

This document both helps as a check-list for the release engineer
and is a base for ideas on how the various tasks could be automated
or distributed.

The checklist of a typical release cycle is as follows:

    (5.10.1 is released, and post-release actions have been done)

    ...time passes...

    a few weeks before the release, a number of steps are performed,
        including bumping the version to 5.10.2

    ...a few weeks pass...

    perl-5.10.2-RC1 is released

    perl-5.10.2 is released

    post-release actions are performed, including creating new
        perldelta.pod

    ... the cycle continues ...

# DETAILS

Some of the tasks described below apply to all four types of
release of Perl. (blead, RC, final release of maint, final
release of blead). Some of these tasks apply only to a subset
of these release types.  If a step does not apply to a given
type of release, you will see a notation to that effect at
the beginning of the step.

This guide assumes you are working on the Perl master repository (i.e.
[https://github.com/Perl/perl5](https://github.com/Perl/perl5)) and **not** on your own fork of the perl5
repository. While it is possible to prepare a release on your own fork
this guide is not written with that in mind and as a result several
key steps are missing. If you do use your own fork then extra care
needs to be taken when setting/pushing the tag and doing the merge
(do **not** use a PR).

## Release types

- Release Candidate (RC)

    A release candidate is an attempt to produce a tarball that is as close as
    possible to the final release. Indeed, unless critical faults are found
    during the RC testing, the final release will be identical to the RC
    barring a few minor fixups (updating the release date in `perlhist.pod`,
    removing the RC status from `patchlevel.h`, etc). If faults are found,
    then the fixes should be put into a new release candidate, never directly
    into a final release.

- Stable/Maint release (MAINT).

    A release with an even version number, and subversion number > 0, such as
    5.14.1 or 5.14.2.

    At this point you should have a working release candidate with few or no
    changes since.

    It's essentially the same procedure as for making a release candidate, but
    with a whole bunch of extra post-release steps.

    Note that for a maint release there are two versions of this guide to
    consider: the one in the maint branch, and the one in blead. Which one to
    use is a fine judgement. The blead one will be most up-to-date, while
    it might describe some steps or new tools that aren't applicable to older
    maint branches. It is probably best to review both versions of this
    document, but to most closely follow the steps in the maint version.

- A blead point release (BLEAD-POINT)

    A release with an odd version number, such as 5.15.0 or 5.15.1.

    This isn't for production, so it has less stability requirements than for
    other release types, and isn't preceded by RC releases. Other than that,
    it is similar to a MAINT release.

- Blead final release (BLEAD-FINAL)

    A release with an even version number, and subversion number == 0, such as
    5.14.0. That is to say, it's the big new release once per year.

    It's essentially the same procedure as for making a release candidate, but
    with a whole bunch of extra post-release steps, even more than for MAINT.

## Prerequisites

Before you can make an official release of perl, there are a few
hoops you need to jump through:

### PAUSE account with pumpkin status

Make sure you have a PAUSE account suitable for uploading a perl release.
If you don't have a PAUSE account, then request one:

    https://pause.perl.org/pause/query?ACTION=request_id

Check that your account is allowed to upload perl distros: go to
[https://pause.perl.org/pause/authenquery?ACTION=who\_pumpkin](https://pause.perl.org/pause/authenquery?ACTION=who_pumpkin) and check that
your PAUSE ID is listed there.  If not, ask Andreas König to add your ID
to the list of people allowed to upload something called perl.  You can find
Andreas' email address at:

    https://pause.perl.org/pause/query?ACTION=pause_04imprint

### GitHub access

You will need a working `git` installation, checkout of the perl
git repository and perl commit bit.  For information about working
with perl and git, see [perlgit](https://metacpan.org/pod/perlgit).

If you are not yet a perl committer, you won't be able to make a
release.  You will need to have a GitHub account (if you don't have one)
and contact the Steering Council with your username to get membership in the
[Perl-Releasers](https://github.com/orgs/Perl/teams/perl-releasers) team.

### Web-based file share

You will need to be able to share tarballs with #p5p members for
pre-release testing, and you may wish to upload to PAUSE via URL.
Make sure you have a way of sharing files, such as a web server or
file-sharing service.

If you use Dropbox, you can append "raw=1" as a parameter to their usual
sharing link to allow direct download (albeit with redirects).

### Quotation for release announcement epigraph

You will need a quotation to use as an epigraph to your release announcement.
It will live forever (along with Perl), so make it a good one.

### Install the previous version of perl

During the testing phase of the release you have created, you will be
asked to compare the installed files with a previous install. Save yourself
some time on release day, and have a (clean) install of the previous
version ready.

### Email account subscribed to perl5-porters

In order for your release announcement email to be delivered to the
perl5-porters distribution list, the email address that you intend to
send from must be subscribed to the list.

Instructions for subscribing can be found here:
[List: perl5-porters](https://lists.perl.org/list/perl5-porters.html)

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

## Building a release - on the day

This section describes the actions required to make a release
that are performed near to, or on the actual release day.

### Re-check earlier actions

Review all the actions in the previous section,
["Building a release - advance actions"](#building-a-release-advance-actions) to ensure they are all done and
up-to-date.

### Create a release branch

For BLEAD-POINT releases, making a release from a release branch avoids the
need to freeze blead during the release. This is less important for
BLEAD-FINAL, MAINT, and RC releases, since blead will already be frozen in
those cases. Create the branch by running

    $ git checkout -b release-5.X.Y

### Build a clean perl

Make sure you have a gitwise-clean perl directory (no modified files,
unpushed commits etc):

    $ git status
    $ git clean -dxf

then configure and build perl so that you have a Makefile and porting tools:

    $ ./Configure -Dusedevel -des && make

### Check module versions

For each Perl release since the previous release of the current branch, check
for modules that have identical version numbers but different contents by
running:

    $ ./perl -Ilib Porting/cmpVERSION.pl --tag=v5.LAST

(This is done automatically by `t/porting/cmp_version.t` for the previous
release of the current branch, but not for any releases from other branches.)

Any modules that fail will need a version bump, plus a nudge to the upstream
maintainer for 'cpan' upstream modules.

### Update Module::CoreList

#### Bump Module::CoreList\* $VERSIONs

If necessary, bump `$VERSION` (there's no need to do this
for every RC; in RC1, bump the version to a new clean number that will
appear in the final release, and leave as-is for the later RCs and final).
It may also happen that `Module::CoreList` has been modified in blead, and
hence has a new version number already.  (But make sure it is not the same
number as a CPAN release.)

`$Module::CoreList::Utils::VERSION` should always be equal to
`$Module::CoreList::VERSION`. If necessary, bump those two versions to match
before proceeding.

Once again, the files to modify are:

- `dist/Module-CoreList/lib/Module/CoreList.pm`
- `dist/Module-CoreList/lib/Module/CoreList/Utils.pm`

#### Update `Module::CoreList` with module version data for the new release

Note that if this is a MAINT release, you should run the following actions
from the maint branch, but commit the `CoreList.pm` changes in
_blead_ and subsequently cherry-pick any releases since the last
maint release and then your recent commit.  XXX need a better example

\[ Note that the procedure for handling Module::CoreList in maint branches
is a bit complex, and the RMG currently don't describe a full and
workable approach. The main issue is keeping Module::CoreList
and its version number synchronised across all maint branches, blead and
CPAN, while having to bump its version number for every RC release.
See this brief p5p thread:

    Message-ID: <20130311174402.GZ2294@iabyn.com>

If you can devise a workable system, feel free to try it out, and to
update the RMG accordingly!

DAPM May 2013 \]

`corelist.pl` uses www.cpan.org to verify information about dual-lived
modules on CPAN. It can use a full, local CPAN mirror and/or fall back
on HTTP::Tiny to fetch package metadata remotely.

(If you'd prefer to have a full CPAN mirror, see
[How to mirror CPAN](https://www.cpan.org/misc/how-to-mirror.html))

Change to your perl checkout, and if necessary,

    $ make

Then, If you have a local CPAN mirror, run:

    $ ./perl -Ilib Porting/corelist.pl ~/my-cpan-mirror

Otherwise, run:

    $ ./perl -Ilib Porting/corelist.pl cpan

This will chug for a while, possibly reporting various warnings about
badly-indexed CPAN modules unrelated to the modules actually in core.
Assuming all goes well, it will update
`dist/Module-CoreList/lib/Module/CoreList.pm` and possibly
`dist/Module-CoreList/lib/Module/CoreList/Utils.pm`.

Check those files over carefully:

    $ git diff dist/Module-CoreList/lib/Module/CoreList.pm
    $ git diff dist/Module-CoreList/lib/Module/CoreList/Utils.pm

#### Bump version in Module::CoreList `Changes`

Also edit Module::CoreList's new version number in its `Changes` file.
This file is `dist/Module-CoreList/Changes`.
(BLEAD-POINT releases should have had this done already as a post-release
action from the last commit, but double-check the listed date.)

#### Add Module::CoreList version bump to perldelta

Add a perldelta entry for the new Module::CoreList version. You only
need to do this if you want to add notes about the changes included
with this version of Module::CoreList. Otherwise, its version bump
will be automatically filled in below in ["Finalize perldelta"](#finalize-perldelta).

#### Update `%Module::CoreList::released`

For any release except an RC: Update this version's entry in the `%released`
hash within `dist/Module-CoreList/lib/Module/CoreList.pm` with today's date.

(BLEAD-POINT releases that happen on the expected date may not have to make
any changes to this file at this point. If the release happens not on the
scheduled day, the date may require manually changing.)

#### Commit Module::CoreList changes

Finally, commit the new version of Module::CoreList:
(unless this is for MAINT; in which case commit it to blead first, then
cherry-pick it back).

    $ git commit -m 'Update Module::CoreList for 5.X.Y' dist/Module-CoreList/Changes dist/Module-CoreList/lib/Module/CoreList.pm dist/Module-CoreList/lib/Module/CoreList/Utils.pm

#### Rebuild and test

Build and test to get the changes into the currently built lib directory and to
ensure all tests are passing.

### Finalize perldelta

Finalize the perldelta.  In particular, fill in the Acknowledgements
section, which can be generated with something like:

    $ perl Porting/acknowledgements.pl v5.LAST..HEAD

For non-MAINT releases, fill in the "New/Updated Modules" sections now
that Module::CoreList is updated:

    $ ./perl -Ilib Porting/corelist-perldelta.pl --mode=update pod/perldelta.pod

For a MAINT release use something like this instead:

    $ ./perl -Ilib Porting/corelist-perldelta.pl 5.020001 5.020002 --mode=update pod/perldelta.pod

Ideally, also fill in a summary of the major changes to each module for which
an entry has been added by `corelist-perldelta.pl`.

You should add pod links for GitHub issue references thusly:

    $ perl -gpi -e 's{\b(?:GH|github)\s*#(\d+)}{L<GH #$1|https://github.com/Perl/perl5/issues/$1>}ig' pod/perldelta.pod

Re-read the perldelta to try to find any embarrassing typos and thinkos;
remove any `TODO` or `XXX` flags; update the "Known Problems" section
with any serious issues for which fixes are not going to happen now; and
run through pod and spell checkers, e.g.

    $ podchecker -warnings -warnings pod/perldelta.pod
    $ spell pod/perldelta.pod
    $ aspell list < pod/perldelta.pod | sort -u

Also, you may want to generate and view an HTML version of it to check
formatting, e.g.

    $ ./perl -Ilib ext/Pod-Html/bin/pod2html pod/perldelta.pod > ~/perldelta.html

If you make changes, be sure to commit them.

### Remove stale perldeltas

For the first RC release that is ONLY for a BLEAD-FINAL, the perldeltas
from the BLEAD-POINT releases since the previous BLEAD-FINAL should have
now been consolidated into the current perldelta, and hence are now just
useless clutter.  They can be removed using:

    $ git rm <file1> <file2> ...

For example, for RC0 of 5.16.0:

    $ cd pod
    $ git rm perldelta515*.pod

### Add recent perldeltas

For the first RC for a MAINT release, copy in any recent perldeltas from
blead that have been added since the last release on this branch. This
should include any recent maint releases on branches older than your one,
but not newer. For example if you're producing a 5.14.x release, copy any
perldeltas from recent 5.10.x, 5.12.x etc maint releases, but not from
5.16.x or higher. Remember to

    $ git add <file1> <file2> ...

### Update and commit perldelta files

If you have added or removed any perldelta files via the previous two
steps, then edit `pod/perl.pod` to add/remove them from its table of
contents, then run `Porting/pod_rules.pl` to propagate your changes there
into all the other files that mention them (including `MANIFEST`). You'll
need to `git add` the files that it changes.

Then build a clean perl and do a full test

    $ git status
    $ git clean -dxf
    $ ./Configure -Dusedevel -des
    $ make
    $ make test

Once all tests pass, commit your changes.

### Final check of perldelta placeholders

Check for any 'XXX' leftover section in the perldelta.
Either fill them or remove these sections appropriately.

    $ git grep XX pod/perldelta.pod

### Build a clean perl

If you skipped the previous step (adding/removing perldeltas),
again, make sure you have a gitwise-clean perl directory (no modified files,
unpushed commits etc):

    $ git status
    $ git clean -dxf

then configure and build perl so that you have a Makefile and porting tools:

    $ ./Configure -Dusedevel -des && make

### Synchronise from blead's perlhist.pod

For the first RC for a MAINT release, copy in the latest
`pod/perlhist.pod` from blead; this will include details of newer
releases in all branches. In theory, blead's version should be a strict
superset of the one in this branch, but it's probably safest to examine the
changes first, to ensure that there's nothing in this branch that was
forgotten from blead. An easy way to do that is with `git checkout -p`,
to selectively apply any changes from the blead version to your current
branch:

    $ git fetch origin
    $ git checkout -p origin/blead pod/perlhist.pod
    $ git commit -m 'Sync perlhist from blead' pod/perlhist.pod

### Update perlhist.pod

Add an entry to `pod/perlhist.pod` with the release date, e.g.:

    David    5.10.1       2009-Aug-06

List yourself in the left-hand column, and if this is the first release
that you've ever done, make sure that your name is listed in the section
entitled `THE KEEPERS OF THE PUMPKIN`.

_If you're making a BLEAD-FINAL release_, also update the "SELECTED
RELEASE SIZES" section with the output of
`Porting/perlhist_calculate.pl`.

Be sure to commit your changes:

    $ git commit -m 'Add new release to perlhist' pod/perlhist.pod

### Update patchlevel.h

_You MUST SKIP this step for a BLEAD-POINT release_

Update `patchlevel.h` to add a `-RC1`-or-whatever string; or, if this is
a final release, remove it. For example:

     static const char * const local_patches[] = {
             NULL
    +        ,"RC1"
     #ifdef PERL_GIT_UNCOMMITTED_CHANGES
             ,"uncommitted-changes"
     #endif

Be sure to commit your change:

    $ git commit -m 'Bump version to RCnnn' patchlevel.h

### Run makemeta to update META files

    $ ./perl -Ilib Porting/makemeta

Be sure to commit any changes (if applicable):

    $ git status   # any changes?
    $ git commit -m 'Update META files' META.*

### Build, test and check a fresh perl

Build perl, then make sure it passes its own test suite, and installs:

    $ git clean -xdf
    $ ./Configure -des -Dprefix=/tmp/perl-5.X.Y-pretest

    # or if it's an odd-numbered version:
    $ ./Configure -des -Dusedevel -Dprefix=/tmp/perl-5.X.Y-pretest

    $ make test install

Check that the output of `/tmp/perl-5.X.Y-pretest/bin/perl -v` and
`/tmp/perl-5.X.Y-pretest/bin/perl -V` are as expected,
especially as regards version numbers, patch and/or RC levels, and @INC
paths. Note that as they have been built from a git working
directory, they will still identify themselves using git tags and
commits. (Note that for an odd-numbered version, perl will install
itself as `perl5.X.Y`). `perl -v` will identify itself as:

    This is perl 5, version X, subversion Y (v5.X.Y (v5.XX.Z-NNN-gdeadbeef))

where 5.X.Z is the latest tag, NNN the number of commits since this tag,
and `deadbeef` commit of that tag.

Then delete the temporary installation.

### Create the release tag

Create the _annotated_ tag identifying this release (e.g.):

    $ git tag v5.21.4 -m 'Perl 5.21.4'

It is **VERY** important that from this point forward, you not push
your git changes to the Perl master repository.  If anything goes
wrong before you publish your newly-created tag, you can delete
and recreate it.  Once you push your tag, we're stuck with it
and you'll need to use a new version number for your release.

Verify that your tag is annotated:

    $ git show v5.X.Y

The output must look similar to the following:

    tag v5.X.Y
    Tagger: Steve Hay <steve.m.hay@googlemail.com>
    Date:   2014-09-20 11:09:51 +0100
    ...

### Build the tarball

Before you run the following, you might want to install 7-Zip (the
`p7zip-full` package under Debian or the `p7zip` port on MacPorts) or
the AdvanceCOMP suite (e.g. the `advancecomp` package under Debian,
or the `advancecomp` port on macports - 7-Zip on Windows is the
same code as AdvanceCOMP, so Windows users get the smallest files
first time). These compress about 5% smaller than gzip and bzip2.
Over the lifetime of your distribution this will save a lot of
people a small amount of download time and disk space, which adds
up.

In order to produce the `xz` tarball, XZ Utils are required. The `xz`
utility is included with most modern UNIX-type operating systems and
is available for Cygwin. A Windows port is available from
[https://tukaani.org/xz/](https://tukaani.org/xz/).

**IMPORTANT**: if you are on OS X, you must export `COPYFILE_DISABLE=1`
to prevent OS X resource files from being included in your tarball. After
creating the tarball following the instructions below, inspect it to ensure
you don't have files like `._foobar`.

Create a tarball. Use the `-s` option to specify a suitable suffix for
the tarball and directory name:

    $ cd root/of/perl/tree

    $ perl Porting/makerel -x -s RC1           # for a release candidate
    $ perl Porting/makerel -x                  # for the release itself

This creates the directory `../perl-x.y.z-RC1` or similar, copies all
the MANIFEST files into it, sets the correct permissions on them, then
tars it up as `../perl-x.y.z-RC1.tar.gz`.  The `-x` also produces a
`tar.xz` file.

If you're getting your tarball suffixed with -uncommitted and you're sure
your changes were all committed, you can override the suffix with:

    $ perl Porting/makerel -x -s ''

XXX if we go for extra tags and branches stuff, then add the extra details
here

Finally, clean up the temporary directory, e.g.

    $ rm -rf ../perl-x.y.z-RC1

### Test the tarball

Once you have a tarball it's time to test the tarball (not the repository).

#### Copy the tarball to a web server

Copy the tarballs (.gz and .xz) to a web server somewhere you have access to.

#### Download the tarball to another machine and unpack it

Download the tarball to some other machine. For a release candidate,
you really want to test your tarball on two or more different platforms
and architectures.

#### Ask #p5p to test the tarball on different platforms

Once you've verified the tarball can be downloaded and unpacked,
ask the #p5p IRC channel on irc.perl.org for volunteers to test the
tarballs on whatever platforms they can.

If you're not confident in the tarball, you can defer this step until after
your own tarball testing, below.

#### Check that `Configure` works

Check that basic configuration and tests work on each test machine:

    $ ./Configure -des && make all minitest test

    # Or for a development release:
    $ ./Configure -Dusedevel -des && make all minitest test

#### Run the test harness and install

Check that the test harness and install work on each test machine:

    $ make distclean
    $ ./Configure -des -Dprefix=/install/path && make all test_harness install
    $ cd /install/path

(Remember `-Dusedevel` above, for a development release.)

#### Check `perl -v` and `perl -V`

Check that the output of `perl -v` and `perl -V` are as expected,
especially as regards version numbers, patch and/or RC levels, and @INC
paths.

Note that the results may be different without a `.git/` directory,
which is why you should test from the tarball.

#### Run the Installation Verification Procedure utility

    $ ./perl -Ilib ./utils/perlivp
    # Or, perhaps:
    $ ./perl5.X.Y ./utils/perlivp5.X.Y
    ...
    All tests successful.
    $

#### Compare the installed paths to the last release

Compare the pathnames of all installed files with those of the previous
release (i.e. against the last installed tarball on this branch which you
have previously verified using this same procedure). In particular, look
for files in the wrong place, or files no longer included which should be.
For example, suppose the about-to-be-released version is 5.10.1 and the
previous is 5.10.0:

    $ cd installdir-5.10.0/
    $ find . -type f | perl -pe's/5\.10\.0/5.10.1/g' | sort > /tmp/f1
    $ cd installdir-5.10.1/
    $ find . -type f | sort > /tmp/f2
    $ diff -u /tmp/f[12]

#### Disable `local::lib` if it's turned on

If you're using `local::lib`, you should reset your environment before
performing these actions:

    $ unset PERL5LIB PERL_MB_OPT PERL_LOCAL_LIB_ROOT PERL_MM_OPT

#### Bootstrap the CPAN client

Bootstrap the CPAN client on the clean install:

    $ bin/cpan

    # Or, perhaps:
    $ bin/cpan5.X.Y

#### Install the Inline module with CPAN and test it

Try installing a popular CPAN module that's reasonably complex and that
has dependencies; for example:

    CPAN> install Inline::C
    CPAN> quit

Check that your perl can run this:

    $ bin/perl -lwe "use Inline C => q[int f() { return 42;}]; print f"
    42
    $

#### Make sure that perlbug works

Test [perlbug](https://metacpan.org/pod/perlbug) with the following:

    $ bin/perlbug
    ...
    Subject: test bug report
    Local perl administrator [yourself]:
    Editor [vi]:
    Module:
    Category [core]:
    Severity [low]:
    (edit report)
    Action (Send/Display/Edit/Subject/Save to File): f
    Name of file to save message in [perlbug.rep]:

and carefully examine the output (in `perlbug.rep]`), especially
the "Locally applied patches" section.

### Monitor smokes

XXX This is probably irrelevant if working on a release branch, though
MAINT or RC might want to push a smoke branch and wait.

Wait for the smoke tests to catch up with the commit which this release is
based on (or at least the last commit of any consequence).

Then check that the smoke tests pass (particularly on Win32). If not, go
back and fix things.

Note that for _BLEAD-POINT_ releases this may not be practical. It takes a
long time for the smokers to catch up, especially the Win32
smokers. This is why we have a RC cycle for _MAINT_ and _BLEAD-FINAL_
releases, but for _BLEAD-POINT_ releases sometimes the best you can do is
to plead with people on IRC to test stuff on their platforms, fire away,
and then hope for the best.

### Upload to PAUSE

Once smoking is okay, upload it to PAUSE. This is the point of no return.
If anything goes wrong after this point, you will need to re-prepare
a new release with a new minor version or RC number.

[https://pause.perl.org/](https://pause.perl.org/)

(Log in, then select 'Upload a file to CPAN')

If your workstation is not connected to a high-bandwidth,
high-reliability connection to the Internet, you should probably use the
"GET URL" feature (rather than "HTTP UPLOAD") to have PAUSE retrieve the
new release from wherever you put it for testers to find it.  This will
eliminate anxious gnashing of teeth while you wait to see if your
15 megabyte HTTP upload successfully completes across your slow, twitchy
cable modem.

_Remember_: if your upload is partially successful, you
may need to contact a PAUSE administrator or even bump the version of perl.

Upload the .gz and .xz versions of the tarball.

Note: You can also use the command-line utility to upload your tarballs, if
you have it configured:

    $ cpan-upload perl-5.X.Y.tar.gz
    $ cpan-upload perl-5.X.Y.tar.xz

Do not proceed any further until you are sure that your tarballs are on CPAN.
Check your authors directory metacpan.org to confirm that your uploads have
been successful.

    https://metacpan.org/author/YOUR_PAUSE_ID/releases

You can also check

    https://metacpan.org/release/YOUR_PAUSE_ID/perl-5.X.Y

which may be faster.

### Wait for indexing

_You MUST SKIP this step for RC and BLEAD-POINT_

Wait until you receive notification emails from the PAUSE indexer
confirming that your uploads have been received.  IMPORTANT -- you will
probably get an email that indexing has failed, due to module permissions.
This is considered normal.

### Disarm patchlevel.h

_You MUST SKIP this step for BLEAD-POINT release_

Disarm the `patchlevel.h` change; for example,

     static const char * const local_patches[] = {
             NULL
    -        ,"RC1"
     #ifdef PERL_GIT_UNCOMMITTED_CHANGES
             ,"uncommitted-changes"
     #endif

Be sure to commit your change:

    $ git commit -m 'Disarm RCnnn bump' patchlevel.h

### Announce to p5p

Mail perl5-porters@perl.org to announce your new release, with a quote you prepared earlier.
Get the SHA256 digests from the PAUSE email responses.

Use the template at Porting/release\_announcement\_template.txt

Send a carbon copy to `noc@metacpan.org`

If your email does not appear on the list, but does not obviously bounce
either, check that the email you are sending from is subscribed to the list.

### Merge release branch back to blead

Merge the (local) release branch back into master now, and delete it.

    $ git checkout blead
    $ git pull
    $ git merge release-5.X.Y
    $ git push
    $ git branch -d release-5.X.Y

Note: The merge will create a merge commit if other changes have been pushed
to blead while you've been working on your release branch. Do NOT rebase your
branch to avoid the merge commit (as you might normally do when merging a
small branch into blead) since doing so will invalidate the tag that you
created earlier.

### Publish the release tag

Now that you've shipped the new perl release to PAUSE and pushed your changes
to the Perl master repository, it's time to publish the tag you created
earlier too (e.g.):

    $ git push origin tag v5.X.Y

### Update epigraphs.pod

Add your quote to `Porting/epigraphs.pod` and commit it.
You can include the customary link to the release announcement even before your
message reaches the web-visible archives by looking for the X-List-Archive
header in your message after receiving it back via perl5-porters.

### Update the link to the latest perl on perlweb

Submit a pull request to [https://github.com/perlorg/perlweb](https://github.com/perlorg/perlweb).  For a dev
release, update the link in `docs/dev/perl5/index.html`.  For a stable
release, update `docs/shared/tpl/stats.html`.

### Release schedule

_You MUST SKIP this step for RC_

Tick the entry for your release in `Porting/release_schedule.pod`.

### Module::CoreList nagging

_You MUST SKIP this step for RC_

Remind the current maintainer of `Module::CoreList` to push a new release
to CPAN.

### New perldelta

_You MUST SKIP this step for RC_

Create a new perldelta.

- Confirm that you have a clean checkout with no local changes.
- Run:
 perl Porting/new-perldelta.pl
- Run the `git add` commands it outputs to add new and modified files.
- Verify that the build still works, by running `./Configure` and
`make test_porting`. (On Win32 use the appropriate make utility).
- If `t/porting/podcheck.t` spots errors in the new `pod/perldelta.pod`,
run `./perl -MTestInit t/porting/podcheck.t | less` for more detail.
Skip to the end of its test output to see the options it offers you.
- When `make test_porting` passes, commit the new perldelta.

        $ git commit -m'New perldelta for 5.X.Y'

At this point you may want to compare the commit with a previous bump to
see if they look similar.  See commit ba03bc34a4 for an example of a
previous version bump.

### Bump version

_You MUST SKIP this step for RC and MAINT_

If this was a BLEAD-FINAL release (i.e. the first release of a new maint
series, 5.x.0 where x is even), then bump the version in the blead branch
in git, e.g. 5.12.0 to 5.13.0.

First, add a new feature bundle to `regen/feature.pl`, initially by just
copying the exiting entry, and bump the file's $VERSION (after the \_\_END\_\_
marker); e.g.

         "5.14" => [qw(switch say state unicode_strings)],
    +    "5.15" => [qw(switch say state unicode_strings)],

Run `regen/feature.pl` to propagate the changes to `lib/feature.pm`.

Then follow the section ["Bump the version number"](#bump-the-version-number) to bump the version
in the remaining files and test and commit.

If this was a BLEAD-POINT release, then just follow the section
["Bump the version number"](#bump-the-version-number).

After bumping the version, follow the section ["Update INSTALL"](#update-install) to
ensure all version number references are correct.

(Note: The version is NOT bumped immediately after a MAINT release in order
to avoid confusion and wasted time arising from bug reports relating to
"intermediate versions" such as 5.20.1-and-a-bit: If the report is caused
by a bug that gets fixed in 5.20.2 and this intermediate version already
calls itself 5.20.2 then much time can be wasted in figuring out why there
is a failure from something that "should have been fixed". If the bump is
late then there is a much smaller window of time for such confusing bug
reports to arise. (The opposite problem -- trying to figure out why there
\*is\* a bug in something calling itself 5.20.1 when in fact the bug was
introduced later -- shouldn't arise for MAINT releases since they should,
in theory, only contain bug fixes but never regressions.))

### Clean build and test

Run a clean build and test to make sure nothing obvious is broken. This is
very important, as commands run after this point must be run using the perl
executable built with the bumped version number.

    $ git clean -xdf
    $ ./Configure -des -Dusedevel
    $ make
    $ make test

In particular, `Porting/perldelta_template.pod` is intentionally exempted
from podchecker tests, to avoid false positives about placeholder text.
However, once it's copied to `pod/perldelta.pod` the contents can now
cause test failures. Problems should be resolved by doing one of the
following:

1. Replace placeholder text with correct text.
2. If the problem is from a broken placeholder link, you can add it to the
array `@perldelta_ignore_links` in `t/porting/podcheck.t`.  Lines
containing such links should be marked with `XXX` so that they get
cleaned up before the next release.
3. Following the instructions output by `t/porting/podcheck.t` on how to
update its exceptions database.

### Push commits

Finally, push any commits done above.

    $ git push origin ....

### Create maint branch

_You MUST SKIP this step for RC, BLEAD-POINT, MAINT_

If this was a BLEAD-FINAL release (i.e. the first release of a new maint
series, 5.x.0 where x is even), then create a new maint branch based on
the commit tagged as the current release.

Assuming you're using git 1.7.x or newer:

    $ git checkout -b maint-5.X v5.X.0
    $ git push origin -u maint-5.X

### Copy perldelta.pod to blead

_You MUST SKIP this step for RC, BLEAD-POINT_

Copy the perldelta.pod for this release into blead; for example:

    $ cd ..../blead
    $ cp -i ../5.10.x/pod/perldelta.pod pod/perl5101delta.pod  #for example
    $ git add pod/perl5101delta.pod

Don't forget to set the NAME correctly in the new file (e.g. perl5101delta
rather than perldelta).

Edit `pod/perl.pod` to add an entry for the file, e.g.:

    perl5101delta          Perl changes in version 5.10.1

Then rebuild various files:

    $ perl Porting/pod_rules.pl

Finally, commit and push:

    $ git commit -a -m 'Add perlXXXdelta'
    $ git push origin ....

### Copy perlhist.pod entries to blead

Make sure any recent `pod/perlhist.pod` entries are copied to
`perlhist.pod` on blead.  e.g.

    5.8.9         2008-Dec-14

### Relax!

_You MUST RETIRE to your preferred PUB, CAFE or SEASIDE VILLA for some
much-needed rest and relaxation_.

Thanks for releasing perl!

## Building a release - the day after

### Update Module::CoreList

_After a BLEAD-POINT release only_

After Module::CoreList has shipped to CPAN by the maintainer, update
Module::CoreList in the source so that it reflects the new blead
version number:

- Update `Porting/Maintainers.pl` to list the new DISTRIBUTION on CPAN,
which should be identical to what is currently in blead.
- Bump the $VERSION in `dist/Module-CoreList/lib/Module/CoreList.pm`
and `dist/Module-CoreList/lib/Module/CoreList/Utils.pm`.
- If you have a local CPAN mirror, run:

        $ ./perl -Ilib Porting/corelist.pl ~/my-cpan-mirror

    Otherwise, run:

        $ ./perl -Ilib Porting/corelist.pl cpan

    This will update `dist/Module-CoreList/lib/Module/CoreList.pm` and
    `dist/Module-CoreList/lib/Module/CoreList/Utils.pm` as it did before,
    but this time adding new sections for the next BLEAD-POINT release.

- Add the new $Module::CoreList::VERSION to
`dist/Module-CoreList/Changes`.
- Remake perl to get your changed .pm files propagated into `lib/` and
then run at least the `dist/Module-CoreList/t/*.t` tests and the
test\_porting makefile target to check that they're ok.

        $ cd t; ./TEST ../dist/Module-CoreList/t/*.t
        $ make test_porting

- Run

        $ ./perl -Ilib -MModule::CoreList -le 'print Module::CoreList->find_version($]) ? "ok" : "not ok"'

    and check that it outputs "ok" to prove that Module::CoreList now knows
    about blead's current version.

- Commit and push your changes.

        $ git add -u
        $ git commit -m "Prepare Module::Corelist for 5.X.Y"
        $ git push origin

### Check tarball availability

Check various website entries to make sure the that tarball has appeared
and is properly indexed:

- Check your author directory under [https://www.cpan.org/authors/id/](https://www.cpan.org/authors/id/)
to ensure that the tarballs are available on the website.
- Check `/src` on CPAN (on a fast mirror) to ensure that links to
the new tarballs have appeared: There should be links in `/src/5.0`
(which is accumulating all new versions), and (for BLEAD-FINAL and
MAINT only) an appropriate mention in `/src/README.html` (which describes
the latest versions in each stable branch, with links).

    The `/src/5.0` links should appear automatically, some hours after upload.
    If they don't, or the `/src` description is inadequate,
    ask Ask <ask@perl.org>.

- Check [https://www.cpan.org/src/](https://www.cpan.org/src/) to ensure that the `/src` updates
have been correctly mirrored to the website.
If they haven't, ask Ask <ask@perl.org>.
- Check [https://metacpan.org](https://metacpan.org) to see if it has indexed the distribution.
It should be visible at a URL like `https://metacpan.org/release/DAPM/perl-5.10.1`.

### Update release manager's guide

Go over your notes from the release (you did take some, right?) and update
`Porting/release_managers_guide.pod` with any fixes or information that
will make life easier for the next release manager.

### For a BLEAD-POINT .0 release

This is the time for the project to decide the fate and begin to
implement the required changes for experimental/deprecated features and
API elements for the next BLEAD-FINAL, a year away.

Fortunately your job is not to do this yourself, but merely to remind
people that this needs to get done.  Send email to
[p5p](mailto:perl5-porters@perl.org).  All of [perlexperiment](https://metacpan.org/pod/perlexperiment),
[perldeprecation](https://metacpan.org/pod/perldeprecation), `mathoms.c`, [perlapi](https://metacpan.org/pod/perlapi), and [perlintern](https://metacpan.org/pod/perlintern) need to
be considered.

# SOURCE

Based on
[git, process and progress (Nicholas Clark)](https://www.nntp.perl.org/group/perl.perl5.porters/2009/05/msg146638.html),
plus a whole bunch of other sources, including private correspondence.
