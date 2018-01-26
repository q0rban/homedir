#!/usr/bin/env python

import shutil
from optparse import OptionParser
from argparse import ArgumentParser

def main():
    # Add options.
    parser = OptionParser()
    parser.add_option("-t", "--tag",
                      help="The git tag to checkout.")
    parser.add_option("-d", "--drush", default="drush",
                      help="The path to drush. Defaults to `drush`")

    # Parse the options and arguments.
    (options, args) = parser.parse_args()
    print options.drush
    print options.tag
    print args
    print shutil.which("drush")

if __name__ == "__main__":
    main()
