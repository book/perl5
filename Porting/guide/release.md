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
