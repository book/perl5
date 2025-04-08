
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

