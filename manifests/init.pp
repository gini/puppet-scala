# == Class: scala
#
# Install the Scala programming languag from the official project site.
# The required Java runtime environment will not be installed automatically.
#
# === Parameters
#
# [*version*]
#   Specify the version of Scala which should be installed.
#
# [*url*]
#   Specify the absolute URL of the Scala package. This overrides any
#   version which has been set before.
#
# === Variables
#
# The variables being used by this module are named exactly like the class
# parameters with the prefix 'scala_', e. g. *scala_version* and *scala_target*.
#
# === Examples
#
#  class { 'scala':
#    version => '2.9.2'
#  }
#
# === Authors
#
# Jochen Schalanda <j.schalanda@smarchive.de>
#
# === Copyright
#
# Copyright 2012, 2013 smarchive GmbH
#
class scala(
  $version        = 'UNSET',
  $url            = 'UNSET',
  $package_format = 'UNSET',
) {

  include scala::params

  $version_real = $version ? {
    'UNSET' => $::scala::params::version,
    default => $version,
  }

  $package_format_real = $package_format ? {
    'UNSET' => $::scala::params::package_format,
    default => $package_format,
  }

  $url_real = $url ? {
    'UNSET' => "http://www.scala-lang.org/files/archive/scala-${version_real}.${package_format_real}",
    default => $url,
  }

  archive::download { "scala-${version_real}.${package_format_real}":
    url        => $url_real,
    checksum   => false,
    src_target => '/var/tmp',
  }

  $package_provider = $::osfamily ? {
    'RedHat' => 'rpm',
    'Debian' => 'dpkg',
    default  => fail('Unsupported OS family'),
  }

  package { "scala-${version_real}":
    ensure   => installed,
    provider => $package_provider,
    source   => "/var/tmp/scala-${version_real}.${package_format_real}",
    require  => Archive::Download["scala-${version_real}.${package_format_real}"],
  }
}
