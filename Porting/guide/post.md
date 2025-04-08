## [Building a release - the day after](post.md)

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

