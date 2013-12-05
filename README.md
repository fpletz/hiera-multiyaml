# MultiYAML backend for Hiera

## Description

All Hiera backends using the `:datadir` configuration, in particular the both
default backends `yaml` and `json` are limited to just one datadir.
Furthermore, only one instance of each backend can be used and configured.

Although there is [#1394](http://projects.puppetlabs.com/issues/13954) and
multiple requests for it on mailing lists, Puppetlabs until now hasn't
decided to fix it.

After looking at the Hiera code, I know why. They would have to rewrite a
buch of code. This is a quick hack that (unfortunately) duplicates some
code from the `yaml` backend. Avoiding the evilest monkey patching I could
imagine, this was the only option.

## Usage

Install the gem using:

    $ gem install hiera-multiyaml

And use it in your `hiera.yaml` like this:

    :backends:
      - multiyaml

    :multiyaml:
      :backends:
        - firstyaml
        - secondyaml

    :firstyaml:
      :datadir: /etc/puppet/environments/production/data

    :secondyaml:
      :datadir: /var/lib/hiera

Please note that the datadirs will be processed and merged *sequentially* in
the order you specify them. This is exactly the same behaviour as the
`:hierachy` configuration option.
