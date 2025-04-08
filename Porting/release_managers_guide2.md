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

## [Prerequisites](guide/prerequisites.md)

## [Building a release - advance actions](guide/preparations.md)

## [Building a release - on the day](guide/release.md)

## [Building a release - the day after](guide/post.md)

# SOURCE

Based on
[git, process and progress (Nicholas Clark)](https://www.nntp.perl.org/group/perl.perl5.porters/2009/05/msg146638.html),
plus a whole bunch of other sources, including private correspondence.
