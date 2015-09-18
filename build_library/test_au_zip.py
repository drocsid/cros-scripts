#!/usr/bin/python2

# Copyright (c) 2013 The Chromium OS Authors. All rights reserved.
# Use of this source code is governed by a BSD-style license that can be
# found in the LICENSE file.

"""Script to validate the output of generate_au_zip.py.

This does NOT validate older versions of au_generator.zip, only the zip files
generated by the matching version of generate_au_zip.py.
"""

from __future__ import print_function

import logging
import optparse
import os
import shutil
import subprocess
import tempfile

import generate_au_zip


class TestFailure(Exception):
  """An exception showing we failed to verify the current au-generator.zip."""
  pass


def FailWithError(msg):
  """Fail the current test.

  Args:
    msg: User readable reason for failing the test.

  Raises:
    TestFailure always raised.
  """
  logging.error(msg)
  raise TestFailure(msg)


def ExpandAuGeneratorZip(zip_file, working_dir):
  """Expand the au-generator.zip file out into a working directory.

  Args:
    zip_file: The file name of the zip file to expand.
    working_dir: The directory into which to expand the zip file.

  Raises:
    TestFailure: Raised if the zip fails to expand.
  """
  cmd = ['unzip', '-o', '-d', working_dir, zip_file]
  logging.debug('Extracting with: %s', ' '.join(cmd))
  p = subprocess.Popen(cmd, stdout=subprocess.PIPE, stderr=subprocess.STDOUT)
  p.communicate()
  if p.returncode != 0:
    FailWithError('Failed: %s' % ' '.join(cmd))


def VerifyBinariesPresent(working_dir):
  """Verify that all expected executables from the zip are present.

  Check the expanded zip contents to see if all expected executable files
  are present.

  Args:
    working_dir: Directory in which expected binaries should be findable.

  Raises:
    TestFailure if an expected executable is missing.
  """
  for src_filename in generate_au_zip.EXECUTABLE_FILES:
    basename = os.path.basename(src_filename)
    expected_name = os.path.join(working_dir, basename)
    logging.debug('Expecting executable: %s', expected_name)

    if not os.path.isfile(expected_name):
      FailWithError('Expected file not found: %s' % expected_name)


def VerifyLinking(working_dir):
  """Verify that binary executables are executable outside of the chroot.

  Run each of the binary executables outside of the chroot with --help and
  see if they can startup and shutdown correctly. This mostly validates
  that problems with dynamic linking are properly handled.

  Args:
    working_dir: Directory in which expected binaries should be present.

  Raises:
    TestFailure if an expected executable is missing.
  """
  for src_filename in generate_au_zip.BINARY_EXECUTABLES:
    basename = os.path.basename(src_filename)
    expected_name = os.path.join(working_dir, basename)

    cmd = [expected_name, '--help']
    p = subprocess.Popen(cmd, stdout=subprocess.PIPE, stderr=subprocess.STDOUT)
    output, _ = p.communicate()

    # We expect --help to either succeed, or fail with 1 or -1.
    if p.returncode not in (0, 1, 255):
      FailWithError('%s failed outside chroot with:\n%s' %
                    (expected_name, output))


def main():
  """Main function to start the script"""
  parser = optparse.OptionParser()

  parser.add_option(
      '-d', '--debug', dest='debug', action='store_true',
      default=False, help='Verbose [%default]',)
  parser.add_option(
      '-o', '--output-dir', dest='output_dir',
      default='/tmp/au-generator',
      help='The output location for copying the zipfile [%default]')
  parser.add_option(
      '-z', '--zip-name', dest='zip_name',
      default='au-generator.zip', help='Name of the zip file. [%default]')

  logging_format = '%(asctime)s - %(filename)s - %(levelname)-8s: %(message)s'
  date_format = '%Y/%m/%d %H:%M:%S'
  logging.basicConfig(level=logging.INFO, format=logging_format,
                      datefmt=date_format)

  (options, _) = parser.parse_args()
  if options.debug:
    logging.getLogger().setLevel(logging.DEBUG)

  logging.debug('Options are %s ', options)

  working_dir = None
  try:
    working_dir = tempfile.mkdtemp(suffix='au', prefix='tmp', dir=os.getcwd())
    logging.debug('Using tempdir = %s', working_dir)

    zip_file = os.path.join(options.output_dir, options.zip_name)

    ExpandAuGeneratorZip(zip_file, working_dir)
    VerifyBinariesPresent(working_dir)
    VerifyLinking(working_dir)

    logging.info('SUCCESS for: %s', zip_file)
  finally:
    if working_dir:
      shutil.rmtree(working_dir, ignore_errors=True)
      logging.debug('Removed tempdir = %s', working_dir)

if __name__ == '__main__':
  main()
